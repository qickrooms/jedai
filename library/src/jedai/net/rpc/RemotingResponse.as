package jedai.net.rpc
{
	public class RemotingResponse
	{
		public var authenticated	: Boolean 	= false;
		public var status			: String;
		public var response			: Object;
			
		public function RemotingResponse( $response:Object=null, $authenticated:Boolean=false, $status:String="" )
		{
			this.response 		= $response;
			this.status 		= $status;
			this.authenticated 	= $authenticated;
		}

	}
}