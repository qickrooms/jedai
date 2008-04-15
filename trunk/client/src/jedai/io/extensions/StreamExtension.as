package jedai.io.extensions
{
	import jedai.io.extensions.enum.ExtensionEnum;
	
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