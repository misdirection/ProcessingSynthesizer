abstract class Controller{
  public static final String POTI = "POTI";
}

class Poti extends Controller{
  PImage img; 
  PImage lable;
  PImage mover;
  float mRotation;
  int mPositionX = 0;
  int mPositionY = 0;
  boolean isExtended = false;
   
  Poti(int x, int y, PImage l){
    img = loadImage("poti.png");
    mover = loadImage("mover.png");
    mPositionX = x;
    mPositionY = y;
    mRotation = 0;
    lable = l;
  }
  
  void draw(){
    imageMode(CENTER); 
    pushMatrix();
    translate(mPositionX, mPositionY);
    pushMatrix();
    rotate(mRotation);
    image(img, 0, 0, 100, 100);
    popMatrix();
    image(lable, 0, 0, 50, 50);
    if(isExtended){
      image(mover, 50, 50, 25, 25);  
    }
    popMatrix(); 
  }
  float getEncodedValue(){
    return mRotation;
  }
  boolean contains(int x, int y){
    if(x <= mPositionX+50 && 
      x >= mPositionX-50 &&
      y <= mPositionY+50 && y >= mPositionY-50
      && !containsMover(x,y)) return true;
      else return false;
  }
  
  boolean containsMover(int x, int y){
    if(x <= mPositionX+75 && 
      x >= mPositionX+25 &&
      y <= mPositionY+75 && 
      y >= mPositionY+25 &&
      isExtended) return true;
      else return false;
  }
  void rotateTo(int x, int y){
    PVector a = new PVector(0, -1);
    PVector b = new PVector(mPositionX - x, mPositionY - y);
    if(x > mPositionX) mRotation = PI-PVector.angleBetween(a,b);
    else mRotation = PI + PVector.angleBetween(a,b);
  }
  
  void move(int x, int y){  
    mPositionX = x-50;
    mPositionY = y-50;
  }
  
  void setLabel(PImage l){
    lable = l;
  }
  
  void toggleExtensions(){ isExtended = !isExtended; }
}


