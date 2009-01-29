package jedai.io.extensions.utils
{
	import jedai.io.extensions.ObserverStreamExtension;
	import jedai.io.extensions.StreamExtension;
	import jedai.io.extensions.enum.ExtensionEnum;
	
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	[Event(name="complete", type="flash.events.Event")]
	
	/**
	 * Manages Scope-Wide Changes in Extension Commands.
	 * 
	 * When you send a scope-wide extension command like suspend or terminate a pool is created and
	 * is responsible for keeping track of when all of the available extensions sucessfully complete
	 * the requested command.
	 * 
	 * @author Jon Valliere ( sybersnake_AT_gmail_DOT_com )
	 */
	public class ExtensionStatusPool
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
		
		public function ExtensionStatusPool( status:ExtensionEnum, plugins:Object, timeout:int=30  )
		{
			_plugs = plugins;
			
			_targetStatus = status;
			
			_timeout = timeout;
		}
		
		private var _isCompleted:Boolean = false;
		
		public function isCompleted():Boolean
		{
			return _isCompleted;
		}
		
		public function terminate():void
		{
			if( !_isCompleted )
			{
				// We have to undo the changes to all the plugins
				for( var i:* in _plugs )
				{
					StreamExtension( _plugs[ i ] ).undoStatusChange();
				}
			}
		}
		
		private function setAllStatus( status:ExtensionEnum ):void
		{
			for( var i:* in _plugs )
			{
				var e:ObserverStreamExtension = ObserverStreamExtension( _plugs[ i ] )
				switch( status )
				{
					case ExtensionEnum.EXT_SUSPENDED:
						e.suspend();
						break;
						
					case ExtensionEnum.EXT_RUNNING:
						e.start();
						break;
						
					case ExtensionEnum.EXT_TERMINATED:
						e.terminate();
						break;
				}

			}
		}
		
		private var _plugs:Object;
		
		private var _targetStatus:ExtensionEnum;
		
		private var _timeout:int;
		
		private var _timer:Timer;
		
		raf function registerStatus( plugin:StreamExtension ):void
		{
			
		}
		
		private function timerHandler( event:TimerEvent ):void
		{
			
		}
	}
}