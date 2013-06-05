package com.bradwearsglasses.utils.helpers
{
  
  import flash.display.Bitmap;
  import flash.display.DisplayObject;
  import flash.display.DisplayObjectContainer;
  import flash.display.Sprite;
  import flash.geom.Rectangle;

  public class SpriteHelper{

    public static function is_moused_over(target:DisplayObjectContainer):Boolean {
      try {
        if (!target || ! target.stage) { return false; }
        return target.hitTestPoint(target.stage.mouseX, target.stage.mouseY,true)
      } catch (e:Error) {
        trace("Couldn't evaluate is_moused_over")
      }
      return false;
    }
    
    public static function clone(scope:Sprite):Sprite {
      var clone:Sprite = new Sprite      
      var bitmap:Bitmap= GraphicsHelper.snapshot(scope, true,false)
      clone.addChild(bitmap) //This might be inaccurate for -x/y coords
      return clone
    }

    public static function add_multiple(scope:DisplayObjectContainer, children:Array):Boolean {
      var success:Boolean=true;
      if (!scope) { return false; }
      var i:Number = -1;
      var num_children:Number = children.length;
      while (++i < num_children) {
        if (!children[i]) continue; 
        try {
          scope.addChild(children[i]);
        } catch (e:Error) { 
          trace (e.message + "\n" + e.getStackTrace())
          success=false;
        }				
      }

      return success;
    }

    public static function add_these(scope:DisplayObjectContainer,...rest):Boolean {
      return add_multiple(scope,rest);
    }

    public static function remove_these(...rest):Boolean {
      var i:Number=-1,count:Number = rest.length, success:Boolean; 
      while (++i < count) { 
        try {
          success = remove_from_parent(rest[i]);
        } catch (e:Error) {
          trace("Couldn't remove:" + rest[i])
        }
      }
      return success;
    }

    public static function destroy_these(...rest):Boolean {
      var i:Number=-1,count:Number = rest.length, success:Boolean; 
      while (++i < count) { 
        try {
          success = destroy(rest[i]);
        } catch (e:Error) {
          trace("Couldn't remove:" + rest[i])
        }
      }
      return success;      
    }
    
    public static function wipe(d:Sprite):void {
      if (!d) return; 
      remove_all_children(d)
      d.graphics.clear()
    }

    public static function destroy(d:DisplayObject):Boolean { //Just like remove_from_parent except also sets display object to null. 
      var success:Boolean=true;
      if (!d || !d.parent) { return false; }
      try { 
        d.parent.removeChild(d); 
        d = null;
      } catch (e:Error) {
        success=false;
      }

      return success;        
    }

    public static function remove_from_parent(d:DisplayObject):Boolean {
      var success:Boolean=true;
      if (!d || !d.parent) { return false; }
      try { 
        d.parent.removeChild(d); 
      } catch (e:Error) {
        success=false;
      }

      return success;			
    }

    public static function remove_all_children(scope:DisplayObjectContainer, except:Array=null, destroy:Boolean=false):Boolean {
      var success:Boolean=true, d:DisplayObject;
      if (!scope) { return false; }
      if (scope.numChildren < 1) { return true; }
      while (scope.numChildren > 0) {
        try { 
          d= scope.removeChildAt(0);
          if (destroy) d = null;
        } catch (e:Error) {
          success=false;
        }
      }

      if (except) { //Restore the ones we weren't supposed to remove. 
        add_multiple(scope, except);
      }

      return success;
    }

    public static function reverse_depth(a:Array):void {
      a.reverse().map(to_top)
    }

    public static function to_top(scope:DisplayObject, ...rest):Boolean {
      var success:Boolean=true;
      try { 
        scope.parent.setChildIndex(scope, (scope.parent.numChildren-1)); 
      } catch (e:Error) {
        success=false;
      }
      return success;			
    }

    public static function to_bottom(scope:DisplayObjectContainer, ...rest):Boolean {
      var success:Boolean=true;
      try { 
        scope.parent.setChildIndex(scope, 0); 
      } catch (e:Error) {
        success=false;
      }
      return success;     
    }

    public static function ahead(subject:DisplayObject, anchor:DisplayObject):Boolean {
      var success:Boolean=true;
      if (!subject || !anchor) return false;
      try { 
        var parent:DisplayObjectContainer = anchor.parent
        parent.setChildIndex(subject, parent.getChildIndex(anchor)) 
      } catch (e:Error) {
        success=false;
      }
      return success;     
    }

    public static function behind(subject:DisplayObject, anchor:DisplayObject):Boolean {
      var success:Boolean=true;
      if (!subject || !anchor) return false;
      try { 
        var parent:DisplayObjectContainer = anchor.parent
        parent.setChildIndex(anchor, parent.getChildIndex(subject)) 
      } catch (e:Error) {
        success=false;
      }
      return success;     
    }
    
    public static function reparent(child:DisplayObject, parent:DisplayObjectContainer):Boolean {
      var success:Boolean=true;
      if (!child || !parent) return false;
      try {  
        var r:Rectangle = child.getBounds(parent);
        var dr:Rectangle = child.getBounds(child);
        var offset_x:Number = dr.left
        var offset_y:Number = dr.top
        remove_from_parent(child)
        parent.addChild(child);
        child.x = r.x - offset_x;
        child.y = r.y - offset_y;
      } catch (e:Error) {
        success=false;
        trace("Failed reparenting")
      }
      return success;  
    }
    
    public static function makeBlocker(t:Sprite,remove:Boolean=false):void {
      t.mouseEnabled=!remove;
      t.useHandCursor=(!remove) ? true : false;	
    }		    
    

  }
}
