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
	import flash.events.SyncEvent;
	import flash.net.SharedObject;
	
	import mx.collections.ArrayCollection;
	import mx.controls.List;
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
	
	[IconFile("../../../../../../../resources/icons/build/PeopleList.png")]
	
	/**
	 *  A UserList component allows the user to chat with others in room.  
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
	public class UserList extends List
	{
		
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		private var users:ArrayCollection = new ArrayCollection();
	
		private var bootStrapper:Red5BootStrapper;
		
		public function UserList()
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
			
			this.labelFunction = myLabelFunction;
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
			rso.addEventListener(SyncEvent.SYNC, onSync);	
		}
		
		public function myLabelFunction(item:Object):String {
			var cm:ClientManager = Red5BootStrapper.getInstance().client;
			trace("item: " + item);
			return item.username;
		}
		
		/**
		 * 
		 * @param event
		 * 
		 */		
		private function onSync(event:SyncEvent) : void {
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
						break;
					case "reject":
						trace("list[" + i + "].code: " + list[i].code);
						break;
					case "change":
						trace("list[" + i + "].code: " + list[i].code);
						users.removeAll();
						
						var so:SharedObject = RemoteSharedObject(event.target).so();
						for (var key:String in so.data)
						{
						    trace(key + ": " + so.data[key]);
						    users.addItem(so.data[key]);
						}
									
						break;
					case "delete":
						users.removeAll();
						
						for (var key1:String in event.target.so.data)
						{
						    trace(key1 + ": " + event.target.so.data[key1]);
						    users.addItem(so.data[key1]);
						}
						
						trace("list[" + i + "].code: " + list[i].code);
						break;
				}			
			} 
			
			this.dataProvider = users;
		}
	}
}