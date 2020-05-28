class Title extends Scene {

  int songNum=Game.fileName.length;
  
  void setup() {
    background(100,200,250);
    for (int i=0; i<songNum; i++) Game.jacket[i]=loadImage("jacket/"+Game.jacketName[i]);
    Game.song1=Game.minim.loadFile("beep/decision3.mp3");
    Game.song2=Game.minim.loadFile("beep/decision23.mp3");
    Game.song3=Game.minim.loadFile("beep/cancel2.mp3");
    Game.song4=Game.minim.loadFile("music/a beginer.wav");
    Game.OPsong=Game.minim.loadFile("music/OP.wav");
    Game.OPsong.setGain(-10); 
    Game.OPsong.play();
    
  }

  void draw() {

    //image(Game.jacket[8], 0, 0, 1000, 600);
    tint(255, 255, 255);
    fill(255);
    ellipse(500, 300, 400, 200);

    fill(0,(float)GameUtil.colorByTime(frameCount+50,200)*255);
    textSize(40);
    textAlign(LEFT);
    text("Press ENTER Key", 340, 320);
    fill(0,255);
    textSize(100);
    text("Litom", 350, 150);
    fill(255);
  }

  void keyPressed() {

    if (key==Game.enter) {
      SceneManager.changeScene("MusicSelect");
      Game.song2.play(0);
      Game.OPsong.pause();
    }
  }
}
