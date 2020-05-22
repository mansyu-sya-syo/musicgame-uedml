

class GameMain extends Scene {

  private Music music;
  private BackGrounds backGrounds;
  private ScoreBoard scoreBoard;

  private double startTime;

  GameMain(Music music){
    this.music=music;
  }


  void setup() {
    for (int i=0; i<LANE_NUM; i++) Game.resetRecent(i);
    startTime=millis();
    Game.beginer=Game.jacket[0];
    scoreBoard=new ScoreBoard();
    backGrounds=new BackGrounds(scoreBoard);
    music.loadWave();
    println(Game.difficulty);
    music.setDifficulty(Game.difficulty);
    music.playMusic();
  }

 //<>//

  void draw() {
    Game.time=millis()-startTime;
    if (Game.time>music.getEndTime()) SceneManager.changeScene("Result");
    Game.resetJudge();
    showJudge();
    showLanes();
    music.draw();
    Game.resetKeys();
  }

  void keyPressed() {
    if(keyCode==CONTROL){
      music.stopMusic();
      SceneManager.changeScene("MusicSelect");
    }
    for (int i=0; i<5; i++) {
      if (key==Game.keys[i]) {
        println(i);
        music.judge(i);
        Game.keyState[i]=true;
      }
    }
  }

  void keyReleased() {
    for (int i=0; i<5; i++) {
      if (key==Game.keys[i]) {
        Game.keyState[i]=false;
        Game.resetRecent(i);
      }
    }
  }
}
