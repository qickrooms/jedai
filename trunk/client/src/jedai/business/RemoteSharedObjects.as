package jedai.business
{
	import com.adobe.cairngorm.business.IServices;
	import jedai.net.rpc.RemoteSharedObject;

	internal class RemoteSharedObjects extends Red5AbstractServices implements IServices
	{
		override protected function getTypeCheck(type:*):Boolean
		{
			 return ( type is RemoteSharedObject );
		}
	}
}