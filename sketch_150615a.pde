import ddf.minim.spi.*;
import ddf.minim.signals.*;
import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.ugens.*;
import ddf.minim.effects.*;

Minim minim;
AudioOutput out;
Poti[] controllerArray;
int outScale = 1;

void setup(){  //noLoop();
  size(1280, 800);
  
  minim = new Minim(this);
  out = minim.getLineOut();
  controllerArray = new Poti[]{new Poti(100, 100, new WaveGen(out))};
}
  

void draw(){
  background(40);
  stroke(255);
  strokeWeight(1);
   
  for(Poti poti : controllerArray){
    poti.draw();
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
  for(Poti controller : controllerArray){
    if(controller.containsMenu(mouseX, mouseY)){
      controller.toggleExtensions();
    }else if(controller.containsAmpSelect(mouseX, mouseY)){
      controller.setType(Controller.TYPE_AMP);
    }else if (controller.containsFreqSelect(mouseX, mouseY)){
      controller.setType(Controller.TYPE_FREQ);
    }else if(controller.contains(mouseX, mouseY)){
      if(mouseButton==LEFT){
        controller.switchTypes();
      }else if(mouseButton == RIGHT){
        controller.toggleExtensions();
      }
    }
  }
}

void checkMenuItemClick(int x, int y){
  // Item1 - make new Oscil
    if(x <= 50+25/2 && 
      x >= 50-25/2 &&
      y <= 25+25/2 && y >= 25-25/2)
      controllerArray = (Poti[])append(controllerArray, new Poti(100, 100, new WaveGen(out)));
}

void mouseDragged(){
  for(Poti controller : controllerArray){
    if(controller.contains(mouseX, mouseY)){        
      if(mouseButton==LEFT){
        controller.rotateTo(mouseX, mouseY);
      }else if(mouseButton==RIGHT){
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

