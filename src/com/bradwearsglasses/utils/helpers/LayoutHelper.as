package com.bradwearsglasses.utils.helpers{

  
  import com.bradwearsglasses.utils.vo.Alignment;
  import com.bradwearsglasses.utils.vo.Corner;
  import com.bradwearsglasses.utils.vo.Placement;
  import com.bradwearsglasses.utils.vo.Position;
  
  import flash.display.DisplayObject;
  import flash.display.DisplayObjectContainer;
  import flash.display.MovieClip;
  import flash.display.Sprite;
  import flash.display.Stage;
  import flash.geom.Point;
  import flash.geom.Rectangle;

  public class LayoutHelper {

    private static var FLOOR:Function	= Math.floor

    public static function nextTo (position:Position, scope:DisplayObjectContainer, anchor:DisplayObject, target:DisplayObject, tweak:Point=null, attach:Boolean=false):void {

      if (!scope || !anchor || !target) { 
        trace ("Bad call to Place: " + scope + "|" + anchor + "|" + target);
        return; 
      }
     
      var placement:Placement= position.placement;
      var alignment:Alignment = position.alignment;
      
      var anchor_bounds:Rectangle, target_bounds:Rectangle;
      var target_x:Number, target_y:Number;
      var anchor_center:Number, target_center:Number;
      var point:Point;
      var offset:Number;

      if (is_placeable(anchor) && anchor.width >0 && anchor.height > 0) {
        anchor_bounds = anchor.getBounds(scope);
      } else {
        point=new Point(anchor.x, anchor.y); 
        anchor_bounds = new Rectangle(point.x, point.y, anchor.width, anchor.height);
      }	

      if (attach) SpriteHelper.add_these(scope, target); 

      if (is_placeable(target) && target.width >0 && target.height > 0) {
        target_bounds = target.getBounds(scope);
      } else {
        point=new Point(target.x, target.y); 
        target_bounds = new Rectangle(point.x, point.y, target.width, target.height);
      }	

      var isVertical:Boolean=(placement==Placement.ABOVE || placement==Placement.BELOW);

      switch (placement) {
        case Placement.ABOVE:	
          target_y=anchor_bounds.top - (target_bounds.bottom-target.y); 
          break;
        case Placement.BELOW:	
          target_y=anchor_bounds.bottom + (target.y-target_bounds.top);	
          break;
        case Placement.LEFT: 
          target_x=anchor_bounds.left - (target_bounds.width-(target.x-target_bounds.left));	
          break;
        case Placement.RIGHT:	
          target_x=anchor_bounds.right + (target.x-target_bounds.left); 
          break;	
        case Placement.SAME:
        default: //Only mistakes don't have a proper label. In FP 10.0.12.36, returns a bad value for x/y -- like a million pixels offscreen.  
          target_x=target.x; 
          break;	
      }

      switch (alignment) {		
        case Alignment.TOP:	
          target_y=anchor_bounds.top - (target_bounds.top-target.y);	
          break;
        case Alignment.BOTTOM: 
          target_y=anchor_bounds.bottom-(target_bounds.bottom-target.y);	
          break;
        case Alignment.LEFT: 
          target_x=anchor_bounds.left-(target_bounds.left-target.x);	
          break;
        case Alignment.RIGHT:	
          target_x=anchor_bounds.right-(target_bounds.right-target.x); 
          break;
        case Alignment.CENTER: 
          if (isVertical) {		          		
            anchor_center=anchor_bounds.left + (anchor_bounds.width/2);
            target_center=target_bounds.left + (target_bounds.width/2);				
            offset = anchor_center-target_center; //How far apart are our centers?
            target_x=target.x + offset;	//target.x !=t.x. the rectangle's x is always the leftmost point. In otherwords, the same as t.left.  
          } else {				
            anchor_center=anchor_bounds.top + (anchor_bounds.height/2);
            target_center=target_bounds.top + (target_bounds.height/2);
            offset = anchor_center-target_center;
            target_y=target.y + offset; 									
          }

          break;	
        case Alignment.SAME:  
        default:  
          if (isVertical) {	target_x=anchor.x; } else { target_y=anchor.y; }		
      }

      if (tweak) {		
        target_x+=tweak.x; 
        target_y+=tweak.y; 
      }

      target.x=FLOOR(target_x);
      target.y=FLOOR(target_y);

    }

    public static function inside(corner:Corner, scope:DisplayObjectContainer, anchor:DisplayObject, target:DisplayObject, tweak:Point=null, attach:Boolean=false):void {

      if (!scope || !anchor || !target) { 
        trace ("Bad call to Place -- (" + target + ") or ("  + anchor  + ") doesn't exist in >" + scope); 
        return; 
      }

      var vertical:String = corner.vertical;
      var horizontal:String = corner.horizontal;
      
      var anchor_bounds:Rectangle, target_bounds:Rectangle;
      var target_x:Number, target_y:Number;
      var point:Object;
      var anchor_center:Number, target_center:Number;
   
      if (is_placeable(anchor)  && anchor.width >0 && anchor.height > 0) {
        anchor_bounds = anchor.getBounds(scope);
      } else {
        point={x:anchor.x, y:anchor.y}; 
        anchor_bounds = new Rectangle(point.x, point.y, anchor.width, anchor.height);  
      } 

      if (attach) SpriteHelper.add_these(scope, target); //Attaching the clip before getting bounds can distort the size of scope when the target is offset.

      if (is_placeable(target) && target.width >0 && target.height > 0) {
        target_bounds = target.getBounds(scope); //May want to make this target.getBounds(target) but not sure how that would work w/differently scaled objects. 
      } else {
        point={x:target.x, y:target.y};
        target_bounds = new Rectangle(point.x,point.y, target.width, target.height);
      }   

      var offset:Number;
      switch (vertical) {
        /*
        case Placement.SAME: 
          target_y = anchor_bounds.y; 
          break;*/
        case "top":	
          target_y=anchor_bounds.top - target_bounds.top;	
          break;
        case "bottom": 
          target_y=anchor_bounds.bottom-target_bounds.height;	
          break;
        case "center":	
          anchor_center=anchor_bounds.top + (anchor_bounds.height/2);
          target_center=target_bounds.top + (target_bounds.height/2);
          offset = anchor_center-target_center;
          target_y=target.y + offset; 	
          break;	
      }

      switch (horizontal) {
        /*
        case Alignment.SAME: 
          target_x = anchor_bounds.x; 
          break;*/			
        case "left": 
          target_x=anchor_bounds.left;	
          break;
        case "right":	
          target_x=anchor_bounds.right-target_bounds.width; 
          break;
        case "center": 				
          anchor_center=anchor_bounds.left + (anchor_bounds.width/2);
          target_center=target_bounds.left + (target_bounds.width/2);
          offset = anchor_center-target_center;
          target_x=target.x + offset; 
          break;
      }

      if (tweak) {		
        if (tweak.x) target_x+=tweak.x; 
        if (tweak.y) target_y+=tweak.y; 
      }

      target.x=FLOOR(target_x);
      target.y=FLOOR(target_y);	

    }

    public static function center_on_stage(target:DisplayObject, stage:Stage, tweak:Object=null):void {
      if (!target || !stage) return;
      if (!tweak) tweak = new Point 
      target.x = target.y = 0
      var b:Rectangle = target.getBounds(target);
      var aCenter:Number, tCenter:Number, offset:Number
      var target_x:Number, target_y:Number
      
      aCenter=b.left + (b.width/2);
      tCenter=(stage.stageWidth/2);
      offset = tCenter- aCenter;
      target_x=target.x + offset;     
      
      aCenter=b.top + (b.height/2);
      tCenter=(stage.stageHeight/2);
      offset = tCenter- aCenter;
      target_y=target.y + offset;         
      
      target.x = FLOOR(target_x) + tweak.x
      target.y = FLOOR(target_y) + tweak.y
      
    }

    public static function in_center(scope:DisplayObjectContainer, anchor:DisplayObject, target:DisplayObject, tweak:Point=null, attach:Boolean=false):void {
      inside(Corner.CenterCenter, scope, anchor, target, tweak, attach);
    }
    
    public static function at(scope:DisplayObject, x:Number, y:Number):DisplayObject {
      if (!scope) return null; 
      scope.x=FLOOR(x); 
      scope.y=FLOOR(y); 
      return scope; 
    }

    public static function stack(scope:DisplayObjectContainer, sprites:Array, padding:Point=null, start:Point=null, attach:Boolean=false, align:Alignment=null):void { //TODO: Would be helpful to return container sprite
      LayoutHelper.in_columns(scope, sprites, padding, 0, 0, attach, start, null, align);
    }

    public static function in_columns(scope:DisplayObjectContainer, sprites:Array, padding:Point=null, column_width:Number=0, column_height:Number=0, attach:Boolean=false, initial_point:Point=null, initial_padding:Point=null, align:Alignment=null):void {
      sprites = sprites.filter(ArrayHelper.has_values); //Make sure we're not passing null values. 
      if (!scope || !sprites || sprites.length < 1) return; 
      if (!padding) padding = new Point(0,0); 
      if (!initial_padding) initial_padding = new Point(0,0); 
      if (!align) align = Alignment.LEFT;
      
      var i:Number = -1, num_to_attach:Number = sprites.length,
        this_sprite:DisplayObject, last_sprite:DisplayObject, 
        column_start:Number, start_new:Boolean=false, num_columns:Number=0;
      while (++i < num_to_attach) {
        this_sprite = sprites[i] as DisplayObject;
        if (!this_sprite) { trace("this_sprite does not exist"); continue; }
        if (column_height !=0 && last_sprite) { //Do we need to start a new column?
          start_new = ((last_sprite.getBounds(scope).bottom + this_sprite.height) > scope.getBounds(scope).top + column_height) 
        }			
        if (i==0 || start_new) {	
          if (i==0) { 
            if (initial_point) { //Place in upper left of container unless we have an initial_point
              this_sprite.x = initial_point.x;
              this_sprite.y = initial_point.y;
              if (attach) scope.addChild(this_sprite);
            } else {
              inside(Corner.TopLeft, scope, scope, this_sprite,initial_padding,attach);
            }
          } else {
            num_columns++;
            column_start=(column_width !=0) ? (column_width+padding.x)*num_columns : scope.getBounds(scope).right + padding.x
            if (initial_point) { //Place in upper left of container unless we have an initial_point
              this_sprite.x = initial_point.x + column_start;
              this_sprite.y = initial_point.y;
              if (attach) scope.addChild(this_sprite);
            } else {						
              inside(Corner.TopLeft, scope, scope, this_sprite, new Point(initial_padding.x + column_start, initial_padding.y),attach);
            } 
          }
        } else {
          nextTo(Position.from(Placement.BELOW, align), scope,last_sprite, this_sprite, padding,attach)
        }
        last_sprite = this_sprite;
      }			
    }

    public static function row(scope:DisplayObjectContainer, sprites:Array, padding:Point=null, start:Point=null, attach:Boolean=false, align:Alignment=null):void {
      in_rows(scope, sprites, padding, 0, 0, attach, start, null, align);
    }

    public static function in_rows(scope:DisplayObjectContainer, sprites:Array, padding:Point=null, row_width:Number=0, row_height:Number=0, attach:Boolean=false, start:Point=null, initial_padding:Point=null, align:Alignment=null):void {
      sprites = sprites.filter(ArrayHelper.has_values); //Make sure we're not passing null values. 
            
      if (!scope || !sprites || sprites.length < 1) {
        trace("No scope >" + scope + "< or sprites >" + sprites + "<")
        return; 
      }
      if (!align) align = Alignment.TOP;
      if (!padding) padding = new Point(0,0); 

      var i:Number = -1, num_to_attach:Number = sprites.length,
        this_sprite:DisplayObject, last_sprite:DisplayObject, 
        row_start:Number, start_new:Boolean=false, num_rows:Number=0;
      
      while (++i < num_to_attach) {
        this_sprite = sprites[i] as DisplayObject;
        if (!this_sprite) {
          continue; 
        }
        if (last_sprite && row_width > 0) { //Do we need to start a new column?
          start_new = ((last_sprite.getBounds(scope).right + this_sprite.width) > scope.getBounds(scope).left +  + row_width) 
        }			
        if (i==0 || start_new) {	
          if (i==0) { 
            if (start) { //Place in upper left of container unless we have an initial_point
              this_sprite.x = start.x;
              this_sprite.y = start.y;
              if (attach) scope.addChild(this_sprite);
            } else {
              inside(Corner.TopLeft, scope, scope, this_sprite,null,attach);
            }
          } else {
            num_rows++;
            row_start=(row_height !=0) ? (row_height+padding.y)*num_rows : scope.getBounds(scope).bottom + padding.y
            if (start) { //Place in upper left of container unless we have an initial_point
              this_sprite.x = start.x;
              this_sprite.y = start.y+ row_start;
              if (attach) scope.addChild(this_sprite);
            } else {						
              inside(Corner.TopLeft, scope, scope, this_sprite, new Point(0,row_start),attach);
            } 
          }
        } else {
          nextTo(Position.from(Placement.RIGHT, align), scope,last_sprite, this_sprite,padding,attach)
        }
        last_sprite = this_sprite;
      }			       
    }

    private static function is_placeable(d:*):Boolean {
      return (d is Sprite || d is DisplayObject || d is MovieClip);
    }
  }
}
