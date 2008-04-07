package com.infrared5.asmf.business
{
	import com.adobe.cairngorm.business.IServices;
	import com.infrared5.asmf.net.rpc.RemoteSharedObject;

	internal class RemoteSharedObjects extends Red5AbstractServices implements IServices
	{
		override protected function getTypeCheck(type:*):Boolean
		{
			 return ( type is RemoteSharedObject );
		}
	}
}