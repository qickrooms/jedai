package com.infrared5.io
{
	
	/**
	 * OutputDevice is a interface used to describe a intelligent device that
	 * requires advanced negoation and automatic configuration before data
	 * transfer occurs.  Advanced configuration is shown in Multi-Purpose 
	 * devices implementing a OneWayMuxer because they are configured based
	 *  on which interface is connected.
	 * 
	 * If you wish to simply provide a interface to define a target where data will
	 * be "pushed" then use OutputStream.
	 * 
	 * @author Jon Valliere ( jvalliere@emoten.com )
	 */
	public interface OutputDevice
	{
		/**
		 * Defines the OutputDevice of which output communication needs to be negotiated.
		 * @param key defines if this is the entrypoint for auto configuration between to muxers
		 */
		function attachInputFrom( stream:InputDevice, ... args ):void;

	}
}