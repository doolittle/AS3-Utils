package com.bradwearsglasses.utils.helpers
{
  import com.bradwearsglasses.utils.css.bwgCSS;
  
  import flash.events.TextEvent;
  import flash.text.AntiAliasType;
  import flash.text.GridFitType;
  import flash.text.TextField;
  import flash.text.TextFieldAutoSize;

  public class TextfieldHelper {

    public static function textfield(tWidth:Number=50, html_text:String=null, wordwrap:Boolean=true, css_class:String=null, tHeight:Number=15):TextField {
      var t:TextField=new TextField(); 
      t.styleSheet=bwgCSS.globalStyles;
      t.width= tWidth;
      t.height=tHeight;
      t.multiline=true;
      t.wordWrap=wordwrap;
      t.autoSize=TextFieldAutoSize.LEFT;
      t.embedFonts=false;
      t.selectable=false;		
      t.border=false;
      t.antiAliasType = AntiAliasType.ADVANCED;
      t.gridFitType = GridFitType.PIXEL;
      if (html_text) t.htmlText=(css_class) ? "<p class='" + css_class + "'>" + html_text + "</p>" : html_text;
      return t;
    }
    
    public static function wrap(s:String, css_class:String='default', tag:String='p', attributes:String=null):String {
      if (!tag) return s;
      var wrapped:String = "<" + tag
      if (css_class) wrapped += " class='" + css_class + "'"
      if (attributes) wrapped += " " + attributes
      wrapped+=">" + s + "</" + tag + ">"
      return wrapped 
    }
    
    
    public static function link(width:Number, text:String, action:String, on_click:Function=null, css:String='blue', wordwrap:Boolean=true, underline:Boolean=true):TextField { 
      var t:TextField = textfield(width, link_string(text, action, css, underline),wordwrap)
      if (on_click!=null) t.addEventListener(TextEvent.LINK, on_click)
      return t;
    }
    
    public static function link_string(text:String, action:String, css:String='blue', underline:Boolean=true):String {
      var s:String  = "" 
      s+="<a href=\"event:" + action + "\""
      if (css) s+=" class=\"" + css + "\" "
      s+=">"
      if (underline) s+="<u>"
      s+=text
      if (underline) s+="</u>";
      s+="</a>"  
      return s;      
    }

    public static function embeddable_field(tWidth:Number=50, tHeight:Number=15, htmlText:String=null):TextField {
      var t:TextField = textfield(tWidth,null,true, null,tHeight);
      t.styleSheet=null;
      t.defaultTextFormat = GeneralHelper.DEFAULT_FORMAT
      if (htmlText) t.htmlText = htmlText;
      return t;
    }
  }
}
