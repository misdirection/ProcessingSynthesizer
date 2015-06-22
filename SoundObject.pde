abstract class SoundObject{
  abstract boolean isType(String s);
  abstract void patch(AudioOutput out, AudioOutput out2);
}

class WaveGen extends SoundObject{
  private Oscil mWave;
  private float maxAmp;
  private float freq;
  
  WaveGen(AudioOutput out){
    maxAmp = 0.5;
    mWave = new Oscil( 0, maxAmp, Waves.SINE );
    mWave.patch(out);
  }
  
  void setAmplitude(float amplitude){ 
    maxAmp = amplitude;
    mWave.setAmplitude( amplitude ); 
  }  
  void setFrequency(float frequency){ freq = frequency; mWave.setFrequency( frequency ); }
  void setWaveform(Wavetable wave){ mWave.setWaveform(wave); }
  float getAmplitude(){ return maxAmp; };
  float getFrequency(){ return freq; };
  void patch(AudioOutput out, AudioOutput out2){
    mWave.unpatch(out);
    mWave.patch(out2);
  }
  
  boolean isType(String s){ return s.equalsIgnoreCase(Controller.TYPE_POTI); }
  
  
  
}  
