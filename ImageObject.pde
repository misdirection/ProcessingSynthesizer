abstract class Controller{
  public static final String TYPE_POTI = "POTI";
  public static final String TYPE_AMP = "AMP";
  public static final String TYPE_FREQ = "FREQ";
}

class Poti extends Controller{
  String type = Controller.TYPE_FREQ;
  PImage img, lable, mover, ampSelect, freqSelect;
  float mRotation;
  int mPositionX = 0, mPositionY = 0;
  boolean isExtended = true;
   
  Poti(int x, int y, PImage l){
    img = loadImage("poti.png");
    mover = loadImage("mover.png");
    ampSelect = loadImage("ampSelect.png");
    freqSelect = loadImage("freqSelect.png");
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
      image(ampSelect, -50, -50, 25, 25); 
      image(freqSelect, -75, 0, 25, 25); 
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
    if(x <= mPositionX+50+25/2 && 
      x >= mPositionX+50-25/2 &&
      y >= mPositionY+50-25/2 && 
      y <= mPositionY+50+25/2 &&
      isExtended) return true;
      else return false;
  }
    
  boolean containsAmpSelect(int x, int y){
    if(x <= mPositionX-50+25/2 && 
      x >= mPositionX-50-25/2 &&
      y <= mPositionY-50+25/2 && 
      y >= mPositionY-50-25/2 &&
      isExtended) {
        println("hit amp");
        return true;
      }
      else return false;
  }
    
  boolean containsFreqSelect(int x, int y){
    if(x <= mPositionX-25-25/2 && 
      x >= mPositionX-75-25/2 &&
      y <= mPositionY+25/2 && 
      y >= mPositionY-25/2 &&
      isExtended) {
        println("hit freq");
        return true;
      }
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
  void setType(String s){ this.type = s; }
  void toggleExtensions(){ isExtended = !isExtended; }
  boolean isFrequencyController(){ return type.equalsIgnoreCase(Controller.TYPE_FREQ);}
  boolean isAmplitudeController(){ return type.equalsIgnoreCase(Controller.TYPE_AMP);}
}


