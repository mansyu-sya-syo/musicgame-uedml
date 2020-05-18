static class Game {

  static Minim minim;
  static AudioPlayer song1, song2, song3, song4;
  static AudioPlayer OPsong;

  //1:decide 2:destart 3:cancel 4:

  static int nowSelecting=0;
  static Difficulty difficulty;
  //screen change
  static PImage[] jacket=new PImage[10];
  static boolean pressed[]=new boolean[5];
  static boolean released[]=new boolean[5];
  static boolean keyState[]=new boolean[5];
  static Music[] music=new Music[10];
  static String[] title={"A Beginer", "Boot UP!!", "hilarious AI", "ALICE IN GLITCHED WORLD", "Dáinsleif", "Hazard BULLΣT", "Pluge", "snow"};
  static String[] fileName={"A Beginer", "Boot UP", "hilarious AI", "ALICE IN GLITCHED WORLD", "Dáinsleif", "Hazard BULLΣT", "Pluge", "snow"};
  static String[] fileName2={"A Beginer", "Boot UP easy", "hilarious AI", "ALICE IN GLITCHED WORLD", "Dáinsleif", "Hazard BULLΣT", "Pluge", "snow"};
  static String ext=".aof";
  static String[] jacketName={"A Beginer.jpg", "boot up.jpg", "hilarious.jpg", "ALICE.jpg", "Dainsleif.jpg", "Hazard.jpg", "Pluge.jpg", "snow.jpg", "yoaruki.jpg", "1.jpg"};
 
  static String[] artist={"Acorn", "?", "?", "?", "?", "?", "?", "?"};
  static String[] bpm={"100", "?", "?", "?", "?", "?", "?", "?"};
  static String[] hardLv={"7", "9", "9", "?", "?", "?", "?", "?"};
  static String[] easyLv={"2", "4", "?", "?", "?", "?", "?", "?"};
  static char keys[]={'c','v','b','n','m'};


  static int score=0;
  static int perfect=0;
  static int good=0;
  static int miss=0;
  static int combo=0;

  static PImage beginer;
  static double time;

  static Judge[] judge=new Judge[5];
  static Judge[] recent=new Judge[5];
  
  static void resetScores(){
    score=0;
    perfect=0;
    good=0;
    miss=0;
    combo=0;
  }


  //ノーツのy座標を計算
  //input:t1=ノーツの通過時刻[msec] t2=現在時刻[msec] 
  //output: ノーツのy座標
  static int calcNoteY(double t1, double t2) {
    return (int)((-t1+t2)/1+550);
  }

  //ジャッジをリセット
  static void resetJudge() {
    for (int i=0; i<5; i++) {
      judge[i]=Judge.NA;
    }
  }
  

  //ジャッジをリセット
  static void resetRecent(int i) {

    recent[i]=Judge.NA;
  }
  //キー入力をリセット
  static void resetKeys() {
    for (int i=0; i<5; i++) {
      pressed[i]=false;
      released[i]=false;
    }
  }
}
