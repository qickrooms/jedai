package com.infrared5.asmf.media.extensions
{
	import com.infrared5.asmf.media.Red5MediaProfileVO;
	import com.infrared5.asmf.media.rtp.Red5NetStream;
	import com.infrared5.asmf.media.rtp.events.Red5NetStreamEvent;
	import com.infrared5.io.extensions.AbstractStreamExtension;
	import com.infrared5.io.extensions.ExtendableStreamControl;
	import com.infrared5.io.extensions.StreamExtension;
	import com.infrared5.io.extensions.enum.ResourceEnum;
	
	import flash.media.Camera;
	import flash.utils.clearInterval;
	import flash.utils.setInterval;


	public class VideoQualityOptimizer 	extends AbstractStreamExtension implements StreamExtension
	{
		public static var adjustmentMarginInFPS		: int = 3;
		
		public static var adjustmentStepsInPercent	: Number = 0.15;
		
		public function VideoQualityOptimizer()
		{
			super();
			
			_records = new Array();
		}
		
		protected var _records			: Array;
		private var _samplerInterval	: uint;
		private var _stream				: Red5NetStream;
		private var _profileCeiling		: Red5MediaProfileVO;
		private var _profileFloor		: Number;
		
		private var _originalVideoQ		: int;
		
		private var _cam				: Camera;
		
		// Use totalTime to calculate total broadcast time. 
		// Use trackerTime to calculate total time spent on current bitrate. 
		// The function blocks should be called using 500 milisecond timers. 
		
		private var totalTime:Number = 0;
		private var trackerTime:Number = 0;
		private var totalBytesSent:Number = 0;
		private var celingBitrate:Number = 128000;
		private var videoBitrate:Number = 64000;  		// Bitrate of Video (in bytes: 256kb) 
		private var playerBuffer:Number = 10;
		
		private var _strength:Number = 0;
		
		private function cameraAttachHandler( cam:Camera ):void
		{
			_cam = cam;
		}
		
		public function checkBitrate() : void
		{
		}
		
		override public function toString() : String {
			var retVal:String = "";
			
				 
			return retVal;
		}
		
		private var switchVal:Boolean = true;
		public function adjustBitrate(percentage:Number) : void
		{
		}
		
		protected function startupCheck( event:Red5NetStreamEvent ):void
		{
			
		}
		 
		protected function stopSampling( event:Red5NetStreamEvent ):void
		{
		}
		
		protected function internalStart():void
		{
		}
		
		
		override raf function connect( stream:ExtendableStreamControl ):void
		{
		}
		
	}
}