abstract class SoundObject{
abstract void draw();
abstract ImageObject[] getController();
}

class WaveGen extends SoundObject{
  private Oscil mWave;
  private int mIndex, waveType = 0;
  private ImageObject[] controller = new ImageObject[0];
  
  WaveGen(AudioOutput out, Wavetable wave, int index){
    mIndex = index;
    controller = (ImageObject[])append(controller, new Poti(index));
    mWave = new Oscil( 0, 0.5f, Waves.SINE );
    mWave.patch(out);
  }
  
  void setAmplitude(float amplitude){
    mWave.setAmplitude( amplitude );
  }  
  void setFrequency(float freqency){
    mWave.setFrequency( freqency );
  }
  void setWaveform(Wavetable wave){
    mWave.setWaveform(wave);
  }
  
  ImageObject[] getController(){
    return controller;
  }
  
  void switchTypes(){
    waveType = (waveType+1)%5;
    println(waveType);
    switch(waveType){
   
    case 0:
      setWaveform(Waves.SINE);
      break;
      
    case 1: 
      setWaveform(Waves.TRIANGLE);  
      break;
 
    case 2:
      setWaveform(Waves.SAW);
      break;
 
    case 3:
      setWaveform(Waves.SQUARE);
      break;
 
    case 4:
      setWaveform(Waves.QUARTERPULSE);
      break;
    default: break; 
    }
    for(ImageObject img : controller){
      if(img.type.equalsIgnoreCase("Poti")){
        ((Poti)img).setWaveType(waveType);
      }
    }
  }
  
  void draw(){
    for(int i = 0; i < controller.length; ++i){
      controller[i].draw();
    }
  } 
}  
