abstract class ImageObject{
  int mIndex, alignHorizontal;
  String type = "";
  abstract void draw();
  abstract boolean contains(int x, int y);
  abstract void move(int x, int y);
  abstract float getEncodedValue();
}

class Poti extends ImageObject{
  PImage img; 
  PImage lable;
  float mRotation;
   
  Poti(int index){
    img = loadImage("poti.png");
    mIndex = index; 
    alignHorizontal = (mIndex+1)*110;  
    mRotation = 0;
    type = "Poti";
    lable = loadImage("sin.png");
  }
  
  void draw(){
    imageMode(CENTER); 
    pushMatrix();
    translate(alignHorizontal, height-50);
    pushMatrix();
    rotate(mRotation);
    image(img, 0, 0, 100, 100);
    popMatrix();
    image(lable, 0, 0, 50, 50);
    popMatrix(); 
  }
  float getEncodedValue(){
    return mRotation;
  }
  boolean contains(int x, int y){
    if(x <= alignHorizontal+50 && 
      x >= alignHorizontal-50 &&
      y < height && y > height-100) return true;
      else return false;
  }
  void move(int x, int y){
    PVector a = new PVector(0, -1);
    PVector b = new PVector(alignHorizontal - x, height-50 - y);
    if(x > alignHorizontal) mRotation = PI-PVector.angleBetween(a,b);
    else mRotation = PI + PVector.angleBetween(a,b);
  }
  
  void setWaveType(int waveType){
    switch(waveType){
   
    case 0:
      lable = loadImage("sin.png");
      break;
      
    case 1: 
      lable = loadImage("triangle.png"); 
      break;
 
    case 2:
      lable = loadImage("saw.png");
      break;
 
    case 3:
      lable = loadImage("square.png");
      break;
 
    case 4:
      lable = loadImage("quarter.png");
      break;
    default: break; 
    }
  }
}
