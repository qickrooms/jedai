package com.infrared5.io.errors
{
	public class DuplicateItemError extends Error
	{
		public function DuplicateItemError(message:String="", id:int=0)
		{
			super(message, id);
		}
		
	}
}