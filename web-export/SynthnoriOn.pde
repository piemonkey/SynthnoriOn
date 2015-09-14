//The MIT License (MIT) - See Licence.txt for details

//Copyright (c) 2013 Mick Grierson, Matthew Yee-King, Marco Gillies
//Copyright (c) 2015 Richard Miller

Maxim maxim;
Synthesiser[] synths;
int playhead;

int numBeats = 16;
int numTracks = 16;
int currentBeat = 0;

//PImage bg;
int tenoriX = 350;
int tenoriY = 20;
int tenoriWidth = 600;

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
    synths[trackIndex] = new Synthesiser(10 + 10 * trackIndex, tracks[trackIndex]);
  }

  // name, value, min, max, pos.x, pos.y, width, height
  dt = new Slider("delay time", 1, 0, 100, 110, 10, 200, 20, HORIZONTAL);
  dg = new Slider("delay amnt", 1, 0, 100, 110, 30, 200, 20, HORIZONTAL);
  a = new Slider("attack", 1, 0, 100, 110, 50, 200, 20, HORIZONTAL);
  r = new Slider("release", 20, 0, 100, 110, 70, 200, 20, HORIZONTAL);
  f = new Slider("filter", 20, 0, 100, 110, 90, 200, 20, HORIZONTAL);
  q = new Slider("res", 10, 0, 100, 110, 110, 200, 20, HORIZONTAL);
  fa = new Slider("filterAmp", 20, 0, 100, 110, 130, 200, 20, HORIZONTAL);
  o = new Slider("transpose", 20, 0, 60, 110, 150, 200, 20, HORIZONTAL);

  frameRate(30);

//  bg = loadImage("brushedM.jpg");
}

