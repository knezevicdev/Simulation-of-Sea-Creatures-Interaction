/**
 Simulacija interakcije morskih stvorenja.
 Izaberite stvorenje pritiskom na dugme u gornjoj liniji.
 Pritisnite dugme u dnu da otvorite meni. 
 Pritisnite i za vise informacija o stvorenjima,
 +/- da dodate ili uklonite trenutno stvorenje,
 p,n da pauzirate i prikazete sledeci korak,
 r za restart,
 s da sacuvate sliku
*/

String title = ">>> Simulacija interakcije morskih stvorenja (klik za opcije) <<<";
 
int maxFrameRate = 30;
 
int textHeight = 18;
int selectionHeight = 30;
 
boolean coverBG = true;
boolean animate = true;
boolean showButtons = true;
boolean showInfo = false;
boolean showMenu = false;
boolean doOneStep = false;
boolean showFrameNo = false;
boolean quitQuestion = false;
//----------------------------------------------------------
void setup()
{
  //fullScreen();     // za JavaScript
  size(100, 100);
  frameRate(maxFrameRate);
  textHeight = height / 50;
  selectionHeight = height / 30;
  textSize(textHeight);
  smooth();
  restart();
}
//----------------------------------------------------------
void draw()
{
  if (coverBG)
    background(28);
  else
  {
    fill(28, 22);
    rect (width/2, height/2, 2*width, 2*height);
  }
  for (int mi = 0; mi < creatures.size (); mi++)
  {
    Creature aCreature = creatures.get(mi);
    aCreature.draw(showInfo);
 
    if (animate || doOneStep)
    {
      aCreature.update();
 
      // check interaction of creatures
      for (int ni = mi+1; ni < creatures.size (); ni++)
      {
        Creature otherCreature = creatures.get(ni);
        if (otherCreature.flees (aCreature));
        if (aCreature.flees (otherCreature));
 
        if (aCreature.bites(otherCreature))
        {
          if (otherCreature.partCount > 1)
          {
            //println (mi + " bites " + ni + "  d=" + otherCreature.partCount);
            otherCreature.partCount--;
          }
          else
          {
            //println (mi + " eats " + ni);
            creatures.remove(ni);
          }
        }
      }
    }
  }
  finishOneStep();
 
    
  if (animate)
    addNewCreatures();
 
  drawInfo();
 
  if (showMenu) drawMenu();
}
//----------------------------------------------------------
void drawInfo()
{
  if (showButtons)
  {
    textAlign (LEFT, BOTTOM);
    textSize (textHeight);
    int xtext = 20;
    int ytext = height - textHeight / 3;
    int yelli = ytext - textHeight / 2;
    int radius = textHeight *  2 / 3;
    int xdist = 20 + round(textWidth ("AAAAA"));
    if (showInfo)
    {
      fill(color(127, 127));
      stroke(color(127, 127));
      ellipse (xtext, yelli, radius, radius);
      text ("zahvat", xtext+textHeight-4, ytext);
   
      xtext += xdist;
      fill(actionColor(ac_flee));
      stroke(actionColor(ac_flee));
      ellipse (xtext, yelli, radius, radius);
      text ("bezanje", xtext+textHeight-4, ytext);
   
      xtext += xdist;
      xtext += 15;
      fill(actionColor(ac_hunt));
      stroke(actionColor(ac_hunt));
      ellipse (xtext, yelli, radius, radius);
      text ("lov", xtext+textHeight-4, ytext);
   
      xtext += xdist;
      fill(actionColor(ac_bite));
      stroke(actionColor(ac_bite));
      ellipse (xtext, yelli, radius, radius);
      text ("hvatanje", xtext+textHeight-4, ytext);
    }
    else
    {
      fill(color(127, 127));
      text (title, 10, ytext);
    }
 
    // show frames per second
    textAlign (RIGHT, BOTTOM);
    fill(color(127, 127));
    text (round(frameRate) + " fps", width-8, ytext);
    if (showFrameNo) text (round(frameCount), width-8, ytext-40);
    textAlign (LEFT, BOTTOM);
 
    // draw creator counter
    fill(133, 66);
    stroke(128);
 
    rectMode(CORNER);
    for (int ni = 0; ni < creatureTypes; ni++)
      rect(ni * width / creatureTypes, 0, width / creatureTypes - 1, selectionHeight, 6);
    rect(0, height-selectionHeight-1, width-1, selectionHeight, 6);
    rectMode(CENTER);
 
    textAlign (CENTER, CENTER);
    drawCountButton(planktonId);
    drawCountButton(pollywogId);
    drawCountButton(snakeId);
    drawCountButton(starfishId);
    drawCountButton(octopusId);
  }
}
//----------------------------------------------------------
void drawCountButton (int typeId)
{
  String [] creatureNames = {"plankton ", "ribe ", "zmije ", "m. zvezda ", "hobotnica "};  
  if (currentId == typeId) fill(188, 188, 33);
    else fill(128);
  int xtext = width * (typeId*2+1) / (creatureTypes*2);
  int ytext = selectionHeight / 2;
  text (creatureNames[typeId] + getCreatureCount(typeId), xtext, ytext);
}
//----------------------------------------------------------
int menuW, menuH, menuX, menuY, menuCount = 10;
final String[] menuText
= {   "detalji (i)"
    , "pozadina (b)"
    , "dodaj stvorenje (+)"
    , "ukloni stvorenje (-)"
    , "sacuvaj sliku (s)"
    , "pauza (p)"
    , "korak (n)"
    , "menu (m)"
    , "restart (r)"
    , "izlaz (q)"
};
//----------------------------------------------------------
void drawMenu()
{
  rectMode(CORNER);
  menuW = width / 2;
  menuH = height / (menuCount+6);
  menuX = width / 4;
  menuY = menuH * 2;
  textAlign (CENTER, CENTER);
  textSize(menuH / 2);
  for (int ni = 0; ni < menuCount; ni++)
  {
    int yp = menuY + ni * menuH;
    fill(88, 44, 88, 66);
    stroke(88, 44, 88);
    rect(menuX, yp, menuW, menuH-4, 6);
 
    fill(128);
    text (menuText[ni], menuX+menuW/2, yp+menuH/2);
  }
  rectMode(CENTER);
}
//----------------------------------------------------------
boolean executeMenu()
{
  if (!showMenu) return false;
  if (mouseX < menuX) return false;
  if (mouseX > menuX +  menuW) return false;
  if (mouseY < menuY) return false;
  if (mouseY > menuY + menuCount * menuH) return false;
  int menuIndex = (int)((mouseY - menuY) / menuH);
  //println ("menu="+menuIndex);
  switch (menuIndex)
  {        case 0:  showInfo = !showInfo;         // detalji
    break; case 1:  coverBG = ! coverBG;          // pozadina
    break; case 2:  addCreature(currentId, -1,0); // dodajC
    break; case 3:  deleteCreature(currentId);    // obrisiC
    break; case 4:  savePNG();                    // sacuvaj sliku
    break; case 5:  toggleAnimation(false);       // pauza
    break; case 6:  doNextStep();                 // sledeci frejm
    break; case 7:  showMenu = false;             // menu
    break; case 8:  restart();                    // restart
    break; case 9:  quitQuestion = true;          // izlaz
  }
  return true;
}
//----------------------------------------------------------
void savePNG()
{
  String filename = "SlikaEkrana.png";
  println("slika sacuvana kao '" + filename + "'" );
  save (filename);
}
//----------------------------------------------------------
void toggleAnimation (boolean oneStep)
{
  animate = !animate;
  if (animate || oneStep) loop();
  else noLoop();
  doOneStep = oneStep;
}   
//----------------------------------------------------------
void doNextStep()
{
  animate = false;
  doOneStep = true;     // sledeci frejm
  loop();
}
//----------------------------------------------------------
void doOneStepF()
{
  if (!animate) doOneStep = true;     // sledeci frejm
  loop();
}
//----------------------------------------------------------
void finishOneStep()
{
  if (doOneStep)
  {
    doOneStep = false;
    noLoop();
  }
}
//----------------------------------------------------------
void keyPressed()
{
  if (key == CODED)
  {
    switch (keyCode)
    {        case 82:  showMenu = !showMenu;
      break; case 27:  showMenu = !showMenu;
    }
  }
  else switch (key)
  {        case '+':  addCreature(currentId, -1,0); // dodajC
    break; case '-':  deleteCreature(currentId);    // obrisiC   
    break; case 'b':  coverBG = ! coverBG;          // bg
    break; case 'c':  showMenu = false;             // menu
    break; case 'f':  showFrameNo = !showFrameNo;   // fps prikaz
    break; case 'n':  doNextStep();                 // sledeci frejm
    break; case 'm':  showMenu = !showMenu;         // menu
    break; case 'p':  toggleAnimation(false);       // pauza
    break; case 'q':  this.exit();                  // izlaz
    break; case 'i':  showInfo = !showInfo;         // detalji
    break; case 'r':  restart();                    // restart
    break; case 's':  save ("SlikaEkrana.png");
    break; case 't':  showButtons = !showButtons;   // dugmad 
  }
  doOneStepF();
}
//----------------------------------------------------------
void mousePressed()
{
  if (mouseY < selectionHeight)
  {
    // top buttons
    currentId = int((constrain ((mouseX * creatureTypes) / width, 0, creatureTypes)));
  }
  else if (mouseY > (height - selectionHeight))
  {
    // bottom button
    showMenu = !showMenu;
  }
  else if (!executeMenu())                      // menu ?
    addCreature(currentId, mouseX, mouseY);     // dodaj kreaturu na mestu misa
  doOneStepF();
}
//----------------------------------------------------------
void mouseReleased()
{
  if (quitQuestion)
  {
    background (0);
    text("Bye",width/2, height/2);
    this.exit();                // izlaz?
  }
  quitQuestion = false;
}
 
