package jedai.io.extensions
{
	import jedai.io.errors.DuplicateItemError;
	import jedai.io.extensions.enum.ExtensionEnum;
	import jedai.io.extensions.enum.ResourceEnum;
	import jedai.io.extensions.utils.ExtensionStatusPool;
	
	import flash.utils.Dictionary;
	
	/**
	 * Most StreamControls will use this class as a delegator for most of the logic that maintains
	 * the set of extensions.
	 * 
	 * @author Jon Valliere ( jvalliere@emoten.com )
	 */
	public class SimpleExtensionManager implements ExtendableStreamControl
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
		
		private var _currentPluginPool	: ExtensionStatusPool;
		
		private var _pluginNameIndex	: Object 		= new Object();
		
		private var _resources			: Dictionary	= new Dictionary();
		private var _resourceQueue		: Dictionary	= new Dictionary();
		
		private var _MasterControl		: ExtendableStreamControl;
		
		public function SimpleExtensionManager( master:ExtendableStreamControl )
		{
			_MasterControl = master;
		}
		
		public function set extensions( plugins:Array ):void
		{
			while( plugins.length > 0 )
			{
				try
				{
					this.loadExtension( StreamExtension( plugins.pop() ) );
				}
				catch( e:* )
				{
					// do nothing
				}
			}
		}
		
		public function loadExtension(plugin:StreamExtension):StreamExtension
		{
			trace("["+plugin.name+"] REGISTERED " );
			
			if( _pluginNameIndex[ plugin.fqn ] == undefined )
			{
				_pluginNameIndex[ plugin.fqn ] = plugin;
				
				use namespace raf;
			
				var plug:AbstractStreamExtension = plugin as AbstractStreamExtension;
			
					plug.connect( this._MasterControl );
					
				trace("["+plugin.name+"] CONNECTED " );
			}
			
			return plugin;
		}
		
		private function terminatePluginByClass( fqn:String ):Boolean
		{
			var result:Boolean = false;
			
			if( _pluginNameIndex[ fqn ] != undefined )
			{
				var inst:StreamExtension = _pluginNameIndex[ fqn ] as AbstractStreamExtension;
				
				inst.deconstruct();
				
				result = true;
				
				_pluginNameIndex[ fqn ] = undefined;
			}
			
			return result;
		}
		
		public function terminateExtension(plugin:StreamExtension):Boolean
		{
			return this.terminatePluginByClass( plugin.fqn );
		}
		
		public function suspendExtensions():ExtensionStatusPool
		{
			return forcePluginStatus( ExtensionEnum.EXT_SUSPENDED );
		}
		
		public function terminateExtensions():ExtensionStatusPool
		{
			return forcePluginStatus( ExtensionEnum.EXT_TERMINATED );
		}
		
		public function startExtensions():ExtensionStatusPool
		{
			return forcePluginStatus( ExtensionEnum.EXT_RUNNING );
		}
		
		public function toggleExtensionSuspension():ExtensionStatusPool
		{
			return null;
		}
		
		public function getExtensions():Object
		{
			return _pluginNameIndex;
		}
		
		private function forcePluginStatus( status:ExtensionEnum ):ExtensionStatusPool
		{
			if( _currentPluginPool != null )
			{
				_currentPluginPool.terminate();
			}
			
			_currentPluginPool = new ExtensionStatusPool( status, this._pluginNameIndex );
			
			return _currentPluginPool;
		}
		
		public function registerExternalResource( resource:ResourceEnum, value:* ):void
		{
			if( this._resources[ resource ] == undefined )
			{
				this._resources[ value ] = value;
				
				if( this._resourceQueue[ resource ] != undefined )
				{
					var ob:Array = this._resourceQueue[ resource ];
					
					while( ob.length > 0 )
					{
						var a:Function = ob.pop() as Function
						
						a( value );
					}
				}
			}
			else
			{
				throw new DuplicateItemError("External Resouce id #"+resource+" has already been registered");
			}
		}
		
		public function requestExternalResource( resource:ResourceEnum, callback:Function ):void
		{
			if( this._resources[ resource ] != undefined )
			{
				callback( this._resources[resource] );
			}
			else
			{
				if( this._resourceQueue[ resource ] == undefined )
				{
					this._resourceQueue[ resource ] = new Array();
				}
				
				var ob:Array = this._resourceQueue[ resource ] as Array;
				
				ob.push( callback );
			}
		}
		
		public function lookupRegisteredResource( resource:ResourceEnum ):*
		{
			if( this._resources[ resource ] != undefined )
			{
				return this._resources[ resource ];
			}
			
			return null;
		}
		
	}
}