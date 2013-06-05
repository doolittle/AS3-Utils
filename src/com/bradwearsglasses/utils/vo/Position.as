package com.bradwearsglasses.utils.vo
{
	public class Position
	{
    
    public static const AboveLeft:Position = new Position(Placement.ABOVE, Alignment.LEFT);
    public static const AboveRight:Position = new Position(Placement.ABOVE,  Alignment.RIGHT);
    public static const AboveCenter:Position = new Position(Placement.ABOVE,  Alignment.CENTER);
    public static const AboveSame:Position = new Position(Placement.ABOVE,  Alignment.SAME);

    public static const BelowLeft:Position = new Position(Placement.BELOW, Alignment.LEFT);
    public static const BelowRight:Position = new Position(Placement.BELOW,  Alignment.RIGHT);
    public static const BelowCenter:Position = new Position(Placement.BELOW,  Alignment.CENTER);
    public static const BelowSame:Position = new Position(Placement.BELOW,  Alignment.SAME);
        
    public static const LeftTop:Position = new Position(Placement.LEFT,  Alignment.TOP);
    public static const LeftCenter:Position = new Position(Placement.LEFT,  Alignment.CENTER);
    public static const LeftBottom:Position = new Position(Placement.LEFT,  Alignment.BOTTOM);
    public static const LeftSame:Position = new Position(Placement.LEFT,  Alignment.SAME);
    
    public static const RightTop:Position = new Position(Placement.RIGHT,  Alignment.TOP);
    public static const RightCenter:Position = new Position(Placement.RIGHT,  Alignment.CENTER);
    public static const RightBottom:Position = new Position(Placement.RIGHT,  Alignment.BOTTOM);
    public static const RightSame:Position = new Position(Placement.RIGHT,  Alignment.SAME);
    
    public static const SameTop:Position = new Position(Placement.SAME,  Alignment.TOP);
    public static const SameCenter:Position = new Position(Placement.SAME,  Alignment.CENTER);
    public static const SameBottom:Position = new Position(Placement.SAME,  Alignment.BOTTOM);
    public static const SameLeft:Position = new Position(Placement.SAME,  Alignment.LEFT);
    public static const SameRight:Position = new Position(Placement.SAME,  Alignment.RIGHT);    
    public static const SameSame:Position = new Position(Placement.SAME,  Alignment.SAME);    
    
    public static function from(placement:Placement, alignment:Alignment):Position {
      switch(placement) {
        case Placement.ABOVE:
          switch(alignment) {
            case Alignment.LEFT:
              return Position.AboveLeft;
            case Alignment.CENTER:
              return Position.AboveCenter;  
            case Alignment.RIGHT:
              return Position.AboveRight;
            case Alignment.SAME:
              return Position.AboveSame;
          }
          break;
        case Placement.BELOW:
          switch(alignment) {
            case Alignment.LEFT:
              return Position.BelowLeft;
            case Alignment.CENTER:
              return Position.BelowCenter;  
            case Alignment.RIGHT:
              return Position.BelowRight;
            case Alignment.SAME:
              return Position.BelowSame;
          }          
          break;
        case Placement.LEFT:
          switch(alignment) {
            case Alignment.TOP:
              return Position.LeftTop;
            case Alignment.CENTER:
              return Position.LeftCenter;  
            case Alignment.BOTTOM:
              return Position.LeftBottom;
            case Alignment.SAME:
              return Position.LeftSame;
          }          
          break;        
        case Placement.RIGHT:
          switch(alignment) {
            case Alignment.TOP:
              return Position.RightTop;
            case Alignment.CENTER:
              return Position.RightCenter;  
            case Alignment.BOTTOM:
              return Position.RightBottom;
            case Alignment.SAME:
              return Position.RightSame;
          }          
          break;
        case Placement.SAME:
          switch(alignment) {
            case Alignment.LEFT:
              return Position.SameLeft;
            case Alignment.CENTER:
              return Position.SameCenter;  
            case Alignment.RIGHT:
              return Position.SameRight;
            case Alignment.TOP:
              return Position.SameTop;
            case Alignment.BOTTOM:
              return Position.SameBottom;              
            case Alignment.SAME:
              return Position.SameSame;
          }          
          break;
      }
      return Position.SameSame;
    }
    
   private static var _enumCreated:Boolean = false;
    {  _enumCreated = true; }
        
    public var placement:Placement;
    public var alignment:Alignment;
    
    public function get description():String {
      return "Position:" + placement.placement + " | Alignment:" + alignment.alignment;
    }
    
    public function Position(_placement:Placement, _alignment:Alignment) {
      if (_enumCreated) {
        throw new Error("The enum is already created:" + _placement + "|" + _alignment);
      }
      placement = _placement;
      alignment = _alignment; 
    }
          
	}
}