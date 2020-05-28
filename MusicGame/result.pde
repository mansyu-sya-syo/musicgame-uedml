class ResultScene extends Scene {

  ScoreBoard scoreBoard;
  private int n;
  private int time=0;

  ResultScene(ScoreBoard scoreBoard) {
    this.scoreBoard=scoreBoard;
    n=Game.musicID;
  }

  void draw() {
    time++;
    background(0, 255, 64, 255);
    //image(Game.jacket[8], 0, 0, 1000, 600);
    fill(255);
    rect(300, 100, 600, 100);
    tint(255, 255, 255, 255);
    image(Game.jacket[n], 50, 50, 200, 200);
    textSize(80);
    fill(0);
    textAlign(LEFT);
    text(Game.title[n], 300, 70);
    textSize(50);
    //text("perfect:"+Integer.toString((int)GameUtil.countUpByTime2(time-10,scoreBoard.perfect,59,2)), 300, 400);
    int perfect=(int)GameUtil.countUpByTime2(time, scoreBoard.perfect, 59);
    int good=(int)GameUtil.countUpByTime2(time, scoreBoard.good, 59);
    int miss=(int)GameUtil.countUpByTime2(time, scoreBoard.miss, 59);
    fill(0,50);
    noStroke();
    rect(295, 350, (float)perfect/(float)(scoreBoard.allNotes)*500, 50);
    rect(295, 400,    (float)good/(float)(scoreBoard.allNotes)*500, 50);
    rect(295, 450,    (float)miss/(float)(scoreBoard.allNotes)*500, 50);
    fill(0,255);
    text("perfect:"+Integer.toString(perfect), 300, 400);
    text("good:"+Integer.toString(good), 300, 450);
    text("miss:"+Integer.toString(miss), 300, 500);
    textSize(100);
    textAlign(RIGHT);
    //text(Integer.toString((int)GameUtil.countUpByTime(time, 10000, 59, 2)), 800, 190);
    text(Integer.toString((int)GameUtil.countUpByTime(time,scoreBoard.calcScore(),59,2)), 400, 190);
    textSize(30);
    fill(0, (float)GameUtil.colorByTime(time, 200)*255);
    text("press Enter key", 700, 550);
  }

  void keyPressed() {
    if (keyCode==Game.enter) {
      SceneManager.changeScene("Title");
      Game.song2.play(0);
    }
  }
}
