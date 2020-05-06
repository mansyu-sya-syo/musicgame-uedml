class GameMain extends Scene {

  private int n;  
  private Music music;

  private double startTime;




  void setup() {
    for (int i=0; i<LANE_NUM; i++) Game.resetRecent(i);
    Game.resetScores();
    this.n=Game.nowSelecting;
    startTime=millis();
    Game.beginer=Game.jacket[0];
    music=Game.music[n];
    music.loadDualFile(Game.fileName[n]+Game.ext  ,Game.fileName2[n]+Game.ext  );
    music.loadWave();
    println(Game.difficulty);
    music.setDifficulty(Game.difficulty);
    music.playMusic();
  }

  void showJudge() {
    for (int i=0; i<LANE_NUM; i++) {
      if (Game.judge[i]==Judge.PERFECT) {
        println("perfect");
        Game.perfect++;
      } else if (Game.judge[i]==Judge.GOOD) {
        println("good");
        Game.good++;
      } else if (Game.judge[i]==Judge.LOST) {
        println("miss");
        Game.miss++;
      }
    }
  }

  private void setColorByJudge(Judge judge) {
    switch(judge) {
    case PERFECT:
      fill(255, 255, 0, 100);
      break;
    case GOOD:
      fill(0, 255, 0, 100);
      break;
    default:
      fill(255, 255, 255, 100);
    }
  }

  void showLanes() {
    background(100, 100, 100);
    tint(255, 255, 255, 100);
    image(Game.beginer, 100, 60, 800, 500);
    stroke(200);
    strokeWeight(5);
    fill(255);
    for (int i=0; i<=5; i++) {
      line(100+160*i, 0, 100+160*i, 550);
    }
    line(100, 550, 900, 550);

    textSize(85);
    text("Y    U    I     O    P", 150, 530);

    for (int i=0; i<5; i++) {

      if (Game.keyState[i]) {
        noStroke();
        setColorByJudge(Game.recent[i]);
        rect(laneX[i], 400, 160, 150);
      }
    } 
    fill(255);
    textSize(25);
    text("SCORE:"+calcScore(), 30, 60);
  }

  int calcScore() {
    int aaa=music.getAllNotes();
    Game.score=(int)((double)(Game.perfect*2+Game.good)/2.0/(double)music.getAllNotes()*10000.0); //<>//
    return Game.score;
  }

  void draw() {
    Game.time=millis()-startTime;
    if (Game.time>music.getEndTime()) SceneManager.changeScene("Result");
    Game.resetJudge();
    music.judge();
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
      if (keyCode==Game.keys[i]) {
        Game.pressed[i]=true;
        Game.keyState[i]=true;
      }
    }
  }

  void keyReleased() {
    for (int i=0; i<5; i++) {
      if (keyCode==Game.keys[i]) {
        Game.released[i]=true;
        Game.keyState[i]=false;
        Game.resetRecent(i);
      }
    }
  }
}
