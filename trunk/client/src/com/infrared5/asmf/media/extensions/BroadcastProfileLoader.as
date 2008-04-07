package com.infrared5.asmf.media.extensions
{
	import com.infrared5.asmf.media.Red5MediaProfileVO;
	import com.infrared5.io.extensions.AbstractStreamExtension;
	import com.infrared5.io.extensions.ExtendableStreamControl;
	import com.infrared5.io.extensions.StreamExtension;
	import com.infrared5.io.extensions.enum.ResourceEnum;
	
	import flash.media.Camera;
	import flash.media.Microphone;

	public class BroadcastProfileLoader extends AbstractStreamExtension implements StreamExtension
	{
		public function BroadcastProfileLoader( preset:Red5MediaProfileVO=null)
		{
			super();
			
			if( preset != null )
			this.loadConfiguration( preset );
		}
		
		private var _confi:Red5MediaProfileVO;
		
		public function loadConfiguration( preset:Red5MediaProfileVO ):void
		{
			_confi = preset;
			
			this.checkResourcesAvail();
		}
		
		public function getProfile():Red5MediaProfileVO
		{
			return _confi;
		}


		override public function deconstruct():void
		{
			super.deconstruct();
	
		}
		
		private var _cam:Camera;
		
		private function cameraAttachHandler( cam:Camera ):void
		{           
			_cam = cam;
			
			this.checkResourcesAvail();
		}
		
		private var _mic:Microphone;
		
		private function micAttachHandler( mic:Microphone ):void
		{
			_mic = mic;
			
			this.checkResourcesAvail();
		}
		
		private function checkResourcesAvail():void
		{
			if( _mic != null && _cam != null && _confi != null )
			{
				// Start
				
				this.loadConfig();
			}
		}
		
		/**
		 * loads a profile 
		 **/
		private function loadConfig():void
		{
			trace("BroacastProfileLoader received required resoruces and loaded the profile");
			
			var c:Red5MediaProfileVO = this._confi;
			
			
			this._cam.setKeyFrameInterval( c.videoKeyframeInterval );
			this._cam.setQuality( c.videoKb, c.videoQuality );
			this._cam.setMode( c.width, c.height, c.fps, true );
			this._mic.rate = c.audioSampleHz; 
			//this._mic.gain = 60;
           	//this._mic.rate = 11;
           	this._mic.setUseEchoSuppression(true);
           	//this._mic.setLoopBack(false);
           	this._mic.setSilenceLevel(5, 1000);  
		}
		
		override raf function connect( stream:ExtendableStreamControl ):void
		{
			use namespace raf;
			super.connect( stream );
			
			this.control.requestExternalResource( ResourceEnum.CAMERA, this.cameraAttachHandler );
			this.control.requestExternalResource( ResourceEnum.MICROPHONE, this.micAttachHandler );
		}
		
	}
}