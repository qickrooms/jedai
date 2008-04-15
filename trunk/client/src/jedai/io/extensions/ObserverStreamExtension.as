package jedai.io.extensions
{
	/**
	 * Base class for all Third-Party Observer Extensions
	 * 
	 * @author Jon Valliere ( jvalliere@emoten.com )
	 */
	public interface ObserverStreamExtension extends StreamExtension
	{
		function suspend( ):Boolean;
		
		function start( ):Boolean;
		
		function terminate( ):Boolean;
		
	}
}