// pocetni broj stvorenja
int planktonStart = 12;
int pollywogStart = 4;
int snakeStart    = 2;
int starfishStart = 2;
int octopusStart  = 1;
 
// id stvorenja
final int planktonId  = 0;
final int pollywogId  = 1;
final int snakeId     = 2;
final int starfishId  = 3;
final int octopusId   = 4;
final int creatureTypes = 5;
 
int currentId = 1;    // trenutni id
 
ArrayList<Creature> creatures;
 
//----------------------------------------------------------
void restart()
{
  println (title);
  coverBG = true;
  showInfo = false;
  creatures = new ArrayList<Creature>();
  for (int ni = 0; ni < planktonStart; ni++) addPlankton (-1.0, 0.0); 
  for (int ni = 0; ni < pollywogStart; ni++) addPollywog (-1.0, 0.0);
  for (int ni = 0; ni <    snakeStart; ni++) addSnake    (-1.0, 0.0);
  for (int ni = 0; ni < starfishStart; ni++) addStarfish (-1.0, 0.0);
  for (int ni = 0; ni <  octopusStart; ni++) addOctopus  (-1.0, 0.0);
}
//----------------------------------------------------------
int getCreatureCount(int typeId)
{
  int count = 0;
  for (Creature aCreature : creatures)
    if (aCreature.typeId == typeId)
      count++;
  return count;
}
//----------------------------------------------------------
void addNewCreatures ()
{
  if (frameCount %      maxFrameRate  == 0) addPlankton(-1.0, 1.0);
  if (frameCount % ( 20*maxFrameRate) == 0) addPollywog (-1.0, 1.0);  
  if (frameCount % (100*maxFrameRate) == 0) addSnake(-1.0, 1.0);
  if (frameCount % (200*maxFrameRate) == 0) addStarfish(-1.0, 1.0);
}
//----------------------------------------------------------
void addCreature (int typeId, float x, float y)
{
  //println ("addCreature " + currentId);
  switch (typeId)
  {        case planktonId:  addPlankton(x, y);
    break; case pollywogId:  addPollywog(x, y);   
    break; case    snakeId:  addSnake(x, y);
    break; case starfishId:  addStarfish(x, y);   
    break; case  octopusId:  addOctopus(x, y);
  }
}
//----------------------------------------------------------
void deleteCreature (int typeId)
{
  for (int ni = 0; ni < creatures.size(); ni++)
  {
    Creature aCreature = creatures.get(ni);
    if (aCreature.typeId == typeId)
    {
      creatures.remove(ni);
      break;
    }
  }
}
//----------------------------------------------------------
void addPlankton(float px, float py)
{
  PVector startPosition;
  if (px > 0.0)
    startPosition = new PVector(px, py); 
  else startPosition = new PVector(random(100, width-200), random(100, height-200));
 
  color headColor = color(random(50, 100), random(200, 255), random(0, 60));
  float speed = random (0.5, 1.0);
  creatures.add (new Creature (planktonId, headColor, startPosition, speed
  ,        2   // velicina
  ,        1   // broj pipaka
  ,        2   // delovi pipka
  ,        4   // sabijenost
  ,     8, 3   // animacija puta
  , 1.2, 1.2   // zamah
  ));
}
//----------------------------------------------------------
void addPollywog(float px, float py)
{
  PVector startPosition;
  if (px > 0.0)
    startPosition = new PVector(px, py); 
  else startPosition = new PVector(random(100, width-200), random(100, height-200));
 
  color headColor = color(random(150, 200), random(50, 100), random(5, 60));
  float speed = random (2.0, 4.0);
  creatures.add (new Creature (pollywogId, headColor, startPosition, speed
  ,        6   
  ,        1   
  ,       12   
  ,        4   
  ,   88, 33   
  , 1.2, 1.2   
  ));
}
//----------------------------------------------------------
void addSnake(float px, float py)
{
  PVector startPosition;
  if (px > 0.0)
    startPosition = new PVector(px, py); 
  else startPosition = new PVector(random(100, width-200), random(100, height-200));
 
  color headColor = color(random(50, 200), random(50, 200), random(50, 200));
  float speed = random (3.0, 4.5);
  Creature aCreature = new Creature (snakeId, headColor, startPosition, speed
  ,        8   
  ,        1   
  ,       66   
  ,        4   
  ,  111, 33   
  , 0.5, 0.5   
  );
  creatures.add(aCreature);
}
//----------------------------------------------------------
void addStarfish(float px, float py)
{
  PVector startPosition;
  if (px > 0.0)
    startPosition = new PVector(px, py); 
  else startPosition = new PVector(random(100, width-200), random(100, height-200));
 
  color headColor = color(random(50, 200), random(50, 200), random(50, 200));
  float speed = random (0.5, 1.5);
  Creature aCreature = new Creature (starfishId, headColor, startPosition, speed
  ,        9   
  ,        5   
  ,       25   
  ,        3   
  ,    1, 46   
  , 0.1, 0.05  
  );
  creatures.add(aCreature);
}
//----------------------------------------------------------
void addOctopus(float px, float py)
{
  PVector startPosition;
  if (px > 0.0)
    startPosition = new PVector(px, py); 
  else startPosition = new PVector(random(100, width-200), random(100, height-200));
 
  color headColor = color(random(50, 200), random(50, 200), random(50, 200));
  float speed = random (3.0, 4.0);
  Creature aCreature = new Creature (octopusId, headColor, startPosition, speed
  ,       10   
  ,        8   
  ,       40   
  ,        5   
  ,   44, 66   
  , 0.1, 0.5  
  );
  creatures.add(aCreature);
}
  
