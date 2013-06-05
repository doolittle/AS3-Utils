package com.bradwearsglasses.utils.helpers
{
  public class StringHelper{

    public static const ALPHABET:Array = ["a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z"]
    
    public static function to_query_string(p:Object):String {
      var u:Array = [];
      for (var param:String in p) { u.push(param +"=" + p[param]); }
      return u.join("&");
    }		
        
    public static function pluralize(quantity:Number, singular:String, plural:String, skip_number:Boolean=false):String {
      var s:String = (skip_number) ? "" : quantity + " ";
      s+=(quantity!=1) ? plural : singular;
      return s;
    }

    public static function is_are(quantity:Number):String {
      return (quantity !=1) ? "are" : "is"
    }

    public static function insert(s:String, i:String, p:Number):String {
      var h:String = s.substring(0, p);
      var t:String = s.substr(p,s.length-1);
      return h + i + t;
    }   
    
    public static var NUMERIC_PATTERN:RegExp =  /[^\d]/gi
    public static function numeric(s:String):Number {
      return Number(s.replace(NUMERIC_PATTERN, ''));     
    }

    public static var NEWLINE_PATTERN:RegExp =  /\n+|\r+|\f+/g;
    public static function trim(s:String, remove_newlines:Boolean=true):String {
      if (!s || s.length < 1) { return ""; }
      if (remove_newlines) {
        s = strip_newlines(s) 
      } else {
        s = s.replace(NEWLINE_PATTERN, '\n');
      }
      while ( s.indexOf("  " ) != -1 ) {  s= s.split("  ").join(" "); }
      if (s.substr(0,1) == " ") s = s.substr( 1 );  
      if (s.substr( s.length-1, 1 ) == " ") s = s.substr( 0, s.length - 1 ); 
      return s;
    }

    public static function remove_underscores(s:String):String {
      try {
        return s.replace(/_/g, " ");
      } catch (e:Error) {
        trace ("Couldn't remove underscores")
      }
      return "";
    }

    public static function rtl(s:String):String { //1424–1535 hebrew characters are in this range
      if (!s || s.length==1) return s;
      var a:Array = s.split("")
      var n:Number = a.length
      var r:String = "", sub:Array = [],subbed:Number=0,l:String,i:Number = -1, code:Number
      while (++i < n) {
        l = a[i]
        code = l.charCodeAt(0)
        if ((code >=  1424 && code <= 1791) || (subbed >0 && (l==" " || l=="'" || l=="\"" || l=="-" || l=="–"))) {
          sub.push(l)
          subbed++
        } else {
          if (subbed > 0) {
            sub.reverse()
            if (sub[0]==" ") { sub.shift(); sub.push(" "); }
            r+=sub.join("")
            sub = []
            subbed = 0
          } 
          r+=l
        }
      }
      if (subbed > 0) r+=sub.reverse().join("")
      return r
    }

    public static function unembeddable_ranges(s:String):Array {
      var ranges:Array = [],current:Array = []
      var a:Array = s.split("")
      var n:Number = a.length
      var subbed:Number=0,l:String,i:Number = -1, code:Number
      while (++i < n) {
        l = a[i]
        code = l.charCodeAt(0)
        if (((code >=  1424 && code <= 1791) || (code >=1024 && code <=1423)) || (subbed >0 && (l==" " || l=="-" || l=="–"))) {
          if (current.length==0) current.push(i)
          subbed++
        } else {
          if (subbed > 0) {
            current.push(i+1)
            ranges.push(current)
            current = []
            subbed = 0
          } 
        }
      }     

      if (subbed > 0) { //Catch unclosed range. 
        current.push(i)
        ranges.push(current)
      }

      return ranges;
    }

    public static var STRIP_NEWLINES_PATTERN:RegExp =  /\n|\r|\f|\t/g;
    public static function strip_newlines(s:String):String {
      return s.replace(STRIP_NEWLINES_PATTERN, '');
    }

    public static function capitalize(s:String):String {
      var a:String = s.substring(0, 1);
      var b:String = s.substring(1, s.length);
      return a.toUpperCase() + b;
    }

    public static function truncate(s:String, string_length:Number, include_ellipses:Boolean=true):String {
      if (!s) { return ""; }
      if (s.length > string_length) {
        s=s.substr(0, string_length);
        if (include_ellipses) { s+="..."; }
      }
      return s;
    } 

    public static function cutout(s:String, start:Number, end:Number):String {
      var h:String = s.substring(0, start);
      var t:String = s.substr(end,s.length-1);
      return h + t;
    }

  	private static const RFC3986_ENCODE:RegExp = /[^a-zA-Z0-9_.~-]/g;
  
    public static function encode_url_utf8(str:String):String { //don't encode http:// etc.
      if (!str || str=="") return ""
      var pieces:Array = str.split("/");
      var path:Array = (pieces.pop() as String).split(".")
      var extension:String = path.pop() as String
      var file:String = path.join(".")
      return pieces.join("/") + "/" + encode_UTF8(file) + "." + extension
    }

    public static function encode_utf8(str:String):String {
      if (!str) { return ""; }
      return encode_UTF8(str).replace(RFC3986_ENCODE, do_encode );
    }
    
    private static function do_encode():String {
      return "%"+(String(arguments[0])).charCodeAt().toString(16).toUpperCase();
    }
    
    private static function encode_UTF8 (s:String):String {
      var a:Number=-1, n:uint, A:uint= s.length;
      var utf:String = "";
      while (++a < A) {  
        n = s.charCodeAt (a);
        if (n < 128) {
          utf += String.fromCharCode (n);
        } else if ((n > 127) && (n < 2048)) {
          utf += String.fromCharCode ((n >> 6) | 192);
          utf += String.fromCharCode ((n & 63) | 128);
        } else {
          utf += String.fromCharCode ((n >> 12) | 224);
          utf += String.fromCharCode (((n >> 6) & 63) | 128);
          utf += String.fromCharCode ((n & 63) | 128);
        }
      }
      return utf;
    } 

  }
}
