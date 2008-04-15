package jedai.net.rpc
{
	import jedai.business.Red5ServiceLocator;
	import jedai.events.Red5Event;
	import jedai.net.IService;
	
	import flash.events.AsyncErrorEvent;
	import flash.events.EventDispatcher;
	import flash.events.NetStatusEvent;
	import flash.events.SyncEvent;
	import flash.net.SharedObject;
	import flash.utils.Dictionary;
	
	[Event(name="sync", type="flash.events.NetStatusEvent")]
	[Event(name="netStatus", type="flash.events.SyncEvent")]
	[Event(name="asyncError", type="flash.events.AsyncErrorEvent")]
	
	/**
	 * RemoteSharedObject is a container class that creates and configures a RemoteSharedObject.
	 * The benefit of this class is that RemoteSharedObjects can be retrieved based on a IoC configuration context
	 * and retrieved anytime from the Red5ServiceLocator.
	 * 
	 * @author Jon Valliere ( jvalliere@emoten.com )
	 * @author Dominick Accattato ( dominick@infrared5.com )
	 */
	public class RemoteSharedObject extends EventDispatcher implements IService
	{
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
		
		private var _name			: String;
		private var _persistence	: Boolean;
		private var _secure			: Boolean;
		private var _eventMap:Dictionary;
		
		public var _so:SharedObject;
		
		public function RemoteSharedObject( name:String, persistence:Boolean=false, secure:Boolean=false, connection:Red5Connection=null )
		{
			_name 			= name;
			_persistence 	= persistence;
			_secure 		= secure;
			_conn			= connection;
			
			use namespace raf;
			
			Red5ServiceLocator.getInstance().registerRemoteSharedObject( this );
			
/* 			if( useDefaultConnection && Red5ServiceLocator.getInstance().getDefaultRed5Connection() != null )
				this.connect(Red5ServiceLocator.getInstance().getDefaultRed5Connection()); */
				
			if( _conn.connected ) {
				this.connect( _conn );
			} else {
				_conn.addEventListener( Red5Event.CONNECTED, this.netConnectedHandler );
				_conn.addEventListener( Red5Event.DISCONNECTED, this.netDisconnectedHandler );
			}
		}
		
		private function netConnectedHandler( value:Red5Event ):void
		{
			this.internalConnect( _conn );
		}
		
		private function netDisconnectedHandler( value:Red5Event ):void
		{
			this.internalClose( _conn );
		}
		
		private function internalConnect( connection:Red5Connection ):void
		{
			this.connect( _conn );
		}
		
		private function internalClose( connection:Red5Connection ):void
		{
			if ( _conn != null ) {
				_conn.close();
			}
		}
		
		public function get name():String
		{
			return _name;
		}
		
		/**
		 * Wraps the SO Connection Method
		 */
		private function connect( value:Red5Connection, params:String='' ):void
		{
			_so = SharedObject.getRemote( _name, value.uri, _persistence, _secure )
			_so.connect( value );
			_so.addEventListener(NetStatusEvent.NET_STATUS, onNetStatus);
			_so.addEventListener(SyncEvent.SYNC, onSync);
			_so.addEventListener(AsyncErrorEvent.ASYNC_ERROR, onAsyncError);
		}
		
		public function onNetStatus(event:NetStatusEvent) : void {
			this.dispatchEvent(event);
		}
		
		public function onSync(event:SyncEvent) : void {
			this.dispatchEvent(event);
		}
		
		public function onAsyncError(event:AsyncErrorEvent) : void {
			this.dispatchEvent(event);
		}
		
		public function so():SharedObject
		{
			return _so;
		}
		
		//-------------------------------------------------------------
		//
		//	Prana Inversion of Control Properties
		//
		//-------------------------------------------------------------
		
		private var _conn:Red5Connection;
		
		/**
		 * Public Setter for IoC.  The server connection is initialized immediately.
		 */
		public function set connection( value:Red5Connection ):void
		{
			if( _conn == null )
			{
				_conn = value;
				
				this.connect( value );
			}
			else
				throw new Error("Connection is already defined");
		}
		
	}
}