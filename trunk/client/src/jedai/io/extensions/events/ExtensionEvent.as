package jedai.io.extensions.events
{
	import flash.events.Event;

	public class ExtensionEvent extends Event
	{
		public static const COMPLETED	: String 	= "completed";
		
		public static const READY		: String	= "ready";
		
		public static const WAITING		: String	= "waiting";
		
		public function ExtensionEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super( type, bubbles, cancelable);
		}
		
	}
}