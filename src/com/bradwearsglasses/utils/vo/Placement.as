package com.bradwearsglasses.utils.vo
{
  public class Placement
  {
    
    public static const ABOVE:Placement = new Placement('above');
    public static const BELOW:Placement = new Placement('below');
    public static const LEFT:Placement = new Placement('left');
    public static const RIGHT:Placement = new Placement('right');
    public static const SAME:Placement = new Placement('same');
    
    private static var _enumCreated:Boolean = false;
    {  _enumCreated = true; }
    
    
    public var placement:String;
    
    
    public function Placement(_placement:String) {
      if (_enumCreated) {
        throw new Error("The enum is already created:" + _placement);
      }
      placement = _placement;
      
    }
  }
}