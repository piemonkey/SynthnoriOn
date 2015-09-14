//The MIT License (MIT) - See Licence.txt for details

//Copyright (c) 2013 Mick Grierson, Matthew Yee-King, Marco Gillies

Maxim maxim;
AudioFilePlayer sample1;
AudioFilePlayer sample2; 
AudioFilePlayer sample3; 
AudioFilePlayer sample4;
Synthesiser synth;
int playhead;
int[] notes = {
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
};

int numBeats = 16;
int currentBeat = 0;

PImage bg;

boolean [] track1;
boolean [] track2;
boolean [] track3;
boolean [] track4;

boolean isPlaying;

Slider dt, dg, a, r, f, q, fa, o;
MultiSlider seq;

void setup()
{
  size(1024, 768);
  maxim = new Maxim(this);
  synth = new Synthesiser(notes);
  sample1 = maxim.loadFile("bd1.wav", 2048);
  sample2 = maxim.loadFile("sn1.wav", 2048);
  sample3 = maxim.loadFile("hh1.wav", 2048);
  sample4 = maxim.loadFile("sn2.wav", 2048);
  sample1.setLooping(false);
  sample2.setLooping(false);
  sample3.setLooping(false);
  sample4.setLooping(false);
  // name, value, min, max, pos.x, pos.y, width, height
  dt = new Slider("delay time", 1, 0, 100, 110, 10, 200, 20, HORIZONTAL);
  dg = new Slider("delay amnt", 1, 0, 100, 110, 30, 200, 20, HORIZONTAL);
  a = new Slider("attack", 1, 0, 100, 110, 50, 200, 20, HORIZONTAL);
  r = new Slider("release", 20, 0, 100, 110, 70, 200, 20, HORIZONTAL);
  f = new Slider("filter", 20, 0, 100, 110, 90, 200, 20, HORIZONTAL);
  q = new Slider("res", 20, 0, 100, 110, 110, 200, 20, HORIZONTAL);
  fa = new Slider("filterAmp", 20, 0, 100, 110, 130, 200, 20, HORIZONTAL);
  o = new Slider("transpose", 0, 1, 80, 110, 150, 200, 20, HORIZONTAL);
  // name,s min, max, pos.x, pos.y, width, height
  seq = new MultiSlider(notes.length, 0, 256, 0, 300, width/18/2, 150, UPWARDS);
  // name, value, min, max, pos.x, pos.y, width, height

  frameRate(30);

  track1 = new boolean[numBeats];
  track2 = new boolean[numBeats];
  track3 = new boolean[numBeats];
  track4 = new boolean[numBeats]; 

  for (int i = 0; i < numBeats; i++)
  {
    track1[i] = false;
    track2[i] = false;
    track3[i] = false;
    track4[i] = false;
  }

  bg = loadImage("brushedM.jpg");

  isPlaying=false;
}

void draw()
{
  image(bg, 0, 0, width, height);
  stroke(255);
  for (int i = 0; i < 5; i++)
    line(0, 500+(i*height/12), width, 500+(i*height/12));
  for (int i = 0; i < numBeats + 1; i++)
    line(i*width/numBeats, 500, i*width/numBeats, 500+(4*height/12));

  int buttonWidth = width/numBeats;
  int buttonHeight = height/12;

  for (int i = 0; i < numBeats; i++)
  {
    noStroke();
    fill(200, 0, 0);

    if (track1[i])
      rect(i*buttonWidth, 500+(0*buttonHeight), buttonWidth, buttonHeight);
    if (track2[i])
      rect(i*buttonWidth, 500+(1*buttonHeight), buttonWidth, buttonHeight);
    if (track3[i])
      rect(i*buttonWidth, 500+(2*buttonHeight), buttonWidth, buttonHeight);
    if (track4[i])
      rect(i*buttonWidth, 500+(3*buttonHeight), buttonWidth, buttonHeight);
  }

  if (f.get()) {
    synth.setFilter(f.get());
  }

  if (dt.get()) {
    synth.setDelayTime(dt.get());
  }

  if (dg.get()) {
    synth.setDelayAmount(dg.get());
  }

  if (q.get()) {
    synth.setRes(q.get());
  }

  if (a.get()) {
    synth.setAttack(a.get());
  }

  if (r.get()) {
    synth.setRelease(r.get());
  }

  if (fa.get()) {
    synth.setFilterAttack(fa.get());
  }

  if (o.get()) {
    synth.setTranspose(o.get());
  }

  dt.display();
  dg.display();
  a.display();
  r.display();
  f.display();
  q.display();
  fa.display(); 
  o.display();
  seq.display();

  synth.tick();
  playhead ++;
  if (playhead%4==0) {
    fill(0, 0, 200, 120);
    rect(currentBeat*buttonWidth, 500, buttonWidth, height);

    if (track1[currentBeat]){
      sample1.cue(0);
      sample1.play();
    }
    if (track2[currentBeat]){
      sample2.cue(0);
      sample2.play();
    }
    if (track3[currentBeat]){
      sample3.cue(0);
      sample3.play();
    }
    if (track4[currentBeat]){
      sample4.cue(0);
      sample4.play();
    }

    currentBeat++;
    if (currentBeat >= numBeats)
      currentBeat = 0;
  }

}


void mousePressed()
{

  if (!isPlaying) {

    isPlaying=true; 
    sample1.cue(0);
    sample1.play();
  }
}

void mouseReleased()
{
  for (int i=0;i<notes.length;i++) {
    notes[i]=seq.get(i);
  }
  synth.setNotes(notes);
  
  dt.mouseReleased();
  dg.mouseReleased();
  a.mouseReleased();
  r.mouseReleased();
  f.mouseReleased();
  q.mouseReleased();
  o.mouseReleased();
  fa.mouseReleased();
  seq.mouseReleased();

  int index = Math.floor(mouseX*numBeats/width);   
  int track = Math.floor((mouseY-500)*(12/height));
  if (track == 0)
    track1[index] = !track1[index];
  if (track == 1)
    track2[index] = !track2[index];
  if (track == 2)
    track3[index] = !track3[index];
  if (track == 3)
    track4[index] = !track4[index];
}

void mouseDragged()
{

  if (!isPlaying) {

    isPlaying=true; 
    sample1.cue(0);
    sample1.play();
  }
  dt.mouseDragged();
  dg.mouseDragged();
  a.mouseDragged();
  r.mouseDragged();
  f.mouseDragged();
  q.mouseDragged();
  fa.mouseDragged();
  o.mouseDragged();
  seq.mouseDragged();

  int index = Math.floor(mouseX*numBeats/width);   
  int track = Math.floor((mouseY-500)*(12/height));
  if (track == 0)
    track1[index] = !track1[index];
  if (track == 1)
    track2[index] = !track2[index];
  if (track == 2)
    track3[index] = !track3[index];
  if (track == 3)
    track4[index] = !track4[index];
}

