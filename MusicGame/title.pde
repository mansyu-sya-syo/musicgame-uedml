class Init extends Scene {
  void setup() {
    background(100, 100, 100);
    String[] settings=loadStrings(Game.settingsPath);
    String[] scoreList=loadStrings(Game.scoreListPath);

    Game.ext=settings[1].split(",")[1];
    Game.SPEED_EASY=Double.parseDouble(settings[4].split(",")[1]);
    Game.SPEED_HARD=Double.parseDouble(settings[5].split(",")[1]);
    Game.SHOWOFFSET=Double.parseDouble(settings[6].split(",")[1]);
    Game.OFFSET    =Double.parseDouble(settings[7].split(",")[1]);

    String[] keys=settings[2].split(",");
    String[] showkeys=settings[3].split(",");
    for (int i=0; i<LANE_NUM; i++) {
      char c=keys[i+1].toCharArray()[0];
      if (keys[i+1]=="UP") c=Game.up;
      if (keys[i+1]=="DOWN") c=Game.down;
      if (keys[i+1]=="LEFT") c=Game.left;
      if (keys[i+1]=="RIGHT") c=Game.right;
      Game.keys[i]=c;
    }

    for (int i=0; i<LANE_NUM; i++) {
      char c=showkeys[i+1].toCharArray()[0];
      if (showkeys[i+1]=="UP") c=Game.up;
      if (showkeys[i+1]=="DOWN") c=Game.down;
      if (showkeys[i+1]=="LEFT") c=Game.left;
      if (showkeys[i+1]=="RIGHT") c=Game.right;
      Game.showKeys[i]=c;
    }

    Game.title=scoreList[1].split(",");
    Game.fileName=scoreList[2].split(",");
    Game.fileName2=scoreList[3].split(",");
    Game.jacketName=scoreList[4].split(",");
    Game.artist=scoreList[5].split(",");
    Game.bpm=scoreList[6].split(",");
    Game.hardLv=scoreList[7].split(",");
    Game.easyLv=scoreList[8].split(",");

    int songNum=Game.fileName.length;
    for (int i=0; i<songNum; i++) Game.jacket[i]=loadImage("jacket/"+Game.jacketName[i]);
    for (int i=0; i<songNum; i++) Game.fileName[i]+=Game.ext;
    for (int i=0; i<songNum; i++) Game.fileName2[i]+=Game.ext;
    Game.song1=Game.minim.loadFile("beep/decision3.mp3");
    Game.song2=Game.minim.loadFile("beep/decision23.mp3");
    Game.song3=Game.minim.loadFile("beep/cancel2.mp3");
    Game.song4=Game.minim.loadFile("music/a beginer.wav");
    Game.OPsong=Game.minim.loadFile("music/OP.wav");

    SceneManager.changeScene("Title");
  }
}



class Title extends Scene {



  void setup() {
    background(100, 200, 250);
    Game.OPsong.setGain(-10); 
    Game.OPsong.play();
  }

  void draw() {

    //image(Game.jacket[8], 0, 0, 1000, 600);
    tint(255, 255, 255);
    fill(255);
    ellipse(500, 300, 400, 200);

    fill(0, (float)GameUtil.colorByTime(frameCount+50, 200)*255);
    textSize(40);
    textAlign(LEFT);
    text("Press ENTER Key", 340, 320);
    fill(0, 255);
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
