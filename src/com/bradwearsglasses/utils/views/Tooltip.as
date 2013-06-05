package com.bradwearsglasses.utils.views
{
  import com.bradwearsglasses.utils.delay.Delay;
  import com.bradwearsglasses.utils.helpers.GraphicsHelper;
  import com.bradwearsglasses.utils.helpers.LayoutHelper;
  import com.bradwearsglasses.utils.helpers.SpriteHelper;
  import com.bradwearsglasses.utils.helpers.TextfieldHelper;
  import com.bradwearsglasses.utils.helpers.TooltipHelper;
  import com.bradwearsglasses.utils.vo.Alignment;
  import com.bradwearsglasses.utils.vo.Placement;
  import com.bradwearsglasses.utils.vo.Position;
  
  import flash.display.InteractiveObject;
  import flash.display.Sprite;
  import flash.geom.Point;
  import flash.geom.Rectangle;
  import flash.text.TextField;

  public class Tooltip
  {
    public var subject:InteractiveObject;
    public var tip:String;
    public var container:Sprite;
    private var field:TextField;
    public function Tooltip(s:InteractiveObject, t:String){
      subject = s;
      tip = t;
    }

    public function display():Boolean {
      try {
        container = new Sprite;
        container.mouseEnabled=false;
        field = TextfieldHelper.textfield(TooltipHelper.MAX_WIDTH, "<span class='default'>" + tip + "</span>")
        if (field.numLines==1) field.wordWrap=false;
        container.addChild(field);
        var b:Rectangle = field.getBounds(container)
        b.inflate(6,6)
        b.offset(0,-2)
        GraphicsHelper.box(container,b, 0xFFFFC7,.95,true, 1, 0xC3C3C3);
        position();
        Delay.delay(TooltipHelper.TIP_EXPIRATION,destroy)
        return true;
      } catch (e:Error) {
        trace("Couldn't draw tooltip");
        return false;
      }

      return false;
    }

    private function position():void {
      //Where are we on stage? (We prefer to show the bubble popping up to the right, unless we're too close to the right side or top.)
      var stage_width:Number = (subject.stage) ? subject.stage.stageWidth : 500; 
      var stage_height:Number = (subject.stage) ? subject.stage.stageHeight : 500; 
      var xQuad:Number = (subject.stage.mouseX > (stage_width-(TooltipHelper.MAX_WIDTH*1.3))) ? 1 : 0;     
      var yQuad:Number = (subject.stage.mouseY < (stage_height-((subject.height + field.height)*1.3))) ? 0 : 1;        
      var quadrant:Point = new Point(xQuad, yQuad);   

      container.alpha=0
      subject.stage.addChild(container);

      var bounds:Rectangle = subject.getBounds(container);

      var placement:Placement = (quadrant.y==1) ?  Placement.ABOVE : Placement.BELOW;
      var alignment:Alignment = (quadrant.x==0) ?  Alignment.RIGHT : Alignment.LEFT;
      var horizontal_padding:Number = (quadrant.x==0) ?  container.width: 0-container.width;
      var vertical_padding:Number = (quadrant.y==1) ?  -1: 3;
      LayoutHelper.nextTo(Position.from(placement, alignment), subject.stage, subject, container, new Point(horizontal_padding,vertical_padding));
    }		

    public function destroy():void {
      SpriteHelper.remove_from_parent(container);
    }
  }
}
