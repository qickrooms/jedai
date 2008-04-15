package com.infrared5.asmf.business
{
	import com.adobe.cairngorm.CairngormError;
	import com.adobe.cairngorm.business.ServiceLocator;
	import com.infrared5.asmf.net.rpc.Red5Connection;
	import com.infrared5.asmf.net.rpc.RemoteSharedObject;

	/**
	 * Service locator for Red5Connections and RemoteSharedObjects
	 * registers services during runtime
	 * 
	 * @author Jon Valliere ( jvalliere@emoten.com )
	 * @author Dominick Accattato ( dominick@infrared5.com )
	 **/
	public dynamic class Red5ServiceLocator extends com.adobe.cairngorm.business.ServiceLocator
	{
		//-------------------------------------------------------------
		//
		//	Namespaces
		//
		//-------------------------------------------------------------
		
		public namespace raf	= "raf/internal";
		
		//-------------------------------------------------------------
		//
		//	Class
		//
		//-------------------------------------------------------------
		
		private static var instance : Red5ServiceLocator;
		
		public static function getInstance() : Red5ServiceLocator
  		{
 			if ( instance == null )
 			{
				instance = new Red5ServiceLocator();
 			}
 			return instance;
		}
		
		//-------------------------------------------------------------
		//
		//	Instance
		//
		//-------------------------------------------------------------
		
		private var _remoteSharedObjects	: RemoteSharedObjects;
		
		private var _red5Connections		: Red5Connections;
      
		public function Red5ServiceLocator()
		{
			super();
			
			Red5ServiceLocator.instance = this;
		}
		
		public function getRemoteSharedObject( name:String, persistance:Boolean=false, secure:Boolean=false):RemoteSharedObject
		{
			var rso:RemoteSharedObject;
			
			try {
				rso = RemoteSharedObject(this.remoteSharedObjects.getService( name ));
			} catch (err:CairngormError) {
				var conn:Red5Connection = Red5ServiceLocator.getInstance().getRed5Connection("default");
				rso = new RemoteSharedObject(name, persistance, secure, conn);
			}
			//trace(this.remoteSharedObjects.getService( name ));
			
			return rso;
		}
		
		/**
		 * Gets a red5 connection or gracefully traces an error
		 * TODO dispatch an event
		 * @arg name String
		 **/
		public function getRed5Connection( name:String ):Red5Connection
		{
			var retConn:Red5Connection = null;
			try {
				retConn = Red5Connection( this.red5Connections.getService( name ) );
			} catch (err:CairngormError) {
				trace("err: " + err);
				retConn = new Red5Connection(name, true );
			}
			
			return retConn;
		}
		
		private var _defCon:Red5Connection;
		
		public function setDefaultRed5Connection( value:Red5Connection ):void
		{
			_defCon = value;
		}
		
		public function getDefaultRed5Connection( ):Red5Connection
		{
			return _defCon;
		}
		
		raf function registerRemoteSharedObject( obj:RemoteSharedObject ):void
		{
			this.remoteSharedObjects.runtimeRegister( obj );
		} 
		
		raf function registerRed5Connection( obj:Red5Connection ):void
		{
			this.red5Connections.runtimeRegister( obj );
		}
		
		private function get remoteSharedObjects():RemoteSharedObjects
		{
			if( _remoteSharedObjects == null )
			{
				_remoteSharedObjects = new RemoteSharedObjects();
				_remoteSharedObjects.register(this);
			}
			return _remoteSharedObjects;
		}
		
		private function get red5Connections():Red5Connections
		{
			if( _red5Connections == null )
			{
				_red5Connections = new Red5Connections();
				_red5Connections.register(this);
			}
			return _red5Connections;
		}
	}
}