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
	import com.infrared5.asmf.net.rpc.Red5Connection;
	
	import flash.events.NetStatusEvent;
	
	/**
	 *  An IRed5Listener is an interface that requires Red5
	 *  lifecycle methods.
	 * 
	 *  @author Dominick Accattato (dominick@infrared5.com)
	 */
	public interface IRed5Listener
	{
		include "../../../../../../core/Version.as";
		function onConnected(event:NetStatusEvent) : void;
		function get connection() : Red5Connection;
	}
}