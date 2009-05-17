package jedai.io.extensions
{
	
	import com.adobe.cairngorm.CairngormError;
	import com.adobe.cairngorm.CairngormMessageCodes;
	
	public class AbstractObserverExtension extends AbstractStreamExtension implements ObserverStreamExtension
	{
		public function AbstractObserverExtension()
		{
			super();
		}
		
		public function suspend():Boolean
		{
			throw new CairngormError( CairngormMessageCodes.ABSTRACT_METHOD_CALLED, "suspend" );
			
			return false;
		}
		
		public function start():Boolean
		{
			throw new CairngormError( CairngormMessageCodes.ABSTRACT_METHOD_CALLED, "start" );
			
			return false;
		}
		
		public function terminate():Boolean
		{
			throw new CairngormError( CairngormMessageCodes.ABSTRACT_METHOD_CALLED, "terminate" );
			
			return false;
		}
		
		protected function canSuspend():Boolean
		{
			return true;
		}
		
		protected function canStart():Boolean
		{
			return true;
		}
		
		protected function canTerminate():Boolean
		{
			return true;
		}
		
	}
}