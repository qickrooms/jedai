package jedai.media.extensions
{
	import jedai.media.extensions.events.DeviceConnectionNotifierEvent;
	import jedai.media.extensions.events.ShutterBugEvent;
	import jedai.commons.utils.CameraBitmap;
	import jedai.io.extensions.AbstractObserverExtension;
	import jedai.io.extensions.ExtendableStreamControl;
	import jedai.io.extensions.ObserverStreamExtension;
	import jedai.io.extensions.enum.ExtensionEnum;
	import jedai.io.extensions.enum.ResourceEnum;
	
	import flash.display.BitmapData;
	import flash.media.Camera;
	import flash.media.Video;
	import flash.utils.clearInterval;
	import flash.utils.setInterval;
	
	[Event(name="tookPhoto", type="jedai.media.extensions.events.ShutterBugEvent")]
	
	/**
	 * Takes Snapshots of the Video Stream.
	 * Can be done based on a interval, one-time or manually.
	 * 
	 * @author Jon Valliere ( jvalliere@emoten.com )
	 */
	public class ShutterBug extends AbstractObserverExtension implements ObserverStreamExtension
	{
		/**
		 * 
		 * @param loops Amount of snapshots to create.
		 * @param delay Amount of delay in milliseconds between each snapshot.
		 */		
		public function ShutterBug( loops:int, delay:int )
		{
			super();
			
			_loops = loops;
			
			_delay = delay;
			
			_photos = new Array();
		}
		
		private var _photos			: Array;
		
		private var _loops			: int;
		
		private var _position		: int	= 0;
		
		private var _delay			: int;
		
		// The Interval defined by SetInterval
		private var _interval		: int;
		
		private var _deviceNotifier	: DeviceConnectionNotifier;
		
		private var _cam			: Camera;
		
		private var _vid			: Video;
		
		/**
		 * Get list of snapshots.
		 * 
		 * @return Array with snapshots. 
		 */		
		public function getPhotos():Array
		{
			return _photos;
		}
		
		private function loop():void
		{
			if( _position < _loops )
			{
				_position++;
				
				_photos.push( this.takePhotoNow() );
			}
			else
			{
				flash.utils.clearInterval( this._interval );
				
				this.setStatus( ExtensionEnum.EXT_COMPLETED );
			}
		}
		
		/**
		 * Create snapshot of video and return resulting BitmapData.
		 * 
		 * @return Snapshot
		 */		
		public function takePhotoNow(): BitmapData
		{
			if( this._vid != null )
			{
				var d:Date = new Date();
				
				trace("took photo @ "+ d.toUTCString());
				
				var cb:CameraBitmap = new CameraBitmap( this._vid.width, this._vid.height );
					cb.draw( this._vid );
					
				var e:ShutterBugEvent = new ShutterBugEvent( ShutterBugEvent.TOOK_PHOTO );
					e.data = cb.data;
				
				this.dispatchEvent( e );
				
				return cb.data;
			}
			
			return null;
		}
		
		override public function suspend():Boolean
		{
			if( this.status == ExtensionEnum.EXT_RUNNING )
			{
				// do something
				this.internalSuspend(null);
				
				this.setStatus( ExtensionEnum.EXT_SUSPENDED );

			}
			
			return true;
		}
		
		override public function start():Boolean
		{
			use namespace raf;
			
			if( this.status == ExtensionEnum.EXT_RUNNING )
			{
				return true;
			}
			else
			if( this.status == ExtensionEnum.EXT_SUSPENDED )
			{
				this.internalStart();
				
				this.setStatus( ExtensionEnum.EXT_RUNNING );
				
				return true;
			}
			else
			if( this.status == ExtensionEnum.EXT_VIRGIN )
			{
				// Check to see if a DeviceConnectionNotifier Extension is registered with the master control.
				var d:* = this._control.getExtensions()["jedai.media.extensions::DeviceConnectionNotifier"];
				
				if( d == undefined )
				{
					this._deviceNotifier = this._control.loadExtension( new DeviceConnectionNotifier() ) as DeviceConnectionNotifier;
				}
				else
				{
					this._deviceNotifier = d;
				}
				
				this.makeEventConnectionsToNotifier( this._deviceNotifier );
				
				this.determineIfConnectedResources();
				
				this.setStatus( ExtensionEnum.EXT_WAITING );
				
				return true;
			}
			
			return false;
		}
		
		override public function terminate():Boolean
		{
			if( this.status == ExtensionEnum.EXT_RUNNING )
			{
				this.internalSuspend(null);
			}
			
			return true;
		}
		
		override public function undoStatusChange():void {}
		
		override public function deconstruct():void {}
		
		private function videoAttachedHandler( value:Video ):void
		{
			// Video Attached
			
			_vid = value;

			this.determineIfConnectedResources();
		}
		
		private function cameraAttachedHandler( value:Camera ):void
		{
			// Camera Attached
			_cam = value;
			
			this.determineIfConnectedResources();
		}
		
		private var _internalStarted:Boolean = false;
		
		private function internalStart():void
		{
			if( !_internalStarted)
			{
				trace(" shutterbug internally starting ");
				
				if( this._loops > 0 )
					this._interval = flash.utils.setInterval( this.loop, this._delay );
				
				_internalStarted = true;
				
				this.setStatus( ExtensionEnum.EXT_RUNNING );
			}
		}
		
		private function internalSuspend( event:DeviceConnectionNotifierEvent=null ):void
		{
			flash.utils.clearInterval( this._interval );
		}
		
		private function determineIfConnectedResources():void
		{
			if( _cam != null && _vid != null && this.status == ExtensionEnum.EXT_VIRGIN )
			{
				// Start the Extension
				this.internalStart();
			}
		}
		
		private function makeEventConnectionsToNotifier( notifier:DeviceConnectionNotifier ):void
		{
			notifier.addEventListener( DeviceConnectionNotifierEvent.CAMERA_DETACHED, this.internalSuspend);
			notifier.addEventListener( DeviceConnectionNotifierEvent.MICROPHONE_DETACHED, this.internalSuspend );
			notifier.addEventListener( DeviceConnectionNotifierEvent.NETWORK_DIED, this.internalSuspend );
		}
		
		override raf function connect( stream:ExtendableStreamControl ):void
		{
			use namespace raf;
			super.connect( stream );
			
			// We want both the Camera and Video attached so we won't start recording black
			this.control.requestExternalResource( ResourceEnum.CAMERA, this.cameraAttachedHandler );
			this.control.requestExternalResource( ResourceEnum.VIDEO, this.videoAttachedHandler );
			
		}
		
	}
}