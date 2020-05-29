import java.util.ArrayList;

static class Game {

  static Minim minim;
  static AudioPlayer song1, song2, song3, song4;
  static AudioPlayer OPsong;

  //1:decide 2:destart 3:cancel 4:
  
  static int musicID=0;
  static boolean[] keyState=new boolean[5];
  //screen change
  static PImage[] jacket=new PImage[50];
  static String[] title={"A Beginer", "Boot UP!!", "hilarious AI", "ALICE IN GLITCHED WORLD", "Dáinsleif", "Hazard BULLΣT", "Pluge", "snow","fdhfdf","fjdskhfk"};
  static String[] fileName={"A Beginer", "Boot UP", "hilarious AI", "ALICE IN GLITCHED WORLD", "Dáinsleif", "Hazard BULLΣT", "Pluge", "snow","",""};
  static String[] fileName2={"", "Boot UP easy", "hilarious AI", "ALICE IN GLITCHED WORLD", "Dáinsleif", "Hazard BULLΣT", "Pluge", "snow","",""};
  static String ext=".aof";
  static String[] jacketName={"A Beginer.jpg", "boot up.jpg", "hilarious.jpg", "ALICE.jpg", "Dainsleif.jpg", "Hazard.jpg", "Pluge.jpg", "snow.jpg", "yoaruki.jpg", "1.jpg"};
 
  static String[] artist={"Acorn", "?", "?", "?", "?", "?", "?", "?"};
  static String[] bpm={"100", "?", "?", "?", "?", "?", "?", "?"};
  static String[] hardLv={"7", "9", "9", "?", "?", "?", "?", "?"};
  static String[] easyLv={"2", "4", "?", "?", "?", "?", "?", "?"};
  static char keys[]={'c','v','b','n','m'}; //実際に叩くキー
  static char showKeys[]={'c','v','b','n','m'}; //表示上のキー
  static char left=LEFT,right=RIGHT,up=UP,down=DOWN,enter=ENTER;

  static PImage beginer;
  static int laneY=550;
  
  //ノーツのy座標を計算
  //input:t1=ノーツの通過時刻[msec] t2=現在時刻[msec] 
  //output: ノーツのy座標
  static int calcNoteY(double t1, double t2) {
    return (int)((-t1+t2)/speed+laneY+SHOWOFFSET);
  }
  
  static final double SPEED_EASY=1.5;
  static final double SPEED_HARD=1;
  static final double SHOWOFFSET=100;
  static final double OFFSET=100;
  
  static private double speed;
  
  static void setSpeed(Difficulty d){
    if(d==Difficulty.EASY) speed=SPEED_EASY;
    if(d==Difficulty.HARD) speed=SPEED_HARD;
  }
}
