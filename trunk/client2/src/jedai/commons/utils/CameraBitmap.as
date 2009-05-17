package jedai.commons.utils
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.IBitmapDrawable;
	import flash.utils.ByteArray;
	
	import mx.graphics.codec.JPEGEncoder;
	import mx.graphics.codec.PNGEncoder;
	
	/**
	 * 
	 * @author Thijs Triemstra ( info@collab.nl )
	 */	
	public class CameraBitmap
	{
		private var _png			: PNGEncoder;
		private var _jpg			: JPEGEncoder;
		private var _width			: int;
		private var _height 		: int;
		private var _data			: BitmapData;
		private var _bitmap			: Bitmap;
			
		public function CameraBitmap( width:int=320, height:int=240 )
		{
			_width = width;
			_height = height;
			_data = new BitmapData( _width,  _height, true );
			_bitmap = new Bitmap( _data );
		}
		
		public function draw( source: IBitmapDrawable ): void
		{
			_data.draw( source );
		}
		
		/**
		 * @return Raw BitmapData.
		 */	
		public function get data(): BitmapData
		{
			return _data;
		}
		
		/**
		 * @return Raw Bitmap.
		 */		
		public function get bitmap(): Bitmap
		{
			return _bitmap;
		}
		
		/**
		 * @return ByteArray containing PNG image.
		 */		
		public function get png(): ByteArray
		{
			return _png.encode( _data );
		}
		
		/**
		 * @return ByteArray containing JPG image.
		 */	
		public function get jpg(): ByteArray
		{
			return _jpg.encode( _data );
		}
		
	}
}