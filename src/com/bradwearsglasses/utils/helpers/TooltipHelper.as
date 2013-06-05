package com.bradwearsglasses.utils.helpers
{
  import com.bradwearsglasses.utils.delay.Delay;
  import com.bradwearsglasses.utils.views.Tooltip;

  import flash.display.InteractiveObject;
  import flash.events.Event;
  import flash.events.MouseEvent;

  public class TooltipHelper
  {
    private static var library:Object = {};
    public static var ENABLED:Boolean = true;
    private static var __current_tip:Tooltip
    private static function set current_tip(t:Tooltip):void {
      if (__current_tip) { __current_tip.destroy(); }
      __current_tip = t;
    }

    private static function get current_tip():Tooltip {
      return __current_tip;
    }

    public static var MAX_WIDTH:Number = 300;
    public static var TIPS_ID:Number = GeneralHelper.generate_id();
    public static var TIPS_DELAY:Number = 1000;
    public static var TIP_EXPIRATION:Number = 10000;
    public static var OFFSET_X:Number = 10;
    public static var OFFSET_Y:Number = 20;

    private static var waiting_for:InteractiveObject

    public static function create(subject:InteractiveObject, text:String, manual_gc:Boolean=false):void {
      subject.addEventListener(MouseEvent.ROLL_OVER, TooltipHelper.request, false,0,true);
      library[subject.name]=new Tooltip(subject, text);
      if (!manual_gc) subject.addEventListener(Event.REMOVED_FROM_STAGE, destroy);
    }

    private static function request(event:MouseEvent):void {
      if (!ENABLED) return; //Can't show tooltips and help bubbles at the same time.
      var target:InteractiveObject = event.target as InteractiveObject;
      if (target) { 
        waiting_for=target;
        Delay.delay(TIPS_DELAY, do_display, [target], TIPS_ID,true);
        target.addEventListener(MouseEvent.ROLL_OUT, hide, false, 0, true);
        target.addEventListener(MouseEvent.MOUSE_DOWN, hide, false, 0, true);
        target.addEventListener(MouseEvent.MOUSE_UP, hide, false, 0, true);        
      }
    }

    private static function do_display(target:InteractiveObject):void {
      try {
        var t:Tooltip = look_up(target);
        if (t==current_tip) { return; } //Make sure we're not asking for the current tip.
        if (waiting_for !=target) return;
        waiting_for=null;
        if (!target.hitTestPoint(target.stage.mouseX, target.stage.mouseY,true)) { return; } //Make sure we're still moused over. 		
        if (t.display()) {
          current_tip = t;
        }
        waiting_for=null;
      } catch (e:Error) {
          //throw e;
      }
    }

    private static function hide(event:Event):void {
      try {
        waiting_for=null;
        var t:Tooltip=look_up(event.target as InteractiveObject)
        if (t) do_hide(t)
      } catch (e:Error) {
        if (e) trace("Couldn't destroy tooltip")
      }    	
    }

    private static function destroy(event:Event):void {
      var t:Tooltip=look_up(event.target as InteractiveObject)
      if (t) {
        hide(event);
        do_destroy(t)       
      }
    }

    private static function do_destroy(t:Tooltip):void {
      try {
        if (t) {     	
          if (t.container) t.container.removeEventListener(Event.REMOVED_FROM_STAGE, destroy);
          delete library[t.subject.name] 
        }
      } catch (e:Error) {
        trace("Couldn't destroy tooltip")
      }      
    }

    private static function do_hide(t:Tooltip):void {
      try {
        if (current_tip==t) current_tip = null;
        if (t.subject) t.subject.removeEventListener(MouseEvent.ROLL_OUT, hide);
        if (t.subject) t.subject.removeEventListener(MouseEvent.MOUSE_DOWN, hide);
        if (t.subject) t.subject.removeEventListener(MouseEvent.MOUSE_UP, hide);
        t.destroy();
      } catch (e:Error) {
        trace("Couldn't hide tooltip:" + e.message + "\n" + e.getStackTrace())
      }   
    }          

    public static function destroy_tip_for(d:InteractiveObject):void {
      var t:Tooltip=look_up(d)
      if (t) do_hide(t)
      if (t) do_destroy(t)  
    }

    private static function look_up(d:InteractiveObject):Tooltip {
      return library[d.name] as Tooltip
    }
  }
}