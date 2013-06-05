package com.bradwearsglasses.utils.vo
{
  public class Alignment
  {
    
    public static const TOP:Alignment = new Alignment('top');
    public static const CENTER:Alignment = new Alignment('center');
    public static const BOTTOM:Alignment = new Alignment('bottom');
    public static const LEFT:Alignment = new Alignment('left');
    public static const RIGHT:Alignment = new Alignment('right');
    public static const SAME:Alignment = new Alignment('same');
    
    private static var _enumCreated:Boolean = false;
    {  _enumCreated = true; }
    

    public var alignment:String;
    
   
    public function Alignment(_alignment:String) {
      if (_enumCreated) {
        throw new Error("The enum is already created:" + _alignment);
      }
      alignment = _alignment;
    }

  }
}