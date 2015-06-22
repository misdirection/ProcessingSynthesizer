import ddf.minim.spi.*;
import ddf.minim.signals.*;
import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.ugens.*;
import ddf.minim.effects.*;

Minim minim;
AudioOutput out;
ArrayList<Poti> controllerArray = new ArrayList<Poti>();
ArrayList<Line> lineArray = new ArrayList<Line>();
Line pressedConnectorLine = null;
int outScale = 1, pressedConnectorID = 0;

void setup(){  //noLoop();
  size(1280, 800);
  
  minim = new Minim(this);
  out = minim.getLineOut();
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
  for(Line l : lineArray){
    l.draw();
  }
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
    repeat = (out.bufferSize() / outScale + xoffset < getWidth());
    xoffset += out.bufferSize() / outScale;
  }
}
void mousePressed(){
  for(Poti controller : controllerArray){
    if(controller.containsPatchOut(mouseX, mouseY)){
      pressedConnectorID = controller.getOutID();
      pressedConnectorLine = new Line(controller.getOutID(), 0, 
          (int)(controller.mPositionX+(Controller.SIZE_IMG*1.5)), controller.mPositionY, 
          mouseX, mouseY);
      return;
    }
  }
}

void mouseReleased(){
     
  for(Poti controller : controllerArray){
    if(controller.getOutID() == pressedConnectorID && audioOutContains(mouseX, mouseY)){ 
      controller.getSoundObject().patch(out);
      pressedConnectorID = 0;
      lineArray.add(pressedConnectorLine);
      return;
    }else{ 
      for(Poti controller2 : controllerArray){
        if(controller.getOutID() == pressedConnectorID && controller2.containsFreqPatchIn(mouseX, mouseY)){  
          controller.getSoundObject().patch(controller2.getSoundObject().getUGen());
          pressedConnectorID = 0;
          pressedConnectorLine.toID = controller2.getFreqInID();
          lineArray.add(pressedConnectorLine);
          return;
        }
      }
    }
  }
  pressedConnectorID = 0;
}

void mouseClicked(){
  checkMenuItemClick(mouseX, mouseY);
  for(int i = 0; i < controllerArray.size(); ++i){
    controllerArray.get(i).containsFreqPatchIn(mouseX, mouseY);
    if(controllerArray.get(i).containsRemove(mouseX, mouseY)){
      controllerArray.get(i).unpatch();
      ArrayList<Line> newLineArray = new ArrayList<Line>();
      for(Line l : lineArray){
        if(!(l.fromID == controllerArray.get(i).getOutID()) && !(l.toID == controllerArray.get(i).getFreqInID())) {
          newLineArray.add(l);
        }
      }
      lineArray = newLineArray;
      controllerArray.remove(i);
    }else if(controllerArray.get(i).containsMenu(mouseX, mouseY)){
      controllerArray.get(i).toggleExtensions();
      return;
    }else if(controllerArray.get(i).containsAmpSelect(mouseX, mouseY)){
      controllerArray.get(i).setType(Controller.TYPE_AMP);
      return;
    }else if (controllerArray.get(i).containsFreqSelect(mouseX, mouseY)){
      controllerArray.get(i).setType(Controller.TYPE_FREQ);
      return;
    }else if(controllerArray.get(i).contains(mouseX, mouseY)){
      if(mouseButton==LEFT){
        controllerArray.get(i).switchTypes();
      }else if(mouseButton == RIGHT){
        controllerArray.get(i).toggleExtensions();
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
  for(Poti controller : controllerArray){
    if(controller.getOutID() == pressedConnectorID){
      pressedConnectorLine.toX = mouseX;
      pressedConnectorLine.toY = mouseY;
      pressedConnectorLine.draw();
    }
    if(controller.contains(mouseX, mouseY)){        
      if(controller.isExtended){
        controller.rotateTo(mouseX, mouseY);
      }else if(!controller.isExtended){
        controller.move(mouseX, mouseY);
        for(Line l : lineArray){
          if(l.fromID == controller.getOutID()){
            l.fromX = (int)(controller.mPositionX+(Controller.SIZE_IMG*1.5));
            l.fromY = controller.mPositionY;
          }
        }
      }
      return;
    }
  }
}


void mouseMoved(){}

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

class Line{
  int fromID, toID, fromX,  toX, fromY,  toY;
  
  Line(int fromID, int toID, int fromX, int fromY, int toX, int toY){
    this.fromID = fromID;
    this.toID = toID; 
    this.fromX = fromX;  
    this.toX = toX;
    this.fromY = fromY;  
    this.toY = toY;
  }
  
  void draw(){
    line(fromX, fromY, toX, toY);
  }
}

