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
	import jedai.net.ClientManager;
	import jedai.net.ConnectionServices;
	import jedai.net.rpc.Red5Connection;
	
	import flash.events.MouseEvent;
	import flash.events.SyncEvent;
	import flash.media.Camera;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.net.SharedObject;
	import flash.utils.Dictionary;
	
	import mx.collections.ArrayCollection;
	import mx.containers.VBox;
	import mx.controls.Button;
	import mx.controls.TileList;
	import mx.core.ClassFactory;
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
	
	[IconFile("../../../../../resources/icons/build/VideoTile.png")]
	
	/**
	 *  A Login component allows the user to input a username
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
	 *  &lt;jedai:Login&gt;
	 *    ...
	 *      <i>child tags</i>
	 *    ...
	 *  &lt;/jedai:Login&gt;
	 *  </pre>
	 *  </p>
	 *  
	 *  @includeExample examples/SimpleCanvasExample.mxml
	 * 
	 *  @author Dominick Accattato (dominick_AT_infrared5_DOT_com)
	 */
	 [Bindable]
	public class VideoTile extends TileList
	{
		include "../../../../config/jedai/Version.as";
		
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
	
		private var bootStrapper:Red5BootStrapper;
		
		public var streamName:String = null;
		public var video:Video = null;
		public var play:Button = null;
		public var vBox2:VBox = null;
		public var vBox1:VBox = null;
		
		public var _clazz:Class = null;
		
		public var conn:NetConnection = null;
		private var so:SharedObject = null;
		
		public var ns:NetStream = null;
		private var cam:Camera = null;
		
		private var connectionManager:ConnectionServices = null;
		private var client:ClientManager = null;
		private var playingFlag:Boolean = false;
		private var videosArray:ArrayCollection = new ArrayCollection();
		private var videosDict:Dictionary = new Dictionary();
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
	
		/**
		 *  Constructor.
		 */
		public function VideoTile()
		{
			super();
			this.addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
			this.addEventListener(MouseEvent.CLICK, onMouseClick);
		} 
		
		public function onMouseClick(event:MouseEvent) : void {
			trace(event);
		}
		
		/**
		 * 
		 * @param event
		 * 
		 */		
		private function onCreationComplete(event:FlexEvent) : void {
			//this.enabled = false;
			bootStrapper = Red5BootStrapper.getInstance();
			bootStrapper.addEventListener(Red5Event.CONNECTED, onConnected);
			this.dataProvider = this.videosArray;
		} 
		
		public function onConnected(connected:Boolean) : void {			
			// guard agains null
			if(!connected) return;
			this.enabled = true;
			//this.conn = connectionManager.connection;	
			//this.client = ClientManager(ConnectionServices.getInstance().clientManager);	
			this.itemRenderer = new ClassFactory(VideoSubscriber);
			var conn:Red5Connection = Red5ServiceLocator.getInstance().getRed5Connection("default");
			
			trace("clazz: " + this._clazz);
			// Set up remoteSharedObject stuff			
			so = SharedObject.getRemote("streamlist", conn.uri);
			so.connect(conn);									
			so.addEventListener(SyncEvent.SYNC, onSync);
							
		}
		
		public function onSync(event:SyncEvent) : void {
			trace("event: " + event);
			
			var list:Array = event.changeList;
			trace("event.changeList.length: " + event.changeList.length);
			
 			for(var i:Number=0; i<list.length; i++){
				switch(list[i].code) {
					case "clear":
						//videosArray = new ArrayCollection();
						videosArray.removeAll();
						videosDict = new Dictionary();
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
						
						for (var key:String in event.target.data)
						{
							trace(key + ": " + event.target.data[key]);
														
							// if the stream is not already in the grid 
							// and if the streamName is not the same as the current client
							//if(videosDict[key] == null && event.target.data[key] != this.client.username) {														    
							    videosArray.addItem(event.target.data[key]);
							//}
							
							videosDict[key] = event.target.data[key];
							    
						}
												
						break;
						
					case "delete":
					
						for(var j:int=0; j<list.length; j++)
//						for (var key:String in event.target.data)
						{
							//trace(key + ": " + event.target.data[key]);
							
							// if the stream is not already in the grid 
							// and if the streamName is not the same as the current client
							trace("videosDict[list[j].name]: " + videosDict[list[j].name]);
							if(videosDict[list[j].name] != this.client.username) {													    
							    var index:int = videosArray.getItemIndex(videosDict[list[j].name]);
								videosArray.removeItemAt(index);
								videosDict[list[j].name] = null;	
							}
							    
						}					
						
						trace("list[" + i + "].code: " + list[i].code);
						break;
				}			
			} 	
		}		
		
		public function set clazz(val:Class) : void {
			this._clazz = val;
		}
	
		
	}
}