package jedai.io.extensions
{
	/**
	 * Base class for all Third-Party Observer Extensions
	 * 
	 * @author Jon Valliere ( sybersnake_AT_gmail_DOT_com )
	 */
	public interface ObserverStreamExtension extends StreamExtension
	{
		function suspend( ):Boolean;
		
		function start( ):Boolean;
		
		function terminate( ):Boolean;
		
	}
}