package com.infrared5.asmf.net
{
	import com.infrared5.asmf.net.ClientManager;
	import com.infrared5.asmf.net.rpc.Red5Application;
	import com.infrared5.asmf.net.rpc.Red5Connection;
	
	import flash.events.NetStatusEvent;
	
	import flexunit.framework.TestCase;
	import flexunit.framework.TestSuite;
	
	import mx.events.FlexEvent;
	
	import org.pranaframework.ioc.loader.ObjectDefinitionsLoaderEvent;
	
	/**
	 * Red5ApplicationTest is a testcase for the bootstrapping and connecting to Red5
	 * 
	 * @author Dominick Accattato (dominick@infrared5.com)
	 **/
	public class Red5ApplicationTest extends TestCase
	{
		private var application:Red5Application;
		private var connection:Red5Connection;
		
		public function Red5ApplicationTest(method:String) {
			super(method);
		}
		
		/**
		 * Tests bootstrap mechanism. Checks for valid client object
		 **/
		public function testBootstrapClient() : void {
			var app:Red5Application = new Red5Application();
			app.addEventListener(ObjectDefinitionsLoaderEvent.COMPLETE, addAsync(onTestBootstrapClient, 2000));
			app.onCreationComplete(new FlexEvent(FlexEvent.CREATION_COMPLETE));
		}
		
		/**
		 * Tests bootstrap mechanism callback. Checks for valid client object
		 **/
		private function onTestBootstrapClient(event:ObjectDefinitionsLoaderEvent) : void {
			assertNotNull(event.target.client); // test to see if bean loaded
			assertEquals(event.target.client.username, "user");
			assertEquals(event.target.client.password, "pass");
		}
		
		/**
		 * Tests bootstrap mechanism. Checks for valid connection object
		 **/
		public function testBootstrapConnection() : void {
			var app:Red5Application = new Red5Application();
			app.addEventListener(ObjectDefinitionsLoaderEvent.COMPLETE, addAsync(onTestBootstrapConnection, 2000));
			app.onCreationComplete(new FlexEvent(FlexEvent.CREATION_COMPLETE));
		}
		
		/**
		 * Tests bootstrap mechanism. Checks for valid connection object
		 **/
		public function onTestBootstrapConnection(event:ObjectDefinitionsLoaderEvent) : void {
			// Setup local client
			var tmpClient:ClientManager = new ClientManager();
			tmpClient.username = "user";
			tmpClient.password = "pass";
			
			// Retrieve connection arguments
			var connection:Red5Connection = Red5Connection(event.target.connection);
			var connectionArgs:Array = connection.connectionArgs;
			var client:ClientManager = ClientManager(connectionArgs[0]);
			
			// test connection arguments
			assertNotNull(event.target.connection);
			assertEquals(client.username, tmpClient.username);
			assertEquals(client.password, tmpClient.password);
			
			// test that connection uri is not null
			assertNotNull(connection.rtmpURI);
			
		}
		
		/**
		 * Tests Red5 connection. Checks for a successful connection
		 **/
		public function testRed5Connection() : void {
			connection = new Red5Connection("default", true);
			connection.connect("rtmp://localhost/jedai", "dominick");
			connection.addEventListener(NetStatusEvent.NET_STATUS, addAsync(onTestRed5Connection, 2000));	
			connection.client = this;
			//addAsync(onTest, 2000);
		}

		/**
		 * Tests Red5 connection callback. Checks for a successful connection
		 **/
		private function onTestRed5Connection(event:NetStatusEvent) : void {
			assertEquals(event.info.code, "NetConnection.Connect.Success");
		}
		public function setClientID(val:Number) : void {
			trace("val: " + val);
		} 
		
		/**
		 * Setup the flexunit suite
		 **/
		public static function suite() : TestSuite {
			var suite:TestSuite = new TestSuite();
			suite.addTest(new Red5ApplicationTest("testBootstrapClient"));
			suite.addTest(new Red5ApplicationTest("testBootstrapConnection"));
			suite.addTest(new Red5ApplicationTest("testRed5Connection"));
			
			return suite;
		} 

	}
}