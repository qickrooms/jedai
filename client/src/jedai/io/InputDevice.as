package com.infrared5.io
{
	
	/**
	 * InputDevice is a interface used to describe a intelligent device that
	 * requires advanced negotiation and automatic configuration before transfer
	 * of data occurs.  Advanced configuration is shown in Multi-Purpose 
	 * devices implementing a OneWayMuxer because they are configured based
	 *  on which interface is connected.
	 * 
	 * If you wish simply provide a interface to have data "pushed" into this class
	 * then use InputStream.
	 * 
	 * @author Jon Valliere ( jvalliere@emoten.com )
	 */
	public interface InputDevice
	{
		/**
		 * Defines the InputDevice which the Input communication needs to be negotiated
		 */
		function attachOutputTo( stream:OutputDevice, ... args ):void;
	}
}