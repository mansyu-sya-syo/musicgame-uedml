class MusicSelect extends Scene {
  void draw() {
    tint(255, 255, 255, 200);
    background(0,255,64);
    //image(Game.jacket[8], 0, 0, 1000, 600);

    if (Game.nowSelecting>=0&&Game.nowSelecting<=3) {

      stroke(255, 0, 0);
      strokeWeight(10);
      fill(255);
      rect(60+(Game.nowSelecting)*240, 80, 160, 160);
    }
    if (Game.nowSelecting>=4&&Game.nowSelecting<=7) {
      stroke(255, 0, 0);
      strokeWeight(10);
      fill(255);
      rect(60+(Game.nowSelecting-4)*240, 350, 160, 160);
    }
    textSize(20);
    fill(0);
    fill(0);
    for (int i=0; i<4; i++) {
      tint(255);
      image(Game.jacket[i], 60+i*240, 80, 160, 160);
    }
    for (int i=0; i<4; i++) {
      image(Game.jacket[i+4], 60+i*240, 350, 160, 160);
    }
    for (int i=0; i<=3; i++) {
      text(Game.title[i], 90+i*240, 260);
    }
    for (int i=4; i<=7; i++) {
      text(Game.title[i], 80+(i-4)*240, 530);
    }
  }

  void keyPressed() {
    if (keyCode==LEFT&&Game.nowSelecting>0) {
      Game.nowSelecting--;
      Game.song1.play(0);
    }
    if (keyCode==RIGHT&&Game.nowSelecting<7) {
      Game.nowSelecting++;
      Game.song1.play(0);
    }
    if (keyCode==UP&&Game.nowSelecting>=4) {
      Game.nowSelecting=Game.nowSelecting-4;
      Game.song1.play(0);
    }
    if (keyCode==DOWN&&Game.nowSelecting<=3) {
      Game.nowSelecting=Game.nowSelecting+4;
      Game.song1.play(0);
    }
    if (keyCode==ENTER) {
      SceneManager.changeScene("MusicInfo");
      Game.song2.play(0);
      if (Game.nowSelecting==0) {
        Game.song4.play(0);
      }
    }
  }
}
