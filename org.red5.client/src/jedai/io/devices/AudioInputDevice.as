package jedai.io.devices
{
	import jedai.media.rtp.Red5NetStream;
	import jedai.io.CookieDeviceManager;
	import jedai.io.DeviceAutoConfig;
	import jedai.io.InputDevice;
	import jedai.io.OutputDevice;
	
	import flash.media.Microphone;

	public class AudioInputDevice implements InputDevice
	{
		public function AudioInputDevice( lookupCookieDevice:Boolean=false, useDeviceNamed:String="" )
		{
			if( lookupCookieDevice )
			{
				if( CookieDeviceManager.getInstance().hasSavedAudioInput() )
				{
					_mic = Microphone.getMicrophone( int( CookieDeviceManager.getInstance().savedAudioInput ) );
				}
			}
			else
			{
				useDevice( useDeviceNamed );
			}
		}
		
		public function useDevice( name:String ):void
		{
			_mic = Microphone.getMicrophone( int( name ) );
			
			if( _attached == true )
			{
				Red5NetStream( _attachedStream ).attachAudio( _mic );
			}
		}
		
		private var _attached:Boolean = false;
		
		private var _attachedStream:OutputDevice;
		
		public function attachOutputTo(stream:OutputDevice, ...args):void
		{
			if( !_attached )
			{
				if( stream is Red5NetStream )
				{
					this.setupInputDevice();
					
					Red5NetStream( stream ).attachAudio( _mic );
					
					_attachedStream = stream;
				}
				
				if( args[0] != DeviceAutoConfig.CONFIG_DIRECTION_TOKEN )
				{
					stream.attachInputFrom( this, DeviceAutoConfig.CONFIG_DIRECTION_TOKEN );
				}
				
				_attached = true;
			}
			else
			{
				throw new Error("The output of this input device is already attached to another input device");
			}
		}
		
		protected var _mic:Microphone;
		
		private function setupInputDevice():void
		{
			if( _mic == null )
			{
				_mic = Microphone.getMicrophone();
			}
		}

		
	}
}