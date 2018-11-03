// to use sound input
import processing.sound.*;
// an audio processing thingy
AudioIn in;

// to remember the size of the screen
final int FLOOR = 800;
//width of a letter, supposedly
final int WIDTH = 30;
//height of a letter, supposedly
final int HEIGHT = 32;
// space between the xpos and ypos of two letters
final int GAP = 32;
// font size
final int FONT_SIZE = 48;
// a string that will print out a welcome message
final String welcome = "Think about what you say.";
// a string that will print out when a screenshot is saved
final String save = "photo saved.";
// a char to represent a space char, which should be skipped when checking for collision
final char space = ' ';

// a fixed-width font
PFont f;
// something to check sound amplitudes
Amplitude amp;
// keep a list of letters
ArrayList<letter> a;
// number to multiply by gap to decide where to start letters
int count;
// number of frames that the letters will show
// also number of frames between checks of amplitude
int fade;
// an opacity to pass into fill( , ) that is based on the amplitude of ambient sound
float opacity;
// holding vars for mousex and mousey (to check whether they have changed)
float prevmx;
float prevmy;

/*
 * This is kind of the meat and potatoes of this project
 * The letter class makes a letter object that can be created multiple times
 * You can set or get various values, and display the object based on its position.
 */
class letter {
 // what character the letter represents
 char c;
 // x coordinate
 float posx;
 // y corrdinate
 float posy;
 // y velocity (no need for x velocity)
 float vely;
 
 /*
  * Constructor for a letter
  * @param x should be the x position of the letter
  * @param y should be the y position of the letter
  * @param let should be the char that the letter represents
  * velocity is set to 5 for a falling effect.
  * a letter object is created.
  */
 letter(float x, float y, char let) {
  posx = x;
  posy = y;
  c = let;
  vely = 5;
 }
 
 /*
  * Displays a letter.
  * Checks for collisions with any other letter and the floor.
  * Updates the position of the letter as well.
  */
 void display() {
  // check for collision with the floor
  if (posy + vely >= FLOOR) {
    // if it collides with the floor, set its position to floor and set vely to 0.
    posy = FLOOR;
    setVely(0);
  }
  // check for collision with other letters
  for (int i = 0; i < a.size(); i++) {
    // if it collides with another letter, set velocity to 0.
    if(collides(a.get(i)) && (a.get(i) != this)) {
      setVely(0);
    }
  }
  // update posy
  posy += vely;
  // display the character in the font
  text(c, posx, posy);
 }
 
 /*
  * Setter for vely
  * @param y is the new vertical velocity for the letter
  */
 void setVely(float y) {
   vely = y; 
 }
 
 /*
  * Getter for vely
  * @return returns vertical velocity for the letter
  */
 float getVely() {
   return vely;
 }
 
  /*
  * Getter for posy
  * @return returns vertical pos for the letter
  */
 float getPosy() {
   return posy;
 }
 
 /*
  * Getter for posy
  * @return returns vertical pos for the letter
  */
 float getPosx() {
   return posx;
 }
 
 /*
  * Check collision with another letter
  * @param other is another letter that you want to check collision against
  * @return returns true if colliding with another letter, false otherwise.
  */
 boolean collides(letter other) {
   if (posx+WIDTH >= other.getPosx() && posx-WIDTH <= other.getPosx()) {
       if (posy+HEIGHT >= other.getPosy() && posy-HEIGHT <= other.getPosy())
         return true;
   }
   return false;
 }
}


void setup() {
  // set background to white
  background(255);
  // set size to the width of the welcome string
  size(800, 800);
  // set up audio
  in = new AudioIn(this, 0);
  in.start();
  // set up amplitude object
  amp = new Amplitude(this);
  amp.input(in);
  // set up a list of letters
  a = new ArrayList<letter>();
  
  // set up font
  f = createFont("absender1.ttf", FONT_SIZE);
  textFont(f);
  // set count and fade to 0
  count = 0;
  fade = 0;
  // add welcome string to the list o fletters
  for (int i = welcome.length()-1; i >= 0; i--) {
    a.add(new letter((i) *GAP, 0, welcome.charAt(i)));
  }
}

void keyPressed() {
  if(mouseX != prevmx || mouseY != prevmy) {
   count = 0; 
  }
  // zero saves a frame
  if(key == 48) { 
      saveFrame("zero-pressed-again");
      println(save);
  }
  // for real char values (not backspace or enter, etc)
  else if(key >= 32 && key <= 126) {
    // don't want to count spaces to save space
    if (key != space) {
      letter l = new letter(((mouseX + (count*GAP))% FLOOR), mouseY, key);
      a.add(l);
    }
    count++;
  }
  prevmx = mouseX;
  prevmy = mouseY;
}

void draw() {  
    background(255);
    
    for (int i = 0; i < a.size(); ++i) {
      if (i < welcome.length()) fill(0);
      else if(fade == 150) {
        opacity = amp.analyze() * 255;
        fill(opacity, opacity);
        fade = 0;
      }
      else {
        fill(opacity, opacity);
        fade++;
      }
      a.get(i).display();
  }
}
