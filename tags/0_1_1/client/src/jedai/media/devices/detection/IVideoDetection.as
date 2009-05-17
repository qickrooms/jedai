package jedai.media.devices.detection
{
	/**
	 * interface that defines device detection methods specific to video
	 * 
	 * @author Dominick Accattato (dominick_AT_infrared5_DOT_com)
	 **/
	public interface IVideoDetection extends IDeviceDetection
	{
		/**
		 * Prompt method request access to video devices
		 **/
		function promptVideo() : void;
	}
}