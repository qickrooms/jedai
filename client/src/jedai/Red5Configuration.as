package jedai
{
	import flash.events.Event;
	
	import org.pranaframework.ioc.ObjectContainer;
	import org.pranaframework.ioc.loader.IObjectDefinitionsLoader;
	import org.pranaframework.ioc.loader.ObjectDefinitionsLoaderEvent;
	import org.pranaframework.ioc.loader.XmlObjectDefinitionsLoader;
	
	/**
	 * Fires up Prana for Initial Red5 Configuration
	 * 
	 * @author Dominick Accattato
	 */
	public class Red5Configuration
	{
		private var _objectDefinitionsLoader:IObjectDefinitionsLoader;
		
		public function Red5Configuration() {
			_objectDefinitionsLoader = new XmlObjectDefinitionsLoader();
			_objectDefinitionsLoader.addEventListener(ObjectDefinitionsLoaderEvent.COMPLETE, onObjectDefinitionsLoaderComplete);
	//		log("loading definitions");
			_objectDefinitionsLoader.load("conf.xml");
		}
		
		private function onObjectDefinitionsLoaderComplete(event:Event) : void {
			var container:ObjectContainer = _objectDefinitionsLoader.container;
				
			trace("'" + container.objectDefinitions.size() + "' object definitions found in container");
			//model.app = container.getObject("connection");
			
		}
	}
}