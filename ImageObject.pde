abstract class Controller{
  public static final String POTI = "POTI";
}

class Poti extends Controller{
  PImage img; 
  PImage lable;
  float mRotation;
  int mPositionX = 0;
  int mPositionY = 0;
   
  Poti(int x, int y, PImage l){
    img = loadImage("poti.png");
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
    popMatrix(); 
  }
  float getEncodedValue(){
    return mRotation;
  }
  boolean contains(int x, int y){
    if(x <= mPositionX+50 && 
      x >= mPositionX-50 &&
      y <= mPositionY+50 && y >= mPositionY-50) return true;
      else return false;
  }
  void move(int x, int y){
    PVector a = new PVector(0, -1);
    PVector b = new PVector(mPositionX - x, mPositionY - y);
    if(x > mPositionX) mRotation = PI-PVector.angleBetween(a,b);
    else mRotation = PI + PVector.angleBetween(a,b);
  }
  
  void setLabel(PImage l){
    lable = l;
  }
}
