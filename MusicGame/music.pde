import java.util.ArrayList;
import javafx.util.Pair;
import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;
import ddf.minim.spi.*;
import ddf.minim.ugens.*;






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
      Game.recent[lane]=Game.judge[lane]=Judge.LOST;
      return true;
    }

    return false;
  }

  //判定（共通部分)
  void judge(double diff) {
    if (diff<PERFECT_TIME) {
      Game.recent[lane]=Game.judge[lane]=Judge.PERFECT;
    } else {
      Game.recent[lane]=Game.judge[lane]=Judge.GOOD;
    }
  }

  //判定(離す)
  boolean judgeRelease() {
    if (type==NoteType.NORMAL) return false;
    double diff=diff(endpos);
    diff=abs((float)diff)/2;
    if (diff>=LOST_TIME) return false; 
    if (status==Status.PRESSED) {
      status=Status.VANISHED;
      return true;
    }
    return false;
  }

  //判定(押す)
  boolean judgePress() {
    double diff=diff(pos);
    if (type==NoteType.LONG && status==Status.PRESSED) diff=diff(endpos);

    diff=abs((float)diff);
    if (diff>=LOST_TIME) return false; 
    boolean ret=true;
    //println(diff);
    if (type==NoteType.NORMAL) {
      status=Status.VANISHED;
    } else if (type==NoteType.LONG) {
      if (status==Status.DEFAULT) {
        status=Status.PRESSED; 
        ret=false;
      }
    }
    judge(diff);

    return ret;
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

class Music {
  String title;
  String subTitle;
  double BPM;
  String filename;
  double offset;
  double demoStart; 
  double endtime;
  private int[] allNotes={0,0};
  private int d; //難易度(0:EASY,1:HARD)
  //private ArrayList<Pair<Double,Double>> scrollChange; //変更時の秒数、変更後の速度
  AudioPlayer wave;
  
  Judge judge;

  int[] level=new int[DIFFICULTY_NUM];
  private ArrayList<Note>[][] lanes=new ArrayList[2][5];
  private int noteCnt[]={0, 0, 0, 0, 0};

  Music() {
    for (int k=0; k<DIFFICULTY_NUM; k++) {
      for (int i=0; i<LANE_NUM; i++) {
        lanes[k][i]=new ArrayList<Note>();
      }
    }
  }

  void setDifficulty(Difficulty d) {
    this.d=d.ordinal();
    println(noteCnt.length);
    for (int i=0;i<LANE_NUM;i++) noteCnt[i]=0;
    
  }

  void judge() {

    //ノーツロスト判定
    for (int i=0; i<LANE_NUM; i++) {
      if (noteCnt[i]>=lanes[d][i].size()) continue; //すでにレーンの全ノーツが消えているならば飛ばす
      Note note=lanes[d][i].get(noteCnt[i]);
      if (note.checkLost() ) {
        noteCnt[i]++;
      }
    }

    //ノーツ押せたか判定
    for (int i=0; i<LANE_NUM; i++) {
      if (noteCnt[i]>=lanes[d][i].size()) continue; //すでにレーンの全ノーツが消えているならば飛ばす
      Note note=lanes[d][i].get(noteCnt[i]);
      if (Game.pressed[i]) {
        if (note.judgePress()) noteCnt[i]++;
      }
      if (Game.released[i]) {
        if (note.judgeRelease()) noteCnt[i]++;
      }
    }
  }

  void draw() {
    for (int i=0; i<LANE_NUM; i++) {
      for (int j=noteCnt[i]; j<lanes[d][i].size(); j++) {
        Note note=lanes[d][i].get(j);
        if (Game.calcNoteY(note.getPos(), Game.time)<-100) break;
        note.draw();
      }
    }
  }



  //譜面の読み込み
  //input: 譜面データのファイル名

  void loadFile(String filename) {

    String    lineData[] = null;

    //テキストファイルを読む(http://mslabo.sakura.ne.jp/WordPress/make/processing%E3%80%80%E9%80%86%E5%BC%95%E3%81%8D%E3%83%AA%E3%83%95%E3%82%A1%E3%83%AC%E3%83%B3%E3%82%B9/%E3%83%95%E3%82%A1%E3%82%A4%E3%83%AB%E3%81%8B%E3%82%89%E6%96%87%E5%AD%97%E5%88%97%E3%83%87%E3%83%BC%E3%82%BF%E3%82%92%E8%AA%AD%E3%81%BF%E8%BE%BC%E3%82%80%E3%81%AB%E3%81%AF/)
    lineData = loadStrings( filename );
    if ( lineData == null ) {
      //読み込み失敗
      println( filename + " 読み込み失敗" );
      System.exit(1);
    }
    //読み込んだ各行を画面に表示
    for ( int i = 0; i < lineData.length; i++ ) {
      println( String.valueOf(i) + "：[" + lineData[i] + "]" );
    }

    convertToArray(lineData);
    //println(music.lanes.data);
  }
  
    //譜面の読み込み
  //input: 譜面データのファイル名

  void loadDualFile(String filename,String filename2) {

    String    lineData1[] = null;
    String    lineData2[] = null;
    
    if(filename2=="") loadFile(filename); 
    
    //テキストファイルを読む(http://mslabo.sakura.ne.jp/WordPress/make/processing%E3%80%80%E9%80%86%E5%BC%95%E3%81%8D%E3%83%AA%E3%83%95%E3%82%A1%E3%83%AC%E3%83%B3%E3%82%B9/%E3%83%95%E3%82%A1%E3%82%A4%E3%83%AB%E3%81%8B%E3%82%89%E6%96%87%E5%AD%97%E5%88%97%E3%83%87%E3%83%BC%E3%82%BF%E3%82%92%E8%AA%AD%E3%81%BF%E8%BE%BC%E3%82%80%E3%81%AB%E3%81%AF/)
    lineData1 = loadStrings( filename );
    lineData2 = loadStrings( filename2 );
    if ( lineData1 == null ) {
      //読み込み失敗
      println( filename + " 読み込み失敗" );
      System.exit(1);
    }
    if ( lineData2 == null ) {
      //読み込み失敗
      println( filename2 + " 読み込み失敗" );
      System.exit(1);
    }
    String lineData[]=new String[lineData1.length+lineData2.length];
    System.arraycopy(lineData1, 0, lineData, 0, lineData1.length);
    System.arraycopy(lineData2, 0, lineData, lineData1.length, lineData2.length);
    
    //読み込んだ各行を画面に表示
    for ( int i = 0; i < lineData.length; i++ ) {
      println( String.valueOf(i) + "：[" + lineData[i] + "]" );
    }

    convertToArray(lineData);
    //println(music.lanes.data);
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

  double getEndTime(){
    return endtime;
  }
   
  /*文字列を音ゲー用形式に変換
   input: 譜面データを表す文字列配列
   */
  private void convertToArray(String[] lines) {
    
    double BPM=120;
    double beats=4;
    double unit=4;
    double time=0;
    for (int i=0;i<2;i++) allNotes[i]=0;
    int d=1; //現在入力中の難易度(デフォルトはHARD)
    //int i=0, j=0;

    //構文解析の状態を表す変数
    //-1:ヘッダ入力中(ヘッダ名）-2:ヘッダ入力中(引数)
    //0:ノーツ入力中　1:コマンド入力中(コマンド名) 2:コマンド入力中（引数) 3:通常状態
    int status=-1; 
    for (int i=0; i<lines.length; i++) {
      String commandName="";
      String argument="";
      int notenum=0;
      if (lines[i].length()==0) continue; //空行は飛ばす
      if (status==0) status=3;
      //println();
      for (int j=0; j<lines[i].length(); j++) {
        char current=lines[i].charAt(j);
        int num=current - '0';

        if (current=='/') {
          if (j+1!=lines[i].length()) {
            if (lines[i].charAt(j+1)=='/') {
              j=lines[i].length(); //コメントに遭遇したら、行の終端まで進める(やり方が汚い)
              continue;
            }
          }
        }

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


        int size=lanes[d][notenum].size();//そのレーンの総ノーツ数
        if (status==0 || status==3) {
          status=0;
          //通常状態
          if (current=='#') {
            //if (notenum!=0) println("");
            commandName="#";
            status=1;
          } else if (num==1) {
            lanes[d][notenum].add(new Note(NoteType.NORMAL, time, notenum));
            //println(Integer.toString(i)+" "+"NORMAL");
            notenum++;
            allNotes[d]++;
          } else if (num==2) {
            if (size==0) {
              lanes[d][notenum].add(new Note(NoteType.LONG, time, notenum));
              allNotes[d]++;
              //println(Integer.toString(i)+" "+"LONG");
            } else {
              Note before=lanes[d][notenum].get(size-1); //一個前のノーツ
              if (before.getEndPos()!=Note.UNDEFINED || before.getType()==NoteType.NORMAL) {
                lanes[d][notenum].add(new Note(NoteType.LONG, time, notenum));
                allNotes[d]++;
                //println(Integer.toString(i)+" "+"LONG");
              }
            }
            notenum++;
          } else if (num==3) {

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
          println("上記のヘッダは存在しません。");
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
          println("上記の#コマンドは存在しません。");
        }
        commandName="";
        argument="";
      } else if (status==0 || status==3) {
        //println("OK: i="+String.valueOf(i)+" time="+String.valueOf(time));
        //println("OK: difficulty="+String.valueOf(d));
        double bpn=4.0/unit; //1ノーツ当たりの拍数 [beats/notes]
        double bps=BPM/60/1000; //1msec当たりの拍数　[beats/msec]
        double spn= bpn / bps; //1ノーツ当たりのmsec数[msec/notes] 
        time+=spn;
      }
    }
    endtime=time;
  }
  
  int getAllNotes(){
    return allNotes[d];
  }

  //波形をロード
  void loadWave() {
    wave=Game.minim.loadFile(filename);
  }

  //波形を再生
  void playMusic() {
    if (wave!=null) wave.play();
    else println("波形が読み込まれていません！");
  }
  
  //再生を停止
  void stopMusic() {
    if (wave!=null) wave.pause();
    else println("波形が読み込まれていません！");
  }
}
