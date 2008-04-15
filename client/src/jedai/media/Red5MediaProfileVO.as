package jedai.media
{
	import com.adobe.cairngorm.vo.IValueObject;
	import jedai.business.Red5MediaProfileLocator;

	public class Red5MediaProfileVO implements IValueObject
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
		
		public function Red5MediaProfileVO( name:String )
		{
			_name = name;
			
			use namespace raf;
			
			Red5MediaProfileLocator.getInstance().registerPreset( this );
		}
		
		private var _name:String;
		
		public function get name():String
		{
			return _name;
		}
		
		public var width					: int;
		public var height					: int;
		public var fps						: int;
		public var videoKb					: int; // ceiling
		public var minVideoKb				: int; // floor
		public var videoKeyframeInterval	: int;
		public var videoQuality				: int	= 90;
		public var audioSampleHz			: int;
		public var archiveable				: Boolean;
		
	}
}