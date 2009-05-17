package jedai.media.extensions
{
	import jedai.io.extensions.AbstractStreamExtension;
	
	[Event(name="networkDied", type="jedai.media.extensions.events.DeviceConnectionNotifierEvent")]
	
	[Event(name="cameraDetached", type="jedai.media.extensions.events.DeviceConnectionNotifierEvent")]
	
	[Event(name="microphoneDetached", type="jedai.media.extensions.events.DeviceConnectionNotifierEvent")]
	
	public class DeviceConnectionNotifier extends AbstractStreamExtension
	{
		public function DeviceConnectionNotifier()
		{
			super();
		}
		
	}
}