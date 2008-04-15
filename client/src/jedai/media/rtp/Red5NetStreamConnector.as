package jedai.media.rtp
{
	import jedai.business.Red5ServiceLocator;
	import jedai.events.Red5Event;
	import jedai.net.rpc.Red5Connection;
	import jedai.io.InputDevice;
	import jedai.io.OneWayMuxer;
	import jedai.io.OutputDevice;
	
	/**
	 * Red5NetStreamConnector is a Wrapper for <code>Red5NetStream</code>.
	 * 
	 * <p>This allows you to create an instance of the <code>Red5NetStream</code> class that does not require 
	 * a NetConnection defined upon instantiation. The NetConnection also does not need to be connected when 
	 * applied. </p>
	 * 
	 * Essentially -- a lazy way to create the entire connection mechanism without having to do anything in   
	 * any specific order.
	 * 
	 * @author Jon Valliere (jvalliere@emoten.com)
	 * @author Dominick Accattato (dominick@infrared5.com)
	 * @author Thijs Triemstra (info@collab.nl)
	 * 
	 * @see jedai.media.rtp.Red5NetStream Red5NetStream
	 */
	public class Red5NetStreamConnector implements OneWayMuxer
	{
		public function Red5NetStreamConnector( connection:Red5Connection=null )
		{
			_net = connection;
			
			/* if( useDefaultConnection )
			{
				_net = Red5ServiceLocator.getInstance().getDefaultRed5Connection();
			} */
			
			if ( _net.connected )
			{
				this.internalConnect( _net );
			}
			else
			{
				_net.addEventListener( Red5Event.CONNECTED, this.netConnectedHandler );
				_net.addEventListener( Red5Event.DISCONNECTED, this.netDisconnectedHandler );
			}
		}
		
		private function netConnectedHandler( value:Red5Event ):void
		{
			this.internalConnect( _net );
		}
		
		private function netDisconnectedHandler( value:Red5Event ):void
		{
			this.internalClose( _net );
		}
		
		private var _stream		: Red5NetStream;
		
		private var _net		: Red5Connection;
		
		/**
		 * 
		 * @param connection
		 */		
		public function useConnection( connection:String ):void
		{
			_net = Red5ServiceLocator.getInstance().getRed5Connection( connection );
			
			if ( _net.connected )
			{
				this.internalConnect( _net );
			}
		}
		
		private function internalConnect( connection:Red5Connection ):void
		{
			_stream = new Red5NetStream( connection );
		}
		
		private function internalClose( connection:Red5Connection ):void
		{
			if ( _stream != null ) {
				_stream.close();
			}
		}
		
		public function getStream():Red5NetStream
		{
			return _stream;
		}
		
		public function getConnection():Red5Connection
		{
			return _net;
		}
		
		/**
		 * 
		 * @param stream
		 * @param args
		 */		
		public function attachInputFrom( stream:InputDevice, ... args ):void
		{
			_stream.attachInputFrom( stream, args[0] );
		}
		
		/**
		 * 
		 * @param stream
		 * @param args
		 */		
		public function attachOutputTo( stream:OutputDevice, ... args ):void
		{
			_stream.attachOutputTo( stream, args[0] );
		}
		
		/**
		 * 
		 * @param streamName The name of the stream.
		 */		
		public function pauseRecord( streamName:String=null ):void
		{
			this.stopRecord();
		}
		
		/**
		 * 
		 * @param streamName The name of the stream.
		 */		
		public function resumeRecord( streamName:String=null ):void
		{
			_stream.publish( streamName, "append" );
		}
		
		/**
		 * 
		 * @param streamName The name of the stream.
		 */		
		public function startRecord( streamName:String=null ):void
		{
			_stream.publish( streamName, "record" );
		}
		
		/**
		 * XXX Thijs: There's something with ns.publish(false), the compiler complains about
		 * passing in a Boolean but this is the only why to stop publishing netStream 
		 * according to the LiveDocs [1].
		 * 
		 * I think what happens is that Red5 receives the stream name "false" as String which it 
		 * recognizes as any other String for a streamname, creating a 'false.flv' file instead 
		 * of actually stopping the recording.
		 * 
		 * A workaround is to close the NetStream which triggers NetStream.Record.Stop and
		 * NetStream.Unpublish.Success events before it closes.
		 * 
		 * @param name
		 * @param type
		 * 
		 * @see [1] http://livedocs.adobe.com/labs/flex/3/langref/flash/net/NetStream.html#publish()
		 * 
		 */			
		public function stopRecord():void
		{
			_stream.close(); //publish( false );
		}
		
		/**
		 * Wraps the NetStream publish method.
		 * 
		 * @param streamName The name of the stream.
		 */
		public function publish( streamName:String, type:String ): void
		{
			_stream.publish(streamName, type);
		}
		
		/**
		 * Wraps the NetStream play method.
		 * 
		 * @param streamName The name of the stream.
		 */
		public function play( streamName:String ) : void 
		{
			_stream.play(streamName);
		}
		
		public function isConnected() : Boolean
		{
			return ( _net.connected );
		}
	}
}