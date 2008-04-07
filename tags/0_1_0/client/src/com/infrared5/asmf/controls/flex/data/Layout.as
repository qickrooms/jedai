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
	import mx.controls.TextArea;
	
	//use namespace jedai;
	
	//--------------------------------------
	//  Events
	//--------------------------------------
	
	/**
	 *  Dispatched when the user changes the chat.
	 *
	 *  @eventType com.infrared5.asmf.events.ChatChangedEvent.CHAT_CHANGED
	 */
	[Event(name="layoutChanged", type="com.infrared5.asmf.events.LyoutChangedEvent")]

	//--------------------------------------
	//  Other metadata
	//--------------------------------------
	
	//[IconFile("Chat.png")]
	
	/**
	 *  A Layout component allows the user to chat with others in room.  
	 *
	 *  @mxml
	 *
	 *  <p>The <code>&lt;jedai:Chat&gt;</code> tag inherits all the tag attributes
	 *  of its superclass. Use the following syntax:</p>
	 *
	 *  <p>
	 *  <pre>
	 *  &lt;jedai:Layoutat&gt;
	 *    ...
	 *      <i>child tags</i>
	 *    ...
	 *  &lt;/jedai:Layout&gt;
	 *  </pre>
	 *  </p>
	 *  
	 * 
	 *  @author Dominick Accattato (dominick@infrared5.com)
	 */
	public class Layout extends TextArea
	{
		public function Layout()
		{
			//TODO: implement function
			//super();
		}
		
	}
}