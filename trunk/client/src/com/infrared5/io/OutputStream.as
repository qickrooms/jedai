package com.infrared5.io
{
	/**
	 * OutputStream is a interface for defining a target for output.
	 * @author Jon Valliere ( jvalliere@emoten.com )
	 */
	public interface OutputStream
	{
		/**
		 * Defines the Target of the Output of this Stream
		 */
		function ouput( stream:InputStream ):void;
	}
}