package com.bradwearsglasses.utils.debug
{
  import com.bradwearsglasses.utils.helpers.DateHelper;

  public class DebugTimer {
    public var start:Date;
    private var label:String;
    public function DebugTimer(l:String=null){
      start = new Date;
      if (l) label = l
    }

    public function mark(m:String=null):Number {
      var end:Date = new Date;
      var diff:Number = DateHelper.diff(start, end)
      trace("\tTIMER:" + label + " " + m + " " + diff)
      return diff;
    }; 
    
  }
}
