package com.bradwearsglasses.utils.service
{
  import flash.events.Event;
  
  public class GenericServiceEvent extends Event
  { 
  
    public static const REQUEST_COMPLETE:String = "request_complete";
    public static const REQUEST_FAIL:String = "request_fail";
    public static const IO_WARNING:String = "io_warning";
    public static const PERMISSION_FAIL:String = "permission_fail";
    public static const PROGRESS:String = "progress";
       
    public var progress:Number
    
    public function GenericServiceEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
    {
      super(type, bubbles, cancelable);
    }
    
    private var __event:Event;
    public function get event():Event { return __event; }
    public function set event(_event:Event):void { __event = _event; }
    
    private var __xml:XML
    public function get xml():XML { return __xml; }
    public function set xml(_xml:XML):void {  __xml = _xml; }
        
    private var __data:*
    public function get data():* { return __data; }
    public function set data(_data:*):void {  __data = _data; }  
    
  }
}