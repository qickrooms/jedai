package com.infrared5.asmf.net
{
	import com.infrared5.asmf.controls.common.LayoutManager;
	
	import flash.events.AsyncErrorEvent;
	import flash.events.IOErrorEvent;
	import flash.events.NetStatusEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.NetConnection;
	
	import mx.rpc.AbstractService;
	
	/**
	 *  Dispatched by the component when its Netconnection has changed status
	 *
	 *  @eventType flash.events.NetStatusEvent
	 */
	[Event(name="NetStatusEvent", type="flash.events.NetStatusEvent")]
	
	/**
	 *  Dispatched by the component when a connection has a syncrhronization error
	 *
	 *  @eventType flash.events.AsyncErrorEvent
	 */
	[Event(name="AsyncErrorEvent", type="flash.events.AsyncErrorEvent")]
	
	/**
	 *  Dispatched by the component when a connection has a IOErrorEvent error
	 *
	 *  @eventType flash.events.IOErrorEvent
	 */
	[Event(name="IOErrorEvent", type="flash.events.IOErrorEvent")]
	
	/**
	 *  Dispatched by the component when a connection has a SecurityErrorEvent error
	 *
	 *  @eventType flash.events.SecurityErrorEvent
	 */
	[Event(name="SecurityErrorEvent", type="flash.events.SecurityErrorEvent")]
	
	/**
	 *  Dispatched by the component when a connection has a ConnectedEvent error
	 *
	 *  @eventType com.infrared5.network.events.ConnectedEvent
	 */
	[Event(name="ConnectedEvent", type="com.infrared5.network.events.ConnectedEvent")]
	
	/** Excluded API's **/
	[Exclude(name="activate", kind="event")]
	[Exclude(name="deactivate", kind="event")]
	
	[Bindable]
	public class ConnectionServices extends AbstractService
	{	
		//-------------------------------------------------------------
		//
		//	Class
		//
		//-------------------------------------------------------------
			
		private static var connectionManager:ConnectionServices = null;
		
		//-------------------------------------------------------------
		//
		//	Instance
		//
		//-------------------------------------------------------------
		
		
		private var _clientManager			: ClientManager = null;
		private var _layoutManager			: LayoutManager = null;
		private var _conn					: NetConnection = null;
		private var _connected				: Boolean = false;
		

		/* private var _username:String = "";
		private var _password:String = ""; */
		
		/**
		 * Constructor
		 **/
		public function ConnectionServices()
		{
		}
		
		/**
		 * Static getInstance returns a singleton ConnectionServices
		 **/
		public static function getInstance() : ConnectionServices
		{
			if(connectionManager == null) {
				connectionManager = new ConnectionServices();
			}
			
			return connectionManager;
		}
		
		/**
		 * connects to server
		 **/
		public function connect(url:String, user:String="", pass:String=null) : void {
			//this.username = user;
			//this.password = pass;
			
			if(connection == null) {
				connection = new NetConnection();
				clientManager = new ClientManager();
				clientManager.username = user;
				clientManager.password = pass;
				connection.client = clientManager;
				connection.connect(url, user, pass);
				connection.addEventListener(NetStatusEvent.NET_STATUS, onConnNetStatus);
				connection.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
				connection.addEventListener(AsyncErrorEvent.ASYNC_ERROR, onAsyncError);
				connection.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError); 			
			}
			
			return;
		}
		
		/**
		 * Gets the connection object
		 * 
		 * @return conn NetConnection
		 **/
		public function get connection() : NetConnection {
			return _conn;
		}
		
		public function set connection(conn:NetConnection) : void {
			this._conn = conn;
		}
		
		/**
		 * Gets the connected object
		 * 
		 * @return conn Boolean
		 **/
		public function get connected() : Boolean {
			return _connected;
		}
		
		public function set connected(val:Boolean) : void {
			this._connected = val;
		}
		
		/**
		 * Gets the clientManager object
		 * 
		 * @return conn String
		 **/
		public function get clientManager() : ClientManager {
			return _clientManager;
		}
		
		public function set clientManager(val:ClientManager) : void {
			_clientManager = val;
		} 
		
		/**
		 * Gets the layoutManager object
		 * 
		 * @return _layoutManager LayoutManager
		 **/
		public function get layoutManager() : LayoutManager {
			return _layoutManager;
		}
		
		public function set layoutManager(val:LayoutManager) : void {
			_layoutManager = val;
		} 
		
		/**
		 * Gets the username object
		 * 
		 * @return conn String
		 **/
		/* public function get username() : String {
			return _username;
		}
		
		public function set username(val:String) : void {
			this._username = val;
		}  */
		
		/**
		 * Gets the password object
		 * 
		 * @return conn String
		 **/
		/* public function get password() : String {
			return _password;
		}
		
		public function set password(val:String) : void {
			this._password = val;
		}  */
		
		/**
		 * called after onConnNetStatus is dispatched
		 * 
		 * @param event NetStatusEvent
		 **/
		public function onConnNetStatus(event:NetStatusEvent) : void {	
			this.connected = true;		
			// dispatch event
			var net:NetStatusEvent = new NetStatusEvent(NetStatusEvent.NET_STATUS);
			this.dispatchEvent(event);
		}
		
		/**
		 * called after onAsyncError is dispatched
		 * 
		 * @param event NetStatusEvent
		 **/
		public function onAsyncError(event:AsyncErrorEvent) : void {			
			// dispatch event
			this.dispatchEvent(event);
		}
		
		
		/**
		 * called after onConnIOError is dispatched
		 * 
		 * @param event NetStatusEvent
		 **/
		public function onIOError(event:IOErrorEvent) : void {			
			// dispatch event
			this.dispatchEvent(event);
		}
		
		/**
		 * called after onConnSecurityError is dispatched
		 * 
		 * @param event NetStatusEvent
		 **/
		public function onSecurityError(event:SecurityErrorEvent) : void {			
			// dispatch event
			this.dispatchEvent(event);
		}
		

	}
}