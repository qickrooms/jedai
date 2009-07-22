package jedai.events
{
	import flash.events.Event;

	/**
	 * Dispatched by a Red5Connection
	 * 
	 * @author Jon Valliere (sybersnake_AT_gmail_DOT_com)
	 * @author Dominick Accattato (dominick_AT_infrared5_DOT_com)
	 * @author Thijs Triemstra (info@collab.nl)
	 * 
	 **/
	public class LoginEvent extends Event
	{
		
		/** dispatched after bootstrapping is complete. **/
		public static const LOGIN:String 	= "login";
		
		/**
		 * Constructor
		 * @param type 
		 * @param bubbles
		 * @param cancelable
		 **/
		public function LoginEvent(username:String, password:String, type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
		/* override protected function clone() : Event {
			return new Red5Event(username, password);
		} */
		
		public var username:String;
		public var password:String;
		
	}
}