package com.infrared5.asmf.media.extensions
{
	import com.infrared5.io.extensions.AbstractStreamExtension;
	import com.infrared5.io.extensions.ExtendableStreamControl;
	import com.infrared5.io.extensions.StreamExtension;
	import com.infrared5.io.extensions.enum.ResourceEnum;
	
	import flash.media.Microphone;

	public class MicrophoneLevelEqualizer 	extends AbstractStreamExtension
											implements StreamExtension
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
		
		public function MicrophoneLevelEqualizer()
		{
			super();
		}
		
		protected var _mic:Function
		
		override raf function connect( stream:ExtendableStreamControl ):void
		{
			_control = stream;
			
			use namespace raf;
			
			stream.requestExternalResource( ResourceEnum.MICROPHONE, this.requestMicrophoneHandler );
		}
		
		private function requestMicrophoneHandler( mic:Microphone ):void
		{
			// Got Microphone
		}
		
		override raf function disconnect( ):void
		{
			
		}
	}
}