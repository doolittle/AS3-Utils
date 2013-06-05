package com.bradwearsglasses.utils.delay
{
  import flash.events.TimerEvent;
  import flash.utils.Timer;

  public class Delayer {

    public var callback:Function
    public var params:Array;
    public var timer_id:Number;
    public var delay_in_ms:Number
    public var fired:Boolean=false;
    private var timer:Timer

    public function Delayer(t:Number, _delay_in_ms:Number, c:Function, p:Array)   {
      timer_id = t;
      delay_in_ms = _delay_in_ms;
      callback = c;
      params = p;

      timer = new Timer(delay_in_ms, 1);
      timer.addEventListener(TimerEvent.TIMER_COMPLETE, fire);
      timer.start();    
    }

    public function restart(d:Number, c:Function, p:Array):void {
      delay_in_ms = d;
      callback = c;
      params = p;
      fired = false;   
      timer.reset();
      timer.start();
    }
    
    public function stop():void {
      timer.stop(); 
      kill();
    }
    
    private function kill():void {
      timer.removeEventListener(TimerEvent.TIMER_COMPLETE,fire)
      Delay.destroy(timer_id)     
    }

    private function fire(event:TimerEvent):void {
      try {
        callback.apply(null, params);
        fired=true; 
        kill(); 
      } catch (e:Error) {
        trace("Couldn't fire delayer: " + e.name + "(" + e.errorID + ")\n\n" + e.getStackTrace())
      }
    }

  }
}