final int ac_move = 0; 
final int ac_flee = 1;
final int ac_hunt = 2;
final int ac_bite = 3;
 
class Creature extends MotionInfo
{
 
  int typeId;                  
  color headColor;            
  float headRadius;            
  float biteRadius;            
  float visibilityRadius;      
  float moveDirection;         
  float swingSize;             
  float swingFrequency;        
  int moveTime, waitTime;           
  int currentTime;             
  boolean stopped;             
  int action;                  
  SteeringInfo steering;      
 
  ArrayList<Tentacle> tentacles;
  int nTentacles;
  int partCount;
 
 
  //----------------------------------------------------------
  // pravljenje stvorenja
  //----------------------------------------------------------
  Creature (int typeId       
  , color headColor          
  , PVector startPosition    
  , float maxMotionSpeed     
  , float size               
  , int tentacleCount        
  , int tentacleParts        
  , float compactness        
  , int movingTime           
  , int waitingTime          
  , float swingSize          
  , float swingFrequency)          
  {
    super ( random(2*PI)     
    , maxMotionSpeed         
    , 0.3                    
    , radians(4.0)             
    , radians(1.0)           
    , startPosition);        
 
    this.typeId = typeId; 
    this.headColor = headColor;
    this.headRadius = size / 2.0;
    this.biteRadius = size * 2.0;
    this.visibilityRadius = size * 10.0;
    this.moveDirection = random(TWO_PI);
    this.steering = new SteeringInfo();
    this.moveTime = constrain (movingTime, 10, 200);
    this.waitTime = constrain (waitingTime, 0, 200);
    this.currentTime = 0;
    this.stopped = false;
    this.swingSize = swingSize;
    this.swingFrequency = swingFrequency;
    this.nTentacles = constrain (tentacleCount, 1, 20);
    this.partCount = constrain (tentacleParts, 2, 100);
    this.action = ac_move;
     
    float angle = TWO_PI / nTentacles / 3;
    float halfAngle = (nTentacles % 2 == 0 ? angle*0.5 : 0.0);
    tentacles = new ArrayList<Tentacle>();
    for (int i = 0; i < nTentacles; i++)
    {
      float direction = moveDirection; // + (0.5 * i * angle) - angle + halfAngle;
      PVector tv = startPosition.get();
      tv.sub (getVector2d (headRadius, direction));
      //println ("add " + typeId + "." +i + ": " + nf(degrees(direction), 2, 0) + "  x=" + tv.x + "  y=" + tv.y);
      Tentacle tentacle = new Tentacle(tv, direction, partCount, size*0.9, compactness, headColor);
      tentacles.add(tentacle);
    }
  }
  //----------------------------------------------------------
  // crtanje stvorenja
  //----------------------------------------------------------
  void draw(boolean showRadii)
  {
    for (int i = 0; i < nTentacles; i++)
      tentacles.get(i).draw();
    fill (headColor);
    ellipse (position.x, position.y, headRadius*2, headRadius*2);
 
    if (showRadii)
    {
      stroke (actionColor(action));
      noFill();
 
      // draw bite radius
      ellipse (position.x, position.y, biteRadius*2, biteRadius*2);
 
      // draw visible radius
      ellipse (position.x, position.y, visibilityRadius*2, visibilityRadius*2);
 
      // draw move direction
      PVector ep = position.get();
      ep.add (getVector2d (visibilityRadius, moveDirection));
      line (position.x, position.y, ep.x, ep.y);
    }
  }
  //----------------------------------------------------------
  // animiranje stvorenja
  //----------------------------------------------------------
  void update()
  {
    if (currentTime % (moveTime) == 0)
      stopped = true;
 
    if (stopped)
    {
      // maxAccel = 0.15;
      maxAccel *= 0.15;          
      velocity.mult(0.95);       
      moveDirection += random(-1, 1) * radians(0.1);
 
      if (currentTime % (moveTime+waitTime) == 0)
      {
        stopped = false;
        currentTime = 1;
      }
    }
    else
    {
      maxAccel = 3.0;
      // moveDirection += random(-1, 1) * radians(100);  // -50° .. 50°
      float add = swingSize * sin(frameCount * swingFrequency);
      // println (nf(degrees(add),0,2) + "   " + degrees(moveDirection));
      moveDirection +=  add;  // -50° .. 50°
    }
 
    steering.linear.div(currentTime/50 > 0 ? currentTime/50 : 1);
    direction = moveDirection;
    steering = wander(this, 100.0, 80.0, radians(5));  // 5° .. +5°
    super.update(steering);
 
    currentTime++;
 
    float partAngle = TWO_PI / nTentacles;
    float halfAngle = (nTentacles % 2 == 0 ? partAngle*0.5 : 0.0);
    for (int ni = 0; ni < nTentacles; ni++)
    {
      Tentacle t = tentacles.get(ni);
      float angle = moveDirection + ni * partAngle + halfAngle;  
      t.position.x = position.x + (cos(angle) * headRadius);
      t.position.y = position.y + (sin(angle) * headRadius);
      t.direction = atan2((t.position.y - position.y), (t.position.x - position.x));
      t.update();
    }
    action = ac_move;
  }
  //----------------------------------------------------------
  // Bezi?
  //----------------------------------------------------------
  boolean flees(Creature otherCreature)
  {
    if (headRadius > otherCreature.headRadius)  
      return false;
    PVector d = otherCreature.position.get();
    d.sub(position);  
    float distance = d.mag();      
    if (distance < visibilityRadius)
    {
      //println (id + " flees " + otherCreature.id);
      action = ac_flee;
      stopped = false;
      moveDirection = atan2(-d.y, -d.x);
      return true;
    }
    return false;
  }
  //----------------------------------------------------------
  // jede?
  //----------------------------------------------------------
  boolean bites(Creature otherCreature)
  {
    if (headRadius <= otherCreature.headRadius)
      return false;
    if (typeId != otherCreature.typeId + 1)
      return false;
    if (action == ac_flee)
      return false;
       
    PVector d = otherCreature.position.get();
    d.sub(position);
    float distance = d.mag();
 
    // lovi?
    if (distance < visibilityRadius)
    {
      //println (id + " hunt " + otherCreature.id);
      action = ac_hunt;
      moveDirection = atan2(d.y, d.x);
    }
 
    // jede?
    if (distance < biteRadius)
    {
      action = ac_bite;
      return true;
    }
 
    return false;
  }
} 
 
