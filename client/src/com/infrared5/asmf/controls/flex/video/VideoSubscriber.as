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
	import flash.media.Camera;
	
	import mx.controls.Button;
	import mx.controls.VideoDisplay;
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
	public class VideoSubscriber extends UIComponent
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
		/* private var _username:String;
	    private var usernameChanged:Boolean = false;
		private var _password:String;
	    private var passwordChanged:Boolean = false; */
		
		/**
	     *  The internal UITextField object that renders the label of this Button.
	     * 
	     *  @default null 
	     */
	    protected var camera:Camera;
	    protected var loopbackVideo:VideoDisplay;
	    protected var publish:Button;
		
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
		 * 
		 * @param event
		 * 
		 */		
		private function onCreationComplete(event:FlexEvent) : void {
			//this.enabled = false;
			bootStrapper = Red5BootStrapper.getInstance();
			bootStrapper.addEventListener("bootStrapComplete", onBootStrapComplete); 
			bootStrapper.addEventListener(Red5Event.CONNECTED, onConnected);
			
			this.publish.addEventListener(MouseEvent.CLICK, onPublish);
			
			
		} 
		
		private function onPublish(event:MouseEvent) : void {
			camera = Camera.getCamera();
			loopbackVideo.attachCamera(camera);
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
			
			var conn:Red5Connection = Red5ServiceLocator.getInstance().getRed5Connection("default");	
			var rso:RemoteSharedObject = Red5ServiceLocator.getInstance().getRemoteSharedObject("clientlist");
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
			
			if (!loopbackVideo)
	        {
	            loopbackVideo = new VideoDisplay();
	            this.addChild(loopbackVideo);
	        } 
	        
	        if (!publish)
	        {
	            publish = new Button();
	            this.addChild(publish);
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
			
			measuredHeight = measuredMinHeight = this.loopbackVideo.getExplicitOrMeasuredHeight();
			measuredWidth = measuredMinWidth = this.loopbackVideo.getExplicitOrMeasuredWidth();
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
			
			loopbackVideo.setActualSize(unscaledWidth, unscaledHeight);
			
			publish.move(loopbackVideo.getExplicitOrMeasuredWidth() + 10, loopbackVideo.getExplicitOrMeasuredHeight() - publish.getExplicitOrMeasuredWidth());
			
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

		
	}
}