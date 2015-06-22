abstract class Controller{
  public static final String TYPE_POTI = "POTI";
  public static final String TYPE_AMP = "AMP";
  public static final String TYPE_FREQ = "FREQ";
  
  public static final int MAX_FREQUENCY = 720;
  public static final int SIZE_IMG = 50;
}

class Poti extends Controller{
  String type = Controller.TYPE_FREQ;
  PImage img, lable, menu, ampSelect, freqSelect;
  float mRotation;
  int mPositionX = 0, mPositionY = 0, waveType = 0;
  boolean isExtended = false;
  SoundObject mSoundObject = null;
   
  Poti(int x, int y, SoundObject so){
    mSoundObject = so;
    img = loadImage("poti.png");
    menu = loadImage("menu.png");
    ampSelect = loadImage("ampSelect.png");
    freqSelect = loadImage("freqSelect.png");
    lable = loadImage("sin.png");
    mPositionX = x;
    mPositionY = y;
    mRotation = 0;
  }
  
  void draw(){
    imageMode(CENTER); 
    pushMatrix();
    translate(mPositionX, mPositionY);
    pushMatrix();
    rotate(mRotation);
    image(img, 0, 0, Controller.SIZE_IMG*2, Controller.SIZE_IMG*2);
    popMatrix();
    image(lable, 0, 0, Controller.SIZE_IMG, Controller.SIZE_IMG);
    image(menu, Controller.SIZE_IMG*0.75, Controller.SIZE_IMG*0.75, Controller.SIZE_IMG/2, Controller.SIZE_IMG/2); 
    if(isExtended){
      image(ampSelect, -Controller.SIZE_IMG, -Controller.SIZE_IMG, Controller.SIZE_IMG/2, Controller.SIZE_IMG/2); 
      image(freqSelect, -(Controller.SIZE_IMG*1.5), 0, Controller.SIZE_IMG/2, Controller.SIZE_IMG/2); 
    }
    popMatrix(); 
  }
  boolean contains(int x, int y){
    if(x <= mPositionX+Controller.SIZE_IMG && 
      x >= mPositionX-Controller.SIZE_IMG &&
      y <= mPositionY+Controller.SIZE_IMG && y >= mPositionY-Controller.SIZE_IMG) return true;
      else return false;
  }
  
  boolean containsMenu(int x, int y){
    if(x <= mPositionX+(Controller.SIZE_IMG*0.75)+(Controller.SIZE_IMG/4) && 
      x >= mPositionX+(Controller.SIZE_IMG*0.75)-(Controller.SIZE_IMG/4) &&
      y >= mPositionY+(Controller.SIZE_IMG*0.75)-(Controller.SIZE_IMG/4) && 
      y <= mPositionY+(Controller.SIZE_IMG*0.75)+(Controller.SIZE_IMG/4)) return true;
      else return false;
  }
    
  boolean containsAmpSelect(int x, int y){
    if(x <= mPositionX-Controller.SIZE_IMG+(Controller.SIZE_IMG/4) && 
      x >= mPositionX-Controller.SIZE_IMG-(Controller.SIZE_IMG/4) &&
      y <= mPositionY-Controller.SIZE_IMG+(Controller.SIZE_IMG/4) && 
      y >= mPositionY-Controller.SIZE_IMG-(Controller.SIZE_IMG/4) &&
      isExtended) {
        println("hit amp");
        return true;
      }
      else return false;
  }
    
  boolean containsFreqSelect(int x, int y){
    if(x <= mPositionX-(Controller.SIZE_IMG/2)-(Controller.SIZE_IMG/4) && 
      x >= mPositionX-(Controller.SIZE_IMG+Controller.SIZE_IMG/2)-(Controller.SIZE_IMG/4) &&
      y <= mPositionY+(Controller.SIZE_IMG/4) && 
      y >= mPositionY-(Controller.SIZE_IMG/4) &&
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
    
    if(isFrequencyController()) ((WaveGen)mSoundObject).setFrequency(degrees( mRotation*(Controller.MAX_FREQUENCY/360)));
    else if(isAmplitudeController()) ((WaveGen)mSoundObject).setAmplitude(degrees( mRotation/360)); 
  }
  
  void move(int x, int y){  
    mPositionX = x;
    mPositionY = y;
  }
  
  void setLabel(PImage l){ lable = l; }
  void setType(String s){ 
    this.type = s; 
    if(s.equalsIgnoreCase(Controller.TYPE_AMP)) mRotation = radians(((WaveGen)mSoundObject).getAmplitude()*360);
    else if(s.equalsIgnoreCase(Controller.TYPE_FREQ)) mRotation = radians(((WaveGen)mSoundObject).getFrequency()/(Controller.MAX_FREQUENCY/360));
  }
  void toggleExtensions(){ isExtended = !isExtended; }
  
  SoundObject getSoundObject(){ return mSoundObject; }
  
  boolean isFrequencyController(){ return type.equalsIgnoreCase(Controller.TYPE_FREQ);}
  boolean isAmplitudeController(){ return type.equalsIgnoreCase(Controller.TYPE_AMP);}

  void switchTypes(){
    waveType = (waveType+1)%5;
    switch(waveType){
      case 0:
        ((WaveGen)mSoundObject).setWaveform(Waves.SINE);
        lable = loadImage("sin.png");
        break;
        
      case 1: 
         ((WaveGen)mSoundObject).setWaveform(Waves.TRIANGLE);
        lable = loadImage("triangle.png");  
        break;
   
      case 2:
         ((WaveGen)mSoundObject).setWaveform(Waves.SAW);
        lable = loadImage("saw.png");
        break;
   
      case 3:
         ((WaveGen)mSoundObject).setWaveform(Waves.SQUARE);
        lable = loadImage("square.png");
        break;
   
      case 4:
         ((WaveGen)mSoundObject).setWaveform(Waves.QUARTERPULSE);
        lable = loadImage("quarter.png");
        break;
      default: break; 
    }
  }
}


