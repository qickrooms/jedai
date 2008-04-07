////////////////////////////////////////////////////////////////////////////////
//
//  Copyright (C) 2007-2008 Infrared5 Incorporated
//  All Rights Reserved. The following is Source Code and is subject to all
//  restrictions on such code as contained in the End User License Agreement
//  accompanying this product.
//
////////////////////////////////////////////////////////////////////////////////

package com.infrared5.asmf.controls.flex.framework
{
	import com.infrared5.asmf.business.Red5ServiceLocator;
	import com.infrared5.asmf.net.rpc.Red5Application;
	import com.infrared5.asmf.net.rpc.Red5Connection;
	
	import flash.events.Event;
	import flash.events.NetStatusEvent;
	
	import mx.core.Application;
	import mx.core.UIComponent;

	/**
	 *  A Red5UI...
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
	public class Red5UI extends UIComponent implements IRed5Listener
	{
		/**
		 *  @private 
		 */
		private var _connection:Red5Connection;
		
		public function Red5UI()
		{
			//TODO: implement function
			super();
			
			var app:Red5Application = Red5Application(mx.core.Application.application);
			app.bootStrapper.addEventListener("bootStrapComplete", onBootStrapComplete);
		}
		
		public function onBootStrapComplete(event:Event) : void {
			trace("boot complete: " + event);
			_connection = Red5ServiceLocator.getInstance().getRed5Connection("default");
			_connection.addEventListener(NetStatusEvent.NET_STATUS, onConnected);
		}
		
		public function onConnected(event:NetStatusEvent) : void {
			throw("must override");
		}
		
		public function get connection() : Red5Connection {
			return this._connection;
		}
		
		
	}
}