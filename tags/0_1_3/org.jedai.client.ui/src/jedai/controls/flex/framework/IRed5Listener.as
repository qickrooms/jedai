////////////////////////////////////////////////////////////////////////////////
//
//  Copyright (C) 2007-2008 Infrared5 Incorporated
//  All Rights Reserved. The following is Source Code and is subject to all
//  restrictions on such code as contained in the End User License Agreement
//  accompanying this product.
//
////////////////////////////////////////////////////////////////////////////////

package jedai.controls.flex.framework
{
	import jedai.net.rpc.Red5Connection;
	
	import flash.events.NetStatusEvent;
	
	/**
	 *  An IRed5Listener is an interface that requires Red5
	 *  lifecycle methods.
	 * 
	 *  @author Dominick Accattato (dominick_AT_infrared5_DOT_com)
	 */
	public interface IRed5Listener
	{
		//include "../../../../config/jedai/Version.as";
		function onConnected(event:NetStatusEvent) : void;
		function get connection() : Red5Connection;
	}
}