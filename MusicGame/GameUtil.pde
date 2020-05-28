static class GameUtil{
  //カウントアップするやつ(線形補完:等速運動)
  static double countUpByTime(double time,double max,double period,int step){
    if(time<=0) return 0;
    return Math.min((max*((time-time%step)/period)),max);
  }
  //カウントアップするやつ(非線形補完:等加速度運動)
  static double countUpByTime2(double time,double max,double period){
    if(time>=period) return max;
    else if(time<=0) return 0;
    else return -max/period/period*time*time+2*max/period*time;
  }  
  //ふわふわ点滅するやつ(例:PRESS ANY KEY)
  static double colorByTime(double time, double period){
    return Math.max(Math.pow(-Math.cos(time/period*2*Math.PI),0.8),0);
  }
  //各行を画面に表示
  static void showText(String[] lineData){
    for ( int i = 0; i < lineData.length; i++ ) {
      println( String.valueOf(i) + "：[" + lineData[i] + "]" );
    }
  }
  
  
  
  //2つのテキストを文字通りくっつける錬金術
  //2つのテキストを順にそのまま繋げる
  
  static String[] bindTwoFiles(String[] lineData1, String[] lineData2) {
    //両方nullならnull
    if(lineData1==null && lineData2==null) return null;
    //いずれかがnullならば他方を返す
    if(lineData1==null) return lineData2;
    if(lineData2==null) return lineData1;
    //コピーを駆使して合体させる
    String lineData[]=new String[lineData1.length+lineData2.length];
    System.arraycopy(lineData1, 0, lineData, 0, lineData1.length);
    System.arraycopy(lineData2, 0, lineData, lineData1.length, lineData2.length);
    return lineData;
  }
}
