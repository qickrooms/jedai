package com.infrared5.io.errors
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