import ddf.minim.spi.*;
import ddf.minim.signals.*;
import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.ugens.*;
import ddf.minim.effects.*;

Minim minim;
AudioOutput out;
ArrayList<Poti> controllerArray;
int outScale = 1, pressedConnectorID = 0;

void setup(){  //noLoop();
  size(1280, 800);
  
  minim = new Minim(this);
  out = minim.getLineOut();
  controllerArray = new ArrayList<Poti>();
  controllerArray.add(new Poti(100, 100, new WaveGen(out)));
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
  pushMatrix();
  translate(getWidth()/2,100);
  image(loadImage("patchIn.png"), 0, 0, 50, 50);
  popMatrix();  
}

boolean audioOutContains(int x, int y){
  if(x <= getWidth()/2+25 && 
      x >= getWidth()/2-25  &&
      y <= 125 && 
      y >= 75)return true;
      else return false;
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
  for(Poti controller : controllerArray){
    if(controller.containsPatchOut(mouseX, mouseY)){
      pressedConnectorID = controller.getOutID();
      return;
    }
  }
}

void mouseReleased(){
  if(pressedConnectorID>0 && audioOutContains(mouseX, mouseY)){    
    for(Poti controller : controllerArray){
      if(controller.getOutID() == pressedConnectorID){
        controller.patch();
        pressedConnectorID = 0;
        return;
      }
    }
  }
  pressedConnectorID = 0;
}
void mouseClicked(){
  checkMenuItemClick(mouseX, mouseY);
  for(Poti controller : controllerArray){
    controller.containsFreqPatchIn(mouseX, mouseY);
    controller.containsAmpPatchIn(mouseX, mouseY);
    if(controller.containsRemove(mouseX, mouseY)){
      controller.unpatch();
      controllerArray.remove(controller);
      return;
    }else if(controller.containsMenu(mouseX, mouseY)){
      controller.toggleExtensions();
      return;
    }else if(controller.containsAmpSelect(mouseX, mouseY)){
      controller.setType(Controller.TYPE_AMP);
      return;
    }else if (controller.containsFreqSelect(mouseX, mouseY)){
      controller.setType(Controller.TYPE_FREQ);
      return;
    }else if(controller.contains(mouseX, mouseY)){
      if(mouseButton==LEFT){
        controller.switchTypes();
      }else if(mouseButton == RIGHT){
        controller.toggleExtensions();
      }
      return;
    }
  }
}

void checkMenuItemClick(int x, int y){
  // Item1 - make new Oscil
    if(x <= 50+25/2 && 
      x >= 50-25/2 &&
      y <= 25+25/2 && y >= 25-25/2)
      controllerArray.add(new Poti(100, 100, new WaveGen(out)));
}

void mouseDragged(){
  int lineStartX=mouseX, lineStartY=mouseY;
  for(Poti controller : controllerArray){
    if(controller.getOutID() == pressedConnectorID){
      lineStartX = controller.mPositionX+((int)(Controller.SIZE_IMG*1.5));
      lineStartY = controller.mPositionY;
    }
    if(controller.contains(mouseX, mouseY)){        
      if(controller.isExtended){
        controller.rotateTo(mouseX, mouseY);
      }else if(!controller.isExtended){
        controller.move(mouseX, mouseY);
      }
      return;
    }
  }
  line(lineStartX, lineStartY, mouseX, mouseY);
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

