package jedai
{
	import jedai.Red5BootStrapper;
	
	import mx.core.Application;
	import mx.events.FlexEvent;

	public class Red5Application extends Application
	{
		private var _bootStrapper:Red5BootStrapper;
		private var _config:String;
		
		public function Red5Application()
		{
			super();
			
			if(this._config == null) {
				_bootStrapper = new Red5BootStrapper("applicationContext.xml");	
			} else {
				_bootStrapper = new Red5BootStrapper(this._config);
			}
			
			_bootStrapper.loadData();
			
			this.addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
		}
		
		public function onCreationComplete(event:FlexEvent):void
		{
		  
		}
		
		public function get bootStrapper():Red5BootStrapper
		{
			return this._bootStrapper;
		}
		
		public function get config():String
		{
			return this._config;
		}
		
		public function set config(val:String):void
		{
			this._config = val;
		}
	}
}