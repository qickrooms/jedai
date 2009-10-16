////////////////////////////////////////////////////////////////////////////////
//
//  Copyright (C) 2007-2008 Infrared5 Incorporated
//  All Rights Reserved. The following is Source Code and is subject to all
//  restrictions on such code as contained in the End User License Agreement
//  accompanying this product.
//
////////////////////////////////////////////////////////////////////////////////

package jedai.controls.flex.video
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.NetStatusEvent;
	import flash.media.Microphone;
	
	import jedai.Red5BootStrapper;
	import jedai.business.Red5ServiceLocator;
	import jedai.controls.flex.jedaiUI;
	import jedai.events.Red5Event;
	import jedai.io.devices.AudioInputDevice;
	import jedai.io.devices.VideoInputDevice;
	import jedai.io.devices.VideoOutputDevice;
	import jedai.media.rtp.Red5NetStreamConnector;
	import jedai.net.rpc.Red5Connection;
	
	import mx.containers.Box;
	import mx.controls.Button;
	import mx.core.UIComponent;
	import mx.events.FlexEvent;
	
	//use namespace jedai;
	
	//--------------------------------------
	//  Events
	//--------------------------------------
	
	/**
	 *  Dispatched when the user presses the login control.
	 *
	 *  @eventType jedai.events.LoginEvent.LOGIN
	 */
	[Event(name="login", type="jedai.events.LoginEvent")]

	//--------------------------------------
	//  Other metadata
	//--------------------------------------
	
	[IconFile("../../../../../resources/icons/build/VideoRecord.png")]
	
	/**
	 *  A VideoPublisher component allows the user to input a username
	 *  and a password.  These values are later used for authenticating
	 *  against a remote server such as Red5. 
	 *
	 *  @mxml
	 *
	 *  <p>The <code>&lt;jedai:Login&gt;</code> tag inherits all the tag attributes
	 *  of its superclass. Use the following syntax:</p>
	 *
	 *  <p>
	 *  <pre>
	 *  &lt;jedai:VideoPublisher&gt;
	 *    ...
	 *      <i>child tags</i>
	 *    ...
	 *  &lt;/jedai:VideoPublisher&gt;
	 *  </pre>
	 *  </p>
	 *  
	 *  @includeExample examples/SimpleCanvasExample.mxml
	 * 
	 *  @author Dominick Accattato (dominick_AT_infrared5_DOT_com)
	 */
	 public class VideoPublisher extends UIComponent
	{
		//include "../../../../config/jedai/Version.as";
		
		//public namespace raf = "raf/internal";
		
		jedaiUI function getTestWidth() : int {
			return this.getExplicitOrMeasuredWidth();
		}
		
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
	
		private var bootStrapper:Red5BootStrapper;
		
		/**
		 *  @private components
		 */
		 
		 // Exposed Properties
		private var _streamName:String = null;
		private var _live:Boolean = false;

		/**
	     *  The internal UITextField object that renders the label of this Button.
	     * 
	     *  @default null 
	     */
	    //protected var _camera:VideoInputDevice;
	    //protected var _loopbackVideo:VideoDisplay;
	    
	    // refactoring publish button out to it's own component
	    // TBD
	    protected var _publish:Button;
	    
	    protected var cont1:Box;
	    
	    //protected var _microphone:Microphone;
	    //protected var _netStream:Red5NetStream;
	   // public var streamConn	: Red5NetStreamConnector;
	    private var _outputDevice	: VideoOutputDevice;
	    private var _outputDeviceWrapper : UIComponent;
	    
	    // Camera Specific
		private var _cameraWidth:int = 160;
		private var _cameraHeight:int = 120;
		private var _fps:Number = 15;
		private var _favorArea:Boolean = true;
	    
	    // Network
		private var _connection:Red5Connection = null;		
		private var _streamIn:Red5NetStreamConnector =  null;
		private var _streamOut:Red5NetStreamConnector =  null;
		private var _inputDevice:VideoInputDevice = null;
		private var _microphone:Microphone = null;
		private var audioIn		: AudioInputDevice;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
	
		/**
		 *  Constructor.
		 */
		public function VideoPublisher()
		{
			super();
			this.addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
		} 
		
		/**
		 * 
		 * @param event
		 * 
		 */		
		private function onCreationComplete(event:FlexEvent) : void {
			this.enabled = false;
			this.mouseChildren = false;
			bootStrapper = Red5BootStrapper.getInstance();
			bootStrapper.addEventListener("bootStrapComplete", onBootStrapComplete); 
			bootStrapper.addEventListener(Red5Event.CONNECTED, onConnected);
			
			if(bootStrapper.connection != null && bootStrapper.connection.connected) {
				onConnected(null);
			}
		} 
		
		public function stopStream() : void {
			_streamIn.getStream().close();
		}
		
		/**
		 * Helper method to start a NetStream
		 * 
		 * @return void
		 **/
		public function startStream() : void {
			// create the netStream object and pass 
			// the netConnection object in the constructor
			_streamIn = new Red5NetStreamConnector( _connection );
			
			_inputDevice = new VideoInputDevice( true );
			_inputDevice.attachOutputTo( _streamIn.getStream() );
			_streamIn.publish("test", "live");
			
			_outputDevice.attachInputFrom( _inputDevice );
		
			_microphone = Microphone.getMicrophone();
			_microphone.setUseEchoSuppression(true);
			
			audioIn = new AudioInputDevice();
			audioIn.attachOutputTo( _streamIn.getStream() );
		}
		
		private var tmpGain:int = 50; // 50 is normal volume
		
		public function mute() : void {
			/* var soundTrans:SoundTransform = new SoundTransform();
		    soundTrans.volume = 0; */
			//audioIn.inputDevice.soundTransform = soundTrans;
			audioIn.inputDevice.gain = 0;
		}
		
		public function unmute() : void {
			/* var soundTrans:SoundTransform = new SoundTransform();
		    soundTrans.volume = 10; */
			audioIn.inputDevice.gain = tmpGain;
		}
		
		private function onNetStatus(event:NetStatusEvent) : void {
			trace("event: " + event);
		}
		
		private function onIOError(event:IOErrorEvent) : void {
			trace("event: " + event);
		}
		
		/**
		 * 
		 * @param event
		 * 
		 */		
		private function onBootStrapComplete(event:Event) : void {
			
		} 
		
		/**
		 * 
		 * @param event
		 * 
		 */		
		private function onConnected(event:Red5Event) : void {
			this.enabled = true; 
			this.mouseChildren = true;
			_connection = Red5ServiceLocator.getInstance().getRed5Connection("default");	
			
			//rso.addEventListener(SyncEvent.SYNC, onSync);	
		}
		
		//--------------------------------------------------------------------------
		//
		//  Flex Framework Lifecycle
		//
		//--------------------------------------------------------------------------
		
		/**
		 * 
		 * 
		 */		
		override protected function createChildren():void {
			super.createChildren();
			
			if (!_outputDevice)
	        {
	            _outputDevice = new VideoOutputDevice();
	            _outputDeviceWrapper = new UIComponent();
	            _outputDeviceWrapper.addChild(_outputDevice);	
	            this.addChild(_outputDeviceWrapper);
	        } 

			if (!cont1) {
				cont1 = new Box();
				this.addChild(cont1);
			}
	      
		} 
		
		/**
		 * 
		 * 
		 */		 
		override protected function commitProperties():void {
			super.commitProperties();
		} 
		
		/**
		 * 
		 * 
		 */		
		override protected function measure():void {
			super.measure();
			
			measuredHeight = measuredMinHeight;
			measuredWidth = measuredMinWidth;
		}
		
		/**
		 * 
		 * @param unscaledWidth
		 * @param unscaledHeight
		 * 
		 */		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			 
			// padding
			 var padding:int = 10;
			
			// position
			var leftPos:int = 50;
			var rightPos:int = 10;
			var topPos:int = 10;
			var bottomPos:int = 10;
			var size:int = (padding + 50);
			var formDist:int = 25;
			
			_outputDevice.width = this.unscaledWidth;
			_outputDevice.height = this.unscaledHeight
			
	        graphics.clear();
	        graphics.lineStyle(1, 1, 1);
	        graphics.moveTo(0,0);
	        graphics.lineTo(this.unscaledWidth, 0);
	        graphics.lineTo(this.unscaledWidth, this.unscaledHeight);
	        graphics.lineTo(0, this.unscaledHeight);
	        graphics.lineTo(0,0);	        
	        graphics.endFill();			
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Getter / Setter 
		//
		//--------------------------------------------------------------------------
				
		/**
		 * get the Camera object
		 * 
		 * @return streamName String
		 **/
		public function get streamName() : String {
			return this._streamName;
		}
		
		/**
		 * get the Camera object
		 * 
		 * @return streamName String
		 **/
		public function set streamName(val:String) : void {
			this._streamName = val;
		}
		
		/**
		 * get the cameraWidth 
		 * 
		 * @return cameraWidth int
		 **/
		public function get cameraWidth() : int {
			return this._cameraWidth;
		}
		
		/**
		 * set the cameraWidth 
		 * 
		 * @param val int
		 * @return void
		 **/
		public function set cameraWidth(val:int) : void {
			this._cameraWidth = val;
		}
		
		/**
		 * get the cameraHeight 
		 * 
		 * @return cameraHeight int
		 **/
		public function get cameraHeight() : int {
			return this._cameraHeight;
		}
		
		/**
		 * set the cameraHeight 
		 * 
		 * @param val int
		 * @return void
		 **/
		public function set cameraHeight(val:int) : void {
			this._cameraHeight = val;
		}
		
		/**
		 * get the fps 
		 * 
		 * @return fps Number
		 **/
		public function get fps() : Number {
			return this._fps;
		}
		
		/**
		 * set the fps 
		 * 
		 * @param val Number
		 * @return void
		 **/
		public function set fps(val:Number) : void {
			this._fps = val;
		}
		
		/**
		 * get the favorArea 
		 * 
		 * @return favorArea String
		 **/
		public function get favorArea() : Boolean {
			return this._favorArea;
		}
		
		/**
		 * set the favorArea 
		 * 
		 * @param val Boolean
		 * @return void
		 **/
		public function set favorArea(val:Boolean) : void {
			this._favorArea = val;
		}

		
	}
}