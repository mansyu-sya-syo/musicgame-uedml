static class Game {

  static Minim minim;
  static AudioPlayer song1, song2, song3, song4;
  static AudioPlayer OPsong;

  //1:decide 2:destart 3:cancel 4:beginer

  static int nowSelecting=0;
  static Difficulty difficulty;
  //screen change
  static PImage[] jacket=new PImage[10];
  static boolean pressed[]=new boolean[5];
  static boolean released[]=new boolean[5];
  static boolean keyState[]=new boolean[5];
  static Music[] music=new Music[10];

  static String[] title={"A Beginer", "Now Making", "Now Making", "Now Making", "Now Making", "Now Making", "Now Making", "donguri"};
  static String[] fileName={"Now Making", "Now Making", "Now Making", "Now Making", "Now Making", "Now Making", "Now Making", "sample"};
  static String[] fileName2={"Now Making-easy", "", "", "", "", "", "", ""};
  static String ext=".aof";
  static String[] jacketName={"A Beginer.jpg", "1.jpg", "2.jpg", "3.jpg", "4.jpg", "5.jpg", "6.jpg", "7.jpg", "back.jpg", "gomi.jpg"};
  static String[] artist={"Acorn", "?", "?", "?", "?", "?", "?", "?"};
  static String[] bpm={"100", "?", "?", "?", "?", "?", "?", "?"};
  static String[] hardLv={"10", "?", "?", "?", "?", "?", "?", "?"};
  static String[] easyLv={"5", "?", "?", "?", "?", "?", "?", "?"};
  static char keys[]={UP, 'u', 'i', 'o', 'p'};


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
    return (int)((-t1+t2)/2+550);
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
