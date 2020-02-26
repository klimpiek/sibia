// Visit The Stimulus Handbook for more details 
// https://stimulusjs.org/handbook/introduction

import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [ "chart" ]

  connect() {
    console.log('gantt table')
    this.createSVG();
    this.createTriangleMarker();

    let events = document.querySelectorAll(".gantt_event")
    let this_controller = this
    events.forEach(function(event) {
      if(event.dataset.predecessor) {
        this_controller.connectDivs(event.dataset.predecessor, event.id, "blue", 0.2)
      }
    })
  }

  createSVG(element) {
    var svg = document.getElementById("svg-canvas");
    var element = this.chartTarget;

    if ((null == svg) && (element != null)) {
      svg = document.createElementNS("http://www.w3.org/2000/svg", "svg");
      svg.setAttribute('id', 'svg-canvas');
      svg.setAttribute('style', 'position:absolute;top:0px;left:0px;');
      svg.setAttribute('width', element.offsetWidth);
      svg.setAttribute('height', element.offsetHeight);
      svg.setAttributeNS("http://www.w3.org/2000/xmlns/", "xmlns:xlink", 
                         "http://www.w3.org/1999/xlink");
      element.appendChild(svg);
    }
    return svg;
  }

  findAbsolutePosition(htmlElement) {
    var x = htmlElement.offsetLeft;
    var y = htmlElement.offsetTop;
    for (var x=0, y=0, el=htmlElement; 
         el != null; 
         el = el.offsetParent) {
           x += el.offsetLeft;
           y += el.offsetTop;
    }
    return {
        "x": x-this.chartTarget.offsetLeft,
        "y": y-this.chartTarget.offsetTop
    };
  }

  createTriangleMarker() {
    var svg = this.createSVG();
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
 
  connectDivs(leftId, rightId, color, tension) {
    var left = document.getElementById(leftId);
    var right = document.getElementById(rightId);
	
    if (left && right) {
      var leftPos = this.findAbsolutePosition(left);
      var x1 = leftPos.x;
      var y1 = leftPos.y;

      var rightPos = this.findAbsolutePosition(right);
      var x2 = rightPos.x;
      var y2 = rightPos.y;
  
      if (x1 < x2) {
        if (y2 < y1) {
          x1 += (left.offsetWidth / 2);
          y1 = y1;
          x2 += (right.offsetWidth / 2);
          y2 += right.offsetHeight+8;
          this.drawCircle(x1, y1, 3, color);
          //this.drawCircle(x2, y2, 3, color);
          this.drawCurvedLine(x1, y1, x2, y2, color, -1*tension);
        } else {
          x1 += (left.offsetWidth / 2);
          y1 += left.offsetHeight;
          x2 -= 8 // minus triangle size
          y2 += (right.offsetHeight / 2);
          this.drawCircle(x1, y1, 3, color);
          //this.drawCircle(x2, y2, 3, color);
          this.drawLine(x1, y1, x2, y2, color, tension);
        }
      } else {
        if (y2 < y1) {
          x1 += (left.offsetWidth / 2);
          y1 = y1;
          x2 += (right.offsetWidth / 2);
          y2 += right.offsetHeight+8;
          this.drawCircle(x1, y1, 3, color);
          //this.drawCircle(x2, y2, 3, color);
          this.drawCurvedLine(x1, y1, x2, y2, color, -1*tension);
        } else {
          x1 += (left.offsetWidth / 2);
          y1 += left.offsetHeight;
          x2 += (right.offsetWidth / 2);
          y2 -= 8;
          this.drawCircle(x1, y1, 3, color);
          //this.drawCircle(x2, y2, 3, color);
          this.drawCurvedLine(x1, y1, x2, y2, color, -1*tension);
        }
      }
    }
  }

  drawCircle(x, y, radius, color) {
    var svg = this.createSVG();
    var shape = document.createElementNS("http://www.w3.org/2000/svg", "circle");
    shape.setAttributeNS(null, "cx", x);
    shape.setAttributeNS(null, "cy", y);
    shape.setAttributeNS(null, "r",  radius);
    shape.setAttributeNS(null, "fill", color);
    svg.appendChild(shape);
  }

  drawLine(x1, y1, x2, y2, color, tension) {
    var svg = this.createSVG();
    var shape = document.createElementNS("http://www.w3.org/2000/svg", "path");
    var delta = 20;
    var path = "M " + x1 + " " + y1 + " L " + x1 + " " + (y2-delta) + " a " + delta + " " + delta + " 0 0 0 " + delta + " " + delta + " L " + x2 + " " + y2 
    shape.setAttributeNS(null, "d", path);
    shape.setAttributeNS(null, "fill", "none");
    shape.setAttributeNS(null, "stroke", color);
    shape.setAttributeNS(null, "marker-end", "url(#triangle)");
    svg.appendChild(shape);
  }

  drawCurvedLine(x1, y1, x2, y2, color, tension) {
    var svg = this.createSVG();
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
}
