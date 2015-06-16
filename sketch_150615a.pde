import ddf.minim.spi.*;
import ddf.minim.signals.*;
import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.ugens.*;
import ddf.minim.effects.*;

Minim minim;
AudioOutput out;
SoundObject[] waveArray; 

void setup(){  //noLoop();
  size(800, 800);
  
  minim = new Minim(this);
  out = minim.getLineOut();
  waveArray = new SoundObject[]{new WaveGen(out, Waves.SINE, 0)};
}
  

void draw(){
  background(40);
  stroke(255);
  strokeWeight(1);
   
  for(SoundObject so : waveArray){
    so.draw();
  }
  // draw the waveform of the output
  drawOutWave(25);
}

void drawOutWave(int sizeValue){
  for(int i = 0; i < out.bufferSize() - 1; i++){
    line( i, sizeValue  - out.left.get(i)*sizeValue,  i+1, sizeValue  - out.left.get(i+1)*sizeValue );
  }
}
void mousePressed(){
  
}
void mouseClicked(){
  ImageObject[] controllerArray;
  for(SoundObject so : waveArray){
    // BoundingBox um zu testen ob das schon zu diesem Object gehört --> Komplexität
    controllerArray = so.getController();
    for(ImageObject controller : controllerArray){
      if(controller.contains(mouseX, mouseY) && controller.type.equalsIgnoreCase("Poti")){
        ((WaveGen)so).switchTypes();
      }
    }
  }
}

void mouseDragged(){
  ImageObject[] controllerArray;
  for(SoundObject so : waveArray){
    // BoundingBox um zu testen ob das schon zu diesem Object gehört --> Komplexität
    controllerArray = so.getController();
    for(ImageObject controller : controllerArray){
      if(controller.contains(mouseX, mouseY)){
        controller.move(mouseX, mouseY);
        ((WaveGen)so).setFrequency(degrees( controller.getEncodedValue())*(720/360));
      }
    }
  }
}


void mouseMoved(){
 /*
  float amp = map( mouseY, 0, height, 1, 0 );
  wave.setAmplitude( amp );
 
  float freq = map( mouseX, 0, width, 110, 880 );
  wave.setFrequency( freq );
  
  redraw();
  */
}

void keyPressed(){ 
   waveArray = (SoundObject[])append(waveArray, new WaveGen(out, Waves.SINE, waveArray.length));
}

