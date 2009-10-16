package jedai
{
	import jedai.Red5BootStrapper;
	
	import mx.core.Application;
	import mx.events.FlexEvent;

	/**
	 * 
	 * @author dominickaccattato
	 * 
	 */
	public class Red5Application extends Application
	{
		private var _bootStrapper:Red5BootStrapper;
		private var _config:String;
		
		/**
		 * 
		 * 
		 */
		public function Red5Application()
		{
			super();
			
			if(this._config == null) {
				_config = "applicationContext.xml";
			}
			
			_bootStrapper = Red5BootStrapper.getInstance(_config);				
			//_bootStrapper.loadData();
			
			this.addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
		}
		
		/**
		 * 
		 * @param event
		 * 
		 */
		public function onCreationComplete(event:FlexEvent):void
		{
		  
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get bootStrapper():Red5BootStrapper
		{
			return this._bootStrapper;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get config():String
		{
			return this._config;
		}
		
		/**
		 * 
		 * @param val
		 * 
		 */
		public function set config(val:String):void
		{
			this._config = val;
		}
	}
}