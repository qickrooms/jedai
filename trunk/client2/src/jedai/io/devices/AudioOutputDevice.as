package jedai.io.devices
{
	import jedai.media.rtp.Red5NetStream;
	import jedai.io.DeviceAutoConfig;
	import jedai.io.InputDevice;
	import jedai.io.OutputDevice;
	
	import flash.media.SoundTransform;

	public class AudioOutputDevice implements OutputDevice
	{
		public function attachInputFrom(stream:InputDevice, ...args):void
		{
			if( stream is Red5NetStream )
			{
				_snd = Red5NetStream(stream).soundTransform;
			}
			
			if( args[0] != DeviceAutoConfig.CONFIG_DIRECTION_TOKEN )
			{
				stream.attachOutputTo( this, DeviceAutoConfig.CONFIG_DIRECTION_TOKEN );
			}
		}
		
		protected var _snd:SoundTransform

	}
}