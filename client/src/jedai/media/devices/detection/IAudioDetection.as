package jedai.media.devices.detection
{
	/**
	 * interface that defines device detection methods specific to audio
	 * 
	 * @author Dominick Accattato (dominick@infrared5.com)
	 **/
	public interface IAudioDetection extends IDeviceDetection
	{
		/**
		 * Prompt method request access to audio devices
		 **/
		function promptAudio() : void;	
	}
}