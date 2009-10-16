////////////////////////////////////////////////////////////////////////////////
//
//  Copyright (C) 2007-2008 Infrared5 Incorporated
//  All Rights Reserved. The following is Source Code and is subject to all
//  restrictions on such code as contained in the End User License Agreement
//  accompanying this product.
//
////////////////////////////////////////////////////////////////////////////////

package jedai.controls.flex.data
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import jedai.Red5BootStrapper;
	import jedai.business.Red5ServiceLocator;
	import jedai.net.ClientManager;
	import jedai.net.rpc.Red5Connection;
	import jedai.vo.AuthVO;
	
	import mx.controls.Alert;
	import mx.controls.Button;
	import mx.controls.Label;
	import mx.controls.TextInput;
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
	
	[IconFile("../../../../../resources/icons/build/SimpleConnect.png")]
	
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
	public class Login extends UIComponent
	{
		//include "../../../../config/jedai/Version.as";
		
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
	
		private var bootStrapper:Red5BootStrapper;
		
		/**
		 *  @private components
		 */
		private var _username:String;
	    private var usernameChanged:Boolean = false;
		private var _password:String;
	    private var passwordChanged:Boolean = false;
		
		/**
	     *  The internal UITextField object that renders the label of this Button.
	     * 
	     *  @default null 
	     */
	    protected var usernameField:TextInput;
	    protected var passwordField:TextInput;
	    protected var usernameLabel:Label;
	    protected var passwordLabel:Label;
	    protected var loginButton:Button;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
	
		/**
		 *  Constructor.
		 */
		public function Login()
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
		} 
		
		/**
		 * 
		 * @param event
		 * 
		 */		
		private function onLoginButtonClick(event:MouseEvent) : void {
			
			var conn:Red5Connection = Red5ServiceLocator.getInstance().getRed5Connection("default");	
			
			var retStr:String;
			if(this.usernameField.text == "") {
				retStr = "Please fill in username";
				Alert.show(retStr);
				return;
			} else if(this.passwordField.text == "") {
				retStr = "Please fill in a password";
				Alert.show(retStr);
				return;
			}
			
			var args:Array = [this.usernameField.text, this.passwordField.text];
			conn.connectionArgs = args;		
			
			// Setup ClientManager
			var cm:ClientManager = new ClientManager();
			cm.username = this.usernameField.text;
			cm.password = this.passwordField.text;
			
			// Setup AuthVO
			var auth:AuthVO = new AuthVO("dominick", "test");
			
			Red5BootStrapper.getInstance().client = cm;
			bootStrapper.connect(auth);
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
			
			if (!usernameField)
	        {
	            usernameField = new TextInput();
	            usernameField.tabIndex = 1;
	            this.addChild(usernameField);
	        } 
	        
	        if (!passwordField)
	        {
	            passwordField = new TextInput();
	            passwordField.tabIndex = 2;
	            this.addChild(passwordField);
	        }
	        
	         
	        if (!usernameLabel)
	        {
	            usernameLabel = new Label();
	            usernameLabel.text = "user:";
	            this.addChild(usernameLabel);
	        }
	        
	        
	        if (!passwordLabel)
	        {
	            passwordLabel = new Label();
	            passwordLabel.text = "pass:";
	            this.addChild(passwordLabel);
	        }
	        
	        if (!loginButton)
	        {
	            loginButton = new Button();
	            loginButton.label = "Login";
	            loginButton.addEventListener(MouseEvent.CLICK, onLoginButtonClick);
	            this.addChild(loginButton);
	        }
	        /* 
	        box = new Canvas();
	        this.addChild(box); */
	        
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
			
			measuredHeight = measuredMinHeight = this.usernameField.getExplicitOrMeasuredHeight() + this.passwordField.getExplicitOrMeasuredHeight() + this.loginButton.getExplicitOrMeasuredHeight();
			measuredWidth = measuredMinWidth = this.usernameField.getExplicitOrMeasuredWidth() + 20;
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
		
			// usernameField size and position
			usernameField.setActualSize((unscaledWidth - size), usernameField.getExplicitOrMeasuredHeight());
			usernameField.move(leftPos, topPos); 
			
			// usernameLabel size and position
			leftPos = padding;
			usernameLabel.setActualSize(usernameLabel.getExplicitOrMeasuredWidth(), usernameLabel.getExplicitOrMeasuredHeight());
			usernameLabel.move(leftPos, topPos);
			
			// passwordField size and position
			topPos += formDist;
			leftPos = 50;
			passwordField.setActualSize((unscaledWidth - size), passwordField.getExplicitOrMeasuredHeight());
			passwordField.move(leftPos, topPos);  
			
			// passwordLabel size and position
			leftPos = padding;
			passwordLabel.setActualSize(passwordLabel.getExplicitOrMeasuredWidth(), passwordLabel.getExplicitOrMeasuredHeight());
			passwordLabel.move(leftPos, topPos);
			
			// loginButton size and position
			topPos += formDist;
			leftPos = unscaledWidth - loginButton.getExplicitOrMeasuredWidth() - padding;
			loginButton.setActualSize(loginButton.getExplicitOrMeasuredWidth(), loginButton.getExplicitOrMeasuredHeight());
			loginButton.move(leftPos, topPos);
			/* 
			box.setActualSize(unscaledWidth, unscaledHeight);
			box.buttonMode = true; */
			
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Getter / Setter 
		//
		//--------------------------------------------------------------------------
		
		
		/**
		 * 
		 * @return 
		 * 
		 */		
		public function get username():String
	    {
	        return _username;
	    } 
	
	    /**
	     *  @private
	     */
	    public function set username(value:String):void {
	    	this._username = value;
	    	
	    	if (_username != value)
	        {
	            _username = value;
	            usernameChanged = true;
	
	            invalidateDisplayList();
	
	            dispatchEvent(new Event("usernameChanged"));
	        }
	    }
	    
	    /**
	     * 
	     * @return 
	     * 
	     */	    
	    public function get password():String
	    {
	        return _password;
	    } 
	 
		/**
		 *  @private
		 */
	    public function set password(value:String):void {
	    	this._password = value;
	    	
	    	if (_password != value)
	        {
	            _password = value;
	            passwordChanged = true;
	
	            invalidateDisplayList();
	
	            dispatchEvent(new Event("passwordChanged"));
	        }
	    } 
		
	}
}