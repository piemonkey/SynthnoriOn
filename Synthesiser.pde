class Synthesiser {
  Synth waveform;
  int note;
  float rawNote;
  float filter, res, delayTime, attack, release, filterAttack;
  int playhead = 0, transpose = 0, delayAmount = 0;
  float[] wavetable = new float[514];
  
  Synthesiser(float rawNote) {
    waveform = new Synth();
    setNote(rawNote);
    for (int i = 0; i < 515 ; i++) {
      wavetable[i]=((float)i/512)-0.5;
    }
    waveform.waveTableSize(514);
    waveform.loadWaveTable(wavetable);
  }
  
  void setNote(float rawNote) {
    this.rawNote = rawNote;      
    calculateNote();
  }
  
  void calculateNote() {
    note = Math.floor((rawNote/256)*12+transpose); 
  }
  
  void setFilter(float filter) {
    this.filter = filter * 100;
    waveform.setFilter(this.filter, res);
  }
  
  void setDelayTime(float delayTime) {
    this.delayTime = delayTime / 50;
    waveform.setDelayTime(this.delayTime);
  }
  
  void setDelayAmount(float delayAmount) {
    this.delayAmount = (int) delayAmount / 100;
    waveform.setDelayAmount(this.delayAmount);
  }
  
  void setRes(float res) {
    this.res = res;
    waveform.setFilter(filter, this.res);
  }
  
  void setAttack(float attack) {
    this.attack = attack * 10;
  }

  void setRelease(float release) {
    this.release = release * 10;
  }

  void setFilterAttack(float filterAttack) {
    this.filterAttack = filterAttack * 10;
  }
  
  void setTranspose(float transpose) {
    this.transpose=Math.floor(transpose);
    calculateNote();
  }
  
  void tick() {
    if (playhead%4==0) {
      waveform.ramp(0.5, attack);
      waveform.setFrequency(mtof[note + 30]);
      waveform.filterRamp((filter/100) * (filterAttack*0.2), attack + release);
    }
    if (playhead%4==1) {
      waveform.ramp(0.0, release);
    }

    waveform.play();
    playhead++;
  }

}

