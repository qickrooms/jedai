package com.infrared5.io.events
{
	import flash.events.Event;

	public class CookieDeviceEvent extends Event
	{
		public static const DEFAULT_VIDEO_INPUT_UPDATED : String = "defaultVideoInputChanged";
		public static const DEFAULT_AUDIO_INPUT_UPDATED	: String = "defaultAudioInputUpdated";
		
		public function CookieDeviceEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
	}
}