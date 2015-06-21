import ddf.minim.spi.*;
import ddf.minim.signals.*;
import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.ugens.*;
import ddf.minim.effects.*;

Minim minim;
AudioOutput out;
SoundObject[] waveArray; 
int outScale = 1;

void setup(){  //noLoop();
  size(800, 800);
  
  minim = new Minim(this);
  out = minim.getLineOut();
  waveArray = new SoundObject[]{new WaveGen(out, 100, 100, 0)};
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
  boolean repeat = true;
  int xoffset = 0;
  while(repeat){
    for(int i = 0; i < out.bufferSize() - outScale; i = i + outScale){
      line( xoffset + i/outScale, sizeValue  - out.left.get(i)*sizeValue,  xoffset + i/outScale+1, sizeValue  - out.left.get(i+outScale)*sizeValue );
    }
    line( xoffset + (out.bufferSize() - outScale-1)/outScale+1, 
      sizeValue  - out.left.get((out.bufferSize() - outScale-1)+outScale)*sizeValue,  
      xoffset + (out.bufferSize() - outScale-1)/outScale+2, 
      sizeValue  - out.left.get((0)+outScale)*sizeValue );
    repeat = (out.bufferSize() / outScale + xoffset < getWidth());
    xoffset += out.bufferSize() / outScale;
  }
}
void mousePressed(){
  
}
void mouseClicked(){
  for(SoundObject so : waveArray){
    if(so.isType(Controller.TYPE_POTI)){
      Poti controller = ((WaveGen)so).getController();
      if(controller.containsAmpSelect(mouseX, mouseY)){
        controller.setType(Controller.TYPE_AMP);
      }else if (controller.containsFreqSelect(mouseX, mouseY)){
        controller.setType(Controller.TYPE_FREQ);
      }else if(controller.contains(mouseX, mouseY)){
        if(mouseButton==LEFT){
          ((WaveGen)so).switchTypes();
        }else if(mouseButton == RIGHT){
          controller.toggleExtensions();
        }
      }
    }
  }
}

void mouseDragged(){
  if(mouseButton==LEFT){
    for(SoundObject so : waveArray){
      if(so.isType(Controller.TYPE_POTI)){
        Poti controller = ((WaveGen)so).getController();
        if(controller.contains(mouseX, mouseY)){
          controller.rotateTo(mouseX, mouseY);
          if(controller.isFrequencyController()) ((WaveGen)so).setFrequency(degrees( controller.getEncodedValue())*(720/360));
          else ((WaveGen)so).setAmplitude(degrees( controller.getEncodedValue()/360));
        }else if(controller.containsMover(mouseX, mouseY)){
          controller.move(mouseX, mouseY);
        }
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
   //waveArray = (SoundObject[])append(waveArray, new WaveGen(out, mouseX, mouseY, waveArray.length));
   switch(key){
     case 'w':
       outScale += 1;
     break;
     case 's': 
       if(outScale>1) outScale -= 1;
     break;
   }
}

