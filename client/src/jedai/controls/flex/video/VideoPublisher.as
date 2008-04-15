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
	import jedai.Red5BootStrapper;
	import jedai.business.Red5ServiceLocator;
	import jedai.events.Red5Event;
	import jedai.media.rtp.Red5NetStreamConnector;
	import jedai.net.rpc.Red5Connection;
	import jedai.net.rpc.RemoteSharedObject;
	import jedai.io.devices.AudioInputDevice;
	import jedai.io.devices.VideoInputDevice;
	import jedai.io.devices.VideoOutputDevice;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.NetStatusEvent;
	import flash.media.Microphone;
	
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
	 *  @author Dominick Accattato (dominick@infrared5.com)
	 */
	public class VideoPublisher extends UIComponent
	{
		include "../../../../config/jedai/Version.as";
		
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
	    protected var _publish:Button;
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
			
			this._publish.addEventListener(MouseEvent.CLICK, onPublish);
			
			
		} 
		
		private function onPublish(event:MouseEvent) : void {
			//camera = Camera.getCamera();
			
			
			// guard agains null
			//if(_connection == null) return;				
				
				switch(_publish.label) {
					case "Start Broadcast":
						startStream();
						break;
						
					case "Stop broadcasting":
						stopStream();
						break;
						
					default:
						break;
						
				}
				
				_publish.label = (_publish.label == "Start Broadcast") ? "Stop broadcasting" : "Start Broadcast";
		}
		
		private function stopStream() : void {
			_streamIn.getStream().close();
		}
		
		/**
		 * Helper method to start a NetStream
		 * 
		 * @return void
		 **/
		private function startStream() : void {
			// create the netStream object and pass 
			// the netConnection object in the constructor
			_streamIn = new Red5NetStreamConnector( _connection );
			//_streamOut = new Red5NetStreamConnector( _connection );
			
			_inputDevice = new VideoInputDevice( true );
			_inputDevice.attachOutputTo( _streamIn.getStream() );
			_streamIn.publish("test", "live");
			
			//_outputDevice = new VideoOutputDevice();
			_outputDevice.attachInputFrom( _inputDevice );
			_outputDevice.width = 200;
			_outputDevice.height = 200;
		
			_microphone = Microphone.getMicrophone();
			_microphone.setUseEchoSuppression(true);
			
			audioIn = new AudioInputDevice();
			audioIn.attachOutputTo( _streamIn.getStream() );
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
				//_outputDeviceWrapper.addChild( _outputDevice );
	            this.addChild(_outputDeviceWrapper);
	        } 
	        
	        if (!_publish)
	        {
	            _publish = new Button();
	            _publish.label = "Start Broadcast";
	            this.addChild(_publish);
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
			
			measuredHeight = measuredMinHeight = 60;
			measuredWidth = measuredMinWidth = 120;
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
			var size = (padding + 50);
			var formDist:int = 25;
			
			_outputDevice.width = this.unscaledWidth - 10;
			_outputDevice.height = this.unscaledHeight - this._publish.getExplicitOrMeasuredHeight() - 20;
			/* _outputDeviceWrapper.width = this.unscaledWidth - 10;
			_outputDeviceWrapper.height = this.unscaledHeight - this._publish.getExplicitOrMeasuredHeight() - 20;
			 */_publish.setActualSize(_publish.getExplicitOrMeasuredWidth(), _publish.getExplicitOrMeasuredHeight());
			_publish.move(this.unscaledWidth - _publish.getExplicitOrMeasuredWidth() - 10, this.unscaledHeight - _publish.getExplicitOrMeasuredHeight() - 10);
			 
			
		/* 
			// usernameField size and position
			usernameField.setActualSize((unscaledWidth - size), usernameField.getExplicitOrMeasuredHeight());
			usernameField.move(leftPos, topPos); 
			
			// usernameLabel size and position
			leftPos = padding;
			usernameLabel.setActualSize(usernameLabel.getExplicitOrMeasuredWidth(), usernameLabel.getExplicitOrMeasuredHeight());
			usernameLabel.move(leftPos, topPos);
			
			// passwordField size and position
			topPos += formDist;
			leftPos = 50;
			passwordField.setActualSize((unscaledWidth - size), passwordField.getExplicitOrMeasuredHeight());
			passwordField.move(leftPos, topPos);  
			
			// passwordLabel size and position
			leftPos = padding;
			passwordLabel.setActualSize(passwordLabel.getExplicitOrMeasuredWidth(), passwordLabel.getExplicitOrMeasuredHeight());
			passwordLabel.move(leftPos, topPos);
			
			// loginButton size and position
			topPos += formDist;
			leftPos = unscaledWidth - loginButton.getExplicitOrMeasuredWidth() - padding;
			loginButton.setActualSize(loginButton.getExplicitOrMeasuredWidth(), loginButton.getExplicitOrMeasuredHeight());
			loginButton.move(leftPos, topPos); */
			/* 
			box.setActualSize(unscaledWidth, unscaledHeight);
			box.buttonMode = true; */
			
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