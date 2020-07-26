import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;
import ddf.minim.spi.*;
import ddf.minim.ugens.*;

//定数たち
final double PERFECT_TIME=50.0;
final double LOST_TIME=150.0;
final int LANE_NUM=5;
final int DIFFICULTY_NUM=2;

//final double TARGET_FPS=60.0;
//final double FRAME_TIME=1000.0/TARGET_FPS;
//final int MAX_NOTES=10000;
final int laneX[]={100, 260, 420, 580, 740, 900};

//ノーツの種類
//通常ノーツ、ロングノーツ
enum NoteType {
  NORMAL, 
    LONG
}

//ノーツの状態
//初期状態、押されている(ロングのみ)、消えている（ロスト含む)
enum Status {
  DEFAULT, 
    PRESSED, 
    VANISHED
}

//難易度
//EASY/HARD
enum Difficulty {
  EASY, 
    HARD
}

//ジャッジ
enum Judge{
  PERFECT
,
  GOOD,
  LOST,
  NA
}




//画面サイズの設定とシーンの設定
public void settings() {
  size(1000, 600);
  SceneManager.set("Init",new Init());
  SceneManager.set("Title", new Title());
  SceneManager.set("MusicSelect", new MusicSelect());
  SceneManager.set("MusicInfo", new MusicInfo());
  SceneManager.set("re", new ResultScene(new ScoreBoard(500)));
  SceneManager.changeScene("Init");
  Game.minim=new Minim(this);
  int songNum=Game.fileName.length;
  for (int i=0; i<songNum; i++) Game.fileName[i]+=Game.ext;
  for (int i=0; i<songNum; i++) Game.fileName2[i]+=Game.ext;

}

@Override
  public void handleDraw() {
  if (g == null) return;
  if (!looping && !redraw) return;
  if (insideDraw) {
    System.err.println("handleDraw() called before finishing");
    System.exit(1);
  }

  insideDraw = true;
  g.beginDraw();
  if (recorder != null) {
    recorder.beginDraw();
  }

  long now = System.nanoTime();

  if (frameCount == 0) {
    SceneManager.getCurrentScene().setup();
    //SceneManager.incrementFrameCount(); //setup()がなぜか２回呼ばれてしまうので挿入
  } else {
    double rate = 1000000.0 / ((now - frameRateLastNanos) / 1000000.0);
    float instantaneousRate = (float) (rate / 1000.0);
    frameRate = (frameRate * 0.9f) + (instantaneousRate * 0.1f);

    if (frameCount != 0) handleMethods("pre");

    pmouseX = dmouseX;
    pmouseY = dmouseY;

    SceneManager.getCurrentScene().draw();

    dmouseX = mouseX;
    dmouseY = mouseY;

    //println(key);
    dequeueEvents();

    handleMethods("draw");

    redraw = false;
  }
  g.endDraw();

  if (recorder != null) recorder.endDraw();
  insideDraw = false;

  if (frameCount != 0) handleMethods("post");

  frameRateLastNanos = now;
  SceneManager.incrementFrameCount();
  frameCount = SceneManager.getFrameCount();
}
