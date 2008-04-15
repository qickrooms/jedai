////////////////////////////////////////////////////////////////////////////////
//
//  Copyright (C) 2007-2008 Infrared5 Incorporated
//  All Rights Reserved. The following is Source Code and is subject to all
//  restrictions on such code as contained in the End User License Agreement
//  accompanying this product.
//
////////////////////////////////////////////////////////////////////////////////

package com.infrared5.asmf.controls.flex.data
{
	import com.infrared5.asmf.Red5BootStrapper;
	import com.infrared5.asmf.business.Red5ServiceLocator;
	import com.infrared5.asmf.events.Red5Event;
	import com.infrared5.asmf.net.ClientManager;
	import com.infrared5.asmf.net.rpc.Red5Connection;
	import com.infrared5.asmf.net.rpc.RemoteSharedObject;
	
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.SyncEvent;
	import flash.net.SharedObject;
	import flash.ui.Keyboard;
	
	import mx.controls.Button;
	import mx.controls.TextArea;
	import mx.controls.TextInput;
	import mx.core.UIComponent;
	import mx.events.FlexEvent;
	
	//use namespace jedai;
	
	//--------------------------------------
	//  Events
	//--------------------------------------
	
	/**
	 *  Dispatched when the user changes the chat.
	 *
	 *  @eventType com.infrared5.asmf.events.ChatChangedEvent.CHAT_CHANGED
	 */
	[Event(name="login", type="com.infrared5.asmf.events.ChatChangedEvent")]

	//--------------------------------------
	//  Other metadata
	//--------------------------------------
	
	[IconFile("../../../../../../../resources/icons/build/chatpng.png")]
	
	/**
	 *  A Chat component allows the user to chat with others in room.  
	 *
	 *  @mxml
	 *
	 *  <p>The <code>&lt;jedai:Chat&gt;</code> tag inherits all the tag attributes
	 *  of its superclass. Use the following syntax:</p>
	 *
	 *  <p>
	 *  <pre>
	 *  &lt;jedai:Chat&gt;
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
	public class Chat extends UIComponent
	{
		private var bootStrapper:Red5BootStrapper;
		
		private var chat:TextArea = null;
		private var input:TextInput = null;
		private var submit:Button = null;
		var rso:RemoteSharedObject = null;
		
		public function Chat()
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
			bootStrapper = Red5BootStrapper.getInstance();
			bootStrapper.addEventListener("bootStrapComplete", onBootStrapComplete); 
			bootStrapper.addEventListener(Red5Event.CONNECTED, onConnected);
			input.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			/* this.input.enabled = false;
			this.submit.enabled = false; */
			this.enabled = false;
		} 
		
		private function onSubmitClick(event:MouseEvent) : void {
			var cm:ClientManager = Red5BootStrapper.getInstance().client;
			var s:String = "";
			s += input.text;
			var ret : String = cm.username + ": " + s + "\n";
			chat.text += ret;
			input.text = "";
			
			rso.so().setProperty("chat", ret);
		}
		
		public function onKeyDown(event:KeyboardEvent) : void {
			trace("event: " + event);
			var cm:ClientManager = Red5BootStrapper.getInstance().client;
			if(event.keyCode == Keyboard.ENTER) {
				var s:String = "";
				s += input.text;
				var ret : String = cm.username + ": " + s + "\n";
				chat.text += ret;
				input.text = "";
				
				rso.so().setProperty("chat", ret);
				chat.verticalScrollPosition = chat.maxVerticalScrollPosition;
			}
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
			rso = Red5ServiceLocator.getInstance().getRemoteSharedObject("chat");
			rso.addEventListener(SyncEvent.SYNC, onSync);	
			/* this.input.enabled = true;
			this.submit.enabled = true; */
			this.enabled = true;
		}
		
		/**
		* callback method that responds to SyncEvent events dispatched from a remote SharedObject
		*
		* @arg
		*	event SyncEvent
		**/	
		public function onSync(event:SyncEvent) : void {
			trace("event: " + event);
			
			// a syncEvent holds a property "changeList" which is an array of changes since last sync
			var changeList:Array = event.changeList;
			
			var so:SharedObject = RemoteSharedObject(event.target).so();
			
			// loop through the changeList and determine what type of change they are, "clear", "success", "change", "delete", etc...
			for(var i:Number=0; i<changeList.length; i++){
				switch(changeList[i].code) {
					case "clear":
						trace("changeList[" + i + "].code: " + changeList[i].code);
						chat.htmlText = "";
						break;
					case "success":
						trace("changeList[" + i + "].code: " + changeList[i].code);
						break;
					case "reject":
						trace("changeList[" + i + "].code: " + changeList[i].code);
						break;
					case "change":
						trace("changeList[" + i + "].code: " + changeList[i].code);
						chat.htmlText += so.data[(changeList[i].name)];
						break;
					case "delete":
						trace("changeList[" + i + "].code: " + changeList[i].code);
						chat.htmlText = "";
						break;
				}			
			} 	
			
			chat.verticalScrollPosition = chat.maxVerticalScrollPosition + 1;
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
			
			if (!chat)
	        {
	            chat = new TextArea();
	            this.addChild(chat);
	        } 
	        
	        if (!input)
	        {
	            input = new TextInput();
	            this.addChild(input);
	        }
	        
	         
	        if (!submit)
	        {
	            submit = new Button();
	            submit.label = "Submit:";
	            submit.addEventListener(MouseEvent.CLICK, onSubmitClick);
	            this.addChild(submit);
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
			
			measuredHeight = measuredMinHeight = this.chat.getExplicitOrMeasuredHeight() + this.input.getExplicitOrMeasuredHeight() + 20;
			measuredWidth = measuredMinWidth = this.chat.getExplicitOrMeasuredWidth() + 20;
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
			var leftPos:int = 10;
			var rightPos:int = 10;
			var topPos:int = 10;
			var bottomPos:int = 10;
			var size = (padding + 50);
			var formDist:int = 25;
		
			// chat size and position
			chat.setActualSize((unscaledWidth - (padding*2)), unscaledHeight - 50);
			chat.move(leftPos, topPos); 
			
			// input size and position
			leftPos = padding;
			topPos = unscaledHeight - input.getExplicitOrMeasuredHeight() - padding;
			input.setActualSize(unscaledWidth - 100, input.getExplicitOrMeasuredHeight());
			input.move(leftPos, topPos);
			
			// submit size and position
			//topPos += formDist;
			leftPos = unscaledWidth - submit.getExplicitOrMeasuredWidth() - padding;
			submit.setActualSize(submit.getExplicitOrMeasuredWidth(), submit.getExplicitOrMeasuredHeight());
			submit.move(leftPos, topPos);
			
		
			
		} 
		
		
		//--------------------------------------------------------------------------
		//
		//  Getter / Setter 
		//
		//--------------------------------------------------------------------------
		
		
	}
}