package com.infrared5.asmf.media.rtp
{
	import com.infrared5.asmf.errors.UnknownDeviceError;
	import com.infrared5.asmf.media.rtp.events.Red5NetStreamEvent;
	import com.infrared5.asmf.net.rpc.Red5Connection;
	import com.infrared5.io.DeviceAutoConfig;
	import com.infrared5.io.InputDevice;
	import com.infrared5.io.OneWayMuxer;
	import com.infrared5.io.OutputDevice;
	import com.infrared5.io.devices.AudioInputDevice;
	import com.infrared5.io.devices.AudioOutputDevice;
	import com.infrared5.io.devices.VideoInputDevice;
	import com.infrared5.io.devices.VideoOutputDevice;
	import com.infrared5.io.errors.OneWayMuxerError;
	import com.infrared5.io.extensions.ExtendableStreamControl;
	import com.infrared5.io.extensions.SimpleExtensionManager;
	import com.infrared5.io.extensions.StreamExtension;
	import com.infrared5.io.extensions.enum.ResourceEnum;
	import com.infrared5.io.extensions.utils.ExtensionStatusPool;
	
	import flash.events.NetStatusEvent;
	import flash.media.Camera;
	import flash.media.Microphone;
	import flash.net.NetStream;
	
	[Event(name="cameraAttached", type="com.infrared5.asmf.media.rtp.events.Red5NetStreamEvent")]
	
	[Event(name="microphoneAttached", type="com.infrared5.asmf.media.rtp.events.Red5NetStreamEvent")]
	
	[Event(name="publishStarted", type="com.infrared5.asmf.media.rtp.events.Red5NetStreamEvent")]
	
	[Event(name="publishEnded", type="com.infrared5.asmf.media.rtp.events.Red5NetStreamEvent")]
	
	/**
	 * RedStream is a class that encapsulates everything required for basic video/audio connections.
	 * <br/>
	 * <p>
	 * RedStream supports plugins for Video, Microphone and Special Event Handlers.  The plugin architecture cleans up  
	 * the mess of events and storage of memory references usually required when trying to implement advanced features
	 * bound to Video and Microphone instances.Only one instance of a IRedStreamPlugin is allowed per instance of 
	 * Red5NetStream.</p>
	 */
	public class Red5NetStream extends NetStream implements ExtendableStreamControl, OneWayMuxer
	{
		public static const FAILED					: String	= "NetStream.Failed";

		public static const PLAYBACK_START			: String	= "NetStream.Play.Start";
		public static const PLAYBACK_STOP			: String	= "NetStream.Play.Stop";
		public static const PLAYBACK_RESET			: String	= "NetStream.Play.Reset";
		public static const PLAYBACK_PAUSE			: String	= "NetStream.Pause.Notify";
		public static const PLAYBACK_RESUME			: String	= "NetStream.Unpause.Notify";
		
		public static const PUBLISH_START			: String	= "NetStream.Publish.Start";
		public static const PUBLISH_STOP			: String	= "NetStream.Unpublish.Success";
		public static const PUBLISH_BAD_NAME		: String	= "NetStream.Publish.BadName";
		public static const PUBLISH_IDLE			: String	= "NetStream.Publish.Idle";
		public static const PLAY_PUBLISH			: String	= "NetStream.Play.PublishNotify";
		public static const PLAY_UNPUBLISH			: String	= "NetStream.Play.UnpublishNotify";
		
		public static const RECORD_START			: String	= "NetStream.Record.Start";
		public static const RECORD_STOP				: String	= "NetStream.Record.Stop";
		public static const RECORD_FAILED			: String	= "NetStream.Record.Failed";
		
		public static const BUFFER_FULL				: String	= "NetStream.Buffer.Full";
		public static const BUFFER_FLUSH			: String	= "NetStream.Buffer.Flush";
		public static const BUFFER_EMPTY			: String	= "NetStream.Buffer.Empty";
		
		
		//-------------------------------------------------------------
		//
		//	Namespaces
		//
		//-------------------------------------------------------------
		
		public namespace raf	= "raf/internal";
		
		//-------------------------------------------------------------
		//
		//	Instance
		//
		//-------------------------------------------------------------
		
		private var _extMgr				: SimpleExtensionManager;
		

		public function Red5NetStream( connection:Red5Connection)
		{

			super( connection );
			
			_extMgr = new SimpleExtensionManager( this );
			
			this.addEventListener( NetStatusEvent.NET_STATUS, this.eventNetStatusHandler );
		}

		
		//-------------------------------------------------------------
		//	Stream Paradigm Support
		//-------------------------------------------------------------
		
		private var _isMixing:uint = 0;
		
		public function attachInputFrom(stream:InputDevice, ... args):void
		{
			/*
				OutputDevice should be a Camera / Microphone
				
				If a OutputDevice is specificed without the EntryPoint Key 0xff0 then
				we can assume that the developer's code looks something like
					Red5NetStream.attachInputFrom( VideoDevice )
				
				So, VideoDevice needs to be self-configured and that will be done by
				attaching the input of this device into the input of it with the EntryPoint Key.
			*/
			
			if( stream is VideoInputDevice || stream is AudioInputDevice )
			{
				if( this._isMixing != 2 )
				{
					if( args[0] != DeviceAutoConfig.CONFIG_DIRECTION_TOKEN )
					{
						stream.attachOutputTo( this, DeviceAutoConfig.CONFIG_DIRECTION_TOKEN );
					}
					
					this._isMixing = 1;
				}
				else
				{
					throw new OneWayMuxerError("You are attempting to connect a Output device to a OneWayMuxer already configured for Output");
				}
			}
			else if(stream == null )
			{
				this.attachAudio(null);
				this.attachCamera(null);
			}
			else
			{
				throw new UnknownDeviceError("The OutputDevice specified is not understood by this InputDevice");
			}
		}
		
		public function attachOutputTo(stream:OutputDevice, ... args):void
		{
			/*
				InputDevice should be Video / Sound.
				
				If a InputDevice is specificed without the EntryPoint Key 0xff0 then
				we can assume that the developer's code looks something like
					Red5NetStream.attachOutputTo( VideoDevice )
				
				So, VideoDevice needs to be self-configured and that will be done by
				attaching the output of this device into the input of it with the EntryPoint Key.
			*/
			
			if( stream is VideoOutputDevice || stream is AudioOutputDevice )
			{
				if( this._isMixing != 1 )
				{
					if( args[0] != DeviceAutoConfig.CONFIG_DIRECTION_TOKEN )
					{
						stream.attachInputFrom( this, DeviceAutoConfig.CONFIG_DIRECTION_TOKEN );
					}
					
					this._isMixing = 2;
				}
				else
				{
					throw new OneWayMuxerError("You are attempting to connect a Input device to a OneWayMuxer already configured for Input");
				}
			}
			else
			{
				throw new UnknownDeviceError("The InputDevice specified is not understood by this OutputDevice");
			}
		}
		
		//-------------------------------------------------------------
		//  Added Functionality
		//-------------------------------------------------------------
		
		private var _isPublishing:Boolean = false;
		
		public function get isPublishing():Boolean
		{
			return _isPublishing;
		}
		
		public function onPlayStatus(val:*) : void {
			trace("val: " + val);
		}
		
		protected function setIsPublishing( value:Boolean ):void
		{
			if( this._isPublishing != value  )
			{
				if( !value )
				{
					this._isPublishing = false;
					
					this.dispatchEvent( new Red5NetStreamEvent( Red5NetStreamEvent.PUBLISH_ENDED ) );
				}
				else
				{
					this._isPublishing = true;
					
					this.dispatchEvent( new Red5NetStreamEvent( Red5NetStreamEvent.PUBLISH_STARTED ) );
				}
			}
		}
		
		private var _isPaused:Boolean = false;
		
		public function get isPaused():Boolean
		{
			return _isPaused;
		}
		
		protected function setIsPaused( value:Boolean ):void
		{
			if ( this._isPaused != value  )
			{
				if ( !value )
				{
					this._isPaused = false;
					
					this.dispatchEvent( new Red5NetStreamEvent( Red5NetStreamEvent.PLAYBACK_RESUMED ) );
				}
				else
				{
					this._isPaused = true;
					
					this.dispatchEvent( new Red5NetStreamEvent( Red5NetStreamEvent.PLAYBACK_PAUSED ) );
				}
			}
		}
		
		private var _isPlaying:Boolean = false;
		
		public function get isPlaying():Boolean
		{
			return _isPlaying;
		}
		
		protected function setIsPlaying( value:Boolean ):void
		{
			if ( this._isPlaying != value  )
			{
				if ( !value )
				{
					this._isPlaying = false;
					
					this.dispatchEvent( new Red5NetStreamEvent( Red5NetStreamEvent.PLAYBACK_ENDED ) );
				}
				else
				{
					this._isPlaying = true;
					
					this.dispatchEvent( new Red5NetStreamEvent( Red5NetStreamEvent.PLAYBACK_STARTED ) );
				}
			}
		}
		
		/**
		 * 
		 * @param event
		 */		
		protected function eventNetStatusHandler( event:NetStatusEvent ):void
		{
			var eventCode:String = event.info.code;
			trace("Red5NS: " + eventCode);
			switch( eventCode )
			{
				case Red5NetStream.PLAYBACK_START:
					this.setIsPlaying( true );
					break;
					
				case Red5NetStream.PLAYBACK_STOP:
					this.setIsPlaying( false );
					break;
					
				case Red5NetStream.PLAYBACK_PAUSE:
					this.setIsPaused( true );
					break;
					
				case Red5NetStream.PLAYBACK_RESUME:
					this.setIsPaused( false );
					break;
					
				case Red5NetStream.PUBLISH_START:
					this.setIsPublishing( true );
					break;
				
				case Red5NetStream.PUBLISH_STOP:
					this.setIsPublishing( false );
					break;
					
				case Red5NetStream.PUBLISH_BAD_NAME:
				case Red5NetStream.FAILED:
					this.setIsPublishing( false );
					break;
				
				case Red5NetStream.RECORD_START:
					//this.setIsRecording( true );
					break;
				
				case Red5NetStream.RECORD_STOP:
					//this.setIsRecording( false );
					break;
			}
		}
		
		//-------------------------------------------------------------
		//	Extension Support
		//-------------------------------------------------------------
		
		public function set extensions( plugins:Array ):void
		{
			this._extMgr.extensions = plugins;
		}
		
		public function loadExtension( plugin:StreamExtension ):StreamExtension
		{
			return this._extMgr.loadExtension( plugin );
		}
		
	
		public function terminateExtension( plugin:StreamExtension ):Boolean
		{
			return this._extMgr.terminateExtension( plugin );
		}
		
		public function suspendExtensions():ExtensionStatusPool
		{
			return this._extMgr.suspendExtensions();
		}
		
		public function terminateExtensions():ExtensionStatusPool
		{
			return this._extMgr.terminateExtensions();
		}
		
		public function startExtensions():ExtensionStatusPool
		{
			return this._extMgr.startExtensions();
		}
		
		public function toggleExtensionSuspension():ExtensionStatusPool
		{
			return null;
		}
		
		public function getExtensions():Object
		{
			return this._extMgr.getExtensions();
		}
		
		public function registerExternalResource( resource:ResourceEnum, value:* ):void
		{
			this._extMgr.registerExternalResource( resource, value );
		}
		
		public function requestExternalResource( resource:ResourceEnum, callback:Function ):void
		{
			this._extMgr.requestExternalResource( resource, callback );
		}
		
		//-------------------------------------------------------------
		//	Overrides
		//-------------------------------------------------------------
		
		override public function publish( name:String=null, type:String=null ):void
		{
			super.publish( name, type );
			
			this.setIsPublishing( true );
		}
		
		override public function close():void
		{
			super.close();
			
			this.setIsPublishing( false );
			
			super.attachCamera( null );
			
			if( this._extMgr.lookupRegisteredResource( ResourceEnum.VIDEO ) != null ) 
				VideoOutputDevice(this._extMgr.lookupRegisteredResource( ResourceEnum.VIDEO )).attachCamera(null);
		}
		
		override public function pause():void
		{
			super.pause();
			
			this.setIsPaused( true );
		}
		
		override public function resume():void
		{
			super.resume();
			
			this.setIsPaused( false );
		}
		
		override public function attachAudio(microphone:Microphone):void
		{
			super.attachAudio( microphone );
			
			if( microphone != null )
			{
				this.dispatchEvent( new Red5NetStreamEvent( Red5NetStreamEvent.MICROPHONE_ATTACHED ) );
				
				this.registerExternalResource( ResourceEnum.MICROPHONE, microphone );
			}
		}
		
		override public function attachCamera(theCamera:Camera, snapshotMilliseconds:int=-1):void
		{
			super.attachCamera(theCamera, snapshotMilliseconds);
			
			if( theCamera != null )
			{
				this.dispatchEvent( new Red5NetStreamEvent( Red5NetStreamEvent.CAMERA_ATTACHED ) );
				
				this.registerExternalResource( ResourceEnum.CAMERA, theCamera );
			}
		}

	}
}