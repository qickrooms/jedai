package com.infrared5.io
{
	import com.infrared5.io.events.CookieDeviceEvent;
	
	import flash.events.EventDispatcher;
	import flash.media.Camera;
	import flash.media.Microphone;
	import flash.net.SharedObject;
	
	[Event(name="defaultAudioInputChanged", type="com.infrared5.io.events.CookieDeviceEvent")]
	[Event(name="defaultVideoInputChanged", type="com.infrared5.io.events.CookieDeviceEvent")] 
	
	public class CookieDeviceManager extends EventDispatcher
	{
		public static var cookieName	: String	= "red5devices";
		
		private static var instance		: CookieDeviceManager;
		
		public static function getInstance():CookieDeviceManager
		{
			if( instance == null )
			{
				instance = new CookieDeviceManager();
			}
			
			return instance;
		}
		
		private var _cookie:SharedObject;
		
		public function CookieDeviceManager()
		{
			_cookie = SharedObject.getLocal( CookieDeviceManager.cookieName );
		}
		
		public function removeDefaultDevices():void
		{
			_cookie.clear()
			
		}
		
		public function saveDefaultDevices():void
		{
			try {
				_cookie.flush();	
			} catch (err:Error) {
				trace("err: " + err);
			}
			
		}
		
		public function get savedAudioInput():String
		{
			return _cookie.data.savedAudioInput;
		}
		
		public function set savedAudioInput( value:String ):void
		{
			trace("trying to save audio : "+ value );
			if( value != _cookie.data.savedAudioInput && value != "" )
			{
				trace("audio input passed failsafe and was saved");
				_cookie.data.savedAudioInput = value;
			
				this.dispatchEvent( new CookieDeviceEvent( CookieDeviceEvent.DEFAULT_AUDIO_INPUT_UPDATED ) );
				
				this.saveDefaultDevices();
			}
		}
		
		public function get savedVideoInput():String
		{
			return _cookie.data.savedVideoInput;
		}
		
		public function set savedVideoInput( value:String ):void
		{
			trace("trying to save video : "+ value );
			if( _cookie.data.savedVideoInput != value && value != "" )
			{
				trace("video input passed failsafe and was saved");
				_cookie.data.savedVideoInput = value;
			
				this.dispatchEvent( new CookieDeviceEvent( CookieDeviceEvent.DEFAULT_VIDEO_INPUT_UPDATED ) );
				
				this.saveDefaultDevices();
			}
		}
		
		public function getListOfAvailableVideoInputDevices():Array
		{
			return Camera.names;
		}
		
		public function getListOfAvailableAudioInputDevices():Array
		{
			return Microphone.names;
		}
		
		public function hasSavedVideoInput():Boolean
		{
			return (  this.savedVideoInput != null && this.savedVideoInput != "" );
		}
		
		public function hasSavedAudioInput():Boolean
		{
			return ( this.savedAudioInput != null && this.savedAudioInput != "" );
		}
		
		override public function toString():String
		{
			return "*******************************" + 
					"       DeviceManager            " + 
					"                                " + 
					" AudioInput: " + this.savedAudioInput +
					" VideoInput: " + this.savedVideoInput +
					"                                " + 
					"********************************";
		}
	}
}