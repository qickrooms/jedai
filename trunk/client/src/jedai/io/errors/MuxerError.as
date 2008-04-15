package jedai.io.errors
{
	public class MuxerError extends Error
	{
		public function MuxerError(message:String="", id:int=0)
		{
			super(message, id);
		}
		
	}
}