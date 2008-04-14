////////////////////////////////////////////////////////////////////////////////
//
//  Copyright (C) 2007-2008 Infrared5 Incorporated
//  All Rights Reserved. The following is Source Code and is subject to all
//  restrictions on such code as contained in the End User License Agreement
//  accompanying this product.
//
////////////////////////////////////////////////////////////////////////////////

package com.infrared5.asmf.controls.flex.video
{
	import com.infrared5.asmf.Red5BootStrapper;
	import com.infrared5.asmf.business.Red5ServiceLocator;
	import com.infrared5.asmf.events.Red5Event;
	import com.infrared5.asmf.media.rtp.Red5NetStreamConnector;
	import com.infrared5.asmf.net.rpc.Red5Connection;
	import com.infrared5.io.devices.VideoOutputDevice;
	
	import flash.events.Event;
	import flash.events.SyncEvent;
	import flash.net.SharedObject;
	
	import mx.controls.listClasses.BaseListData;
	import mx.controls.listClasses.IListItemRenderer;
	import mx.core.UIComponent;
	import mx.events.FlexEvent;
	
	//use namespace jedai;
	
	//--------------------------------------
	//  Events
	//--------------------------------------
	
	/**
	 *  Dispatched when the user presses the login control.
	 *
	 *  @eventType com.infrared5.asmf.events.LoginEvent.LOGIN
	 */
	[Event(name="login", type="com.infrared5.asmf.events.LoginEvent")]

	//--------------------------------------
	//  Other metadata
	//--------------------------------------
	
	[IconFile("../../../../../../../resources/icons/build/VideoPlayBack.png")]
	
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
	public class VideoSubscriber extends UIComponent implements IListItemRenderer
	{
		include "../../../../../../core/Version.as";
		
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
	
		private var bootStrapper:Red5BootStrapper;
		
		/**
		 *  @private components
		 */
		public var streamName:String = null;
		
		/**
	     *  The internal UITextField object that renders the label of this Button.
	     * 
	     *  @default null 
	     */
	   // Network
		private var _connection:Red5Connection = null;		
		private var _streamOut:Red5NetStreamConnector =  null;
		private var _outputDevice	: VideoOutputDevice;
	    private var _outputDeviceWrapper : UIComponent;
	    private var _so:SharedObject = null;
	    private var _data:*;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
	
		/**
		 *  Constructor.
		 */
		public function VideoSubscriber()
		{
			super();
			this.addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
		} 
		
				
		/**
		 *  The data to render or edit.
		 */
		public function get data():Object {
			return this._data;
		}
		
		/**
		 *  @private
		 */
		public function set data(value:Object):void {
			
			if(this._data == null) {
				this._data = value;
				if (!_outputDevice)
		        {
		            _outputDevice = new VideoOutputDevice();
		            _outputDeviceWrapper = new UIComponent();
		            _outputDeviceWrapper.addChild(_outputDevice);	
		            this.addChild(_outputDeviceWrapper);
		        } 
				startStream(String(value));
			}
		}
		
		/**
     *  @private
     *  Storage for the listData property.
     */
    private var _listData:BaseListData;
/* 
    [Bindable("dataChange")]
    [Inspectable(environment="none")] */

    /**
     *  When a component is used as a drop-in item renderer or drop-in
     *  item editor, Flex initializes the <code>listData</code> property
     *  of the component with the appropriate data from the List control.
     *  The component can then use the <code>listData</code> property
     *  to initialize the <code>data</code> property of the drop-in
     *  item renderer or drop-in item editor.
     *
     *  <p>You do not set this property in MXML or ActionScript;
     *  Flex sets it when the component is used as a drop-in item renderer
     *  or drop-in item editor.</p>
     *
     *  @default null
     *  @see mx.controls.listClasses.IDropInListItemRenderer
     */
    public function get listData():BaseListData
    {
        return _listData;
    }

    /**
     *  @private
     */
    public function set listData(value:BaseListData):void
    {
        _listData = value;
    }

		
		/**
		 * 
		 * @param event
		 * 
		 */		
		private function onCreationComplete(event:FlexEvent) : void {
			//this.enabled = false;
			bootStrapper = Red5BootStrapper.getInstance();
			bootStrapper.addEventListener("bootStrapComplete", onBootStrapComplete); 
			bootStrapper.addEventListener(Red5Event.CONNECTED, onConnected);
			
			//this.publish.addEventListener(MouseEvent.CLICK, onPublish);
		
			// is this an itemrenderer
			
			if(this._data != null) {			
				this.streamName = String(this._data);
				//playStream(this.streamName);	
			}
			
			
			
		} 
		
		public function onSync(event:SyncEvent) : void {
			trace("event: " + event);
			
			var list:Array = event.changeList;
			trace("event.changeList.length: " + event.changeList.length);
			
			for(var i:Number=0; i<list.length; i++){
				switch(list[i].code) {
					case "clear":
						trace("list[" + i + "].code: " + list[i].code);
						break;
					case "success":
						trace("list[" + i + "].code: " + list[i].code);
						//output.text += so.data[(list[i].name)];
						break;
					case "reject":
						trace("list[" + i + "].code: " + list[i].code);
						break;
					case "change":
						trace("list[" + i + "].code: " + list[i].code);
						startStream(event.target.data[list[i].name]);
						/* users.removeAll(); */
						/* for (var key:String in event.target.data)
						{
						    trace(key + ": " + event.target.data[key]);
						    users.addItem(event.target.data[key]);
						} */
									
						//output.text += so.data[(list[i].name)]
						break;
					case "delete":
						stopStream()
						/* for (var key:String in event.target.data)
						{
						    trace(key + ": " + event.target.data[key]);
						    users.removeAll();
						    var removeIndex:int = users.getItemIndex(event.target.data[key]);
						    users.removeItemAt(removeIndex);
//						    users.addItem(event.target.data[key]);
						} */
						
						/* for (var key1:String in event.target.data)
						{
						    trace(key1 + ": " + event.target.data[key1]);
						    users.addItem(event.target.data[key1]);
						} */
						
						trace("list[" + i + "].code: " + list[i].code);
						break;
				}			
			} 	
		}
		
		private function stopStream() : void {
			/* video.attachNetStream(null);
			video.clear();
			playingFlag = false; */
		}
		
		private function startStream(val:String) : void {
				/* 
				if(!playingFlag) {
					playingFlag = true;
					ns = new NetStream(conn);
					video = new Video();
					comp = new UIComponent();
					comp.addChild(video);
					this.addChild(comp);
					video.attachNetStream(ns);
					ns.play(val);
					video.width = this.vBox2.width;
					video.height = this.vBox2.height;
				} */
				
			//_connection = Red5ServiceLocator.getInstance().getRed5Connection("default");	
			//var rso:RemoteSharedObject = Red5ServiceLocator.getInstance().getRemoteSharedObject("clientlist");
			
			
			_streamOut = new Red5NetStreamConnector( Red5ServiceLocator.getInstance().getRed5Connection("default") );
			_streamOut.play(val);	
			_outputDevice.attachInputFrom(_streamOut.getStream());
			_outputDevice.width = 200;
			_outputDevice.height = 200;
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
			/* trace("event: " + event);
			this.enabled = true; */
			_connection = Red5ServiceLocator.getInstance().getRed5Connection("default");	
			
			if(streamName == null) {
				// Set up remoteSharedObject stuff			
				_so = SharedObject.getRemote("streamlist", this._connection.uri);
				_so.connect(this._connection);									
				_so.addEventListener(SyncEvent.SYNC, onSync);
			} else {				
				startStream(this.streamName);
			}
				
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
			_outputDevice.height = this.unscaledHeight - 20; 
			
			
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Getter / Setter 
		//
		//--------------------------------------------------------------------------

		
	}
}