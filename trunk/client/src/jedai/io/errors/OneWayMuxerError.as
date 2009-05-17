package jedai.io.errors
{
	public class OneWayMuxerError extends Error
	{
		public function OneWayMuxerError(message:String="", id:int=0)
		{
			super(message, id);
		}
		
	}
}