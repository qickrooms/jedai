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
	import com.infrared5.asmf.net.rpc.Red5Connection;
	import com.infrared5.asmf.net.rpc.RemoteSharedObject;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.SyncEvent;
	
	import mx.controls.Button;
	import mx.controls.Label;
	import mx.controls.TextInput;
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
	
	/* [IconFile("6.png")] */
	
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
	 *  @author Dominick Accattato (dominick@infrared5.com)
	 */
	public class VideoPlayer extends UIComponent
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
		private var _username:String;
	    private var usernameChanged:Boolean = false;
		private var _password:String;
	    private var passwordChanged:Boolean = false;
		
		/**
	     *  The internal UITextField object that renders the label of this Button.
	     * 
	     *  @default null 
	     */
	    protected var usernameField:TextInput;
	    protected var passwordField:TextInput;
	    protected var usernameLabel:Label;
	    protected var passwordLabel:Label;
	    protected var loginButton:Button;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
	
		/**
		 *  Constructor.
		 */
		public function VideoPlayer()
		{
			super();
			this.addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
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
		private function onCreationComplete(event:FlexEvent) : void {
			//this.enabled = false;
			bootStrapper = Red5BootStrapper.getInstance();
			bootStrapper.addEventListener("bootStrapComplete", onBootStrapComplete); 
			bootStrapper.addEventListener(Red5Event.CONNECTED, onConnected);
		} 
		
		/**
		 * 
		 * @param event
		 * 
		 */		
		private function onConnected(event:Red5Event) : void {
			/* trace("event: " + event);
			this.enabled = true; */
			
			var conn:Red5Connection = Red5ServiceLocator.getInstance().getRed5Connection("default");	
			var rso:RemoteSharedObject = Red5ServiceLocator.getInstance().getRemoteSharedObject("streamlist");
			rso.addEventListener(SyncEvent.SYNC, onSync);	
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
			/* 
			if (!usernameField)
	        {
	            usernameField = new TextInput();
	            this.addChild(usernameField);
	        }  */
	        
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
			
			/* measuredHeight = measuredMinHeight = this.usernameField.getExplicitOrMeasuredHeight() + this.passwordField.getExplicitOrMeasuredHeight() + this.loginButton.getExplicitOrMeasuredHeight();
			measuredWidth = measuredMinWidth = this.usernameField.getExplicitOrMeasuredWidth() + 20; */
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
			/* var padding:int = 10;
			
			// position
			var leftPos:int = 50;
			var rightPos:int = 10;
			var topPos:int = 10;
			var bottomPos:int = 10;
			var size = (padding + 50);
			var formDist:int = 25;
		
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
		 * 
		 * @return 
		 * 
		 */		
		public function get username():String
	    {
	        return _username;
	    } 
	
	    /**
	     *  @private
	     */
	    public function set username(value:String):void {
	    	this._username = value;
	    	
	    	if (_username != value)
	        {
	            _username = value;
	            usernameChanged = true;
	
	            invalidateDisplayList();
	
	            dispatchEvent(new Event("usernameChanged"));
	        }
	    }
	    
	    /**
	     * 
	     * @return 
	     * 
	     */	    
	    public function get password():String
	    {
	        return _password;
	    } 
	 
		/**
		 *  @private
		 */
	    public function set password(value:String):void {
	    	this._password = value;
	    	
	    	if (_password != value)
	        {
	            _password = value;
	            passwordChanged = true;
	
	            invalidateDisplayList();
	
	            dispatchEvent(new Event("passwordChanged"));
	        }
	    } 
		
	}
}