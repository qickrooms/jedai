////////////////////////////////////////////////////////////////////////////////
//
//  Copyright (C) 2007-2008 Infrared5 Incorporated
//  All Rights Reserved. The following is Source Code and is subject to all
//  restrictions on such code as contained in the End User License Agreement
//  accompanying this product.
//
////////////////////////////////////////////////////////////////////////////////

package jedai.controls.flex.video
{
	import flash.events.MouseEvent;
	
	import jedai.Red5BootStrapper;
	import jedai.events.Red5Event;
	
	import mx.controls.Button;
	import mx.core.UIComponent;
	import mx.events.FlexEvent;
	
	//use namespace jedai;
	
	//--------------------------------------
	//  Events
	//--------------------------------------
	
	/**
	 *  Dispatched when the user presses the login control.
	 *
	 *  @eventType jedai.events.LoginEvent.LOGIN
	 */
	[Event(name="login", type="jedai.events.LoginEvent")]

	//--------------------------------------
	//  Other metadata
	//--------------------------------------
	
	[IconFile("../../../../../resources/icons/build/VideoRecord.png")]
	
	/**
	 *  A Login component allows the user to input a username
	 *  and a password.  These values are later used for authenticating
	 *  against a remote server such as Red5. 
	 *
	 *  @mxml
	 *
	 *  <p>The <code>&lt;jedai:Login&gt;</code> tag inherits all the tag attributes
	 *  of its superclass. Use the following syntax:</p>
	 *
	 *  <p>
	 *  <pre>
	 *  &lt;jedai:Login&gt;
	 *    ...
	 *      <i>child tags</i>
	 *    ...
	 *  &lt;/jedai:Login&gt;
	 *  </pre>
	 *  </p>
	 *  
	 *  @includeExample examples/SimpleCanvasExample.mxml
	 * 
	 *  @author Dominick Accattato (dominick_AT_infrared5_DOT_com)
	 */
	public class VideoPublisherControls extends UIComponent
	{
		//include "../../../../config/jedai/Version.as";
		
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
	
		private var bootStrapper:Red5BootStrapper;
		
		public var _dataProvider:VideoPublisher;
		
		private var connected:Boolean = false;
		
		private static var PUBLISH_STARTED:String = "publish_started";
		private static var PUBLISH_STOPPED:String = "publish_stopped";
		private var publishState:String = VideoPublisherControls.PUBLISH_STOPPED;
		
		
		public function set dataProvider(dp:VideoPublisher) : void {
			invalidateSize();
			invalidateDisplayList();
			this._dataProvider = dp;
		}
		
		/**
	     *  The internal UITextField object that renders the label of this Button.
	     * 
	     *  @default null 
	     */
	    protected var publishButton:Button;
	    protected var muteButton:Button;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
	
		/**
		 *  Constructor.
		 */
		public function VideoPublisherControls()
		{
			super();
			this.addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
		} 
		
		/**
		 * 
		 * @param event
		 * 
		 */		
		private function onCreationComplete(event:FlexEvent) : void {
			//this.enabled = false;
			this.tabChildren = true;
			bootStrapper = Red5BootStrapper.getInstance(); 
			bootStrapper.addEventListener(Red5Event.CONNECTED, onConnected);
			if(bootStrapper.connection != null && bootStrapper.connection.connected) {
				onConnected(null);
			}
			
		} 
		
		private function onConnected(event:Red5Event) : void {
			connected = true;
		}
		
		/**
		 * 
		 * @param event
		 * 
		 */		
		private function onPublishButtonClick(event:MouseEvent) : void {
			
			if(connected) {
				
				if(publishState == VideoPublisherControls.PUBLISH_STOPPED) {
					publishState = VideoPublisherControls.PUBLISH_STARTED;
					publishButton.label = "Pause / Stop";
					_dataProvider.startStream();
				} else {
					publishState = VideoPublisherControls.PUBLISH_STOPPED;
					publishButton.label = "Publish";
					_dataProvider.stopStream();
				}
			}
		}
		
		/**
		 * 
		 * @param event
		 * 
		 */		
		private function onMuteButtonClick(event:MouseEvent) : void {
			
			if(connected) {
				switch (muteButton.label) {
					case "Mute":
						muteButton.label = "Unmute";
						_dataProvider.mute();
						break;
						
					case "Unmute":
						muteButton.label = "Mute";
						_dataProvider.unmute();
						break;
						
					default:
						break;
				}
				
			}
		}
		
		//--------------------------------------------------------------------------
		//
		//  Flex Framework Lifecycle
		//
		//--------------------------------------------------------------------------
		
		/**
		 * 
		 * 
		 */		
		override protected function createChildren():void {
			super.createChildren();
			
			if (!publishButton)
	        {
	            publishButton = new Button();
	            publishButton.label = "Publish";
	            publishButton.addEventListener(MouseEvent.CLICK, onPublishButtonClick);
	            this.addChild(publishButton);
	        } 
	        
	        if (!muteButton)
	        {
	            muteButton = new Button();
	            muteButton.label = "Mute";
	            muteButton.addEventListener(MouseEvent.CLICK, onMuteButtonClick);
	            this.addChild(muteButton);
	        } 
				        
		} 
		
		/**
		 * 
		 * 
		 */		 
		override protected function commitProperties():void {
			super.commitProperties();
		} 
		
		/**
		 * 
		 * 
		 */		
		override protected function measure():void {
			super.measure();
			
			if(_dataProvider != null) {
				measuredHeight = measuredMinHeight;
				measuredWidth = measuredMinWidth = this._dataProvider.width;
			} else {
				measuredHeight = measuredMinHeight = this.publishButton.getExplicitOrMeasuredHeight();
				measuredWidth = measuredMinWidth = this.publishButton.getExplicitOrMeasuredWidth() + 20;	
			}
			
		}
		
		/**
		 * 
		 * @param unscaledWidth
		 * @param unscaledHeight
		 * 
		 */		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			 
			// padding
			var padding:int = 10;
			
			// position
			var leftPos:int = 50;
			var rightPos:int = 10;
			var topPos:int = 10;
			var bottomPos:int = 10;
			var size:int = (padding + 50);
			var formDist:int = 25;
		
			//use namespace jedaiUI;
			//var tmp:int = _dataProvider.jedaiUI::getTestWidth();
		
			/* if(_dataProvider != null) {
				publishButton.setActualSize(_dataProvider.getExplicitOrMeasuredWidth(), publishButton.getExplicitOrMeasuredHeight());
				publishButton.move(0, 0);

			} else {
				// loginButton size and position
				topPos += formDist;
				leftPos = unscaledWidth - publishButton.getExplicitOrMeasuredWidth() - padding;
				publishButton.setActualSize(publishButton.getExplicitOrMeasuredWidth(), publishButton.getExplicitOrMeasuredHeight());
				publishButton.move(0, 0);
			} */
			
			publishButton.setActualSize(publishButton.getExplicitOrMeasuredWidth(), publishButton.getExplicitOrMeasuredHeight());
			publishButton.move(0, 0);
			
			muteButton.setActualSize(muteButton.getExplicitOrMeasuredWidth(), muteButton.getExplicitOrMeasuredHeight());
			muteButton.move(publishButton.getExplicitOrMeasuredWidth() + 20, 0);
			
			
		}
		
		public namespace raf = "raf/internal";
		
		
	}
}