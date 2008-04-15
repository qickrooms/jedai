package com.infrared5.asmf.business
{
	import com.infrared5.asmf.net.rpc.Red5Connection;
	
	internal class Red5Connections extends Red5AbstractServices
	{
		override protected function getTypeCheck(type:*):Boolean
		{
			return ( type is Red5Connection );
		}
	}
}