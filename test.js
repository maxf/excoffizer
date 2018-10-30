'use strict';

const sourceImage = document.getElementById('source_image');
const inputCanvas = document.getElementById('input_canvas');
const outputCanvas = document.getElementById('output_canvas');
const inputCanvasCtx = inputCanvas.getContext('2d');
const outputCanvasCtx = outputCanvas.getContext('2d');
let w, h;


// clear output canvas
outputCanvasCtx.fillStyle = 'white';
outputCanvasCtx.fillRect(0,0,w,h);
outputCanvasCtx.fillStyle='black';


//outputCanvasCtx.fillRect(0,0,100,100);

function ts(p) {
  return [ p[0] + 10*Math.sin(0.05*p[1]), p[1] ]
}

function td(p) {
  const p2 = ts(p);
  const sx = 200*p2[0]/w;
  return (1 + Math.sin(sx))/2;
}

function tr(p, tx, ty, theta) {
  const x = p[0] + tx, y = p[1] + ty;
  const cos = Math.cos(theta), sin = Math.sin(theta);
  return [ x * cos - y * sin, x * sin + y * cos ]
}



let ti = new Image();
ti.onload = function() {
  inputCanvasCtx.drawImage(ti,0,0);
  w = sourceImage.width;
  h = sourceImage.width;

  const inputPixmap = new Pixmap(inputCanvas);


  for (let r=0; r<w; r++) {
    for (let c=0; c<w; c++) {
      let v = td(tr([c,r], 12,1, 2));

      const imageColor = inputPixmap.colorAt(c, r);

      const height = v + (imageColor.r + imageColor.g + imageColor.b)/768;

      const grey = height > 1 ? 255 : 0;


      const fill=`rgb(${grey}, ${grey}, ${grey})`;
      outputCanvasCtx.fillStyle=fill;
      outputCanvasCtx.fillRect(c,r,1,1);
    }
  }
};
ti.src = sourceImage.getAttribute('src');