color actionColor(int action)
{
  final color[] visColor = {
      color(128, 34)              // ac_move = gray
    , color( 44, 222, 44, 111)    // ac_flee = green
    , color(222, 222, 44, 111)    // ac_hunt = yellow
    , color(255,  88, 88, 111)    // ac_bite = red
  };
  return visColor[constrain(action, 0, 3)];
};
 
final float margin = 140.0;   // border margin
 
class MotionInfo
{
  PVector position;    
  PVector velocity;   
  float direction;    
  float rotation;     
  float maxSpeed;     
  float maxAccel;      
  float maxAngSpeed;
  float maxAngAccel;
  //----------------------------------------------------------
  MotionInfo()
  {
    maxSpeed = 0.1;
    maxAccel = 1.0;
    maxAngSpeed = 0.0;
    maxAngAccel = 0.0;
    position = new PVector(0, 0, 0);
    velocity = new PVector(0, 0, 0);
    direction = random (0, TWO_PI);
    rotation = 0.0;
  }
  //----------------------------------------------------------
  MotionInfo(float startDirection          
            ,float maxMotionSpeed
            ,float maxMotionAcceleration
            ,float maxAngleSpeed
            ,float maxAngleAcceleration
            ,PVector startPosition)
  {
    direction = startDirection;
    maxSpeed = maxMotionSpeed;
    maxAccel = maxMotionAcceleration;
    maxAngSpeed = maxAngleSpeed;
    maxAngAccel = maxAngleAcceleration;
    position = startPosition;
    velocity = new PVector(0, 0, 0);
    rotation = 0.0;
  }
  //----------------------------------------------------------
  PVector getOrientationAsVector()
  {
    return new PVector(cos(direction), sin(direction), 0.0);
  }
  //----------------------------------------------------------
  void update(PVector move, float angular)
  {
    velocity.add(move);
    velocity.limit(maxSpeed);
    position.add(velocity);
 
    if(position.x > width + margin)
      position.x = -margin;
    else if(position.x < -margin)
      position.x = width + margin;
     
    if(position.y  > height + margin)
      position.y = -margin;
    else if(position.y < -margin)
      position.y = height + margin;
 
    if(rotation < maxAngSpeed)
      rotation += angular; 
    else
      rotation = maxAngSpeed;
 
    direction += rotation;
    direction %= TWO_PI;
  }
  //----------------------------------------------------------
  void update(SteeringInfo steering)
  {
    update(steering.linear, steering.angular);
  }
};
 
 
//----------------------------------------------------------
class SteeringInfo
{
  PVector linear;
  float angular;
  SteeringInfo()
  {
    linear = new PVector(0, 0, 0);
    angular = 0;
  }
};
 
