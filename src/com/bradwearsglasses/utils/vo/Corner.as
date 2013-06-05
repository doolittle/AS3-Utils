package com.bradwearsglasses.utils.vo
{
  public class Corner
  {
    
    public static const TopLeft:Corner = new Corner('top', 'left');
    public static const TopCenter:Corner = new Corner('top', 'center');
    public static const TopRight:Corner = new Corner('top', 'right');
    
    public static const CenterLeft:Corner = new Corner('center', 'left');
    public static const CenterCenter:Corner = new Corner('center', 'center');
    public static const CenterRight:Corner = new Corner('center', 'right');
    
    public static const BottomLeft:Corner = new Corner('bottom', 'left');
    public static const BottomCenter:Corner = new Corner('bottom', 'center');
    public static const BottomRight:Corner = new Corner('bottom', 'right');    
    
    private static var _enumCreated:Boolean = false;
    {  _enumCreated = true; }
    
    public var vertical:String;
    public var horizontal:String; 
    
    public function Corner(_vertical:String, _horizontal:String) {
      if (_enumCreated) {
        throw new Error("The enum is already created:" + _vertical + "|" + _horizontal);
      }
      vertical = _vertical;
      horizontal = _horizontal;
      
    }
  }
}