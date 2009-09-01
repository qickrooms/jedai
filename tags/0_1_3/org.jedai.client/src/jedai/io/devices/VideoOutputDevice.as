package jedai.io.devices
{
	import jedai.media.rtp.Red5NetStream;
	import jedai.io.DeviceAutoConfig;
	import jedai.io.InputDevice;
	import jedai.io.OutputDevice;
	import jedai.io.extensions.enum.ResourceEnum;
	
	import flash.media.Camera;
	import flash.media.Video;

	public class VideoOutputDevice extends Video implements OutputDevice
	{
		public namespace raf = "raf/internal";
		
		public function attachInputFrom(stream:InputDevice, ...args):void
		{
			if( stream is Red5NetStream )
			{
				this.attachNetStream( Red5NetStream(stream) );
			}
			else
			if( stream is Camera )
			{
				this.attachCamera( Camera(stream) );
			}
			else
			if( stream is VideoInputDevice )
			{
				
				use namespace raf;
				this.attachCamera( VideoInputDevice( stream ).camera );
				
				// We Manually Register with the Red5NetStream because otherwise it would cause a OneWayMuxer error.
				if( VideoInputDevice( stream ).connectedStream != null )
					Red5NetStream( VideoInputDevice( stream ).connectedStream ).registerExternalResource( ResourceEnum.VIDEO, this );
			}
			
			if( args[0] != DeviceAutoConfig.CONFIG_DIRECTION_TOKEN )
			{
				stream.attachOutputTo( this, DeviceAutoConfig.CONFIG_DIRECTION_TOKEN );
			}
		}
		
		
	}
} 