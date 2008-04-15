package com.infrared5.asmf.net
{
	[Bindable]
	public class ClientManager
	{
		private var id:Number;
		private var _username:String = null;
		private var _password:String = null;
		
		public function setClientID(val:Number) : void {
			trace("Client ID: " + val);
			this.id = val;
		}
		
		public function get username() : String {
			return this._username;
		}
		
		public function set username(val:String) : void {
			this._username = val;
		}
		
		public function get password() : String {
			return this._password;
		}
		
		public function set password(val:String) : void {
			this._password = val;
		}
	}	
	
}