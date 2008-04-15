package com.infrared5.io.devices
{
	import com.infrared5.asmf.media.rtp.Red5NetStream;
	import com.infrared5.io.InputDevice;
	import com.infrared5.io.MuxerDevice;
	import com.infrared5.io.OutputDevice;
	import com.infrared5.io.errors.MuxerError;
	
	import flash.display.DisplayObjectContainer;
	import flash.media.Camera;
	import flash.media.Video;
	
	[Event(name="configurationComplete", type="com.infrared5.io.events.MuxerEvent")]
	
	[Deprecated("You should use VideoInputDevice / VideoOutputDevice")]
	/**
	 * VideoMuxer is a MuxerDevice that can operate as both a Video Display and a Camera that attaches to another MuxerDevice.
	 * @author Jon Valliere ( jvalliere@emoten.com )
	 */
	public class VideoMuxer extends DisplayObjectContainer implements MuxerDevice
	{
		protected var _cam:Camera;
		protected var _vid:Video;
		
		public function attachInputFrom(stream:InputDevice, ... args ):void
		{
			/*
				If we are attaching a ASMFNetStream as a Output Device then VideoDevice becomes a flash.media.Video
			*/
			
			
			
			if( stream is Red5NetStream )
			{
				this.setupOutputDevice();
				
				_vid.attachNetStream( Red5NetStream(stream) );
			}
			else if( stream is VideoMuxer )
			{
				this.setupOutputDevice();
				this.setupInputDevice();
				
				_vid.attachCamera( VideoMuxer(stream).camera );
			}
			else
			{
				throw new MuxerError("The OutputDevice you tried to attach is not understood by this Muxer");
			}
		}
		
		/**
		 * 
		 */
		public function attachOutputTo(stream:OutputDevice, ... args ):void
		{
			/*
				If we are attaching a ASMFNetStream as a Input Stream then VideoDevice should become flash.media.Camera
			*/
			
			
			if( stream is Red5NetStream )
			{
				this.setupInputDevice();
				
				Red5NetStream( stream ).attachCamera( _cam );
			}
			else
			if( stream is VideoMuxer )
			{
				this.setupOutputDevice();
				this.setupInputDevice();
				
				VideoMuxer(stream).video.attachCamera( _cam );

			}
			else
			{
				throw new MuxerError("The inputDevice you tried to attach is not understood by this Muxer");
			}
		}
		
		public function get camera():Camera
		{
			this.setupInputDevice();
			
			return _cam;
		}
		
		public function get video():Video
		{
			this.setupOutputDevice();
			
			return _vid;
		}
		
		private function setupOutputDevice():void
		{
			if( _vid == null )
			{
				_vid = new Video();
			
				this.addChild( _vid );
			}
		}
		
		private function setupInputDevice():void
		{
			if( _cam == null )
			{
				_cam = new Camera();
			}
			
		}
		
		//-------------------------------------------------------------
		//
		//	Prana Inversion of Control Properties
		//
		//-------------------------------------------------------------
		
		/**
		 * defines if a Camera connection should be called when the 'set connection' is called.
		 */
		public function set isCamera( value:Boolean ):void
		{
			
		}
		
		/**
		 * defines if a Video connection should be called when the 'set connection' is called.
		 */
		public function set isVideo( value:Boolean ):void
		{
			
		}
		
		public function set connection( con:Red5NetStream ):void
		{
			
		}
	}
}