package com.infrared5.asmf.media.extensions
{
	import com.infrared5.io.extensions.AbstractStreamExtension;
	
	[Event(name="networkDied", type="com.infrared5.asmf.media.extensions.events.DeviceConnectionNotifierEvent")]
	
	[Event(name="cameraDetached", type="com.infrared5.asmf.media.extensions.events.DeviceConnectionNotifierEvent")]
	
	[Event(name="microphoneDetached", type="com.infrared5.asmf.media.extensions.events.DeviceConnectionNotifierEvent")]
	
	public class DeviceConnectionNotifier extends AbstractStreamExtension
	{
		public function DeviceConnectionNotifier()
		{
			super();
		}
		
	}
}