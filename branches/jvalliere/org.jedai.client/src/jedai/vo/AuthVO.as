package jedai.vo
{
	import com.adobe.cairngorm.vo.IValueObject;

	[RemoteClass(alias="jedai.vo.AuthVO")]
	public class AuthVO implements IValueObject
	{
		public var userName:String;
		public var password:String;
		
		
		public function AuthVO(userName:String, password:String)
		{
			this.userName = userName;
			this.password = password;
		}
		
		public function toString():String
		{
			return "[AuthVO (userName:" + userName + ", password:" + password + ")]";
		}
	}
}