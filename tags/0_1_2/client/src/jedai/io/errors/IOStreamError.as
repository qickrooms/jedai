package jedai.io.errors
{
	import com.adobe.cairngorm.CairngormError;

	public class IOStreamError extends CairngormError
	{
		public function IOStreamError(errorCode:String, ...rest)
		{
			super(errorCode, rest);
		}
		
	}
}