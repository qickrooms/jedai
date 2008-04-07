package com.infrared5.asmf.media.extensions.events
{
	import flash.display.BitmapData;
	import flash.events.Event;

	public class ShutterBugEvent extends Event
	{
		public static const TOOK_PHOTO		: String		= "tookPhoto";
		
		public function ShutterBugEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
		public var data:BitmapData;
		
	}
}