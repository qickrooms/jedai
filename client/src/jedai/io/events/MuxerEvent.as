package com.infrared5.io.events
{
	import flash.events.Event;

	public class MuxerEvent extends Event
	{
		public static const CONFIGURATION_COMPLETE		: String = "configurationComplete";
		
		public function MuxerEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
	}
}