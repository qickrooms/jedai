package jedai.media.rtp.events
{
	import flash.events.Event;

	public class Red5NetStreamEvent extends Event
	{
		public static const MICROPHONE_ATTACHED		: String	= "microphoneAttached";
		
		public static const CAMERA_ATTACHED			: String	= "cameraAttached";
		
		public static const PLAYBACK_STARTED		: String	= "playbackStarted";
		public static const PLAYBACK_ENDED			: String	= "playbackEnded";
		public static const PLAYBACK_PAUSED			: String	= "playbackPaused";
		public static const PLAYBACK_RESUMED		: String	= "playbackResumed";
		
		public static const PUBLISH_STARTED			: String	= "publishStarted";
		public static const PUBLISH_ENDED			: String	= "publishEnded";
		
		public static const RECORDING_STARTED		: String	= "recordingStarted";
		public static const RECORDING_ENDED			: String	= "recordingEnded";
		
		public function Red5NetStreamEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
	}
}