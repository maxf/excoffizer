const Excoffizer = function(params) {
  this._inputCanvas = params.inputCanvas;
  this._outputCanvas = params.outputCanvas;
  this._sx = params.sx / 10;
  this._sy = params.sy / 10;
  this._tx = params.tx;
  this._ty = params.ty;
  this._theta = params.theta * Math.PI / 180;
  this._waviness = params.waviness;
  this._contrast = params.contrast;
  this._opacity = params.opacity;
  this._line_height = params.line_height;
};

Excoffizer.prototype.render = function() {
  'use strict';
  this._inputPixmap = new Pixmap(this._inputCanvas);
  this._wiggleFrequency = this._waviness/100.0;
  this._wiggleAmplitude = this._wiggleFrequency===0 ? 0 : 0.5/this._wiggleFrequency;
  this._contrastFactor = (259 * (this._contrast + 255)) / (255 * (259 - this._contrast));

  this._excoffize();
  return true;
};

Excoffizer.prototype._wiggle = function(x) {
  'use strict';
  return this._wiggleAmplitude*Math.sin(x*this._wiggleFrequency);
};

Excoffizer.prototype._S2P = function(x,y) {
  'use strict';
  // transform x,y from "sine space" to picture space
  // rotation ('theta'), scaling (sx,sy), translation (tx, ty)
  var c=Math.cos(this._theta),
      s=Math.sin(this._theta),
      sx=this._sx, sy=this._sy,
      tx=this._tx, ty=this._ty;

  return [x*sx*c - y*sy*s + tx*sx*c - ty*sy*s, x*sx*s + y*sy*c + tx*sx*s + ty*sy*c];
};

Excoffizer.prototype._P2S = function(x,y) {
  'use strict';
  // convert x,y from picture space to  "sine space"

  var c=Math.cos(-this._theta),
      s=Math.sin(-this._theta),
      sx = 1/this._sx, sy = 1/this._sy,
      tx = -this._tx, ty = -this._ty;

  return [ x*sx*c - y*sx*s + tx, x*sy*s + y*sy*c + ty ];
};

Excoffizer.prototype._sidePoints = function(x1,y1,x2,y2,r) {
  'use strict';
  var L=Math.sqrt((x2-x1)*(x2-x1) + (y2-y1)*(y2-y1)),
      px=(x2-x1)*r/L,
      py=(y2-y1)*r/L;

  return [x1-py-(px/20), y1+px-(py/20), x1+py-(px/20), y1-px-(py/20)];
};

Excoffizer.prototype._excoffize = function() {
  'use strict';
  const outputCanvas = this._outputCanvas;
  const outputWidth = outputCanvas.width;
  const outputHeight = outputCanvas.height;
  const outputCtx = outputCanvas.getContext('2d');

  const inputWidth = this._inputPixmap.width;
  const inputHeight = this._inputPixmap.height;


  // clear output canvas
  outputCtx.shadowColor='black';
  outputCtx.shadowOffsetX=0;
  outputCtx.shadowOffsetY=0;
  outputCtx.shadowBlur=0;
  outputCtx.fillStyle = 'white';
  outputCtx.fillRect(0,0,outputWidth,outputHeight);


  // and add in the initial picture with transparency
  outputCtx.globalAlpha = this._opacity / 256;
  outputCtx.drawImage(this._inputPixmap.canvas,0,0,outputWidth,outputHeight);
  outputCtx.globalAlpha = 1;

  // ready to draw
  outputCtx.fillStyle='black';

  // boundaries of the image in sine space
  const corner1 = this._P2S(0,0);
  const corner2 = this._P2S(inputWidth,0);
  const corner3 = this._P2S(inputWidth,inputHeight);
  const corner4 = this._P2S(0,inputHeight);
  const minX = Math.min(corner1[0],corner2[0],corner3[0],corner4[0]);
  const minY = Math.min(corner1[1],corner2[1],corner3[1],corner4[1]);
  const maxX = Math.max(corner1[0],corner2[0],corner3[0],corner4[0]);
  const maxY = Math.max(corner1[1],corner2[1],corner3[1],corner4[1]);

  // from the min/max bounding box, we know which sines to draw

  const zoom = outputWidth/inputWidth;
  const stepx = 2;
  const stepy = this._line_height;

  // declare these outside the loop for speed
  let imageP, rx, ry, imageP2, rx2, ry2, radius, radius2, sidePoints, sidePoints2;

  for (let y = minY-this._wiggleAmplitude; y < maxY+this._wiggleAmplitude; y += stepy) {
    for (let x = minX; x < maxX; x += stepx) {
      imageP=this._S2P(x,y+this._wiggle(x));
      rx=imageP[0];
      ry=imageP[1];

      // rx2,ry2 is the point ahead, to which we draw a segment
      imageP2=this._S2P(x+stepx,y+this._wiggle(x+stepx));
      rx2=imageP2[0];
      ry2=imageP2[1];

      if ((rx  >= 0 && rx  < inputWidth && ry  >= 0 && ry  < inputHeight)||
          (rx2 >= 0 && rx2 < inputWidth && ry2 >= 0 && ry2 < inputHeight)) {

        radius=100/(10+this._inputPixmap.brightnessAverageAt(Math.floor(rx), Math.floor(ry), 1, this._contrastFactor));
        radius2=100/(10+this._inputPixmap.brightnessAverageAt(Math.floor(rx2), Math.floor(ry2), 1, this._contrastFactor));

        sidePoints=this._sidePoints(rx,ry,rx2,ry2,radius);
        sidePoints2=this._sidePoints(rx2,ry2,rx,ry,radius2);

        // scale everything to output resolution
        sidePoints[0]*=zoom;
        sidePoints[1]*=zoom;
        sidePoints[2]*=zoom;
        sidePoints[3]*=zoom;
        sidePoints2[0]*=zoom;
        sidePoints2[1]*=zoom;
        sidePoints2[2]*=zoom;
        sidePoints2[3]*=zoom;

        outputCtx.beginPath();
        outputCtx.moveTo(sidePoints[0],sidePoints[1]);
        outputCtx.lineTo(sidePoints[2],sidePoints[3]);
        outputCtx.lineTo(sidePoints2[0],sidePoints2[1]);
        outputCtx.lineTo(sidePoints2[2],sidePoints2[3]);
        outputCtx.fill();
      }
    }
  }
};
