package jedai.business;

import org.red5.server.api.*;
import org.springframework.security.context.SecurityContext;
import org.springframework.security.context.SecurityContextHolderStrategy;
import org.springframework.security.context.SecurityContextImpl;
import org.springframework.util.*;

public class JedaiSecurityContextHolderStrategy implements SecurityContextHolderStrategy {
	private static final String CONTEXT_ATTRIBUTE = "acegi_context";
	private static ThreadLocal<SecurityContext> contextHolder = new ThreadLocal<SecurityContext>();

	public void clearContext() {
		IConnection connection = Red5.getConnectionLocal();
		if(connection!=null){
			synchronized (connection) {
				connection.removeAttribute(CONTEXT_ATTRIBUTE);
			}
		}else{
			contextHolder.set(null);
		}
	}

	public SecurityContext getContext() {
		IConnection connection = Red5.getConnectionLocal();
		if(connection!=null){
			synchronized(connection){
				SecurityContext securityContext = (SecurityContext) connection.getAttribute(CONTEXT_ATTRIBUTE);
				if(securityContext == null){
					securityContext = new SecurityContextImpl();
					connection.setAttribute(CONTEXT_ATTRIBUTE, securityContext);
				}
				return securityContext;
			}
		}else{
	        if (contextHolder.get() == null) {
	            contextHolder.set(new SecurityContextImpl());
	        }
	        return (SecurityContext) contextHolder.get();
		}
	}

	public void setContext(SecurityContext context) {
		IConnection connection = Red5.getConnectionLocal();
		if(connection!=null){
			synchronized (connection) {
				connection.setAttribute(CONTEXT_ATTRIBUTE, context);
			}
		}else{
	       Assert.notNull(context, "Only non-null SecurityContext instances are permitted");
	       contextHolder.set(context);
		}
	}

}