package com.infrared5.asmf.media.extensions.events
{
	import flash.events.Event;

	public class DeviceConnectionNotifierEvent extends Event
	{
		public static const CAMERA_DETACHED			: String	= "cameraDetached";
		
		public static const MICROPHONE_DETACHED		: String	= "microphoneDetached";
		
		public static const NETWORK_DIED			: String	= "networkDied";
		
		public function DeviceConnectionNotifierEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
	}
}