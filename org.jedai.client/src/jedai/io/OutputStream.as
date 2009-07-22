package jedai.io
{
	/**
	 * OutputStream is a interface for defining a target for output.
	 * @author Jon Valliere ( sybersnake_AT_gmail_DOT_com )
	 */
	public interface OutputStream
	{
		/**
		 * Defines the Target of the Output of this Stream
		 */
		function ouput( stream:InputStream ):void;
	}
}