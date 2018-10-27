var Color = function(r,g,b,a) {
  this.r = r > 255 ? 255 : (r < 0 ? 0 : r);
  this.g = g > 255 ? 255 : (g < 0 ? 0 : g);
  this.b = b > 255 ? 255 : (b < 0 ? 0 : b);
  this.a = a > 255 ? 255 : (a < 0 ? 0 : a);
};

Color.prototype.toString = function() {
  return 'rgb('+Math.round(this.r)+','+Math.round(this.g)+','+Math.round(this.b)+')';
}

Color.prototype.brightness = function() {
  return (this.r+this.g+this.b)/3;
}

//################################################################################

const Pixmap = function(canvas) {
  this.canvas = canvas;
  this.width = this.canvas.width;
  this.height = this.canvas.height;
  this.context = this.canvas.getContext('2d');
  this._pixels = this.context.getImageData(0,0,this.canvas.width,this.canvas.height).data;
};


//################################################################################

Pixmap.prototype.colorAverageAt = function( x, y, radius, contrast ) {
  var index;
  var resultR=0.0, resultG=0.0, resultB=0.0;
  var count=0;

  for (var i=-radius; i<=radius; i++) {
    for (var j=-radius; j<=radius; j++) {
      if (x+i>=0 && x+i<this.width && y+j>=0 && y+j<this.height) {
        count++;
        index = 4*((x+i)+this.width*(y+j));
        resultR+=this._pixels[index];
        resultG+=this._pixels[index+1];
        resultB+=this._pixels[index+2];
      }
    }
  }
  if (contrast != undefined) {
    const red = contrast * (resultR/count - 128) + 128;
    const grn = contrast * (resultG/count - 128) + 128;
    const blu = contrast * (resultB/count - 128) + 128;
    return new Color(red, grn, blu, 1);
  } else {
    const red = resultR/count;
    const grn = resultG/count;
    const blu = resultB/count;
    return new Color(red, grn, blu, 1);
  }
};

Pixmap.prototype.brightnessAverageAt = function(x, y, radius, contrast) {
  return this.colorAverageAt(x, y, radius, contrast).brightness();
}
