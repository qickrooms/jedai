package jedai.io
{
	/**
	 * OneWayDevice extend both OutputDevice and InputDevice but attempting to use both at the same time 
	 * will result in an exception.
	 * 
	 * This interface is only here for API documentation purpoase and correct behavioral typing.
	 * 
	 * @author Jon Valliere ( jvalliere@emoten.com )
	 */
	public interface OneWayMuxer extends InputDevice, OutputDevice
	{
		
	}
}