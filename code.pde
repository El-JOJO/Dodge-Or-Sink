PImage vague;                    //On initialise toutes les images
PImage perso;
PImage GameOver;
PImage eau;
PImage blockEau;
PImage restart;
PImage sol,obstacle;

int taille=50, NbDeLignes=10, NbDeColonnes=15, NbX, NbY, AleatoireObstacle;    //Variables nécessaires à la création de la map

int XobsH;                  //Variables concernant les obstacles
int YobsH;
int XobsV;
int YobsV;
int largeurObs = 50;
int hauteurObs = 50;
int vitObsX = 6;
int vitObsY = 6;

int Xhero = 180;            //Variables concernant le hero
int Yhero = 100;
int largeurH = 50;
int hauteurH = 50;

int Yvag;        //Position de la vague pour le game over

float NbAlX,NbAlY, test ;


boolean mort = false;      //Variables d'état des différents objets sur la scène
boolean objH = true;
boolean objV = true;

boolean enter;                      //Variables associées aux touches
boolean right, left, up, down;

int tab[][] = new int[10][15];    //création du tableau

int t1, t2;  //variables de temps
int d1, d2;
int time1, time2;

int score;

void setup()
{
  size(1000,700);
  sol=loadImage("sol.png");
  obstacle=loadImage("obstacle.png");
  perso = loadImage("sprite sheet vue de face.png");
  vague = loadImage("vague.png");
  GameOver = loadImage("GAMEOVER.jpg");
  restart = loadImage("restart.png");
  eau = loadImage("eau1.png");
  blockEau = loadImage("block_eau.png");
  right = left = up = down = false;
  textSize(50);
  
  
  for(int j=0;j<(NbDeLignes-1);j++)
  {
   for(int i=0;i<(NbDeColonnes-1);i++)
   {
     tab[j][i]=1;
   }
  }
  mappe(); //initialisation de la map
  
}



void draw()
{
  image(eau,0,0);
        
  if (mort == true)
  {  
    gameover();
  }
  else
  {
    suppression();
    dessiner();
    mort();
    collisions();
    score++;
    fill(0,255,100);
    text(score/10,800,50);
  }
}




void keyPressed() 
{
    if (keyCode == RIGHT) { right = true; }
    if (keyCode == LEFT ) { left = true;}
    if (keyCode == UP)    { up = true;}         
    if (keyCode == DOWN)  { down = true;}    
    if (keyCode == ENTER) { enter = true;}
     

}
void keyReleased() 
{
    if (keyCode == RIGHT) { right = false; }
    if (keyCode == LEFT ) { left = false;  }
    if (keyCode == UP)    { up = false;    }
    if (keyCode == DOWN)  { down = false;  }
    if (keyCode == ENTER) { enter = false;}
}


void dessiner()
{
  time1 = millis();
  if (time1 - time2 >=100)
  {
    if (right)
    { Xhero = Xhero+50;}
  
    if (left ) 
    { Xhero = Xhero-50;}   
    
    if (up)    
    { Yhero = Yhero-50;}    
    
    if (down)  
    { Yhero = Yhero+50;}
    time2= millis();
  }
  obstacle();
  image(perso,Xhero,Yhero); 
}






//collisions avec l'obstacle qui arrive sur le joueur
void collisions()
{
  boolean ValignerV = ValigneV();
  boolean ValignerH = ValigneH();
  boolean HalignerV = HaligneV();
  boolean HalignerH = HaligneH();
  if (ValignerV == true && ValignerH == true)
  {

      Yhero = Yhero + 50;
      objV = false;
  }
  if (HalignerV == true && HalignerH == true)
  {
      Xhero =Xhero +50;
      objH = false;
    
  }
  
  
}
boolean ValigneV()
{
  boolean aligneV = false;
  if (XobsV + largeurObs > Xhero && XobsV < Xhero + largeurH)
  { aligneV = true; }
  return aligneV;
}
boolean ValigneH()
{
  boolean aligneH = false;
  if (YobsV + hauteurObs > Yhero && YobsV < Yhero + hauteurH)
  { aligneH = true; }
  return aligneH;
}
boolean HaligneV()
{
  boolean aligneV = false;
  if (XobsH + largeurObs > Xhero && XobsH < Xhero + largeurH)
  { aligneV = true; }
  return aligneV;
}
boolean HaligneH()
{
  boolean aligneH = false;
  if (YobsH + hauteurObs > Yhero && YobsH < Yhero + hauteurH)
  { aligneH = true; }
  return aligneH;
}



