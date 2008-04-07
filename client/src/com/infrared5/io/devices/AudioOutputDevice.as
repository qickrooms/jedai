package com.infrared5.io.devices
{
	import com.infrared5.asmf.media.rtp.Red5NetStream;
	import com.infrared5.io.DeviceAutoConfig;
	import com.infrared5.io.InputDevice;
	import com.infrared5.io.OutputDevice;
	
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