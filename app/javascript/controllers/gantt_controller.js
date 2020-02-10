// Visit The Stimulus Handbook for more details 
// https://stimulusjs.org/handbook/introduction

import { Controller } from "stimulus"

function createSVG() {
  var svg = document.getElementById("svg-canvas");
  if (null == svg) {
    svg = document.createElementNS("http://www.w3.org/2000/svg", "svg");
    svg.setAttribute('id', 'svg-canvas');
    svg.setAttribute('style', 'position:absolute;top:0px;left:0px');
    svg.setAttribute('width', document.body.clientWidth);
    svg.setAttribute('height', document.body.clientHeight);
    svg.setAttributeNS("http://www.w3.org/2000/xmlns/", "xmlns:xlink", 
                       "http://www.w3.org/1999/xlink");
    document.body.appendChild(svg);
  }
  return svg;
}

function drawCircle(x, y, radius, color) {
    var svg = createSVG();
    var shape = document.createElementNS("http://www.w3.org/2000/svg", "circle");
    shape.setAttributeNS(null, "cx", x);
    shape.setAttributeNS(null, "cy", y);
    shape.setAttributeNS(null, "r",  radius);
    shape.setAttributeNS(null, "fill", color);
    svg.appendChild(shape);
}

function findAbsolutePosition(htmlElement) {
  var x = htmlElement.offsetLeft;
  var y = htmlElement.offsetTop;
  for (var x=0, y=0, el=htmlElement; 
       el != null; 
       el = el.offsetParent) {
         x += el.offsetLeft;
         y += el.offsetTop;
  }
  return {
      "x": x,
      "y": y
  };
}

function connectDivs(leftId, rightId, color, tension) {
  var left = document.getElementById(leftId);
  var right = document.getElementById(rightId);
	
  var leftPos = findAbsolutePosition(left);
  var x1 = leftPos.x;
  var y1 = leftPos.y;
  x1 += left.offsetWidth;
  y1 += (left.offsetHeight / 2);

  var rightPos = findAbsolutePosition(right);
  var x2 = rightPos.x;
  var y2 = rightPos.y;
  y2 += (right.offsetHeight / 2);

  var width=x2-x1;
  var height = y2-y1;

  drawCircle(x1, y1, 3, color);
  //drawCircle(x2, y2, 3, color);
  drawCurvedLine(x1, y1, x2, y2, color, tension);
}

var markerInitialized = false;

function createTriangleMarker() {
  if (markerInitialized)
    return;
  markerInitialized = true;
  var svg = createSVG();
  var defs = document.createElementNS('http://www.w3.org/2000/svg', 'defs');
  svg.appendChild(defs);

  var marker = document.createElementNS('http://www.w3.org/2000/svg', 'marker');
  marker.setAttribute('id', 'triangle');
  marker.setAttribute('viewBox', '0 0 10 10');
  marker.setAttribute('refX', '0');
  marker.setAttribute('refY', '5');
  marker.setAttribute('markerUnits', 'strokeWidth');
  marker.setAttribute('markerWidth', '10');
  marker.setAttribute('markerHeight', '8');
  marker.setAttribute('orient', 'auto');
  var path = document.createElementNS('http://www.w3.org/2000/svg', 'path');
  marker.appendChild(path);
  path.setAttribute('d', 'M 0 0 L 10 5 L 0 10 z');
  defs.appendChild(marker);
}

function drawCurvedLine(x1, y1, x2, y2, color, tension) {
    var svg = createSVG();
    var shape = document.createElementNS("http://www.w3.org/2000/svg", "path");
    if (tension<0) {
      var delta = (y2-y1)*tension;
      var hx1=x1;
      var hy1=y1-delta;
      var hx2=x2;
      var hy2=y2+delta;
      var path = "M " + x1 + " " + y1 + " C " + hx1 + " " + hy1 + " "  + hx2 + " " + hy2 + " " + x2 + " " + y2;
    } else {
      var delta = (x2-x1)*tension;
      var hx1=x1+delta;
      var hy1=y1;
      var hx2=x2-delta;
      var hy2=y2;
      var path = "M "  + x1 + " " + y1 + " C " + hx1 + " " + hy1 + " "  + hx2 + " " + hy2 + " " + x2 + " " + y2;
    }
    shape.setAttributeNS(null, "d", path);
    shape.setAttributeNS(null, "fill", "none");
    shape.setAttributeNS(null, "stroke", color);
    shape.setAttributeNS(null, "marker-end", "url(#triangle)");
    svg.appendChild(shape);
}

export default class extends Controller {
  static targets = [  ]

  connect() {
    console.log('gantt table')
    createSVG();
    createTriangleMarker();

    connectDivs("bar_0", "bar_1", "blue", 0.2)
    connectDivs("bar_1", "bar_2", "blue", 0.2)
  }

}
