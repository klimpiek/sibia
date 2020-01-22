import { Controller } from "stimulus"

// Agenda
function Graph() {
    this.clusters = [];
    this.nodes = {};
}

function Cluster() {
    this.nodes = {};
    this.width = 0;
    this.maxCliqueSize = 1;
}

function Node(id, start, end, event) {
    this.id = id;
    this.start = start;
    this.end = end;
    this.neighbours = {};
    this.cluster = null;
    this.position = null;
    this.biggestCliqueSize = 1;
    this.event = event;
}

    var BOARD_WIDTH = 600;
    var BOARD_HEIGHT = 720;
    var BOARD_PADDING = 10;

    /**
     * The required function
     * @param events
     */
    function layOutDay(events, element) {
        let isInputValid = validateEvents(events);
        let eventsWithPositioning = [];

        if (isInputValid) {
            var histogram = createHistogram(events);
            var graph = createTheGraph(events, histogram);
            setClusterWidth(graph);
            setNodesPosition(graph);

            //setting the position and width of each event
            for(var nodeId in graph.nodes) {
                var node = graph.nodes[nodeId];
                var event = {
                    id: node.id,
                    top: node.start,
                    left: node.position * node.cluster.width + BOARD_PADDING,
                    height: node.end + 1 - node.start,
                    width: node.cluster.width,
                    event: node.event
                };
                eventsWithPositioning.push(event);
            }

        }
        return eventsWithPositioning;
    }

    /**
     * Will check if provided input is in correct form. events should be an array of object. Each object of the array
     * should have 3 attributes: id (Number|unique), start (number|between:0,720),
     * end (number|between:0,720|greaterThen:start)
     * @param events
     * @returns {boolean}
     */
    function validateEvents(events) {
        var isValid = true;
        var mapOfIds = {};

        if (events instanceof Array) {
            for (var i = 0; i < events.length; i++) {
                var event = events[i];

                //checking the event id
                if (!(event && isInt(event.id) && !mapOfIds[event.id])) {
                    isValid = false;
                    console.error("invalid event id");
                } else {
                    mapOfIds[event.id] = true;
                }

                //checking the event start time
                if (!(isInt(event.start) && 0 <= event.start && event.start <= (BOARD_HEIGHT-21))) {
                    isValid = false;
                    console.error("invalid start time");
                }

                //checking the event end time
                if (!(isInt(event.end) && event.start < event.end && event.end <= BOARD_HEIGHT)) {
                    isValid = false;
                    console.error("invalid end time");
                }
            }

            if (!isValid) {
                console.error("one of the objects in the events array is invalid");
            }

        } else {
            console.error("input should be an Array");
            isValid = false;
        }

        if (!isValid) {
            alert("the provided events are invalid, check console log for more information");
        }

        return isValid;
    }

    /**
     * Creates an array of arrays, each index of the top array represents a minute, each minuet is an array of
     * events which takes place at this time (minute);
     * @param events
     * @returns {Array}
     */
    function createHistogram(events) {

        //initializing the minutes array
        var minutes = new Array(BOARD_HEIGHT);
        for (var i = 0; i < minutes.length; i++) {
            minutes[i] = [];
        }

        //setting which events occurs at each minute
        events.forEach(function (event) {
            for (var i = event.start; i <= event.end - 1; i++) {
                minutes[i].push(event.id);
            }
        });

        return minutes;
    }

    /**
     * creates a graph of events
     * @param events - the provided input (events)
     * @param minutes - the histogram array
     * @returns {Graph}
     */
    function createTheGraph(events, minutes) {
        var graph = new Graph();
        var nodeMap = {};

        //creating the nodes
        events.forEach(function (event) {
            var node = new Node(event.id, event.start, event.end - 1, event);
            nodeMap[node.id] = node;
        });

        //creating the clusters
        var cluster = null;

        //cluster is a group of nodes which have a connectivity path, when the minute array length is 0 it means that
        //there are n more nodes in the cluster - cluster can be "closed".
        minutes.forEach(function (minute) {
            if (minute.length > 0) {
                cluster = cluster || new Cluster();
                minute.forEach(function (eventId) {
                    if (!cluster.nodes[eventId]) {
                        cluster.nodes[eventId] = nodeMap[eventId];
                        nodeMap[eventId].cluster = cluster;
                    }
                });
            } else {
                if (cluster != null) {
                    graph.clusters.push(cluster);
                }

                cluster = null;
            }
        });

        if (cluster != null) {
            graph.clusters.push(cluster);
        }

        //adding neighbours to nodes, neighbours is the group of colliding nodes (events).
        //adding the biggest clique for each site
        minutes.forEach(function (minute) {
            minute.forEach(function (eventId) {
                var sourceNode = nodeMap[eventId];

                //a max clique is a biggest group of colliding events
                sourceNode.biggestCliqueSize = Math.max(sourceNode.biggestCliqueSize, minute.length);
                minute.forEach(function (targetEventId) {
                    if (eventId != targetEventId) {
                        sourceNode.neighbours[targetEventId] = nodeMap[targetEventId];
                    }
                });
            });
        });

        graph.nodes = nodeMap;

        return graph;
    }

    /**
     * width of each node in a cluster defined by the board width divided by the biggest colliding group (a.k.a neighbours)
     * in the cluster.
     * @param graph
     */
    function setClusterWidth(graph) {
        graph.clusters.forEach(function (cluster) {

            //cluster must have at least one node
            var maxCliqueSize = 1;
            for (var nodeId in cluster.nodes) {
                maxCliqueSize = Math.max(maxCliqueSize, cluster.nodes[nodeId].biggestCliqueSize);
            }

            cluster.maxCliqueSize = maxCliqueSize;
            cluster.width = BOARD_WIDTH / (maxCliqueSize);
//            cluster.width = (BOARD_WIDTH-2*BOARD_PADDING) / (maxCliqueSize);
        });
    }

    /**
     * sets each nodes position (relative to its neighbours). The number of available positions on the X axes is
     * according to the biggest clique in the cluster.
     * @param graph
     */
    function setNodesPosition(graph) {
        graph.clusters.forEach(function (cluster) {
            for (var nodeId in cluster.nodes) {
                var node = cluster.nodes[nodeId];
                var positionArray = new Array(node.cluster.maxCliqueSize);

                //find a place (offset) on the X axis of the node
                for (var neighbourId in node.neighbours) {
                    var neighbour = node.neighbours[neighbourId];
                    if (neighbour.position != null) {
                        positionArray[neighbour.position] = true;
                    }
                }

                for (var i = 0; i < positionArray.length; i++) {
                    if (!positionArray[i]) {
                        node.position = i;
                        break;
                    }
                }
            }
        });
    }

    /**
     * Checks if given number is an int
     * @param n
     * @returns {boolean}
     */
    function isInt(n) {
        return Number(n) === n && n % 1 === 0;
    }

