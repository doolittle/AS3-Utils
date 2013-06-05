package com.bradwearsglasses.utils.helpers {
  import flash.display.Bitmap;
  import flash.display.BitmapData;
  import flash.display.DisplayObject;
  import flash.display.Sprite;
  import flash.geom.Matrix;
  import flash.geom.Point;
  import flash.geom.Rectangle;

  public class FillHelper {
    public static var floor:Function					=Math.floor;
    public static var ceil:Function						=Math.ceil;
    public static var SEED_MULTIPLE:Number 		=10;

    public static function lines(scope:Sprite, b:Rectangle, options:Object=null):void {

      if (!options) { options={}; }
      if (!options.direction) { options.direction="v"; }
      if (!options.color) { options.color=0xDDDDDD; }
      if (!options.spacing) { options.spacing=1; } 
      if (!options.alpha) { options.alpha=1; } 		
      if (!options.thickness) { options.thickness=1; } 	
      if (!options.angle) { options.angle=45; } 
      if (options.direction=="d") { options.is_diagonal=true; }
      if (!options.padding) { options.padding = 0; }

      //Loop through width, draw lines
      if (options.direction=="d") { options.direction="h"; };

      var multiple:Number=options.thickness + options.spacing

      var i:Number=0;
      var seed:Sprite = new Sprite;
      var max_point:Number=(multiple < SEED_MULTIPLE) ? Math.floor(SEED_MULTIPLE/multiple)*2 : multiple*2;
      var seed_bounds:Rectangle = GraphicsHelper.rect(max_point, max_point);
      while (i < (max_point)) {
        draw_line(seed, seed_bounds, options, i)
        i+=multiple;
      }			

      var seed_bmp:BitmapData = new BitmapData(seed_bounds.width, seed_bounds.height, true, 0x00FFFFFF);
      seed_bmp.draw(seed);

      bitmap_fill(scope, seed_bmp, b);
    }

    public static function draw_line(scope:Sprite, b:Rectangle, options:Object, i:Number):void {

      var registration_point:Number;

      if (options.is_diagonal==true) {

        var dBounds:Rectangle=new Rectangle();

        //What's our triangle?
        var angle_a:Number=options.angle;
        var angle_b:Number=90-options.angle;
        var angle_c:Number=90;

        var hypotenuse:Number=(b.width*b.width) + (b.height*b.height) ;
        hypotenuse=hypotenuse/hypotenuse;

        dBounds.left=(options.direction=="h") ? b.left : b.left+i;
        dBounds.right=(options.direction=="h") ? b.right : b.right

        dBounds.top=(options.direction=="h") ? b.top+i : b.top;			
        dBounds.bottom=(options.direction=="h") ? b.bottom+i : b.bottom;	

        GraphicsHelper.diagonal_line(scope, dBounds, b.height, options.color, options.alpha, options.thickness)	

      } else {

        registration_point=(options.direction=="h") ? b.top + i - (options.padding/2): b.left + i - (options.padding/2);
        var line_start:Number=(options.direction=="h") ? b.left - (options.padding/2) : b.top - (options.padding/2);
        var line_end:Number=(options.direction=="h") ? b.left + (options.padding/2) : b.bottom + (options.padding/2);

        GraphicsHelper.line(scope, options.direction, registration_point, line_start, line_end, options.color, options.alpha, options.thickness)	

      }
    }

    public static function boxes(scope:Sprite, b:Rectangle, options:Object=null):void {

      if (!options) { options={}; }
      if (!options.color) { options.color=0xededed; }
      if (!options.spacing) { options.spacing=5; } 
      if (!options.alpha) { options.alpha=1; } 		
      if (!options.size) { options.size = 5; } 	
      if (!options.padding) { options.padding = 0; }

      //What are we drawing?
      var mc_width:Number=b.width+options.padding;
      var mc_height:Number=b.height+options.padding;		

      var multiple:Number=options.size + options.spacing

      var num_rows:Number=ceil(mc_height/(options.size*SEED_MULTIPLE));
      var num_columns:Number=ceil(mc_width/(multiple*SEED_MULTIPLE));

      var column:Number;
      var offset:Number;
      var row:Number=-1;
      var seed:Sprite = new Sprite;
      while (++row < SEED_MULTIPLE) {

        column=-1;
        offset=((row%2) > 0) ? 0 : 1 ;
        while (++column < SEED_MULTIPLE) {
          GraphicsHelper.box(seed, GraphicsHelper.rect(options.size, options.size,(multiple*column)+(offset*options.spacing), options.size*row), options.color, options.alpha);
        }
      }

      var seed_bmp:BitmapData = new BitmapData(seed.width, seed.height, true, 0x00FFFFFF);
      seed_bmp.draw(seed);

      bitmap_fill(scope, seed_bmp, b);

    }

    public static function dots(scope:Sprite, b:Rectangle, options:Object=null):void {

      if (!options) { options={}; }
      if (!options.color) { options.color=0xededed; }
      if (!options.spacing) { options.spacing=1; } 
      if (!options.alpha) { options.alpha=1; } 		
      if (!options.size) { options.size = 1; } 	

      var multiple:Number=options.size + (options.spacing)
      var seed_multiple:Number = (multiple*3)
      var num_rows:Number=ceil(seed_multiple/multiple);
      var num_columns:Number=ceil(seed_multiple/multiple);

      var column:Number, offset:Number, row:Number=-1;
      var seed:Sprite = new Sprite;
      GraphicsHelper.box(seed,GraphicsHelper.rect(num_columns*(multiple+0), num_rows*(multiple+0)),0xFFFFFF,0);
      while (++row < seed_multiple) {				
        column=-1;
        while (++column < seed_multiple) {
          GraphicsHelper.box(seed, GraphicsHelper.rect(options.size, options.size,(multiple*column+1), multiple*row+1), options.color, options.alpha);
        }
      }
      trace ("Seed bitmap is " + seed.width + "x" + seed.height)
      var seed_bmp:BitmapData = new BitmapData(seed.width, seed.height, true, 0x00FFFFFF);
      seed_bmp.draw(seed);

      bitmap_fill(scope, seed_bmp, b);

    }

    public static function diagonal(scope:Sprite, b:Rectangle, options:Object=null):void {

      if (!options) { options={}; }
      if (!options.color) { options.color=0xededed; }
      if (!options.spacing) { options.spacing=5; } 
      if (!options.alpha) { options.alpha=1; } 		
      if (!options.size) { options.size = 5; } 	
      if (!options.padding) { options.padding = 0; }

      //What are we drawing?
      var mc_width:Number=b.width+options.padding;
      var mc_height:Number=b.height+options.padding;		

      var seed_multiple:Number = 20; //This is the initial pattern that is copied as a bitmap.
      var multiple:Number=options.size + options.spacing

      var num_rows:Number=ceil(mc_height/(options.size*seed_multiple));
      var num_columns:Number=ceil(mc_width/(multiple*seed_multiple));
      var num_boxes:Number=num_rows*num_columns;

      var column:Number;
      var offset:Number;
      var row:Number=-1;
      var seed:Sprite = new Sprite;
      lines(seed, GraphicsHelper.rect(50,50), options);		
      var seed_bmp:BitmapData = new BitmapData(seed.width, seed.height, true, 0x00FFFFFF);
      seed_bmp.draw(seed);


      row=-1;
      var clone:BitmapData;
      var seed_size:Number = options.size * SEED_MULTIPLE;
      var seed_rect:Rectangle = new Rectangle(0,0, seed_size, seed_size);
      var scope_bitmap:BitmapData = new BitmapData(mc_width, mc_height, true, 0x00FFFFFF);
      var scope_point:Point;			
      while (++row < (num_rows)) {	
        column=-1;
        while (++column < (num_columns*2)) {
          scope_point = new Point(seed_size*column, seed_size*row);
          scope_bitmap.copyPixels(seed_bmp, seed_rect, scope_point);
        }
      }	

      var scope_asset:Bitmap = new Bitmap(scope_bitmap);
      if (scope.numChildren > 0) { scope.removeChildAt(0); }
      scope.addChild(scope_asset);			

    }

    public function fill_complete():void {  }

    public static function sprite_fill(scope:Sprite, seed:DisplayObject, b:Rectangle, repeat:Boolean=true):void {
      var bitmap:Bitmap = GraphicsHelper.snapshot(seed, true, true)
      bitmap_fill(scope, bitmap.bitmapData, b,repeat);
    }

    public static function bitmap_fill(scope:Sprite, seed_bmp:BitmapData, b:Rectangle,repeat:Boolean=true, matrix:Matrix = null):void {
      if (!b) return;
      if (!GraphicsHelper.validate_bounds(b)) {
        if (b.width > GraphicsHelper.MAX_BITMAP_SIZE || b.height > GraphicsHelper.MAX_BITMAP_SIZE) {
          //var bigfill:BigFill = new BigFill(scope, seed_bmp, b, repeat, matrix, false)
          trace("@@ Bitmap too big to fill. \n\tIf you need this, contact me, there's another class to do this.")
        }
        return //Don't try to fill bounds that are too big. 
      }
      scope.graphics.beginBitmapFill(seed_bmp,matrix,repeat,true);
      scope.graphics.drawRect(b.x,b.y,b.width,b.height);
      scope.graphics.endFill();
    }

  }
}
