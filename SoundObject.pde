abstract class SoundObject{
  abstract void draw();
  abstract boolean isType(String s);
  abstract void patch(AudioOutput out, AudioOutput out2);
}

class WaveGen extends SoundObject{
  private Oscil mWave;
  private int mIndex, waveType = 0;
  private Poti controller;
  private 
  
  WaveGen(AudioOutput out, int x, int y, int index){
    mIndex = index;
    controller = new Poti(x, y, loadImage("sin.png"));
    mWave = new Oscil( 0, 0.5f, Waves.SINE );
    mWave.patch(out);
  }
  
  void setAmplitude(float amplitude){ mWave.setAmplitude( amplitude ); }  
  void setFrequency(float freqency){ mWave.setFrequency( freqency ); }
  void setWaveform(Wavetable wave){ mWave.setWaveform(wave); }
  Poti getController(){ return controller; }
  void patch(AudioOutput out, AudioOutput out2){
    mWave.unpatch(out);
    mWave.patch(out2);
  }
  
  boolean isType(String s){ return s.equalsIgnoreCase(Controller.TYPE_POTI); }
  
  void switchTypes(){
    waveType = (waveType+1)%5;
    switch(waveType){
   
    case 0:
      setWaveform(Waves.SINE);
      controller.setLabel(loadImage("sin.png"));
      break;
      
    case 1: 
      setWaveform(Waves.TRIANGLE);
      controller.setLabel(loadImage("triangle.png"));  
      break;
 
    case 2:
      setWaveform(Waves.SAW);
      controller.setLabel(loadImage("saw.png"));
      break;
 
    case 3:
      setWaveform(Waves.SQUARE);
      controller.setLabel(loadImage("square.png"));
      break;
 
    case 4:
      setWaveform(Waves.QUARTERPULSE);
      controller.setLabel(loadImage("quarter.png"));
      break;
    default: break; 
    }
  }
  
  void draw(){
      controller.draw();
  } 
}  
