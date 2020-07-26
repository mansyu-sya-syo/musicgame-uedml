import java.util.LinkedList;
import java.util.Iterator;

abstract class Effect{
  abstract void draw(); //描画
  protected int lifeTime; //残りの命[msec]
}

static class EffectManager{
  private static LinkedList<Effect> list= new LinkedList<Effect>();
  private static int prevTime=0;
  private static Iterator<Effect> iter=list.iterator();
  
  static void add(Effect e){
    list.add(e);
  }
  
  static void draw(int millis){
    int diff=millis-prevTime;
    prevTime=millis;
    //寿命の尽きたエフェクトを削除
    while(iter.hasNext()){
      Effect e=(Effect)iter.next();
      if((e.lifeTime-=diff)>0) e.draw();
      else iter.remove();
    }
  }
    
}

class StringMsg extends Effect{
  
  String msg;
  int x,y;
  int maxLifeTime=400;
  
  StringMsg(String msg,int x,int y){
    this.msg=msg; this.x=x; this.y=y;
    lifeTime=maxLifeTime;
  }
  
  void draw(){
    textAlign(CENTER);
    fill(0,lifeTime);
    text(msg,x,y-(maxLifeTime-lifeTime)/3);
  }
  
}
