//The MIT License (MIT) - See Licence.txt for details

//Copyright (c) 2013 Mick Grierson, Matthew Yee-King, Marco Gillies

Maxim maxim;
Synthesiser[] synths;
int playhead;

int numBeats = 16;
int numTracks = 4;
int currentBeat = 0;

PImage bg;

boolean [][] tracks;

Slider dt, dg, a, r, f, q, fa, o;

void setup()
{
  size(1024, 768);
  maxim = new Maxim(this);
  
  synths = new Synthesiser[numTracks];
  tracks = new boolean[numTracks][numBeats];
  for (int trackIndex = 0; trackIndex < numTracks; trackIndex++) {
    for (int i = 0; i < numBeats; i++) {
      tracks[trackIndex][i] = false;
    }
    synths[trackIndex] = new Synthesiser(20 + 60 * trackIndex, tracks[trackIndex]);
  }

  // name, value, min, max, pos.x, pos.y, width, height
  dt = new Slider("delay time", 1, 0, 100, 110, 10, 200, 20, HORIZONTAL);
  dg = new Slider("delay amnt", 1, 0, 100, 110, 30, 200, 20, HORIZONTAL);
  a = new Slider("attack", 1, 0, 100, 110, 50, 200, 20, HORIZONTAL);
  r = new Slider("release", 20, 0, 100, 110, 70, 200, 20, HORIZONTAL);
  f = new Slider("filter", 20, 0, 100, 110, 90, 200, 20, HORIZONTAL);
  q = new Slider("res", 20, 0, 100, 110, 110, 200, 20, HORIZONTAL);
  fa = new Slider("filterAmp", 20, 0, 100, 110, 130, 200, 20, HORIZONTAL);
  o = new Slider("transpose", 0, 1, 80, 110, 150, 200, 20, HORIZONTAL);

  frameRate(30);

//  bg = loadImage("brushedM.jpg");
}

void draw()
{
  background(20);
//  image(bg, 0, 0, width, height);
  stroke(255);
  for (int i = 0; i < 5; i++)
    line(0, 500+(i*height/12), width, 500+(i*height/12));
  for (int i = 0; i < numBeats + 1; i++)
    line(i*width/numBeats, 500, i*width/numBeats, 500+(4*height/12));

  int buttonWidth = width/numBeats;
  int buttonHeight = height/12;

  for (int trackIndex = 0; trackIndex < numTracks; trackIndex++) {
    for (int i = 0; i < numBeats; i++) {
      noStroke();
      fill(200, 0, 0);
  
      if (tracks[trackIndex][i]) {
        rect(i*buttonWidth, 500+(trackIndex*buttonHeight), buttonWidth, buttonHeight);
      }
    }
  }

  if (f.get()) {
    for (Synthesiser synth : synths) {
      synth.setFilter(f.get());
    }
  }

  if (dt.get()) {
    for (Synthesiser synth : synths) {
      synth.setDelayTime(dt.get());
    }
  }

  if (dg.get()) {
    for (Synthesiser synth : synths) {
      synth.setDelayAmount(dg.get());
    }
  }

  if (q.get()) {
    for (Synthesiser synth : synths) {
      synth.setRes(q.get());
    }
  }

  if (a.get()) {
    for (Synthesiser synth : synths) {
      synth.setAttack(a.get());
    }
  }

  if (r.get()) {
    for (Synthesiser synth : synths) {
      synth.setRelease(r.get());
    }
  }

  if (fa.get()) {
    for (Synthesiser synth : synths) {
      synth.setFilterAttack(fa.get());
    }
  }

  if (o.get()) {
    for (Synthesiser synth : synths) {
      synth.setTranspose(o.get());
    }
  }
  
  dt.display();
  dg.display();
  a.display();
  r.display();
  f.display();
  q.display();
  fa.display(); 
  o.display();
  
  for (Synthesiser synth : synths) {
    synth.tick();
  }
  playhead ++;
  if (playhead%4==0) {
    fill(0, 0, 200, 120);
    rect(currentBeat*buttonWidth, 500, buttonWidth, height);

    currentBeat++;
    if (currentBeat >= numBeats)
      currentBeat = 0;
  }

}


void mouseReleased()
{
  dt.mouseReleased();
  dg.mouseReleased();
  a.mouseReleased();
  r.mouseReleased();
  f.mouseReleased();
  q.mouseReleased();
  o.mouseReleased();
  fa.mouseReleased();
  
  int index = Math.floor(mouseX*numBeats/width);   
  int track = Math.floor((mouseY-500)*(12/height));
  tracks[track][index] = synths[track].toggleActive(index);
}

void mouseDragged()
{
  dt.mouseDragged();
  dg.mouseDragged();
  a.mouseDragged();
  r.mouseDragged();
  f.mouseDragged();
  q.mouseDragged();
  fa.mouseDragged();
  o.mouseDragged();
  
  int index = Math.floor(mouseX*numBeats/width);   
  int track = Math.floor((mouseY-500)*(12/height));
  tracks[track][index] = synths[track].toggleActive(index);
}

