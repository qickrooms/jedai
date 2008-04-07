package com.infrared5.io.extensions
{
	import com.infrared5.io.extensions.enum.ExtensionEnum;
	
	import flash.events.EventDispatcher;
	import flash.utils.getQualifiedClassName;
	
	[Event(name="completed", "com.infrared5.io.extensions.events.ExtensionEvent")]
	
	[Event(name="ready", "com.infrared5.io.extensions.events.ExtensionEvent")]
	
	/**
	 * @author Jon Valliere ( jvalliere@emoten.com )
	 */
	public class AbstractStreamExtension extends EventDispatcher implements StreamExtension
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
		
		
		
		//-------------------------------------------------------------
		//
		//	Instance
		//
		//-------------------------------------------------------------
		
		protected var _cached:Object;
		
		public function AbstractStreamExtension()
		{
			_cached = new Object();
			
			_cached.status = ExtensionEnum.EXT_VIRGIN;
			
		}
		
		public function get name():String
		{
			if( _cached._cGenName == "" || _cached._cGenName == undefined )
				_cached._cGenName = flash.utils.getQualifiedClassName( this ).split("::")[1];
				
			return _cached._cGenName;
		}
		
		public function get fqn():String
		{
			if( _cached._cFqn == "" || _cached._cFqn == undefined )
				_cached._cFqn = flash.utils.getQualifiedClassName( this );
				
			return _cached._cFqn;
		}
		

		
		
		
		public function get status():ExtensionEnum
		{
			return _cached.status;
		}
		
		protected function setStatus( status:ExtensionEnum ):void
		{
			_cached.status = status;
		}
		
		public function undoStatusChange():void
		{
			
		}
		
		public function deconstruct():void
		{
			// Immediately mark for Garbage Collection
			for( var i:* in _cached )
			{
				delete _cached[i];
			}
		}
		
		protected var _control:ExtendableStreamControl;
		
		protected function get control():ExtendableStreamControl
		{
			return this._control;
		}
		
		raf function connect( stream:ExtendableStreamControl ):void
		{
			_control = stream;
		}
		
		raf function disconnect( ):void
		{
			
		}
		
	}
}