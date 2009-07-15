////////////////////////////////////////////////////////////////////////////////
//
//  Copyright (C) 2007-2008 Infrared5 Incorporated
//  All Rights Reserved. The following is Source Code and is subject to all
//  restrictions on such code as contained in the End User License Agreement
//  accompanying this product.
//
////////////////////////////////////////////////////////////////////////////////


package jedai.events
{
	import flash.events.Event;

	/**
	 *  A Red5Event...
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
	public class Red5Event extends Event
	{
		/** dispatched after bootstrapping is complete. **/
		public static const BOOTSTRAP_COMPLETE		: String 	= "bootStrapComplete";
		
		/** dispatched after a NetConnection is successfully connected. **/
		public static const CONNECTED			: String	= "connected";
		
		/** dispatched after a NetConnection is closed. **/
		public static const DISCONNECTED		: String	= "disconnected";
		
		public static const REJECTED : String = "rejected";
		
		/**
		 * Constructor
		 * @param type 
		 * @param bubbles
		 * @param cancelable
		 **/
		public function Red5Event(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
		override public function clone() : Event {
			return new Red5Event(this.type);
		}
		
		public var username:String;
		public var password:String;
		
	}
}