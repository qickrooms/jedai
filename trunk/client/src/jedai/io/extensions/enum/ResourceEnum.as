package jedai.io.extensions.enum
{
	import jedai.commons.utils.Enum;

	public class ResourceEnum extends Enum
	{
		public static const MICROPHONE		: ResourceEnum 		= new ResourceEnum();
		
		public static const CAMERA			: ResourceEnum		= new ResourceEnum();
		
		public static const VIDEO			: ResourceEnum		= new ResourceEnum();
		
		public static const SOUND			: ResourceEnum		= new ResourceEnum();
		
		public function ResourceEnum(_value:*=null)
		{
			super(_value);
		}
		
	}
}