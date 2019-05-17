import processing.sound.*;

SoundFile deathMusic;            //Musique de Game Over

PImage vague;                    //On initialise toutes les images
PImage perso;
PImage GameOver;
PImage eau;
PImage blockEau;
PImage restart;
PImage sol,obstacle;

int taille=50, NbDeLignes=10, NbDeColonnes=15, NbX, NbY, AleatoireObstacle;    //Variables nécessaires à la création de la map

//Variables concernant les obstacles
int XobsH;                                  //Coordonée en abscisse de l'objet qui se déplace horizontalement
int YobsH;                                  //Coordonée en ordonnée de l'objet qui se déplace horizontalement
int XobsV;                                  //Coordonée en abscisse de l'objet qui se déplace verticalement
int YobsV;                                  //Coordonée en ordonnée de l'objet qui se déplace verticalement
int largeurObs = 50;                        //largeur de l'objet
int hauteurObs = 50;                        //hauteur de l'objet
int vitObsX = 6;                            //vitesse des objets en abscisse
int vitObsY = 6;                            //vitesse des objets en ordonnée

//Variables concernant le hero
int Xhero = 180;           
int Yhero = 100;
int largeurH = 50;
int hauteurH = 50;

int Yvag;        //Position de la vague pour le game over

float NbAlX,NbAlY, test ;               //nonmbres aléatoires et  une variable servant de transition

//Variables d'état des différents objets sur la scène
boolean mort = false;     //Pour le personnage 
boolean objH = true;      //Pour l'objet "horizontal"
boolean objV = true;      //Pour l'objet "vertical"

//Variables associées aux touches
boolean enter;                      
boolean right, left, up, down;

int tab[][] = new int[10][15];    //création du tableau

int t1, t2;  //variables de temps pour compter le temps à l'horloge
int d1, d2;
int time1, time2;

int score;    //score

void setup()
{
  size(1000,700);                                            //On crée la fenêtre
  
  //Ici on affecte nos images et musiques 
  deathMusic = new SoundFile(this, "gameover.mp3");          //la musique
  sol=loadImage("sol.png");                                  //la plateforme
  obstacle=loadImage("obstacle.png");                        //les objets
  perso = loadImage("sprite sheet vue de face.png");         //le personnage
  vague = loadImage("vague.png");                            //la vague
  GameOver = loadImage("GAMEOVER.jpg");                      //logo game over
  restart = loadImage("restart.png");                        //phrase "Press enter to restart"
  eau = loadImage("eau1.png");                               //fond eau
  blockEau = loadImage("block_eau.png");                     //bloc d'eau qui remplacera les bouts de plateforme 
  right = left = up = down = false;
  textSize(50);                                              //taille de texte
  
  
  for(int j=0;j<(NbDeLignes-1);j++)                        //Ici on dit que tous les blocs de plateforme sont à l'état 1 c'est-à-dire présents
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
  image(eau,0,0);                          //On dessine le fond du jeu (eau)
        
  if (mort == true)                        //On vérifie que le joueur n'est pas mort avant de lancer tout le programme
  {  
    gameover(); 
  }
  else
  {
    suppression();
    dessiner();
    mort();
    collisions();
    score++;                              //On incrémente le score
    fill(0,255,100);
    text(score/10,800,50);                //et on l'affiche
  }
}




void keyPressed()                             //commmande des touches
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
  if (time1 - time2 >=100)              //On impose un délai de 100 ms pour pas que le perso se déplace de 2 cases en une touche de clavier
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
  if(deathMusic.isPlaying()==false)
  {
    deathMusic.play();
  }
  image(vague, 0, height-Yvag);
  if(Yvag <=height + 180)
  {
    Yvag = Yvag +3;
  }
  
  else if (enter)
  {
    deathMusic.stop();
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