SteeringInfo align (MotionInfo agent
                   ,MotionInfo target
                   ,float slowRadius
                   ,float targetRadius)
{
  SteeringInfo steering = new SteeringInfo();
 
  float angularDirection = target.direction - agent.direction;
 
  angularDirection %= TWO_PI;
 
  if (angularDirection > PI)
    angularDirection -= TWO_PI;
  else if (angularDirection < -PI)
    angularDirection += TWO_PI;
 
  float angularDistance = abs(angularDirection);
 
  if(angularDistance < targetRadius)
  {
    agent.rotation = 0;
    steering.angular = 0;
    return steering;
  }
 
  float targetRotationSpeed;
 
  if( angularDistance < slowRadius )
    targetRotationSpeed = agent.maxAngAccel * (angularDistance / slowRadius);
  else
    targetRotationSpeed = agent.maxAngAccel;
  
 
  // combinaison de la vitesse et de la direction
  if(angularDirection > 0) angularDirection /= angularDistance;
  float targetRotation = targetRotationSpeed * angularDirection;
  steering.angular = targetRotation - agent.rotation;
 
  if(steering.angular > agent.maxAngAccel)
  {
    steering.angular /= abs(steering.angular);
    steering.angular *= agent.maxAngAccel;
  }
  return steering;
}
 
