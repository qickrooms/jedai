package jedai.io.devices.events
{
	import flash.events.Event;

	public class DeviceEvent extends Event
	{
		public static const DISCONNECTED	: String 	= "disconnected";
		public static const CONNECTED		: String	= "connected";
		
		public function DeviceEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
	}
}