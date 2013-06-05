package com.bradwearsglasses.utils.helpers
{

  import flash.system.Capabilities;
  import flash.text.TextFormat;

  public class GeneralHelper {

    public static var DEFAULT_FORMAT:TextFormat = new TextFormat("Arial", 12, 0x000000);
    
    private static function isset(_var:*):Boolean {	
      return (_var=='' || _var == "undefined" || _var ==undefined || String(_var) =="NaN") ? false : true;	
    }	

    //Functions for pulling strings out of XML
    public static function set_string(s:String):String {	
      return (!isset(s)) ? "" : s;	
    }
    
    public static function set_boolean(s:String):Boolean {	
      return (s=="true" || s==true) ? true : false;	
    }
    
    public static function set_binary_boolean(s:*):Boolean {	
      return (s=="1" || s==1) ? true : false;	
    }
    
    public static function to_binary_boolean(s:*):Number {	
      return (s || s==1) ? 1 : 0;	
    }
    
    public static function set_number(number:*):Number { 
      return (number!==0 && (number=="" || number==null || number=="null")) ? NaN : int(number); 
    }
    
    public static function set_multiple_flag(s:String, values:Array, default_value:*):* {
      var i:Number=-1;
      while (++i < values.length) {
        if (s==values[i]) return values[i];
      }
      return default_value;
    }

    public static function is_on_a_mac():Boolean {
      return (Capabilities.os.indexOf("Mac") !=-1);
    }		

    public static function generate_id():Number {
      var date:Date = new Date(); 
      return Math.floor(date.getTime() + (Math.random() * 99999));
    }
    
  }
}
