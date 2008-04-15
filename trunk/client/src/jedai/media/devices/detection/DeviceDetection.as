package com.infrared5.asmf.media.devices.detection
{
	import com.infrared5.asmf.events.DetectionEvent;
	
	import flash.events.EventDispatcher;
	import flash.events.StatusEvent;
	import flash.media.Camera;
	import flash.media.Microphone;
	import flash.media.Video;
	
	/** Device Events **/
	[Event(name="promptAcceptedEvent", type="com.infrared5.asmf.events.DetectionEvent")]
	[Event(name="promptDeniedEvent", type="com.infrared5.asmf.events.DetectionEvent")]
	[Event(name="audioFoundEvent", type="com.infrared5.asmf.events.DetectionEvent")]
	[Event(name="audioNotFoundEvent", type="com.infrared5.asmf.events.DetectionEvent")]
	[Event(name="videoFoundEvent", type="com.infrared5.asmf.events.DetectionEvent")]
	[Event(name="videoNotFoundEvent", type="com.infrared5.asmf.events.DetectionEvent")]
	
	/**
	 * Class that detects audio/video devices and dispatches status to 
	 * components listening for the events.
	 * 
	 * @author Dominick Accattato (dominick@infrared5.com)
	 **/
	public class DeviceDetection extends EventDispatcher implements IAudioDetection, IVideoDetection
	{
		private var cam		: Camera;
		private var mic		: Microphone;
		
		/**
		 * Prompts the user and detect their device status. 
		 **/
		public function prompt() : void 
		{
			// Detect if the user has a camera installed.
			if ( Camera.names.length == 0 ) {
			    trace("User has no cameras installed.");
			} else {
			    
			    cam = Camera.getCamera();
			    mic = Microphone.getMicrophone();
			    var video:Video = new Video();
			    video.attachCamera(cam);
			    
			    // Camera detection
			    if ( cam == null ) {
				    trace("User has no cameras installed.");
				} else {
				    trace("User has at least 1 camera installed.");
				    cam.addEventListener( StatusEvent.STATUS, this.onPromptStatus );				    
				}
			}
		}
		
		/**
		 * Prompt method request access to audio devices.
		 **/
		public function promptAudio() : void 
		{
			mic = Microphone.getMicrophone();
			mic.addEventListener( StatusEvent.STATUS, this.onMicStatus );
		}
		
		/**
		 * Prompt method request access to video devices.
		 **/
		public function promptVideo() : void 
		{
			cam = Camera.getCamera();
			cam.addEventListener( StatusEvent.STATUS, onCameraStatus );
		}
		
		/**
		 * Event handler that checks whether the user "accepted" or "denied" access
		 * to their devices in the privacy settings dialogue and then dispatches a DeviceEvent
		 * for listening classes to handle the implementation.
		 **/ 
		private function onPromptStatus( event:StatusEvent ) : void 
		{
		    // This event gets dispatched when the user clicks the "Allow" or "Deny"
		    // button in the Flash Player Settings dialog box.
		    trace("onPromptStatus: " + event.code); // "Camera.Muted" or "Camera.Unmuted"
		    var status:Boolean = true;
		    	
		    switch(event.code) {
		    	case cam.muted:
		    		status = false;
		    				    		
		    	case mic.muted:
		    		status = false;
		    		
		    	default:
		    		break;
		    }
		    
		    // if either the camera or microphone are denied, we reject.
		    if ( !status ) {
		    	// user declined to allow access to devices
				var declineEvent:DetectionEvent = new DetectionEvent( DetectionEvent.PROMPT_DENIED );			
				dispatchEvent( declineEvent );
		    } else {
		    	// user allowed access to devices
				var acceptEvent:DetectionEvent = new DetectionEvent( DetectionEvent.PROMPT_ACCEPTED );			
				dispatchEvent( acceptEvent );
		    }
		}
		
		/**
		 * Event handler for Microphone StatusEvents.
		 * 
		 * @arg event
		 **/
		private function onMicStatus( event:StatusEvent ) : void 
		{
		    if ( event.code == "Microphone.Unmuted" ) {
		        trace("Microphone access was allowed.");
		   		var declineEvent:DetectionEvent = new DetectionEvent( DetectionEvent.AUDIO_FOUND );			
				dispatchEvent(declineEvent);
		    } else {
		       	// user allowed access to devices
				var acceptEvent:DetectionEvent = new DetectionEvent( DetectionEvent.AUDIO_NOT_FOUND );			
				dispatchEvent(acceptEvent);	       
		    }
		    // Remove the status event listener.
		    mic.removeEventListener(StatusEvent.STATUS, onMicStatus);
		    
		}
		
		/**
		 * Event handler for Camera StatusEvents.
		 * 
		 * @arg event
		 **/
		private function onCameraStatus( event:StatusEvent ) : void 
		{
			if ( cam.muted ) {
		        trace("Unable to connect to active camera.");
		        var declineEvent:DetectionEvent = new DetectionEvent( DetectionEvent.VIDEO_NOT_FOUND );			
				dispatchEvent(declineEvent);
		    } else {
		       	// User allowed access to devices.
				var acceptEvent:DetectionEvent = new DetectionEvent( DetectionEvent.VIDEO_FOUND );			
				dispatchEvent(acceptEvent);	       
		    }
		    // Remove the status event listener.
		    cam.removeEventListener( StatusEvent.STATUS, onCameraStatus );

		}
	}
}