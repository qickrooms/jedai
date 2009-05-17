package jedai.business
{
	import com.adobe.cairngorm.CairngormError;
	import com.adobe.cairngorm.CairngormMessageCodes;
	import com.adobe.cairngorm.business.AbstractServices;
	import com.adobe.cairngorm.business.IServiceLocator;
	
	import jedai.net.IService;
	
	import flash.utils.Dictionary;

	/**
	 * Implements Abstract API used by ASMF Services.  Most of the code came from Cairngorm's RemoteObject class.
	 * 
	 * @author Jon Valliere ( sybersnake_AT_gmail_DOT_com )
	 * @author Dominick Accattato ( dominick_AT_infrared5_DOT_com )
	 */
	public class Red5AbstractServices extends AbstractServices
	{
		protected function getTypeCheck( type:* ):Boolean
		{
			throw new CairngormError( CairngormMessageCodes.ABSTRACT_METHOD_CALLED, "getTypeCheck" );
		}
		
		private var services : Dictionary = new Dictionary();
      
      /**
       * Register the services.
       * @param serviceLocator the IServiceLocator instance.
       */
      public override function register( serviceLocator : IServiceLocator ) : void
      {
         var accessors : XMLList = getAccessors( serviceLocator );
         
         for ( var i : uint = 0; i < accessors.length(); i++ )
         {
            var name : String = accessors[ i ];
            var obj : Object = serviceLocator[ name ];
            
            if ( this.getTypeCheck( obj ) )
            {
               services[ name ] = obj;
            }
         }
      }
      
      /**
      * Registers service objects at runtime
      * 
      * @arg *
      **/
      public function runtimeRegister( obj:* ):void
      {
      	if( this.getTypeCheck( obj ) )
      	{
      		services[ IService( obj ).name ] = obj;
      	}
      }
      
      /**
       * Return the service with the given name.
       * @param name the name of the service.
       * @return the service.
       */
      public override function getService( name : String ) : Object
      {
         var service : * = services[ name ];
         
         if ( service == null )
         {
            throw new CairngormError(
               CairngormMessageCodes.REMOTE_OBJECT_NOT_FOUND, name );
         }
         
         return service;
      }
      
      /**
       * Set the credentials for all registered services.
       * @param username the username to set.
       * @param password the password to set.
       */
      public override function setCredentials( username : String, password : String ) : void
      {
         for ( var name : String in services )
         {
            var service : * = services[ name ];
            
            service.logout();
            service.setCredentials( username, password );
         }
      }
      
      /**
       * Set the remote credentials for all registered services.
       * @param username the username to set.
       * @param password the password to set.
       */
      public override function setRemoteCredentials( username : String, password : String ) : void
      {
         for ( var name : String in services )
         {
            var service : * = services[ name ];
            
            service.setRemoteCredentials( username, password );
         }
      }
      
      /**
       * Log the user out of all registered services.
       */
      public override function logout() : void
      {
         for ( var name : String in services )
         {
            var service : * = services[ name ];
            
            service.logout();
         }
      }
	}
}