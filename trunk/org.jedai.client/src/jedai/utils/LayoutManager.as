package jedai.utils
{
	import flash.net.NetConnection;
	import flash.net.SharedObject;
	import flash.utils.Dictionary;
	
	import mx.binding.utils.BindingUtils;
	
	import jedai.net.ConnectionServices;
	
	[Bindable]
	public class LayoutManager
	{
		private static var layoutManager:LayoutManager = null;
		private var layoutDict:Dictionary = new Dictionary();
		private var connectionManager:ConnectionServices = null;
		private var conn:NetConnection = null;
		private var so:SharedObject = null;
		
		public function LayoutManager() {
			
		}
		
		/**
		 * Static getInstance returns a singleton LayoutManager
		 **/
		public static function getInstance() : LayoutManager {
			
			
			if(layoutManager == null) {
				layoutManager = new LayoutManager();
				layoutManager.connectionManager = ConnectionServices.getInstance();
				BindingUtils.bindSetter(layoutManager.onConnected, layoutManager.connectionManager, "connected");
			}
						
			return layoutManager;
		}
		
		public function onConnected(connected:Boolean) : void {				
			
			// guard agains null
			if(!connected) return;
			conn = connectionManager.connection;
			
			// Set up remoteSharedObject stuff			
			so = SharedObject.getRemote("layoutlist", conn.uri);
			so.connect(conn);									
			
			for (var key:String in layoutDict)
			{
			    Layout(layoutDict[key]).setSharedObject(so);
			    var state:String = Layout(layoutDict[key]).state;
			} 				
		}

		public function getLayout(val:String) : Layout {
			if(layoutDict[val] == null) {
				layoutDict[val] = new Layout(val, this);
			}
			
			return layoutDict[val];
		}
		
	}
}