export default class extends Controller {
  static targets = ['timeline', 'board', 'events']

  connect() {
    let events = []
    Array.from(this.eventsTarget.getElementsByTagName("li")).forEach(function(el) {
      events.push({
        id: parseInt(el.dataset.id),
        start: parseInt(el.dataset.start),
        end: parseInt(el.dataset.end),
        title: el.dataset.title,
        url: el.dataset.url,
      })
    })
/*
    let events = [
        {id: 1, start: 30, end: 150},
        {id: 2, start: 540, end: 600},
        {id: 3, start: 560, end: 620},
        {id: 4, start: 610, end: 670},
        {id: 5, start: 80, end: 240},
        {id: 6, start: 250, end: 360}
    ];
*/
    let eventsHTMLString = ""
    let event_pos = layOutDay(events, this.boardTarget)
    event_pos.forEach(function(node) {
//      let style=`top: ${node.top}px; left: ${node.left}px; width: ${node.width}px; height: ${node.height}px;`
      let style=`top: ${100*node.top/BOARD_HEIGHT}%; left: ${100*node.left/BOARD_WIDTH}%; width: ${100*node.width/BOARD_WIDTH}%; height: ${100*node.height/BOARD_HEIGHT}%;`
      let s = `<div class="event" style="${style}"><span>${node.event.title || node.id}</span></div>`
      eventsHTMLString += s
    })
    this.boardTarget.insertAdjacentHTML('beforeend', eventsHTMLString);
  }
}
