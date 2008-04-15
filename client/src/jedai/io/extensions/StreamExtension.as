package com.infrared5.io.extensions
{
	import com.infrared5.io.extensions.enum.ExtensionEnum;
	
	/**
	 * Base Interface for all StreamExtensions
	 */
	public interface StreamExtension
	{
		function get name():String;
		
		function get fqn():String;
		
		function get status():ExtensionEnum;
		
		function undoStatusChange():void;
		
		function deconstruct():void;
	}
}