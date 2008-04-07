package com.infrared5.asmf.business
{
	import com.adobe.cairngorm.CairngormError;
	import com.adobe.cairngorm.CairngormMessageCodes;
	import com.infrared5.io.errors.DuplicateItemError;
	import com.infrared5.asmf.media.Red5MediaProfileVO;

	public class Red5MediaProfileLocator
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
		
		private static var instance:Red5MediaProfileLocator;
		
		public static function getInstance():Red5MediaProfileLocator
		{
			if( instance == null )
			{
				instance = new Red5MediaProfileLocator( new SingleKey());
			}
			
			return instance;
		}

		//-------------------------------------------------------------
		//
		//	Instance
		//
		//-------------------------------------------------------------
		
		public function Red5MediaProfileLocator( sin:SingleKey )
		{
			if( sin == null )
			{
				throw new CairngormError( CairngormMessageCodes.SINGLETON_EXCEPTION );
			}
		}
		
		private var _presets:Object =  new Object();
		
		raf function registerPreset( preset:Red5MediaProfileVO ):void
		{
			if( _presets[ preset.name ] != undefined )
			{
				//throw new DuplicateItemError("Preset "+preset.name+" has already been registered with this Locator");
			}
			
			_presets[ preset.name ] = preset;
		}
		
		public function lookupPreset( name:String ):Red5MediaProfileVO
		{
			return _presets[ name ] as Red5MediaProfileVO;
		}
	}
}

class SingleKey {}