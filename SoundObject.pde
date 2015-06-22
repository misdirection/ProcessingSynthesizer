abstract class SoundObject{
  abstract boolean isType(String s);
  abstract void patch();
  abstract void patch(AudioOutput out);
 // abstract void patch(UGen ugen);
  abstract void unpatch();
 // abstract UGen getUGen();
}

class WaveGen extends SoundObject{
  private Oscil mWave;
  private float maxAmp;
  private float freq;
  private AudioOutput audioOutput = null;
  private UGen patchOut = null;
  
  WaveGen(AudioOutput out){
    maxAmp = 2;
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
  Oscil getOscil(){return mWave; }
  void patch(UGen.UGenInput ugen){ mWave.patch(ugen); }
  void patch(AudioOutput out){ unpatchFromOut(); mWave.patch(out); this.audioOutput = out;}
  void patch(){
    unpatch();  
    mWave.patch(audioOutput);
  }
  void unpatch(){
    try{ mWave.unpatch(audioOutput);
    }catch(Exception e){}
    try{ mWave.unpatch(patchOut);
    }catch(Exception e){}
  }
  
  void unpatchFromOut(){
    try{ mWave.unpatch(audioOutput);
    }catch(Exception e){}
  }
    
  void unpatchFromUGen(UGen ugen){
    try{ mWave.unpatch(ugen);
    }catch(Exception e){}
  }
  
  boolean isType(String s){ return s.equalsIgnoreCase(Controller.TYPE_POTI); }
  
  
  
}  
