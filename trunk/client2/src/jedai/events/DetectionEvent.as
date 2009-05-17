package jedai.events
{
	import flash.events.Event;

	/**
	 * Dispatched by a Red5Connection
	 * 
	 * @author Dominick Accattato (dominick_AT_infrared5_DOT_com)
	 **/
	public class DetectionEvent extends Event
	{
		/** dispatched after device prompt **/
		public static const PROMPT_ACCEPTED		: String 	= "promptAcceptedEvent";
		public static const PROMPT_DENIED		: String 	= "promptDeniedEvent";
		
		/** dispatched after audio test **/
		public static const AUDIO_FOUND			: String 	= "audioFoundEvent";
		public static const AUDIO_NOT_FOUND		: String 	= "audioNotFoundEvent";
		
		/** dispatched after video test **/
		public static const VIDEO_FOUND			: String 	= "videoFoundEvent";
		public static const VIDEO_NOT_FOUND		: String 	= "videoNotFoundEvent";
		
		/**
		 * Constructor
		 * @param type 
		 * @param bubbles
		 * @param cancelable
		 **/
		public function DetectionEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
		
	}
}