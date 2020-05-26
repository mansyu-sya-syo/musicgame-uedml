import java.util.ArrayList; //<>//
import javafx.util.Pair;
import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;
import ddf.minim.spi.*;
import ddf.minim.ugens.*;


class ScoreBoard{
  int perfect=0;
  int good=0;
  int miss=0;
  int max_combo=0;
  
  int allNotes; //ノーツ数
  
  ScoreBoard(int allNotes){
    this.allNotes=allNotes;
  }
  
  int calcScore() {
    //int aaa=getAllNotes();
    int score=(int)((double)(perfect*2+good)/2.0/(double)allNotes*10000.0);
    return score;
  }
}

//class SongInfo{
   
//}

class BackGrounds{
  
  Judge[] recent=new Judge[5];
  ScoreBoard scoreBoard;
  
  BackGrounds(ScoreBoard scoreBoard){
    this.scoreBoard=scoreBoard;
  }
  
  boolean judge(int lane,Judge judge) {
    if(judge==null) return false;
    recent[lane]=judge;
    for (int i=0; i<LANE_NUM; i++) {
      if (judge==Judge.PERFECT) {
        println("perfect");
        scoreBoard.perfect++;
      } else if (judge==Judge.GOOD) {
        println("good");
        scoreBoard.good++;
      } else if (judge==Judge.LOST) {
        println("miss");
        scoreBoard.miss++;
      }
    }
    return true;
  }

  private void setColorByJudge(Judge judge) {
    switch(judge) {
    case PERFECT:
      fill(255,255,0,100);
      break;
    case GOOD:
      fill(0, 255, 0, 100);
      break;
    default:
      fill(255, 255, 255, 100);
    }
  }

  void draw() {
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
        //setColorByJudge(recent[i]);
        rect(laneX[i], 400, 160, 150);
      }
    } 
    fill(255);
    textSize(25);
    text("SCORE:"+scoreBoard.calcScore(), 30, 60);
  }
  
}


//不変オブジェクトにしたほうが上手い・・・？
class Note {
  private NoteType type; //ノーツの種類
  static final double UNDEFINED=100000000;
  private double pos=UNDEFINED; //位置[sec]
  private double endpos=UNDEFINED; //終端位置[sec](ロングのみ)
  private int lane; //所属レーン番号(左から0,1,2,3,4）
  private Status status=Status.DEFAULT;

  Note(NoteType type, double pos, int lane) {
    this.type=type;
    this.pos=pos;
    this.lane=lane;
  }



  //ノーツ描画
  void draw() {
    noStroke();
    fill(255, 170, 170);
    if (type==NoteType.NORMAL) rect(laneX[lane], Game.calcNoteY(pos, Game.time), 160, 10);
    else if (type==NoteType.LONG) rect(laneX[lane], Game.calcNoteY(endpos, Game.time), 160, (Game.calcNoteY(pos, Game.time)-Game.calcNoteY(endpos, Game.time)));
  }

  //既定の時刻と現在の時刻の差を求める(正ならば現在時刻のほうが早い)
  double diff(double t1) {
    return t1-Game.time;
  }


  //ロストチェック
  boolean checkLost() {
    if (diff(pos)<-LOST_TIME && status==Status.DEFAULT) {
      status=Status.VANISHED;
      return true;
    }

    return false;
  }
  //判定（共通部分)
  Judge judge(double diff) {
    if (diff<PERFECT_TIME) {
      return Judge.PERFECT;
    } else {
      return Judge.GOOD;
    }
  }

  //判定(離す)
  Judge judgeRelease() {
    if (type==NoteType.NORMAL) return null;
    double diff=diff(endpos);
    diff=abs((float)diff)/2;
    if (status==Status.PRESSED) {
      status=Status.VANISHED;
      if(diff>=LOST_TIME) return Judge.LOST;
      else return Judge.PERFECT;
    }
    return null;
  }

  //判定(押す)
  Judge judgePress() {
    double diff=diff(pos);
    if (type==NoteType.LONG && status==Status.PRESSED) diff=diff(endpos);

    diff=abs((float)diff);
    if (diff>=LOST_TIME) return null; 
    //println(diff);
    if (type==NoteType.NORMAL) {
      status=Status.VANISHED;
    } else if (type==NoteType.LONG) {
      if (status==Status.DEFAULT) {
        status=Status.PRESSED; 
        return null;
      }
    }
    return judge(diff);
  }

  NoteType getType() {
    return type;
  }

  double getPos() {
    return pos;
  }

  void setPos(double pos) {
    this.pos=pos;
  }

  double getEndPos() {
    return endpos;
  }

  void setEndPos(double endpos) {
    this.endpos=endpos;
  }
}

class Music extends Scene{
  
  private BackGrounds backGrounds;
  private ScoreBoard scoreBoard;
  
  private double startTime;

  void setup() {
    startTime=millis();
    Game.beginer=Game.jacket[0];
    println(Game.difficulty);
    setDifficulty(Game.difficulty);
    scoreBoard=new ScoreBoard(getAllNotes());
    backGrounds=new BackGrounds(scoreBoard);
    loadWave();
    playMusic();
  }



