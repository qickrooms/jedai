package jedai.media.devices.detection
{
	/**
	 * interface that defines device detection methods specific to video
	 * 
	 * @author Dominick Accattato (dominick@infrared5.com)
	 **/
	public interface IVideoDetection extends IDeviceDetection
	{
		/**
		 * Prompt method request access to video devices
		 **/
		function promptVideo() : void;
	}
}