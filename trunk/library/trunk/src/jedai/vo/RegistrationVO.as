package jedai.vo
{
	import com.adobe.cairngorm.vo.IValueObject;

	[RemoteClass(alias="jedai.vo.RegistrationVO")]
	public class RegistrationVO implements IValueObject
	{
		public var userName:String;
		public var password:String;
		public var email:String;
		public var gender:int;
		// others...
		
		
		public function RegistrationVO()
		{
		}

	}
}