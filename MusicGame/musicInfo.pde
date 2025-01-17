class MusicInfo extends Scene {

  private int n; //曲No.
  private int select=2;

  void setup(){
    this.n=Game.musicID;
  }

  void draw() {
    tint(255, 255, 255, 100);
    background(0,255,64);
    //image(Game.jacket[8], 0, 0, 1000, 600);
    tint(255, 255, 255);
    if (select==0) {
      stroke(255, 0, 0);
      strokeWeight(10);
      fill(255);
      ellipse(100, 500, 100, 50);
    }
    if (select==2) {
      stroke(255, 0, 0);
      strokeWeight(10);
      rect(330, 290, 330, 80);
    }
    if (select==1) {
      stroke(255, 0, 0);
      strokeWeight(10);    
      rect(330, 390, 330, 80);
    }

    stroke(0);
    strokeWeight(5);
    fill(255);
    rect(330, 290, 330, 80);
    rect(330, 390, 330, 80);
    stroke(0);
    strokeWeight(3);

    tint(255, 255, 255);
    fill(255);
    ellipse(100, 500, 100, 50);
    fill(0);
    textSize(20);
    text("RETURN", 60, 510);
    fill(0);

    image(Game.jacket[n], 50, 50, 200, 200);
    textSize(100);
    text(Game.title[n], 300, 80);
    textSize(30);
    text("Artist : "+Game.artist[n], 700, 150);
    text("BPM:"+Game.bpm[n], 400, 200);
    textSize(50);
    text("HARD  Lv."+Game.hardLv[n], 350, 350);
    text("EASY   Lv."+Game.easyLv[n], 350, 450);
  }

  void keyPressed() {
    if (keyCode==Game.left&&select>=1) {
      select=0;
      Game.song1.play(0);
    }
    if (keyCode==Game.right&&select==0) {
      select=1;
      Game.song1.play(0);
    }
    if (keyCode==Game.up&&select==1) {
      select=2;
      Game.song1.play(0);
    }
    if (keyCode==Game.down&&select==2) {
      select=1;
      Game.song1.play(0);
    }
    if (keyCode==Game.enter) {
      if (select==0) {
        SceneManager.changeScene("MusicSelect"); //楽曲選択に戻る
        Game.song3.play(0);
      }
      if (select==1 || select==2) {
        try{
          String[] score=GameUtil.bindTwoFiles(loadStrings("scores/"+Game.fileName[n]),loadStrings("scores/"+Game.fileName2[n]));
          //TODO 楽曲の停止処理
          Music music=new Music(score);
          SceneManager.set("GameMain", music);
          SceneManager.changeScene("GameMain"); //ゲームメインに移行
          if(select==1) music.setDifficulty(Difficulty.EASY);
          else music.setDifficulty(Difficulty.HARD);
          Game.song2.play(0);
          
        }catch(Exception e){
          e.printStackTrace();
        }

      }
    }
  }
}
