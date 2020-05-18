  class ResultScene extends Scene{
  
  int n;
  
  void setup(){
    this.n=Game.nowSelecting;
  }
  
  void draw() {
    background(0,255,64);
    //image(Game.jacket[8], 0, 0, 1000, 600);
    fill(255);
    rect(300, 100, 600, 100);
    image(Game.jacket[n], 50, 50, 200, 200);
    textSize(80);
    fill(0);
    text(Game.title[n], 300, 70);
    textSize(50);
    text("perfect:"+Integer.toString(Game.perfect), 300, 400);
    text("good:"+Integer.toString(Game.good), 300, 450);
    text("miss:"+Integer.toString(Game.miss), 300, 500);
    textSize(30);
    text("press Ent key", 700, 550);
    textSize(100);
    text(Integer.toString(Game.score), 400, 190);
  }

  void keyPressed() {
    if (key=='m') {
      SceneManager.changeScene("Title");
      Game.song2.play(0);
    }
  }
}
