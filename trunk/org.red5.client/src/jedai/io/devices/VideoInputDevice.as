package jedai.io.devices
{
	import jedai.media.rtp.Red5NetStream;
	import jedai.io.CookieDeviceManager;
	import jedai.io.DeviceAutoConfig;
	import jedai.io.InputDevice;
	import jedai.io.OutputDevice;
	import jedai.io.devices.events.DeviceEvent;
	
	import flash.events.StatusEvent;
	import flash.media.Camera;
	import flash.media.Video;
	
	[Event(name="activity", type="flash.events.ActivityEvent")]
	
	[Event(name="status", type="flash.events.StatusEvent")]
	
	[Event(name="connected", type="jedai.io.devices.events.DeviceEvent")]
	[Event(name="disconnected", type="jedai.io.devices.events.DeviceEvent")]
	
	/**
	 * Note About Events:: Events dispatched will have a 'target' of the Camera object, not VideoInputDevice.
	 */
	public class VideoInputDevice implements InputDevice
	{
		public namespace raf = "raf/internal";
		
		public function VideoInputDevice( lookupCookieDevices:Boolean=false, useDeviceNamed:String="" )
		{
			if( lookupCookieDevices )
			{
				if( CookieDeviceManager.getInstance().hasSavedVideoInput() )
				{
					this.usingDefaultDevice = true;
					this.useDevice(CookieDeviceManager.getInstance().savedVideoInput);
				}
			}
			else
			if( useDeviceNamed != "" )
			{
				this.useDevice( useDeviceNamed );
			}
		}
		
		public function useDevice( name:String ):void
		{
			if( _cam != null )
			_cam.removeEventListener(StatusEvent.STATUS, this.onStatus );
			
			_cam = Camera.getCamera( name );
			
			if( _cam != null )
			{
				_cam.addEventListener(StatusEvent.STATUS, this.onStatus );
				
				if( _attached == true )
				{
					Red5NetStream( _attachedStream ).attachCamera( _cam );
				}
			}
			else
			{
				throw new Error("The Camera selected is not available");
			}
		}
		
/* 		private function defaultDeviceChanged( event:CookieDeviceEvent ):void
		{
			this.resetDevice();
			
			this.useDevice( CookieDeviceManager.getInstance().savedVideoInput );
		}
		
		protected function resetDevice( ):void
		{
			_cam = Camera.getCamera(false);
		} */
		
		protected var usingDefaultDevice:Boolean = false;
		
		private var _attached:Boolean = false;
		
		private var _attachedStream:OutputDevice;
		
		public function attachOutputTo(stream:OutputDevice, ...args):void
		{
			if( stream is Red5NetStream )
			{
				this.setupInputDevice();
				
				Red5NetStream( stream ).attachCamera( _cam );
				
				_attachedStream = stream;
			}
			else
			if( stream is Video )
			{
				Video(stream).attachCamera( _cam );
			}
			else
			if( stream is VideoOutputDevice && args[0] == DeviceAutoConfig.CONFIG_DIRECTION_TOKEN )
			{
				this.setupInputDevice();
			}
			
			if( args[0] != DeviceAutoConfig.CONFIG_DIRECTION_TOKEN )
			{
				stream.attachInputFrom( this, DeviceAutoConfig.CONFIG_DIRECTION_TOKEN );
			}
			
			_attached = true;


		}
		
		public function get connectedStream():OutputDevice
		{
			return _attachedStream;
		}
		
		
		raf function get camera():Camera
		{
			return _cam;
		}
		
		protected var _cam:Camera;
		
		private function setupInputDevice():void
		{
			if( _cam == null )
			{
				_cam = Camera.getCamera();
				
				_cam.addEventListener(StatusEvent.STATUS, this.onStatus );
			}
			
		}
		
		private function onStatus( event:StatusEvent ):void
		{
			switch( event.code )
			{
				case "Camera.muted":
					this._cam.dispatchEvent( new DeviceEvent( DeviceEvent.DISCONNECTED ) );
					break;
				
				case "Camera.unmuted":
					this._cam.dispatchEvent( new DeviceEvent( DeviceEvent.CONNECTED ) );
					break;
			}
		}
				
		//----------------------------------------------------------------------
		// Wrap the Camera API
		
		public function get activityLevel():Number
		{
			return _cam.activityLevel;
		}
		
		public function get bandwidth():int
		{
			return _cam.bandwidth;
		}
		
		public function get currentFPS():Number
		{
			return _cam.currentFPS;
		}
		
		public function get fps():Number
		{
			return _cam.fps;
		}
		
		public function get height():int
		{
			return _cam.height;
		}
		
		public function get index():int
		{
			return _cam.index;
		}
		
		public function get keyFrameInterval():int
		{
			return _cam.keyFrameInterval;
		}
		
		public function get loopback():Boolean
		{
			return _cam.loopback;
		}
		
		public function get motionLevel():int
		{
			return _cam.motionLevel;
		}
		
		public function get muted():Boolean
		{
			return _cam.muted;
		}
		
		public function get name():String
		{
			return _cam.name;
		}
		
		public function get quality():int
		{
			return _cam.quality;
		}
		
		public function get width():int
		{
			return _cam.width;
		}
		
		public function setLoopBack( compress:Boolean=false):void
		{
			_cam.setLoopback( compress );
		}
		
		public function setMode( width:int, height:int, fps:Number, favorArea:Boolean=true ):void
		{
			_cam.setMode( width, height, fps, favorArea );
		}
		
		public function setMotionLevel( motionLevel:int, timeout:int=2000):void
		{
			_cam.setMotionLevel( motionLevel, timeout );
		}
		
		public function setQuality( bandwidth:int, quality:int ):void
		{
			_cam.setQuality( bandwidth, quality );
		}
		
		public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void
		{
			_cam.addEventListener( type, listener, useCapture, priority, useWeakReference );
		}
	}
}