//----------------------------------------------------------
SteeringInfo face (MotionInfo agent
                  ,MotionInfo target
                  ,float slowRadius
                  ,float targetRadius)
{
  PVector direction = PVector.sub(target.position, agent.position);
 
  MotionInfo alignTarget = new MotionInfo(random(2*PI), 1.0, 1.0, 0.2, 0.2, direction);
  alignTarget.direction = atan2(direction.y, direction.x);
 
  return align(agent, alignTarget, slowRadius, targetRadius);
}
 
float wanderOrientation = 0.0;
 
//----------------------------------------------------------
// wanderOffset = distance to the projected circle
// wanderRadius = circle radius
// wanderRate   = rate of direction change
//----------------------------------------------------------
SteeringInfo wander (MotionInfo agent
                    ,float wanderOffset
                    ,float wanderRadius
                    ,float wanderRate)
{
  MotionInfo target = new MotionInfo();
 
  wanderOrientation += random(-1, 1) * wanderRate;
  wanderOrientation %= TWO_PI;
 
  if (wanderOrientation > PI)
    wanderOrientation -= TWO_PI;
  else if (wanderOrientation < -PI)
    wanderOrientation += TWO_PI;
 
  target.direction = agent.direction + wanderOrientation;
 
  PVector positionOffset = agent.getOrientationAsVector();
  positionOffset.mult(wanderOffset);
 
  PVector orientationOffset = target.getOrientationAsVector();
  orientationOffset.mult(wanderRadius/2);
 
  target.position = agent.position.get();
  target.position.add(positionOffset);
  /*
  pushMatrix();
  pushStyle();
  noFill();
  stroke(255, 0, 0);
  ellipse(target.position.x, target.position.y, wanderRadius, wanderRadius);
  */
  target.position.add(orientationOffset);
  /*
  rect(target.position.x, target.position.y, 2, 2);
  popMatrix();
  popStyle();
  */
 
  SteeringInfo steering = face(agent, target, PI, 0);
  steering.linear = agent.getOrientationAsVector();
  steering.linear.mult(agent.maxAccel);
  return steering;
}
 