  void draw() {
    Game.time=millis()-startTime;
    if (Game.time>getEndTime()){
      SceneManager.set("Result", new ResultScene(scoreBoard));
      SceneManager.changeScene("Result");
    }
    backGrounds.draw();
    Game.resetKeys();
    drawNotes();
  }

  void keyPressed() {
    if(keyCode==CONTROL){
      stopMusic();
      SceneManager.changeScene("MusicSelect");
    }
    for (int i=0; i<5; i++) {
      if (key==Game.keys[i]) {
        //println(i);
        judge(i);
        Game.keyState[i]=true;
      }
    }
  }

  void keyReleased() {
    for (int i=0; i<5; i++) {
      if (key==Game.keys[i]) {
        Game.keyState[i]=false;
        //Game.resetRecent(i);
      }
    }
  } 
  
  
  String title;
  String subTitle;
  double BPM;
  String filename;
  double offset;
  double demoStart; 
  double endtime;
  private int[] allNotes={0, 0};
  private int d; //難易度(0:EASY,1:HARD)
  //private ArrayList<Pair<Double,Double>> scrollChange; //変更時の秒数、変更後の速度
  AudioPlayer wave;

  Judge judge;

  int[] level=new int[DIFFICULTY_NUM];
  private ArrayList<Note>[][] lanes=new ArrayList[2][5];
  private int noteCnt[]={0, 0, 0, 0, 0};

  void setDifficulty(Difficulty d) {
    this.d=d.ordinal();
    println(noteCnt.length);
    for (int i=0; i<LANE_NUM; i++) noteCnt[i]=0;
  }

  //ノーツロスト判定
  void checkLost() {
    for (int i=0; i<LANE_NUM; i++) {
      if (noteCnt[i]>=lanes[d][i].size()) continue; //すでにレーンの全ノーツが消えているならば飛ばす
      Note note=lanes[d][i].get(noteCnt[i]); //一番手前のノーツ
      if (note.checkLost() ){
        backGrounds.judge(i,Judge.LOST); //BackGroundsにロストしたことを通知
        noteCnt[i]++; //ロストしてたらカウント一個あげる
      }
    }
  }


  
  //ノーツを押せたか判定を行う(引数：レーンNo.0~4)
  void judge(int lane) {
    if (noteCnt[lane]>=lanes[d][lane].size()) return; //すでにレーンの全ノーツが消えているならば飛ばす
    Note note=lanes[d][lane].get(noteCnt[lane]);
    if (backGrounds.judge(lane,note.judgePress())) noteCnt[lane]++;
    if (backGrounds.judge(lane,note.judgeRelease())) noteCnt[lane]++;
  }
  

  
  //ノーツの描画
  void drawNotes() {
    for (int i=0; i<LANE_NUM; i++) {
      for (int j=noteCnt[i]; j<lanes[d][i].size(); j++) {
        Note note=lanes[d][i].get(j);
        if (Game.calcNoteY(note.getPos(), Game.time)<-100) break;
        note.draw();
      }
    }
  }

  //分数を小数に変換
  //input: String型の分数を表す文字列
  //output: 分数の計算結果
  private double frac(String s) {
    int status=0; //0:分子入力中　1:分母入力中
    String numerator="";
    String denominator="";
    for (int i=0; i<s.length(); i++) {
      if (s.charAt(i)=='/') {
        status=1;
      } else if (status==0) {
        numerator+=s.charAt(i);
      } else {
        denominator+=s.charAt(i);
      }
    }
    return Double.parseDouble(numerator)/Double.parseDouble(denominator);
  }

  double getEndTime() {
    return endtime;
  }

