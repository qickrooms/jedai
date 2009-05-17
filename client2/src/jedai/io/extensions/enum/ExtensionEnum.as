package jedai.io.extensions.enum
{
	import jedai.commons.utils.Enum;

	public class ExtensionEnum extends Enum
	{
		public static const EXT_TERMINATED	: ExtensionEnum = new ExtensionEnum();
		
		public static const EXT_RUNNING		: ExtensionEnum = new ExtensionEnum();
		
		public static const EXT_SUSPENDED	: ExtensionEnum = new ExtensionEnum();
		
		public static const EXT_COMPLETED	: ExtensionEnum = new ExtensionEnum();
		
		public static const EXT_VIRGIN		: ExtensionEnum	= new ExtensionEnum();
		
		public static const EXT_WAITING		: ExtensionEnum	= new ExtensionEnum();
		
		public function ExtensionEnum(_value:Object=null)
		{
			super(_value);
		}
		
	}
}