PVector getVector2d (float radius, float direction)
{
  return new PVector (cos(direction) * radius
                     ,sin(direction) * radius);
}
 
class TentaclePart
{
  PVector position;
  float size;
  color tColor;
};
 
class Tentacle
{
  PVector position;
  float direction;
  float compactness;
  ArrayList<TentaclePart> parts;  
  int nParts;
  
  Tentacle (PVector startPosition    
    , float startDirection      
    , int partCount            
    , float partSize          
    , float compactnessFactor   
    , color aColor)
  {
    position = startPosition;
    direction = startDirection;
    nParts = constrain (partCount, 2, 100);
    float headSize = partSize;
    compactness = compactnessFactor;
 
    // create tentacle parts
    parts = new ArrayList<TentaclePart>();
    color mixColor = color(random(150,222));
    for (int ni = 0; ni < nParts; ni++)
    {
      TentaclePart part = new TentaclePart();
      part.position = position.get();
      part.position.sub (getVector2d(float(ni+1), direction));
      part.size = headSize * float(nParts-ni) / nParts;
      float mix = 0.5 + 0.5 * sin(float(ni)*0.4);
      part.tColor = lerpColor (aColor, mixColor, mix);
      parts.add(part);
    }
  }
 
  void update()
  {
    PVector pos0 = parts.get(0).position;  
    PVector pos1 = parts.get(1).position;  
    pos1.set(position.get());      
    pos0.set(position.get());      
    pos1.sub(getVector2d(compactness, direction));
//    println ("update=");
    for (int ni = 2; ni < nParts; ni++)
    {
      PVector partPos = parts.get(ni).position;  
      PVector currentPos = partPos.get();
      PVector pos2 = parts.get(ni-2).position.get();
      PVector dist = PVector.sub(currentPos, pos2);
      float distance = dist.mag();
      PVector pos = parts.get(ni-1).position.get();
      PVector move = PVector.mult(dist, compactness);
      move.div(distance);
  //    println ("d=" + nf (distance,0,2));
      pos.add(move);
      partPos.set(pos);
    }
  }

  void update2()
  {
    PVector pos0 = parts.get(0).position;
    PVector pos1 = parts.get(1).position;
    pos1.set(position.get());      
    pos0.set(position.get());
    pos1.x = pos0.x + ( compactness * cos( direction ) );
    pos1.y = pos0.y + ( compactness * sin( direction ) );
    for (int i = 2; i < nParts; i++)
    {
      PVector currentPos = parts.get(i).position.get();
      PVector dist = PVector.sub( currentPos, parts.get(i-2).position.get() );
      float distmag = dist.mag();
      PVector pos = parts.get(i - 1).position.get();
      PVector move = PVector.mult(dist, compactness);
      move.div(distmag);
      pos.add(move);
      parts.get(i).position.set(pos);
    }
  }

  void draw()
  {
    for (int ni = nParts - 1; ni >= 0; ni--)
    {
      TentaclePart part = parts.get(ni);
      noStroke();
      fill(part.tColor);
      ellipse(part.position.x, part.position.y, part.size, part.size);
    }
  }
};
