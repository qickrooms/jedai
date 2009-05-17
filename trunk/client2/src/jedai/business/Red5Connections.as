package jedai.business
{
	import jedai.net.rpc.Red5Connection;
	
	internal class Red5Connections extends Red5AbstractServices
	{
		override protected function getTypeCheck(type:*):Boolean
		{
			return ( type is Red5Connection );
		}
	}
}