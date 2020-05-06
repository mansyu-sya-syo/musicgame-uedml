class Title extends Scene {

  void setup() {
    background(200);
    for (int i=0; i<10; i++) Game.jacket[i]=loadImage(Game.jacketName[i]);
    Game.song1=Game.minim.loadFile("decision3.mp3");
    Game.song2=Game.minim.loadFile("decision23.mp3");
    Game.song3=Game.minim.loadFile("cancel2.mp3");
    Game.song4=Game.minim.loadFile("a beginer.wav");
    Game.OPsong=Game.minim.loadFile("OP.wav");
    
    for(int i=0;i<8;i++) Game.music[i]=new Music();
    
    Game.OPsong.play();
    
  }

  void draw() {

    //image(Game.jacket[8], 0, 0, 1000, 600);
    tint(255, 255, 255);
    fill(255);
    ellipse(500, 300, 400, 200);

    fill(0);
    textSize(40);
    text("Press ENTER Key", 340, 320);
    textSize(100);
    text("Litom", 350, 150);
    fill(255);
  }

  void keyPressed() {

    if (key==ENTER) {
      SceneManager.changeScene("MusicSelect");
      Game.song2.play(0);
      Game.OPsong.pause();
    }
  }
}
