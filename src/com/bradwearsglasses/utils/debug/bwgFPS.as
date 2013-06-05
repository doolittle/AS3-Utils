package com.bradwearsglasses.utils.debug
{
  import flash.display.Shape;
  import flash.display.Sprite;
  import flash.events.Event;
  import flash.geom.ColorTransform;
  import flash.text.TextField;
  import flash.text.TextFormat;
  import flash.utils.getTimer;

  public class bwgFPS extends Sprite {
    //Shamelessly stolen from the papervision FPS
    public var time :Number;
    public var frameTime :Number;
    public var prevFrameTime :Number = getTimer();
    public var secondTime :Number;
    public var prevSecondTime :Number = getTimer();
    public var frames :Number = 0;
    public var fps :Number = 0;
    
    public var tf:TextField;
    public var anim:String = "";
    public var bar:Shape;
    
    private var averages:Array = []
    private var rolling_sum:Number = 0
    private var average_size:Number = 30
    private var target_fps:Number = -1;
    
    private var bg_color:Number;
    private var efficiency:Number;
    private var warning:Boolean = false; 
    private var color:ColorTransform = new ColorTransform;
   
    public function bwgFPS(_bg_color:Number=0x595959, text_color:Number=0xffffff, _target_fps:Number=-1):void {

      target_fps = _target_fps;
      bg_color = _bg_color; 
      
      bar = new Shape();
      addChild(bar);
      bar.x = 19;
      bar.y = 4;
      color.color = bg_color; 
      bar.transform.colorTransform = color;
      
      var i:Number = -1
      while (++i < average_size) { 
        averages.push(0); 
      }
      
      drawBar();
      
      tf = new TextField();
      addChild(tf);
      tf.x = 20;
      tf.y = 5;
      tf.width = 300;
      tf.height = 500;
      tf.defaultTextFormat = new TextFormat("Arial", 9, text_color);
      tf.alpha = 0.6;
      addEventListener(Event.ENTER_FRAME, enterFrameHandler);
    }

    private function drawBar(overrideColor:Number=-1):void {
      bar.graphics.clear(); 
      bar.graphics.beginFill((overrideColor !=-1) ? overrideColor : bg_color, 0.5);
      bar.graphics.lineStyle();
      bar.graphics.drawRect(0, 0, 1, 15);
      bar.graphics.endFill();    
    }
    
    private function enterFrameHandler( event:Event ):void {
      time = getTimer();
      frameTime = time - prevFrameTime;
      secondTime = time - prevSecondTime;
      
      rolling_sum-=averages.shift()
      rolling_sum+=frameTime
      averages.push(frameTime)
      
      if(secondTime >= 1000) {
        fps = frames;
        frames = 0;
        prevSecondTime = time;
      } else {
        frames++;
      }
      
      bar.scaleX =rolling_sum/average_size;
      
      if (target_fps > -1) {
        efficiency = fps/target_fps;
        if (efficiency < .5) {
          warning = true; 
          color.color = 0xFF0000; 
          bar.transform.colorTransform = color;
        } else if (efficiency < .66) {
          warning = true; 
          color.color = 0xFF9999;
          bar.transform.colorTransform = color;
        } else if (efficiency > .9) {
          color.color = 0xc31d100;
          bar.transform.colorTransform = color;
        } else if (warning) {
          warning = false; 
          color.color = bg_color;
          bar.transform.colorTransform = color;
        }
        
      }
      
      prevFrameTime = time;
      tf.text = ((fps + " FPS / ") + frameTime) + " MS" + anim;
    }
  }
}