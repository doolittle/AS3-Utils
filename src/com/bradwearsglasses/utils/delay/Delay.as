package com.bradwearsglasses.utils.delay {
  import flash.events.TimerEvent;
  import flash.utils.Timer;
  import com.bradwearsglasses.utils.helpers.GeneralHelper;

  public class Delay {
    private static var timers:Object={};

    public static function delay(delay_in_ms:Number, callback:Function, params:Array=null, timer_id:Number=undefined, restart_timer:Boolean=false):Delayer {

      var create_timer:Boolean=true;
      if (!timer_id) timer_id=GeneralHelper.generate_id(); 
      if (timer_id && timers[timer_id]) { //Are we supposed to check if this timer has already started?
        var delayer:Delayer =timers[timer_id] as Delayer
        if (restart_timer || delayer.fired) delayer.restart(delay_in_ms, callback, params)
      } else {
				timers[timer_id]= new Delayer(timer_id, delay_in_ms, callback, params);  
      }
      return timers[timer_id]; 
    }
    
    public static function destroy(timer_id:Number):void {
      if (timers[timer_id]) timers[timer_id]=null
    }
  }
}