void draw()
{
  background(20);
//  image(bg, 0, 0, width, height);
  stroke(255);
  // Draw horizontal lines
  for (int i = 0; i < numTracks + 1; i++) {
    int yPos = tenoriY + (i * tenoriWidth/numBeats);
    line(tenoriX, yPos, tenoriX + tenoriWidth, yPos);
  }
  // Draw vertical lines
  for (int i = 0; i < numBeats + 1; i++) {
    int xPos = tenoriX + (i * tenoriWidth/numBeats);
    line(xPos, tenoriY, xPos, tenoriY + tenoriWidth);
  }

  int buttonWidth = tenoriWidth/numBeats;
  int buttonHeight = tenoriWidth/numTracks;

  for (int trackIndex = 0; trackIndex < numTracks; trackIndex++) {
    for (int i = 0; i < numBeats; i++) {
      noStroke();
      fill(200, 200, 255);

      if (tracks[trackIndex][i]) {
        rect(tenoriX + i*buttonWidth, tenoriY+(trackIndex*buttonHeight), buttonWidth, buttonHeight);
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
    rect(tenoriX + currentBeat*buttonWidth, tenoriY, buttonWidth, tenoriWidth);

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

  int index = Math.floor((mouseX - tenoriX) * numBeats/tenoriWidth);
  int track = Math.floor((mouseY - tenoriY) * numTracks/tenoriWidth);
  if (index >= 0 && index < numBeats && track >= 0 && track < numTracks) {
    tracks[track][index] = synths[track].toggleActive(index);
  }
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

  int index = Math.floor((mouseX - tenoriX) * numBeats/tenoriWidth);
  int track = Math.floor((mouseY - tenoriY) * numTracks/tenoriWidth);
  if (index >= 0 && index < numBeats && track >= 0 && track < numTracks) {
    tracks[track][index] = synths[track].toggleActive(index);
  }
}

int HORIZONTAL = 0;
int VERTICAL   = 1;
int UPWARDS    = 2;
int DOWNWARDS  = 3;

class Widget
{

  
  PVector pos;
  PVector extents;
  String name;

  color inactiveColor = color(60, 60, 100);
  color activeColor = color(100, 100, 160);
  color bgColor = inactiveColor;
  color lineColor = color(255);
  
  
  
  void setInactiveColor(color c)
  {
    inactiveColor = c;
    bgColor = inactiveColor;
  }
  
  color getInactiveColor()
  {
    return inactiveColor;
  }
  
  void setActiveColor(color c)
  {
    activeColor = c;
  }
  
  color getActiveColor()
  {
    return activeColor;
  }
  
  void setLineColor(color c)
  {
    lineColor = c;
  }
  
  color getLineColor()
  {
    return lineColor;
  }
  
  String getName()
  {
    return name;
  }
  
  void setName(String nm)
  {
    name = nm;
  }


  Widget(String t, int x, int y, int w, int h)
  {
    pos = new PVector(x, y);
    extents = new PVector (w, h);
    name = t;
    //registerMethod("mouseEvent", this);
  }

  void display()
  {
  }

  boolean isClicked()
  {
    
    if (mouseX > pos.x && mouseX < pos.x+extents.x 
      && mouseY > pos.y && mouseY < pos.y+extents.y)
    {
      return true;
    }
    else
    {
      return false;
    }
  }
  
  public void mouseEvent(MouseEvent event)
  {
    //if (event.getFlavor() == MouseEvent.PRESS)
    //{
    //  mousePressed();
    //}
  }
  
  
  boolean mousePressed()
  {
    return isClicked();
  }
  
  boolean mouseDragged()
  {
    return isClicked();
  }
  
  
  boolean mouseReleased()
  {
    return isClicked();
  }
}

class Button extends Widget
{
  PImage activeImage = null;
  PImage inactiveImage = null;
  PImage currentImage = null;
  color imageTint = color(255);
  
  Button(String nm, int x, int y, int w, int h)
  {
    super(nm, x, y, w, h);
  }
  
  void setImage(PImage img)
  {
    setInactiveImage(img);
    setActiveImage(img);
  }
  
  void setInactiveImage(PImage img)
  {
    if(currentImage == inactiveImage || currentImage == null)
    {
      inactiveImage = img;
      currentImage = inactiveImage;
    }
    else
    {
      inactiveImage = img;
    }
  }
  
  void setActiveImage(PImage img)
  {
    if(currentImage == activeImage || currentImage == null)
    {
      activeImage = img;
      currentImage = activeImage;
    }
    else
    {
      activeImage = img;
    }
  }
  
  void setImageTint(float r, float g, float b)
  {
    imageTint = color(r,g,b);
  }

  void display()
  {
    if(currentImage != null)
    {
      //float imgHeight = (extents.x*currentImage.height)/currentImage.width;
      float imgWidth = (extents.y*currentImage.width)/currentImage.height;
      
      
      pushStyle();
      imageMode(CORNER);
      tint(imageTint);
      image(currentImage, pos.x, pos.y, imgWidth, extents.y);
      stroke(bgColor);
      noFill();
      rect(pos.x, pos.y, imgWidth,  extents.y);
      noTint();
      popStyle();
    }
    else
    {
      pushStyle();
      stroke(lineColor);
      fill(bgColor);
      rect(pos.x, pos.y, extents.x, extents.y);
  
      fill(lineColor);
      textAlign(CENTER, CENTER);
      text(name, pos.x + 0.5*extents.x, pos.y + 0.5* extents.y);
      popStyle();
    }
  }
  
  boolean mousePressed()
  {
    if (super.mousePressed())
    {
      bgColor = activeColor;
      if(activeImage != null)
        currentImage = activeImage;
      return true;
    }
    return false;
  }
  
  boolean mouseReleased()
  {
    if (super.mouseReleased())
    {
      bgColor = inactiveColor;
      if(inactiveImage != null)
        currentImage = inactiveImage;
      return true;
    }
    return false;
  }
}

class Toggle extends Button
{
  boolean on = false;

  Toggle(String nm, int x, int y, int w, int h)
  {
    super(nm, x, y, w, h);
  }


  boolean get()
  {
    return on;
  }

  void set(boolean val)
  {
    on = val;
    if (on)
    {
      bgColor = activeColor;
      if(activeImage != null)
        currentImage = activeImage;
    }
    else
    {
      bgColor = inactiveColor;
      if(inactiveImage != null)
        currentImage = inactiveImage;
    }
  }

  void toggle()
  {
    set(!on);
  }

  
  boolean mousePressed()
  {
    return super.isClicked();
  }

  boolean mouseReleased()
  {
    if (super.mouseReleased())
    {
      toggle();
      return true;
    }
    return false;
  }
}

class RadioButtons extends Widget
{
  public Toggle [] buttons;
  
  RadioButtons (int numButtons, int x, int y, int w, int h, int orientation)
  {
    super("", x, y, w*numButtons, h);
    buttons = new Toggle[numButtons];
    for (int i = 0; i < buttons.length; i++)
    {
      int bx, by;
      if(orientation == HORIZONTAL)
      {
        bx = x+i*(w+5);
        by = y;
      }
      else
      {
        bx = x;
        by = y+i*(h+5);
      }
      buttons[i] = new Toggle("", bx, by, w, h);
    }
  }
  
  void setNames(String [] names)
  {
    for (int i = 0; i < buttons.length; i++)
    {
      if(i >= names.length)
        break;
      buttons[i].setName(names[i]);
    }
  }
  
  void setImage(int i, PImage img)
  {
    setInactiveImage(i, img);
    setActiveImage(i, img);
  }
  
  void setAllImages(PImage img)
  {
    setAllInactiveImages(img);
    setAllActiveImages(img);
  }
  
  void setInactiveImage(int i, PImage img)
  {
    buttons[i].setInactiveImage(img);
  }

  
  void setAllInactiveImages(PImage img)
  {
    for (int i = 0; i < buttons.length; i++)
    {
      buttons[i].setInactiveImage(img);
    }
  }
  
  void setActiveImage(int i, PImage img)
  {
    buttons[i].setActiveImage(img);
  }
  
  
  
  void setAllActiveImages(PImage img)
  {
    for (int i = 0; i < buttons.length; i++)
    {
      buttons[i].setActiveImage(img);
    }
  }

  void set(String buttonName)
  {
    for (int i = 0; i < buttons.length; i++)
    {
      if(buttons[i].getName().equals(buttonName))
      {
        buttons[i].set(true);
      }
      else
      {
        buttons[i].set(false);
      }
    }
  }
  
  int get()
  {
    for (int i = 0; i < buttons.length; i++)
    {
      if(buttons[i].get())
      {
        return i;
      }
    }
    return -1;
  }
  
  String getString()
  {
    for (int i = 0; i < buttons.length; i++)
    {
      if(buttons[i].get())
      {
        return buttons[i].getName();
      }
    }
    return "";
  }

  void display()
  {
    for (int i = 0; i < buttons.length; i++)
    {
      buttons[i].display();
    }
  }

  boolean mousePressed()
  {
    for (int i = 0; i < buttons.length; i++)
    {
      if(buttons[i].mousePressed())
      {
        return true;
      }
    }
    return false;
  }
  
  boolean mouseDragged()
  {
    for (int i = 0; i < buttons.length; i++)
    {
      if(buttons[i].mouseDragged())
      {
        return true;
      }
    }
    return false;
  }

  boolean mouseReleased()
  {
    for (int i = 0; i < buttons.length; i++)
    {
      if(buttons[i].mouseReleased())
      {
        for(int j = 0; j < buttons.length; j++)
        {
          if(i != j)
            buttons[j].set(false);
        }
        //buttons[i].set(true);
        return true;
      }
    }
    return false;
  }
}

class Slider extends Widget
{
  float minimum;
  float maximum;
  float val;
  int textWidth = 60;
  int orientation = HORIZONTAL;

  Slider(String nm, float v, float min, float max, int x, int y, int w, int h, int ori)
  {
    super(nm, x, y, w, h);
    val = v;
    minimum = min;
    maximum = max;
    orientation = ori;
    if(orientation == HORIZONTAL)
      textWidth = 60;
    else
      textWidth = 20;
    
  }

  float get()
  {
    return val;
  }

  void set(float v)
  {
    val = v;
    val = constrain(val, minimum, maximum);
  }

  void display()
  {
    
    float textW = textWidth;
    if(name == "")
      textW = 0;
    pushStyle();
    textAlign(LEFT, TOP);
    fill(lineColor);
    text(name, pos.x, pos.y);
    stroke(lineColor);
    noFill();
    if(orientation ==  HORIZONTAL){
      rect(pos.x+textW, pos.y, extents.x-textWidth, extents.y);
    } else {
      rect(pos.x, pos.y+textW, extents.x, extents.y-textW);
    }
    noStroke();
    fill(bgColor);
    float sliderPos; 
    if(orientation ==  HORIZONTAL){
        sliderPos = map(val, minimum, maximum, 0, extents.x-textW-4); 
        rect(pos.x+textW+2, pos.y+2, sliderPos, extents.y-4);
    } else if(orientation ==  VERTICAL || orientation == DOWNWARDS){
        sliderPos = map(val, minimum, maximum, 0, extents.y-textW-4); 
        rect(pos.x+2, pos.y+textW+2, extents.x-4, sliderPos);
    } else if(orientation == UPWARDS){
        sliderPos = map(val, minimum, maximum, 0, extents.y-textW-4); 
        rect(pos.x+2, pos.y+textW+2 + (extents.y-textW-4-sliderPos), extents.x-4, sliderPos);
    };
    popStyle();
  }

  
  boolean mouseDragged()
  {
    if (super.mouseDragged())
    {
      float textW = textWidth;
      if(name == "")
        textW = 0;
      if(orientation ==  HORIZONTAL){
        set(map(mouseX, pos.x+textW, pos.x+extents.x-4, minimum, maximum));
      } else if(orientation ==  VERTICAL || orientation == DOWNWARDS){
        set(map(mouseY, pos.y+textW, pos.y+extents.y-4, minimum, maximum));
      } else if(orientation == UPWARDS){
        set(map(mouseY, pos.y+textW, pos.y+extents.y-4, maximum, minimum));
      };
      return true;
    }
    return false;
  }

  boolean mouseReleased()
  {
    if (super.mouseReleased())
    {
      float textW = textWidth;
      if(name == "")
        textW = 0;
      if(orientation ==  HORIZONTAL){
        set(map(mouseX, pos.x+textW, pos.x+extents.x-10, minimum, maximum));
      } else if(orientation ==  VERTICAL || orientation == DOWNWARDS){
        set(map(mouseY, pos.y+textW, pos.y+extents.y-10, minimum, maximum));
      } else if(orientation == UPWARDS){
        set(map(mouseY, pos.y+textW, pos.y+extents.y-10, maximum, minimum));
      };
      return true;
    }
    return false;
  }
}

class MultiSlider extends Widget
{
  Slider [] sliders;
  /*
  MultiSlider(String [] nm, float min, float max, int x, int y, int w, int h, int orientation)
  {
    super(nm[0], x, y, w, h*nm.length);
    sliders = new Slider[nm.length];
    for (int i = 0; i < sliders.length; i++)
    {
      int bx, by;
      if(orientation == HORIZONTAL)
      {
        bx = x;
        by = y+i*h;
      }
      else
      {
        bx = x+i*w;
        by = y;
      }
      sliders[i] = new Slider(nm[i], 0, min, max, bx, by, w, h, orientation);
    }
  }
  */
  MultiSlider(int numSliders, float min, float max, int x, int y, int w, int h, int orientation)
  {
    super("", x, y, w, h*numSliders);
    sliders = new Slider[numSliders];
    for (int i = 0; i < sliders.length; i++)
    {
      int bx, by;
      if(orientation == HORIZONTAL)
      {
        bx = x;
        by = y+i*h;
      }
      else
      {
        bx = x+i*w;
        by = y;
      }
      sliders[i] = new Slider("", 0, min, max, bx, by, w, h, orientation);
    }
  }
  
  void setNames(String [] names)
  {
    for (int i = 0; i < sliders.length; i++)
    {
      if(i >= names.length)
        break;
      sliders[i].setName(names[i]);
    }
  }

  void set(int i, float v)
  {
    if(i >= 0 && i < sliders.length)
    {
      sliders[i].set(v);
    }
  }
  
  float get(int i)
  {
    if(i >= 0 && i < sliders.length)
    {
      return sliders[i].get();
    }
    else
    {
      return -1;
    }
    
  }

  void display()
  {
    for (int i = 0; i < sliders.length; i++)
    {
      sliders[i].display();
    }
  }

  
  boolean mouseDragged()
  {
    for (int i = 0; i < sliders.length; i++)
    {
      if(sliders[i].mouseDragged())
      {
        return true;
      }
    }
    return false;
  }

  boolean mouseReleased()
  {
    for (int i = 0; i < sliders.length; i++)
    {
      if(sliders[i].mouseReleased())
      {
        return true;
      }
    }
    return false;
  }
}

class Synthesiser {
  Synth waveform;
  int note;
  float rawNote;
  float filter, res, delayTime, attack, release, filterAttack;
  int playhead = 0, transpose = 0, delayAmount = 0;
  float[] wavetable = new float[514];
  boolean[] activeBeats;
  
  Synthesiser(float rawNote, boolean[] activeBeats) {
    waveform = new Synth();
    setNote(rawNote);
    for (int i = 0; i < 515 ; i++) {
      wavetable[i]=((float)i/512)-0.5;
    }
    waveform.waveTableSize(514);
    waveform.loadWaveTable(wavetable);
    this.activeBeats = new boolean[activeBeats.length];
    arrayCopy(activeBeats, this.activeBeats);
  }
  
  boolean toggleActive(int index) {
    activeBeats[index] = !activeBeats[index];
    return activeBeats[index];
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
    if (playhead%4==0 && activeBeats[playhead/4 % activeBeats.length]) {
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


