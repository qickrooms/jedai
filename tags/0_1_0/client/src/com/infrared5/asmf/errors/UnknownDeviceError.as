package com.infrared5.asmf.errors
{
	public class UnknownDeviceError extends Error
	{
		public function UnknownDeviceError(message:String="", id:int=0)
		{
			super(message, id);
		}
		
	}
}