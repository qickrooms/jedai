package jedai.net.rpc
{
	import flash.events.NetStatusEvent;
	import flash.net.NetConnection;
	import flash.utils.Dictionary;
	
	import jedai.business.Red5ServiceLocator;
	import jedai.events.Red5Event;
	import jedai.net.ClientManager;
	import jedai.net.IService;
	
	[Event(name="connected", type="jedai.events.Red5Event")]
	[Event(name="disconnected", type="jedai.events.Red5Event")]
	[Event(name="netStatus", type="flash.events.NetStatusEvent")]
	
	public class Red5Connection extends NetConnection implements IService
	{
		public static const CODE_CONNECT_SUCCESS 	: String = "NetConnection.Connect.Success";
		public static const CODE_CONNECT_CLOSED		: String = "NetConnection.Connect.Closed";
		public static const CODE_CONNECT_FAILED		: String = "NetConnection.Connect.Failed";
		public static const CODE_CONNECT_REJECTED	: String = "NetConnection.Connect.Rejected";
		public static const CODE_CONNECT_APPSHUTDOWN: String = "NetConnection.Connect.AppShutdown";
		public static const CODE_CONNECT_INVALIDAPP	: String = "NetConnection.Connect.InvalidApp";
		
		public static const CODE_CALL_BADVERSION	: String = "NetConnection.Call.BadVersion";
		public static const CODE_CALL_FAILED		: String = "NetConnection.Call.Failed";
		public static const CODE_CALL_PROHIBITED	: String = "NetConnection.Call.Prohibited";
		
		//-------------------------------------------------------------
		//
		//	Namespaces
		//
		//-------------------------------------------------------------
		
		public namespace raf	= "raf/internal";
		
		//-------------------------------------------------------------
		//
		//	Instance
		//
		//-------------------------------------------------------------
		
		private var _name:String;
		private var _connected	: Boolean = false;
		private var _rtmpURI:String;
		private var _connectionArgs:Array;
		private var _client:ClientManager;
		private var _sessionAttributes:Dictionary = new Dictionary();
		
		/**
		 * 
		 * @param name Name of NetConnection.
		 * @param isGlobalDefault Make this the global NetConnection.
		 */		
		public function Red5Connection( name:String, isGlobalDefault:Boolean=false )
		{
			_name = name;
			
			use namespace raf;
			
			Red5ServiceLocator.getInstance().registerRed5Connection( this );
			
			if ( isGlobalDefault )
			{
				Red5ServiceLocator.getInstance().setDefaultRed5Connection( this );
			}

			this.addEventListener(NetStatusEvent.NET_STATUS, this.onNetStatus);
		}
		
		private function onNetStatus( event:NetStatusEvent ): void
		{
			var infoCode:String = event.info.code;
			
			if ( this.connected && !_connected && infoCode == Red5Connection.CODE_CONNECT_SUCCESS )
			{
				_connected = true;
				
				this.dispatchEvent( new Red5Event( Red5Event.CONNECTED ) );
			} 
			else if ( _connected && infoCode == Red5Connection.CODE_CONNECT_CLOSED )
			{
				_connected = false;
				this.dispatchEvent( new Red5Event( Red5Event.DISCONNECTED ) );
			} 
			else if ( infoCode == Red5Connection.CODE_CONNECT_REJECTED ||
						infoCode == CODE_CONNECT_APPSHUTDOWN )
			{
				_connected = false;
				
				this.dispatchEvent( new Red5Event( Red5Event.REJECTED ) );
			} 
			else if ( infoCode == Red5Connection.CODE_CONNECT_FAILED || 
					  infoCode == Red5Connection.CODE_CONNECT_INVALIDAPP )
			{
				_connected = false;
				
				this.dispatchEvent( new Red5Event( Red5Event.DISCONNECTED ) );
			}
		}
		
		public function get name():String
		{
			return _name;
		}
		
		public function set connectionArgs(val:Array) : void {
			this._connectionArgs = val;
		}
		
		public function get connectionArgs() : Array {
			return this._connectionArgs;
		}
		
		public function get rtmpURI() : String {
			return this._rtmpURI;
		}
		
		public function set rtmpURI(val:String) : void {
			this._rtmpURI = val;
		}
		
		/**
		 * XXX Thijs: I'm testing with the Red5 oflaDemo and not sure yet how to catch undefined properties
		 * and handle their ReferenceErrors like:
		 * <code>ReferenceError: Error #1069: Property onBWDone not found on 
		 * jedai.net.rpc.Red5Connection and there is no default value.</code>
		 */		
		public function onBWDone():void
		{
			
		}
		
		public function get clientManager():ClientManager {
			return this._client;
		}
		
		public function set clientManager(val:ClientManager) : void {
			this._client = val;
		}
		
		/**
		 * Sets attributes from the session.
		 *  
		 * @param key
		 * @param val
		 * 
		 */
		public function setAttribute(key:String, val:*) : void {
			_sessionAttributes[key] = val;
		}
		
		/**
		 * Gets attributes from the session.
		 *  
		 * @param key
		 * @return 
		 * 
		 */
		public function getAttribute(key:String) : * {
			return _sessionAttributes[key];
		}
		
	}
}