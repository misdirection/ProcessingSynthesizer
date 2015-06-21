import ddf.minim.spi.*;
import ddf.minim.signals.*;
import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.ugens.*;
import ddf.minim.effects.*;

Minim minim;
AudioOutput out;
WaveGen[] waveArray; 
int outScale = 1;

void setup(){  //noLoop();
  size(1280, 800);
  
  minim = new Minim(this);
  out = minim.getLineOut();
  waveArray = new WaveGen[]{new WaveGen(out, 100, 100, 0)};
}
  

void draw(){
  background(40);
  stroke(255);
  strokeWeight(1);
   
  for(WaveGen so : waveArray){
    so.draw();
  }
  // draw the waveform of the output
  drawOutWave(25);
  drawMenu();
}

void drawMenu(){
  imageMode(CENTER); 
  pushMatrix();
  translate(50, 25);
  image(loadImage("wave.png"), 0, 0, 25, 25);
  popMatrix(); 
}

void drawOutWave(int sizeValue){
  boolean repeat = true;
  int xoffset = 0;
  while(repeat){
    for(int i = 0; i < out.bufferSize() - outScale; i = i + outScale){
      line( xoffset + i/outScale, 
        25 + sizeValue  - out.left.get(i)*sizeValue,  
        xoffset + i/outScale+1, 
        25 + sizeValue  - out.left.get(i+outScale)*sizeValue );
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
  checkMenuItemClick(mouseX, mouseY);
  for(WaveGen so : waveArray){
    if(so.isType(Controller.TYPE_POTI)){
      Poti controller = so.getController();
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

void checkMenuItemClick(int x, int y){
  // Item1 - make new Oscil
    if(x <= 50+25/2 && 
      x >= 50-25/2 &&
      y <= 25+25/2 && y >= 25-25/2)
      waveArray = (WaveGen[])append(waveArray, new WaveGen(out, 100, 100, waveArray.length));
}

void mouseDragged(){
  if(mouseButton==LEFT){
    for(WaveGen so : waveArray){
      Poti controller = so.getController();
      if(controller.contains(mouseX, mouseY)){
        controller.rotateTo(mouseX, mouseY);
        if(controller.isFrequencyController()) so.setFrequency(degrees( controller.getEncodedValue())*(720/360));
        else so.setAmplitude(degrees( controller.getEncodedValue()/360));
      }else if(controller.containsMover(mouseX, mouseY)){
        controller.move(mouseX, mouseY);
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
   switch(key){
     case 'w':
       outScale += 1;
     break;
     case 's': 
       if(outScale>1) outScale -= 1;
     break;
   }
}