  /*文字列を音ゲー用形式に変換
   input: 譜面データを表す文字列配列
   */
  Music(String[] lines)  throws ScoreFileSyntaxErrorException{
    

    for (int k=0; k<DIFFICULTY_NUM; k++) {
      for (int i=0; i<LANE_NUM; i++) {
        lanes[k][i]=new ArrayList<Note>();
      }
    }

    double BPM=120;
    double beats=4; //現在あまり意味なし
    double unit=4;
    double time=0;
    for (int i=0; i<2; i++) allNotes[i]=0;
    int d=1; //現在入力中の難易度(デフォルトはHARD)
    //int i=0, j=0;

    //構文解析の状態を表す変数
    //-1:ヘッダ入力中(ヘッダ名）-2:ヘッダ入力中(引数)
    //0:ノーツ入力中　1:コマンド入力中(コマンド名) 2:コマンド入力中（引数) 3:通常状態
    int status=-1; 
    for (int i=0; i<lines.length; i++) {
      String commandName=""; //コマンド(ヘッダ)名
      String argument=""; //その引数
      int notenum=0; //その行でカウントされた数字の数(行の終端の判定に使う)
      if (lines[i].length()==0) continue; //空行は飛ばす
      if (status==0) status=3;
      //println();
      
      //☆一文字ずつ処理
      for (int j=0; j<lines[i].length(); j++) {
        
        char current=lines[i].charAt(j);
        int num=current - '0';

        //コメント
        if (current=='/') {
          if (j+1!=lines[i].length()) {
            if (lines[i].charAt(j+1)=='/') {
              j=lines[i].length(); //コメントに遭遇したら、行の終端まで進める(やり方が汚い)
              continue;
            }
          }
        }


        //コマンド
        if (status==-2) {
          argument+=current;
        } else if (status==-1) {
          //ヘッダ入力中
          if (current==':') {
            status=-2;
          } else {
            commandName+=current;
          }
        }

        //ノーツ
        int size=lanes[d][notenum].size();//そのレーンの総ノーツ数
        if (status==0 || status==3) {
          status=0;
          //通常状態
          if (current=='#') {
            //コマンド入力へ移行
            commandName="#";
            status=1;
          } else if (num==1) {
            //通常ノーツ
            lanes[d][notenum].add(new Note(NoteType.NORMAL, time, notenum));
            //println(Integer.toString(i)+" "+"NORMAL");
            notenum++;
            allNotes[d]++;
          } else if (num==2) {
            //ロングノーツ
            Note before; //一個前のノーツ
            //2000003と22222223をどちらも許容するための処理。
            if (size==0 || (before=lanes[d][notenum].get(size-1)).getEndPos()!=Note.UNDEFINED || before.getType()==NoteType.NORMAL) {
              lanes[d][notenum].add(new Note(NoteType.LONG, time, notenum));
              allNotes[d]++;
            }
            notenum++;
          } else if (num==3) {
            //ロングノーツの終端
            if(size==0) throw new ScoreFileSyntaxErrorException("ロングノーツの終点に対応する始点がありません。");
            Note before=lanes[d][notenum].get(size-1); //一個前のノーツ
            before.setEndPos(time);
            notenum++;
          } else if (num==0) {
            notenum++;
          }
        } else if (status==1) {
          //コマンド入力中
          if (current==' ') status=2;
          else commandName+=current;
        } else if (status==2) {
          argument+=current;
        }
      }

      //行の終端
      if (status==-1 || status==-2) {
        //ヘッダ情報(または#STARTコマンド)を処理
        println(commandName);
        status=-1;
        switch(commandName) {
        case "":
          //すべてコメントの行。何もしない。
          break;
        case "#START":
          status=0;
          break;
        case "TITLE":
          title=argument;
          break;
        case "SUBTITLE":
          subTitle=argument;
          break;
        case "LEVEL":
          level[d]=Integer.parseInt(argument);
          break;
        case "BPM":
          BPM=Double.parseDouble(argument);//はじめのBPMの値にもなる
          break;
        case "WAVE":
          filename=argument;
          break;
        case "OFFSET":
          offset=Double.parseDouble(argument);
          time=-offset;
          break;
        case "DIFFICULTY":
          d=Integer.parseInt(argument);
          time=0;
          break;
        case "DEMOSTART":
          demoStart=Double.parseDouble(argument);
          break;
        default:
          throw new ScoreFileSyntaxErrorException("このヘッダは存在しません。");
        }
        commandName="";
        argument="";
      } else if (status==1 || status==2) {
        //コマンドを処理
        println(commandName);
        status=0;
        switch(commandName) {
        case "#START":
          status=0;
          break;
        case "#END":
          status=-1;
          break;
        case "#BPMCHANGE":
          BPM=Double.parseDouble(argument);  
          break;
        case "#UNIT":
          unit=Double.parseDouble(argument);

          break;
        case "#MEASURE":
          beats=frac(argument);
          break;
        default:
          throw new ScoreFileSyntaxErrorException("この#コマンドは存在しません。");
        }
        commandName="";
        argument="";
      } else if (status==0 || status==3) {
        println("OK: i="+String.valueOf(i)+" line="+lines[i]);
        //println("OK: difficulty="+String.valueOf(d));
        double bpn=4.0/unit; //1ノーツ当たりの拍数 [beats/notes]
        double bps=BPM/60/1000; //1msec当たりの拍数　[beats/msec]
        double spn= bpn / bps; //1ノーツ当たりのmsec数[msec/notes] 
        time+=spn;
      }
    }
    endtime=time;
  }

  int getAllNotes() {
    return allNotes[d];
  }

  //波形をロード
  void loadWave() {
    wave=Game.minim.loadFile("music/"+filename);
  }

  //波形を再生
  void playMusic() throws NullPointerException{
    if (wave!=null) wave.play();
    else throw new NullPointerException("波形が読み込まれていません！最初にloadWave()を呼ぶ必要があります。");
  }
  
  //再生を停止
  void stopMusic() throws NullPointerException{
    if (wave!=null) wave.pause();
    else throw new NullPointerException("波形が読み込まれていません！最初にloadWave()を呼ぶ必要があります。");
  }
  
  class ScoreFileSyntaxErrorException extends Exception {
    ScoreFileSyntaxErrorException(String msg) {
      super(msg);
    }
  }

}
