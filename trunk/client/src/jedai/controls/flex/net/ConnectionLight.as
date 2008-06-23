////////////////////////////////////////////////////////////////////////////////
//
//  Copyright (C) 2007-2008 Infrared5 Incorporated
//  All Rights Reserved. The following is Source Code and is subject to all
//  restrictions on such code as contained in the End User License Agreement
//  accompanying this product.
//
////////////////////////////////////////////////////////////////////////////////

package jedai.controls.flex.net
{
	import jedai.Red5BootStrapper;
	import jedai.events.Red5Event;
	import jedai.net.rpc.Red5Connection;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	
	import mx.core.UIComponent;
	import mx.events.FlexEvent;
	
	//use namespace jedai;
	
	//--------------------------------------
	//  Events
	//--------------------------------------
	
	/**
	 *  Dispatched when the user changes the chat.
	 *
	 *  @eventType jedai.events.ChatChangedEvent.CHAT_CHANGED
	 */
	[Event(name="login", type="jedai.events.ChatChangedEvent")]

	//--------------------------------------
	//  Other metadata
	//--------------------------------------
	
	[IconFile("../../../../../resources/icons/build/ConnectionLight.png")]
	
	/**
	 *  A ConnectionLight component allows the user to chat with others in room.  
	 *
	 *  @mxml
	 *
	 *  <p>The <code>&lt;jedai:ConnectionLight&gt;</code> tag inherits all the tag attributes
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
	 *  @author Dominick Accattato (dominick_AT_infrared5_DOT_com)
	 */
	public class ConnectionLight extends UIComponent
	{
		
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		[Embed(source="../../../../../resources/connected.swf")]
		private var IconConnected:Class;
		[Embed(source="../../../../../resources/disconnected.swf")]
		private var IconDisconnected:Class;
		
		private var currentIcon:DisplayObject;
	
		private var bootStrapper:Red5BootStrapper;
		private var connection:Red5Connection;
		
		private var statusChanged:Boolean;
		
		public function ConnectionLight()
		{
			//TODO: implement function
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
			connection = bootStrapper.connection;
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
			this.statusChanged = true;
			invalidateProperties();
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
			
			if (!currentIcon)
	        {
	            currentIcon = new IconConnected();
	            this.addChild(currentIcon);
	        } 
	        
		} 
		
		/**
		 * 
		 * 
		 */		 
		override protected function commitProperties():void {
			super.commitProperties();
			
			
			if(this.statusChanged) {
				this.statusChanged = false;
				removeChild(currentIcon);
				this.currentIcon = new IconDisconnected();
				//this.addChild(currentIcon); 
				this.addChild(currentIcon); 
			}
			
			
		} 
		
		/**
		 * 
		 * 
		 */		
		override protected function measure():void {
			super.measure();
			
			measuredHeight = measuredMinHeight = this.currentIcon.height;
			measuredWidth = measuredMinWidth = this.currentIcon.width;
		} 
		
		/**
		 * 
		 * @param unscaledWidth
		 * @param unscaledHeight
		 * 
		 */		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			
			//this.currentIcon.width = 100;
			//this.currentIcon.height = 100;
				
		} 
		
		
		//--------------------------------------------------------------------------
		//
		//  Getter / Setter 
		//
		//--------------------------------------------------------------------------
		
		
	}
}