package jedai.controls.common
{
	import flash.net.SharedObject;
	import flash.events.SyncEvent;
	
	[Bindable]
	public class Layout
	{
		private var _state:String = "";
		private var so:SharedObject = null;
		private var layoutName:String = null;
		private var layoutManager:LayoutManager = null;
		
		public function Layout(val:String, lm:LayoutManager) {
			this.layoutName = val;
			this.layoutManager = lm;
		}
		
		public function get state() : String {
			return this._state;
		}
		
		public function set state(val:String) : void {
			this.so.setProperty(layoutName, val);
			this._state = val;
		}
		
		public function setSharedObject(val:SharedObject) : void {
			this.so = val;
			this.so.addEventListener(SyncEvent.SYNC, onSync);
		}		
		
		public function onSync(event:SyncEvent) : void {
			trace("event: " + event);
			
			var list:Array = event.changeList;
			trace("event.changeList.length: " + event.changeList.length);
			
			for(var i:Number=0; i<list.length; i++){
				switch(list[i].code) {
					case "clear":
						trace("list[" + i + "].code: " + list[i].code);
						break;
					case "success":
						trace("list[" + i + "].code: " + list[i].code);
						break;
						
					case "reject":
						trace("list[" + i + "].code: " + list[i].code);
						break;
						
					case "change":
						trace("list[" + i + "].code: " + list[i].code);
						
						if(this.layoutName == list[i].name) {
							this.state = so.data[(list[i].name)];
						}
						break;
						
					case "delete":
						trace("list[" + i + "].code: " + list[i].code);
						break;
				}			
			} 	
		}
	}
}