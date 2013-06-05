package com.bradwearsglasses.utils.queue
{
  import flash.display.MovieClip;
  import flash.events.Event;
  import flash.events.EventDispatcher;

  public class Queue extends EventDispatcher
  {
    private var reducer:MovieClip

    private var stack:Array;
    private var scope:Object;
    private var action:Function;
    private var params:Array
    private var callback:Function;

    private var is_complete:Boolean 		    = false;
    private var initialized:Boolean 				= false;
    private var manual_iteration:Boolean    = false
    private var loops:Number								= 0; //Number of loops 
    private var NUM_THREADS:Number 					= 256;		

    public function Queue(_stack:Array, _scope:Object, _action:Function, _params:Array=null, start_immediately:Boolean = true, custom_threading:Number = 0, _manual_iteration:Boolean=false)
    {
      stack = _stack;
      scope= _scope;
      action = _action;
      params = (_params) ? _params : [];
      manual_iteration = _manual_iteration

      if (custom_threading > 0) NUM_THREADS = custom_threading;
      if (start_immediately && !manual_iteration) {
        start()
      } else {
        initialized = true
      }
    }

    public function start():void {
      reducer = new MovieClip;
      reducer.addEventListener(Event.ENTER_FRAME, tick);
    }

    public function next():void {
      tick();
    }

    private function tick(event:Event=null):void {
      if (!initialized) { 
        initialized=true; 
        return; 
      } //Give the app a chance to set listeners. Waiting for a frame to pass insures that the procedural code is called first. 
      
      var i:Number = -1;
      while ((++i < NUM_THREADS) && !is_complete) {
        run();
      }
      
    }

    private function run(increment:Boolean = false):void {
      if (stack.length==0) return complete(); 		
      action.apply(scope, params.concat(stack.shift()))
      loops++;
    }

    private function complete():void {
      cleanup();
      dispatchEvent(new QueueEvent(QueueEvent.QUEUE_COMPLETE));
      destroy();
    }

    private function cleanup():void {
      if (reducer) reducer.removeEventListener(Event.ENTER_FRAME,tick);
      reducer = null;
      is_complete=true;
    }

    private function destroy():void {
      delete this;
    }				
  }
}
