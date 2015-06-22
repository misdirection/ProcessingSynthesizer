abstract class SoundObject{
  abstract boolean isType(String s);
  abstract void patch();
  abstract void unpatch();
}

class WaveGen extends SoundObject{
  private Oscil mWave;
  private float maxAmp;
  private float freq;
  private AudioOutput audioOutput = null;
  private UGen patchOut = null;
  
  WaveGen(AudioOutput out){
    maxAmp = 0.5;
    mWave = new Oscil( 0, maxAmp, Waves.SINE );
    audioOutput = out;
  }
  
  void setAmplitude(float amplitude){ 
    maxAmp = amplitude;
    mWave.setAmplitude( amplitude ); 
  }  
  void setFrequency(float frequency){ freq = frequency; mWave.setFrequency( frequency ); }
  void setWaveform(Wavetable wave){ mWave.setWaveform(wave); }
  float getAmplitude(){ return maxAmp; };
  float getFrequency(){ return freq; };
  void patch(){
    try{ unpatch();
    }catch(Exception e){}
    mWave.patch(audioOutput);
  }
  void unpatch(){
    try{ 
      mWave.unpatch(audioOutput);
    }catch(Exception e){}
    try{ 
      mWave.unpatch(patchOut);
    }catch(Exception e){}
  }
  
  boolean isType(String s){ return s.equalsIgnoreCase(Controller.TYPE_POTI); }
  
  
  
}  
