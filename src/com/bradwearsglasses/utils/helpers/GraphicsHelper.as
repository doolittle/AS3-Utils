package com.bradwearsglasses.utils.helpers { 

  import com.bradwearsglasses.utils.vo.CircleBounds;
  import com.bradwearsglasses.utils.vo.ShineOptions;
  
  import flash.display.Bitmap;
  import flash.display.BitmapData;
  import flash.display.CapsStyle;
  import flash.display.DisplayObject;
  import flash.display.GradientType;
  import flash.display.JointStyle;
  import flash.display.LineScaleMode;
  import flash.display.PixelSnapping;
  import flash.display.Sprite;
  import flash.filters.BitmapFilter;
  import flash.filters.BitmapFilterQuality;
  import flash.filters.BlurFilter;
  import flash.filters.ColorMatrixFilter;
  import flash.filters.DropShadowFilter;
  import flash.geom.ColorTransform;
  import flash.geom.Matrix;
  import flash.geom.Point;
  import flash.geom.Rectangle;

  public class GraphicsHelper {

    private static var round:Function			=Math.round
    private static var tan:Function				=Math.tan
    private static var sin:Function				=Math.sin
    private static var PI:Number					=Math.PI
    private static var floor:Function			=Math.floor
    public static var MAX_BITMAP_SIZE:Number = 2880;

    public static function box(scope:Sprite, bounds:Rectangle, color:*=null, alpha:Number=1, 
                               outline:Boolean=false, outlineWeight:Number=0, outlineColor:Number=0xFFFFFF, outlineAlpha:Number=1, 
                               padding:Number=0,roundCorners:Boolean=false, roundSize:Number=5, radial:Boolean =false):Sprite {
      var b:Rectangle = bounds.clone(); //Clone bounds so we don't change it. 
      if (padding) b.inflate(padding, padding);
      clean_bounds(b)
      with (scope.graphics) {
        if (outline==true) {	lineStyle(outlineWeight, outlineColor, outlineAlpha,true,LineScaleMode.NORMAL,CapsStyle.SQUARE,JointStyle.MITER);	}
        start_fill(scope, color, alpha, b,radial);
        if (roundCorners) {
          drawRoundRect(b.x,b.y,b.width,b.height,roundSize,roundSize);	
        } else {
          drawRect(b.x, b.y, b.width, b.height);
        } 
        endFill();	
      }
      return scope
    }

    public static function clean_bounds(bounds:Rectangle):Boolean {
      bounds.width = round(bounds.width);
      bounds.height = round(bounds.height);     
      bounds.x = round(bounds.x);
      bounds.y = round(bounds.y);
      return true;   
    }

    public static function validate_bounds(bounds:Rectangle):Boolean {
      return  !(bounds.width > MAX_BITMAP_SIZE || bounds.height > MAX_BITMAP_SIZE || (bounds.width==0 && bounds.height==0) || !bounds.height || !bounds.width)  
    }

    public static function round_box(scope:Sprite, bounds:Rectangle, color:*=null, roundSize:Number=5, 
                                     alpha:Number=1, outline:Boolean=false, outlineWeight:Number=0, outlineColor:Number=0xFFFFFF, 
                                     outlineAlpha:Number=1, padding:Number=0):Sprite {
      return box(scope, bounds, color,alpha, outline, outlineWeight,outlineColor,outlineAlpha,padding,true,roundSize);
    }

    public static function start_fill(scope:Sprite, color:*, alpha:Number, bounds:Rectangle, radial:Boolean=false):Sprite {
      var isGradient:Boolean=false;
      var colors:Array,fillType:String, alphas:Array,ratios:Array, matrix:Matrix;		

      if (typeof color !="number") { 
        //We have a gradient for the color
        if (!color) { color = {}; }
        if (!color.a_alpha) { color.a_alpha=1; }
        if (!color.b_alpha) { color.b_alpha=1; }
        if (!color.size) { color.size=1; }

        isGradient=true;
        colors = [color.a, color.b];
        fillType = (radial) ? GradientType.RADIAL : GradientType.LINEAR
        if (radial) color.size*=1.5
        alphas = [color.a_alpha, color.b_alpha];
        ratios = [0, 255];
        var gWidth:Number=(bounds.width)*color.size
        var gHeight:Number=(bounds.height)*color.size
        var r:Number=(color.dir=="v") ? (0/180)*Math.PI: 1.57;
        var start_x:Number=(color.starts==1) ? bounds.left-gWidth : bounds.left;
        var start_y:Number=(color.starts==1) ? bounds.bottom-gHeight : bounds.top;
        if (radial) {
          start_x-=(gWidth/5)
          start_y-=(gHeight/5)
        }
        matrix = new Matrix();
        matrix.createGradientBox(gWidth, gHeight, r, start_x, start_y);	
      }	

      if (isGradient) { 
        scope.graphics.beginGradientFill(fillType, colors, alphas, ratios, matrix);	
      } else {
        scope.graphics.beginFill(color,alpha);
      }
      return scope; 
    }

    public static function strut(scope:Sprite, b:Rectangle, debug:Boolean=false):Sprite { //Draw an invisible box to define an area for the placement code.
      return box(scope, b, 0xFF0000, (debug) ? .2 : 0, false, 1, 0xFF0000);
    }
    
    public static function spacer(w:Number=10, h:Number=10):Sprite {
      return strut(new Sprite, rect(w,h))
    }

    public static function rect(width:Number, height:Number, start_x:Number=0, start_y:Number=0):Rectangle {
      return new Rectangle(start_x, start_y, width, height);
    }

    public static function light_box(scope:Sprite, bounds:Rectangle, padding:Number=0, options:Object=null):Sprite {
      var options:Object =(options) ? options : {}
      options.drop_shadow=false;
      options.shadow_top_color=0xF0F0F0
      return dialog_box(scope, bounds, padding, null, options);
    }

    public static function dialog_box(scope:Sprite, bounds:Rectangle, padding:Number=0, shadow:Object=null, options:Object=null):Sprite {

      var b:Rectangle = bounds.clone();
      if (!options) { options = {drop_shadow:true }; }
      if (!options.drop_shadow_size) { options.drop_shadow_size = 5; }
      if (!shadow) { shadow = {}; }
      if (!options.dragger_color) { options.dragger_color = 0xffffff; }
      if (!options.shadow_top_color) { options.shadow_top_color =0xd8d8d8 ; }
      if (!options.shadow_bottom_color) { options.shadow_bottom_color = 0xffffff; }
      if (!options.highlight_colors) { 
        options["highlight_colors"]={};
        options["highlight_colors"]["highlight"]=0xffffff; 
        options["highlight_colors"]["shadow"]=0xebebeb; 
      }
      if (!options.border_colors) { 
        options.border_colors={};
        options.border_colors.highlight=0xcccccc; 
        options.border_colors.shadow=0x999999; 
      }

      if (padding) {	b.inflate(padding, padding);		}

      box(scope, b, options.dragger_color);

      var top_color:Number;
      var bottom_color:Number;

      //Draw gradient along bottom
      if (shadow) {
        if (shadow.display !=false && b.height > 15) {

          var g:Rectangle=(shadow.location=="top") ? new Rectangle(b.left, b.top, b.width, 15) : new Rectangle(b.left, b.bottom, b.width, -15);
          if (shadow.location=="top") { 
            bottom_color=options.shadow_bottom_color; 
            top_color=options.shadow_top_color; 
          } else {
            top_color=options.shadow_bottom_color; 
            bottom_color=options.shadow_top_color;  
          }

          if (shadow.top_color) { top_color=shadow.top_color; }
          if (shadow.bottom_color) { bottom_color=shadow.bottom_color; }

          var shadow_size:Number=(shadow.size) ? shadow.size : 1
          var shadow_direction:String=(shadow.direction) ? shadow.direction : "h";
          box(scope, g, {b:top_color, a:bottom_color, size:shadow_size, dir:shadow_direction, starts:1}, 1, false, 0, 0, 0, 0);	
        }
      }
      
      inset(scope, b, options.highlight_colors.highlight, options.highlight_colors.shadow);
      border(scope, b, options.border_colors.highlight, options.border_colors.shadow);
      
      if (options.drop_shadow) {
        dropshadow_remove(scope);
        dropshadow(scope,options.drop_shadow_size,options.drop_shadow_size);
      }
      
      return scope; 
      
    }


    public static function shine(scope:Sprite, bounds:Rectangle, options:ShineOptions=null):void {
      //Draw a white shine across the top of the box. mask it against the top edge of the object
      var descent:Number = floor(bounds.height/2);
      var scoop:Number = floor(bounds.height/4);
      var half_width:Number = floor(bounds.width/2);

      if (!options) { options = new ShineOptions; }

      with (scope.graphics) {
        start_fill(scope, {a:options.color_top, b:options.color_base, a_alpha:options.color_top_alpha, b_alpha:options.color_base_alpha}, 1, bounds);
        moveTo(bounds.left, bounds.top); 
        lineStyle(null, 0, 0, true);
        lineTo(bounds.right, bounds.top); 
        lineTo(bounds.right, bounds.bottom-descent); 
        switch (options.type){
          case "straight":
            lineTo(bounds.left, bounds.bottom-descent);
            break;
          case "ascend":
            curveTo(bounds.right - (half_width), (bounds.bottom-descent) - scoop ,bounds.left, bounds.bottom-descent);
            break;	
          case "descend":	
          default:
            curveTo(bounds.right - (half_width), (bounds.bottom-descent) + scoop ,bounds.left, bounds.bottom-descent);
            break;
        }

        lineTo(bounds.left, bounds.top);
        endFill();		
      }
    }

    public static function hashes(scope:Sprite, bounds:Rectangle, highlight:Number=0x808080, shadow:Number=0xd7d7d7, options:Object=null):void { 

      if (!options) { options={}; }
      var hashes:Sprite=scope;
      var i:Number=-1
      while (++i < 4) {
        if (options.orientation=="h") {
          line(hashes, "v", (i*4), bounds.top+3, bounds.bottom-3, highlight, 1, 1 );
          line(hashes, "v", ((i*4)+1), bounds.top+3, bounds.bottom-3, shadow, 1, 1 );
        } else {
          line(hashes, "h", (bounds.top + (i*4)), bounds.left+1, bounds.right-3, highlight, 100, 1 );
          line(hashes, "h", (bounds.top + ((i*4)+1)), bounds.left+1, bounds.right-3, shadow, 1, 1 );			
        }
      }
    }

    public static function grabber(scope:Sprite, bounds:Rectangle):Sprite {
      box(scope, rect(bounds.width-2, bounds.height - 4, 2, 2), {a: 0xF2F2F2, b: 0xCCCCCC, direction: "h"});
      border(scope, rect(bounds.width, bounds.height));
      var i:Number=-1, b:Rectangle, num_grabbies:Number=Math.floor((bounds.height - 8) / 2);
      var grabber:Sprite=scope.addChild(new Sprite) as Sprite
      
      while (++i < num_grabbies) {
        b=rect(bounds.width-4, 1, 2, (i * 2) + 6);
        box(grabber, b, 0x000000, 100);
      }

      color_transform(grabber, 0xBFBFBF);
      return scope
    }

    public static function line(scope:Sprite, orientation:String, start:Number, min:Number, width:Number, color:Number=0x000000, alpha:Number=100, thickness:Number=1):void {
      var s:Rectangle=(orientation=="v") ? new Rectangle(start, min, thickness, width) : new Rectangle(min, start, width, thickness);
      box(scope, s, color, alpha);		
    }

    public static function actual_line(scope:Sprite, orientation:String, start:Number, min:Number, max:Number, color:Number=0x000000, alpha:Number=1, thickness:Number=1):void {
      with (scope.graphics) {
        lineStyle(thickness,color,alpha,true,LineScaleMode.NONE,CapsStyle.SQUARE,JointStyle.MITER);
        moveTo(min,start);
        lineTo(max,start);
      }
    }

    public static function diagonal_line(scope:Sprite, bounds:Rectangle, hypotenuse:Number, color:Number=0x000000, alpha:Number=100, thickness:Number=1):void {
      with (scope) { 
        beginFill(color, alpha);
        moveTo(bounds.xMin, bounds.yMin); //a
        lineTo(bounds.xMax, bounds.yMax); //ab
        lineTo(bounds.xMax, bounds.yMax+thickness); //bc
        lineTo(bounds.xMin, bounds.yMin+thickness); // cd
        lineTo(bounds.xMin, bounds.yMin); //da
      }
    }

    public static function border(scope:Sprite, bounds:Rectangle, highlight:Number=0xCCCCCC, shadow:Number=0x999999, thickness:Number=1, skip_bottom:Boolean=false):Sprite {
      box(scope, new Rectangle(bounds.left, bounds.top, thickness, bounds.height), highlight); //Draw left (highlight)
      box(scope, new Rectangle(bounds.left, bounds.top, bounds.width, thickness), highlight);	 //Draw top (highlight)	
      box(scope, new Rectangle(bounds.right-thickness, bounds.top, thickness, bounds.height), shadow);	//Draw right (shadow)
      if (!skip_bottom) box(scope, new Rectangle(bounds.left, bounds.bottom - thickness, bounds.width, thickness), shadow); //Draw bottom (shadow)	
      return scope
    }

    public static function inset(scope:Sprite, bounds:Rectangle, highlight:Number=0xffffff, shadow:Number=0xebebeb, inset:Number=1, thickness:Number=1, skip_bottom:Boolean=false):Sprite {
      var c:Rectangle = bounds.clone();
      c.inflate(0-inset, 0-inset)
      return border(scope, c, highlight, shadow, thickness,skip_bottom);
    }

    public static function recession(scope:Sprite, bounds:Rectangle, highlight:Number=0x666666, shadow:Number=0xC4C4C4, inset:Number=0, thickness:Number=1, skip_bottom:Boolean=false):Sprite {
      var c:Rectangle = bounds.clone();
      c.inflate(0-inset, 0-inset)
      return border(scope, c, highlight, shadow, thickness,skip_bottom);
    }	

    public static function recessed_box(scope:Sprite, bounds:Rectangle):Sprite {
      strut(scope,bounds ,true)
      bounds.inflate(1,1)
      return recession(scope, bounds)
    }

    public static function progress_bar(scope:Sprite, bounds:Rectangle, percent:Number=0, color:Number=0xe2e4d0):void {
      border(scope, bounds, color, color,1)
      var fill:Rectangle = bounds.clone()
      fill.width = bounds.width*percent
      box(scope, fill, color)
    }

    public static function highlight(scope:Sprite, bounds:Rectangle, direction:String="top", orientation:String="h", o:Object=null):Sprite {

      var start:Number, min:Number, max:Number;

      if (orientation=="h") {
        start=(direction=="top") ? bounds.top : bounds.bottom
        min=bounds.left
        max=bounds.right
      } else {
        start= (direction=="top") ? bounds.left : bounds.right;
        min=bounds.top;
        max=bounds.bottom;
      }
      if (!o) { o={}; }
      if (!o.highlight_color) { o.highlight_color=(direction=="top") ? 0xf2f2f2 : 0xffffff; }
      if (!o.highlight_thickness) { o.highlight_thickness=1; }

      if (!o.edge_color) { o.edge_color=(direction=="top") ? 0xc4c4c4 : 0xc4c4c4; }
      if (!o.edge_thickness) { o.edge_thickness=1; }

      var highlight_start:Number = (direction == "top") ? (start - (o.highlight_thickness)) : (start + o.highlight_thickness);

      line(scope, orientation, start+2 , min, max,  0xEDEDED, 100, o.highlight_thickness);
      line(scope, orientation, start+1 , min, max,  0xFFFFFF, 100, o.highlight_thickness);
      line(scope, orientation, start, min, max,  0xc4c4c4, 100, o.edge_thickness);

      return scope
    }		

    public static function edge(scope:Sprite, bounds:Rectangle, direction:String="top", orientation:String="h", options:Object=null):void {

      //An edge makes an object look like it is on top of another one. It is a highlight, a dark line, 
      // a lighter line, and a gradient shadow extending the rest of the height of the object.
      //Draw gradient - first so it is below the others
      if (direction=="top") {
        box(scope, bounds, {a:0xc0c0c0, b:0xFFFFFF, a_alpha:.5, b_alpha:0, dir:orientation, size:1})
      } else {
        box(scope, bounds, {b:0xc0c0c0, a:0xFFFFFF, a_alpha:0, b_alpha:.5, dir:orientation, size:1})
      }

      highlight(scope, bounds, direction, orientation, options);

    }

    public static function edge_dropshadow(scope:Sprite, bounds:Rectangle, strength:Number = 10, distance:Number=10, intensity:Number=0.2, color:uint=0x000000, angle:Number=45):void {
      dropshadow_remove(scope);
      box(scope, bounds, 0x000000,1);
      dropshadow(scope,distance, strength, intensity,color,angle);
    }

    //@TODO: Setup triangle bounds VO
    public static function triangle(scope:Sprite, bounds:Object, color:*=0xFFFFFF, alpha:Number=1, outline:Boolean=false, outlineWeight:Number=0, outlineColor:Number=0x000000, outlineAlpha:Number=1, isCallout:Boolean=false):Sprite {
      var fill_bounds:Rectangle = GraphicsHelper.rect(Math.abs(bounds.vA_x - bounds.vB_x),Math.abs(bounds.pY-bounds.vA_y));
      with (scope.graphics) {

        if (outline==true) {	lineStyle(outlineWeight, outlineColor, outlineAlpha,true,LineScaleMode.NORMAL,CapsStyle.SQUARE,JointStyle.MITER);	}    
        start_fill(scope, color, alpha, fill_bounds);
        moveTo(bounds.vA_x, bounds.vA_y);
        lineTo(bounds.pX, bounds.pY);	
        lineTo(bounds.vB_x, bounds.vB_y);
        if (isCallout) { lineStyle(outlineWeight, outlineColor, 0,true,LineScaleMode.NORMAL,CapsStyle.SQUARE,JointStyle.MITER);  } 
        lineTo(bounds.vA_x, bounds.vA_y);
        lineStyle(outlineWeight, outlineColor, outlineAlpha,true,LineScaleMode.NORMAL,CapsStyle.SQUARE,JointStyle.MITER);
        endFill();	
      }	
      return scope
    }

    public static function easy_triangle(scope:Sprite, leg_length:Number, direction:String, color:*=0x808080, outline:Boolean=false, outlineWeight:Number=0, outlineColor:Number=0x000000, isCallout:Boolean=false):Sprite {

      var t:Sprite=scope.addChild(new Sprite) as Sprite;	
      var half_leg:Number=leg_length/2;
      var tBounds:Object;

      switch(direction) {
        case "right": tBounds={pX:half_leg, pY:half_leg , vA_x:0, vA_y:0, vB_x:0, vB_y:leg_length}; break;
        case "left": tBounds={pX:half_leg, pY:half_leg , vA_x:leg_length, vA_y:0, vB_x:leg_length, vB_y:leg_length}; break;
        case "down": tBounds={pX:half_leg, pY:leg_length , vA_x:0, vA_y:0, vB_x:leg_length, vB_y:0}; break;
        default: tBounds={pX:half_leg, pY:0 , vA_x:0, vA_y:leg_length, vB_x:leg_length, vB_y:leg_length}; break;
      }

      triangle(t,tBounds, color, 1, outline, outlineWeight, outlineColor, 1, isCallout);
      return scope
    }

    public static function circle(scope:Sprite, bounds:CircleBounds, color:*=0x000000, alpha:Number=1, outline:Boolean=false, outlineWeight:Number=0, outlineColor:Number=0x000000, outlineAlpha:Number=1):Sprite {

      for (var n:String in bounds) { bounds[n]=round(bounds[n]); }
      var color_bounds:Object=rect(bounds.r,bounds.r)
      with (scope.graphics) {
        if (outline==true) {	lineStyle(outlineWeight, outlineColor, outlineAlpha,false,LineScaleMode.NONE,CapsStyle.ROUND,JointStyle.ROUND);	}
        start_fill(scope, color, alpha, color_bounds);
        drawCircle(bounds.x, bounds.y, bounds.r);
        endFill();	
      }
      
      return scope
    }

    public static function pattern_fill(scope:Sprite, bounds:Rectangle, options:Object):void {

      switch (options.fill_type) {
        case "lines":
          FillHelper.lines(scope, bounds, options);
          break;
        case "diagonal":
          FillHelper.diagonal(scope, bounds, options);
          break;			
        case "boxes":
          FillHelper.boxes(scope, bounds, options);
          break;
        case "dots":
          FillHelper.dots(scope, bounds, options);	
          break;
        default:			
          break;
      }
    }

    public static function crosshairs(scope:Sprite, draw_at:Point, size:Number = 100, thickness:Number=2, color:Number = 0xFF0000, alpha:Number = 1):Sprite {
      box(scope, rect(size*2,thickness,draw_at.x-size,draw_at.y-(thickness/2)),color, alpha);
      box(scope, rect(thickness,size*2,draw_at.x-(thickness/2),draw_at.y-size),color,alpha); 
      return scope       
    }

    public static function adjust(scope:DisplayObject, to_grayscale:Boolean=false, to_sepia:Boolean=false):void {
      if (!scope) return;
      remove_color_filter(scope) 
      scope.transform.colorTransform = new ColorTransform;   
      if (to_grayscale) grayscale(scope)
      if (to_sepia) sepia(scope)
    }

    public static function grayscale(scope:DisplayObject):void {
      var rLum:Number = 0.2225;
      var gLum:Number = 0.7169;
      var bLum:Number = 0.0606;  

      var bwMatrix:Array = [rLum, gLum, bLum, 0, 0,
        rLum, gLum, bLum, 0, 0,
        rLum, gLum, bLum, 0, 0,
        0, 0, 0, 1, 0];  
      var f:ColorMatrixFilter = new ColorMatrixFilter(bwMatrix);
      add_filter(scope, f);	                     
    }

    public static function sepia(scope:DisplayObject):void {

      var sepia:Array = [0.3930000066757202, 0.7689999938011169, 
        0.1889999955892563, 0, 0, 0.3490000069141388, 
        0.6859999895095825, 0.1679999977350235, 0, 0, 
        0.2720000147819519, 0.5339999794960022, 
        0.1309999972581863, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1];;  
      var f:ColorMatrixFilter = new ColorMatrixFilter(sepia);
      add_filter(scope, f);	                     
    }

    public static function remove_color_filter(scope:DisplayObject):void {
      remove_filter(scope, ColorMatrixFilter);
    }   

    public static function darken(scope:DisplayObject):void  {
      var f:ColorMatrixFilter = new ColorMatrixFilter([1,0,0,0,-20,0,1,0,0,-20,0,0,1,0,-20,0,0,0,1,0]);
      add_filter(scope, f);	
    }		

    public static function lighten(scope:DisplayObject):void  {
      var f:ColorMatrixFilter = new ColorMatrixFilter([1,0,0,0,50,0,1,0,0,50,0,0,1,0,50,0,0,0,1,0]);
      add_filter(scope, f);	
    }		

    public static function desaturate(scope:DisplayObject):void  {
      var f:ColorMatrixFilter = new ColorMatrixFilter([0.6543,0.3047,0.041,0,50,0.1543,0.8047,0.041,0,50,0.1543,0.3047,0.541,0,50,0,0,0,1,0]);
      add_filter(scope, f);	
    }		

    public static function blur(scope:DisplayObject, strength:Number = 10):void  {
      var blur:BlurFilter = new BlurFilter(strength, strength);  
      blur.quality = BitmapFilterQuality.MEDIUM;
      add_filter(scope, blur)
    }

    public static function blur_remove(scope:DisplayObject):void  {
      remove_filter(scope, BlurFilter);
    }

    public static function dropshadow(scope:DisplayObject, distance:Number = 10, strength:Number = 10, intensity:Number = 0.2, color:Number=0x000000, angle:Number = 45, quality:Number=0, only_dropshadow:Boolean =true):void {
      if (only_dropshadow) dropshadow_remove(scope)
      var shadow:DropShadowFilter = new DropShadowFilter(distance, angle, color, intensity, strength, strength);  
      shadow.quality = (quality=-1) ? BitmapFilterQuality.LOW : BitmapFilterQuality.MEDIUM; 
      add_filter(scope, shadow);						
    }

    public static function color_transform(scope:DisplayObject, transform_to:Number):void {
      var color:ColorTransform = new ColorTransform;
      color.color = transform_to;
      scope.transform.colorTransform = color;
    }		

    public static function dropshadow_remove(scope:DisplayObject):void {
      remove_filter(scope, DropShadowFilter);
    }

    private static function add_filter(scope:DisplayObject, f:BitmapFilter):void {
      var temp_filters:Array = scope.filters; 
      if (!temp_filters) { temp_filters = []; }
      temp_filters.push(f); 
      scope.filters = temp_filters;			
    }		

    public static function remove_filters(scope:DisplayObject):void {
      scope.filters=[];
    }

    private static function remove_filter(scope:DisplayObject, filter_class:*):void {
      var filters:Array = scope.filters;
      var i:Number = -1, rebuilt:Array=[], f:BitmapFilter;
      while (++i < filters.length) {
        f = filters[i];
        if (!(f is filter_class)) { rebuilt.push(f); }
      }	
      scope.filters=rebuilt;	

    }

    public static function snapshot(d:DisplayObject, correct_placement:Boolean=false, smoothing:Boolean=true, bounds:Rectangle=null, rescale:Number = 1):Bitmap {

      var bitmap_width:Number = (bounds) ? bounds.width : (d.width > MAX_BITMAP_SIZE) ? MAX_BITMAP_SIZE : round(d.width)
      var bitmap_height:Number = (bounds) ? bounds.height : (d.height > MAX_BITMAP_SIZE) ? MAX_BITMAP_SIZE : round(d.height)

      var b:BitmapData = new BitmapData(bitmap_width*=rescale, bitmap_height*=rescale, true, 0xFFFFFF);
      var m:Matrix = new Matrix;
      m.scale(rescale, rescale)
      var offset_x:Number = 0
      var offset_y:Number = 0

      if (correct_placement) {
        var bounds:Rectangle = d.getBounds(d)
        offset_x = (0-round(bounds.left))*rescale
        offset_y = (0-round(bounds.top))*rescale
        m.translate(offset_x,offset_y)
      }

      b.draw(d,m);
      var bitmap:Bitmap = new Bitmap(b,PixelSnapping.AUTO,smoothing);
      bitmap.x-=offset_x
      bitmap.y-=offset_y
      return bitmap;
    }

  }
}
