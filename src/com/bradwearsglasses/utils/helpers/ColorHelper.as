package com.bradwearsglasses.utils.helpers
{
  import flash.display.BitmapData;

  public class ColorHelper{

    public static function convert_to_hex_string(c:*):String {

      if (typeof c =="string") {
        return validate_hex_string(c);
      } else if (typeof c=="number") {
        return int_to_hex_string(c);
      } else {
        return new String(c);
      }
    }

    public static function validate_hex_string(c:String):String {
      c=c.toUpperCase();
      if (c.indexOf("#")!=0) { c="#" + c; }
      if (c.length > 7) { c=c.substr(0, 7); }
      return c;
    }

    public static function string_to_uint(c:String):uint {
      if (c.indexOf("#")==0) { c=c.substr(1, c.length); }
      return new uint("0x" + c);
    }

    public static function int_to_hex_string(color:int = 0):String {
      var mask:String = "000000";
      var str:String = mask + color.toString(16).toUpperCase();
      return "#" + str.substr(str.length - 6);
    }

    public static function uint_to_hex_string(n:uint):String {
      var t:String = n.toString(16);
      while (t.length !=6) { t = "0"+t; }
      return "#" + t.toUpperCase();
    }  

    public static function average_color( source:BitmapData ):uint {
      var red:Number = 0;
      var green:Number = 0;
      var blue:Number = 0;

      var count:Number = 0;
      var pixel:Number;

      var x:Number = -1, y:Number = -1
      while (++x < source.width){
        y = -1;
        while (++y < source.height) {
          pixel = source.getPixel(x, y);

          red += pixel >> 16 & 0xFF;
          green += pixel >> 8 & 0xFF;
          blue += pixel & 0xFF;
          count++
        }
      }

      red /= count;
      green /= count;
      blue /= count;

      return red << 16 | green << 8 | blue;
    }

  }
}
