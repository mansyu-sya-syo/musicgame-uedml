class MusicSelect extends Scene {
  
  
  int songNum=Game.fileName.length;
  
  void draw() {
    tint(255, 255, 255, 200);
    background(0,255,64);
    //image(Game.jacket[8], 0, 0, 1000, 600);

    if (Game.musicID%8>=0&&Game.musicID%8<=3) {

      stroke(255, 0, 0);
      strokeWeight(10);
      fill(255);
      rect(60+(Game.musicID%8)*240, 80, 160, 160);
    }
    if (Game.musicID%8>=4&&Game.musicID%8<=7) {
      stroke(255, 0, 0);
      strokeWeight(10);
      fill(255);
      rect(60+(Game.musicID%8-4)*240, 350, 160, 160);
    }
    textSize(20);
    fill(0);
    fill(0);
    int page=(int)Game.musicID/8;
    textAlign(CENTER);
    for (int i=0; i<4; i++) {
      tint(255);
      if(i+page*8>=songNum) break;
      image(Game.jacket[i+page*8], 60+i*240, 80, 160, 160);
      text(Game.title[i+page*8], 140+i*240, 260);
    }
    for (int i=0; i<4; i++) {
      if(i+page*8+4>=songNum) break;
      image(Game.jacket[i+4+page*8], 60+i*240, 350, 160, 160);
      text(Game.title[i+4+page*8], 140+i*240, 530);
    }
    textAlign(LEFT);
  }

  void keyPressed() {
    if (keyCode==Game.left&&Game.musicID>0) {
      Game.musicID--;
      Game.song1.play(0);
    }
    if (keyCode==Game.right&&Game.musicID<songNum-1) {
      Game.musicID++;
      Game.song1.play(0);
    }
    if (keyCode==Game.up&&Game.musicID>=4) {
      Game.musicID=Game.musicID-4;
      Game.song1.play(0);
    }
    if (keyCode==Game.down&&Game.musicID<songNum/4*4) {
      Game.musicID=Math.min(Game.musicID+4,songNum-1);
      Game.song1.play(0);
    }
    if (keyCode==Game.enter) {
      SceneManager.changeScene("MusicInfo");
      Game.song2.play(0);
      //TODO 楽曲流す処理
    }
  }
}
