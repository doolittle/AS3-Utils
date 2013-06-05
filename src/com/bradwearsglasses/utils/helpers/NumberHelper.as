package com.bradwearsglasses.utils.helpers
{
  public class NumberHelper {

    private static var FLOOR:Function = Math.floor; 
    private static var RANDOM:Function = Math.random;
    public static function random(min:Number, max:Number):Number {   
      return FLOOR(RANDOM() * (max - min + 1)) + min;	
    }
    
    public static function sample(size:Number):Boolean { 
      return (random(0,size)==0)
    }    
    
    public static function confine_number(n:Number, min:Number, max:Number):Number {
      if (n < min) return min;
      if (n > max) return max;
      return n;
    }
       
    public static function is_number(n:*):Boolean {
      return (Number(n)==n)
    }
    
    public static function is_whole_number(n:*):Boolean {
      return (Number(n)==Math.round(Number(n)))
    }
    
     public static function format(n:Number):String {
       var a:Array = String(n).split(".")
       var head:String = a[0];
       var pieces:Array = []
       while (head.length > 3) {
         pieces.push(head.substring(head.length-3,head.length));
         head = head.slice(0,head.length-3)
       }
       pieces.push(head);
       pieces.reverse();
       var f:String = pieces.join(",")
       if (a[1]) f+="." + a[1]
       return f;
     }

  }
}