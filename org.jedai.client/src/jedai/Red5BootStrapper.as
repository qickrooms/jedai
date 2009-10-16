////////////////////////////////////////////////////////////////////////////////
//
//  Copyright (C) 2007-2008 Infrared5 Incorporated
//  All Rights Reserved. The following is Source Code and is subject to all
//  restrictions on such code as contained in the End User License Agreement
//  accompanying this product.
//
////////////////////////////////////////////////////////////////////////////////


package jedai
{
	import flash.events.EventDispatcher;
	
	import jedai.events.Red5Event;
	import jedai.net.ClientManager;
	import jedai.net.rpc.Red5Connection;
	import jedai.vo.AuthVO;
	
	import org.pranaframework.ioc.ObjectContainer;
	import org.pranaframework.ioc.loader.ObjectDefinitionsLoaderEvent;
	import org.pranaframework.ioc.loader.XmlObjectDefinitionsLoader;
	
	[Event(name="bootComplete", type="jedai.events.Red5Event")]
	[Event(name="connected", type="jedai.events.Red5Event")]
	[Event(name="disconnected", type="jedai.events.Red5Event")]
	
	/**
	 * Red5BootStrapper takes care of steps 1-3 in "Workflow(wrapped)" in Basecamp:
	 * 
	 * 1. Create a NetConnection ( by config.xml )
     * 2. Create a NetStream → Camera / Microphone & Video / Sound 
     * ( by app-context.xml via AMF with the "context" Red5Connection )
     * 3. Attach everything together ( automated by app-context.xml via AMF )
	 * 
	 * @author Dominick Accattato (dominick_AT_infrared5_DOT_com)
	 * @author Jon Valliere ( sybersnake_AT_gmail_DOT_com )
	 */
	public class Red5BootStrapper extends EventDispatcher
	{
		private var _objectDefinitionsLoader:XmlObjectDefinitionsLoader;
		private var _client:ClientManager;
		private var _connection:Red5Connection;
		private var _config:String;
		private static var _instance:Red5BootStrapper;
		private var _container:ObjectContainer;
		
		/**
		 * 
		 * 
		 */		
		public function Red5BootStrapper(clazz:Private ,config:String)
		{
			if(clazz == null) {
				throw("must call getInstance");
			}
			
			/* 
			NetConnection.defaultObjectEncoding = ObjectEncoding.AMF0;
			SharedObject.defaultObjectEncoding = ObjectEncoding.AMF0; 
			*/
			
			this._config = config;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */		
		public static function getInstance(config:String=null) : Red5BootStrapper {
			
			if(_instance == null) {
				if(config == null) {
					config = "applicationContext.xml";
				} 
				_instance = new Red5BootStrapper(new Private(), config);
				_instance.loadData();
			}
			
			return _instance;
		}
		
		/**
		 * 
		 * 
		 */		
		private function loadData() : void {
			_objectDefinitionsLoader = new XmlObjectDefinitionsLoader();
			_objectDefinitionsLoader.addEventListener(ObjectDefinitionsLoaderEvent.COMPLETE, onObjectDefinitionsLoaderComplete);
			_objectDefinitionsLoader.load(this._config);
		}
		
		/**
		 * 
		 * @param event
		 * 
		 */		
		private function onObjectDefinitionsLoaderComplete(event:ObjectDefinitionsLoaderEvent) : void {
			_container = _objectDefinitionsLoader.container;
			_client = _container.getObject("client");
			_connection = _container.getObject("connection");	
		
			dispatchEvent(new Red5Event(Red5Event.BOOTSTRAP_COMPLETE));
			dispatchEvent(new ObjectDefinitionsLoaderEvent(ObjectDefinitionsLoaderEvent.COMPLETE));
		}
		
		/**
		 * 
		 * 
		 */		
		public function connect(authVO:AuthVO) : void {
			// Create a Red5Connection which registers the connection
			
			this._connection.connect(this._connection.rtmpURI, authVO.userName, authVO.password);
			this._connection.addEventListener(Red5Event.CONNECTED, this.onConnectionHandler );
			this._connection.addEventListener(Red5Event.DISCONNECTED, this.onDisconnectHandler );
			this._connection.addEventListener(Red5Event.REJECTED, this.onConnectionRejected );
			//this._connection.client = this;
		}
		
		/**
		 * 
		 * @param event
		 * 
		 */		
		private function onConnectionHandler(event:Red5Event) : void {
			trace("event: " + event);
			dispatchEvent(event.clone());
		}
		
		/** 
		 * @param event
		 * 
		 */		
		private function onDisconnectHandler(event:Red5Event) : void {
			trace("event: " + event);
			dispatchEvent(event.clone());
		}
		
		/**
		 * 
		 * @param event
		 * 
		 */		
		private function onConnectionRejected(event:Red5Event) : void {
			trace("event: " + event);
			dispatchEvent(event.clone());
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */		
		public function get client() : ClientManager {
			return this._client;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */		
		public function set client(val:ClientManager) : void {
			this._client = val;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */		
		public function get connection() : Red5Connection {
			return this._connection;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */		
		public function get container() : ObjectContainer {
			return this._container;
		}
	}

}

class Private {
	
}