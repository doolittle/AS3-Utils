package com.bradwearsglasses.utils.queue
{
	import flash.events.Event;
	public class QueueEvent extends Event {
	 	
	 	public static const QUEUE_COMPLETE:String = "queue_complete";
		
		public function QueueEvent(type:String):void {
			super(type);
		}		
	}
}