void mort()
{
  color c;
  c = get(Xhero-1, Yhero);
  
  float b = blue(c);
  
  
  if(b >= 80)
  {
      mort = true;
  }
}
  
void gameover()
{
  image(vague, 0, height-Yvag);
  if(Yvag <=height + 180)
  {
    Yvag = Yvag +3;
  }
  
  else if (enter)
  {
    println("Dernier score : ", score);
    mort = false;  
    restart();
  }
  
  else
  {
    image(GameOver,width/2-250,height/2-150);
    image(restart,width/2-250,height/2+150);
    fill(0);
    text(score/10,500,100);
  }

}


void restart()
{
  score = 0;
  XobsH = 0;
  YobsH = 300;
  XobsV = 0;
  YobsV = 300;
  largeurObs = 50;
  hauteurObs = 50;
  vitObsX = 6;
  vitObsY = 6;
  Xhero = 180;
  Yhero = 100;
  mort = false;
  objH = true;
  objV = true;
  Yvag = 0;
  int y=(height-(NbDeLignes*taille))/2;
  for(int j=0;j<(NbDeLignes-1);j++)
  {
    int x=(width-(NbDeColonnes*taille))/2;
    for(int i=0;i<(NbDeColonnes-1);i++)
    {
      tab[j][i]=1;
    }
   y=y+taille;
  }
  
}

void suppression()
{
  t1=millis();
  if (t1-t2 >= 1300)
  {
    NbAlX=random(0,(NbDeColonnes-1));
    NbAlY=random(0,(NbDeLignes-1));
    NbX=int(NbAlX);
    NbY=int(NbAlY);
    int y=(height-(NbDeLignes*taille))/2;
    for(int j=0;j<(NbDeLignes-1);j++)
      {
        int x=(width-(NbDeColonnes*taille))/2;
        int Xo=x;
        for(int i=0;i<(NbDeColonnes-1);i++)
        {
          if(NbX==i&NbY==j)
          {
            tab[j][i]=0;
          }
          x=x+taille;
        }
       y=y+taille;
      }
      t2=millis();
  }
    
  mappe();
}


void mappe()
{
  
  int y=(height-(NbDeLignes*taille))/2;
 
   for(int j=0;j<(NbDeLignes-1);j++)
  {
    
    int x=(width-(NbDeColonnes*taille))/2;
    for(int i=0;i<(NbDeColonnes-1);i++)
    {
      x=x+taille;
      if (tab[j][i] == 1)
      image(sol,x,y);
     
    }
   y=y+taille;
  }
}


void obstacle()
{
    if (objH)
    {
      if (XobsH < width)
      {
        XobsH = XobsH + vitObsX;
        image(obstacle,XobsH,YobsH);
      }
      else
      {
        objH = false;
        vitObsX++;
      }
    }
    else
    {
      test=random(0,NbDeLignes-1);
      AleatoireObstacle= int(test);
      XobsH=taille;
      YobsH=((height-(NbDeLignes*taille))/2+(AleatoireObstacle*taille));
      image(obstacle,XobsH,YobsH);
      objH =true;
    }
    
    if (objV)
    {
      if (YobsV < width)
      {
        YobsV = YobsV + vitObsY;
        image(obstacle,XobsV,YobsV);
      }
      else
      {
        objV = false;
        vitObsY++;
      }
    }
    else
    {
      test=random(0,NbDeLignes-1);
      AleatoireObstacle= int(test);
      XobsV=((width-(NbDeLignes*taille))/2+(AleatoireObstacle*taille));
      YobsV=taille;
      image(obstacle,XobsV,YobsV);
      objV =true;
    }

}
