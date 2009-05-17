package jedai.business;

/*
 * Jedai Networking Framework - http://jedai.googlecode.com
 * 
 * Copyright (c) 2006-2009 by respective authors (see below). All rights reserved.
 * 
 * This library is free software; you can redistribute it and/or modify it under the 
 * terms of the GNU Lesser General Public License as published by the Free Software 
 * Foundation; either version 2.1 of the License, or (at your option) any later 
 * version. 
 * 
 * This library is distributed in the hope that it will be useful, but WITHOUT ANY 
 * WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A 
 * PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.
 * 
 * You should have received a copy of the GNU Lesser General Public License along 
 * with this library; if not, write to the Free Software Foundation, Inc., 
 * 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA 
 */

import jedai.vo.AuthVO;

import org.red5.server.adapter.ApplicationLifecycle;
import org.red5.server.adapter.MultiThreadedApplicationAdapter;
import org.springframework.beans.BeansException;
import org.springframework.context.ApplicationContext;
import org.springframework.context.ApplicationContextAware;
import org.springframework.security.Authentication;
import org.springframework.security.AuthenticationException;
import org.springframework.security.AuthenticationManager;
import org.springframework.security.context.SecurityContextHolder;
import org.springframework.security.providers.UsernamePasswordAuthenticationToken;

/**
 * An default implementation of an authorization service.  This class can be subclassed
 * if additional logic is needed.
 * 
 * @author dominickaccattato
 *
 */
public class JAuthorizationService extends ApplicationLifecycle implements ApplicationContextAware {

	private MultiThreadedApplicationAdapter application;
	private AuthenticationManager authenticationManager;
	
	/**
	 * initializes the strategy used by SpringSecurity
	 */
	public void init() {
		SecurityContextHolder.setStrategyName("jedai.business.JedaiSecurityContextHolderStrategy");
	}
	
	/**
	 * gets the AuthenticationManager instance
	 * 
	 * @return
	 */
	public AuthenticationManager getAuthenticationManager() {
		return authenticationManager;
	}

	/**
	 * sets the AuthenticationManager instance
	 * 
	 * @param authenticationManager
	 */
	public void setAuthenticationManager(AuthenticationManager authenticationManager) {
		this.authenticationManager = authenticationManager;
	}

	/* (non-Javadoc)
	 * @see org.springframework.context.ApplicationContextAware#setApplicationContext(org.springframework.context.ApplicationContext)
	 */
	@Override
	public void setApplicationContext(ApplicationContext appCtx) throws BeansException {
		this.application = (MultiThreadedApplicationAdapter) appCtx.getBean("web.handler");
		this.application.addListener(this);
	}

	/**
	 * authenticates a client
	 * 
	 * @param authvo
	 * 			AuthVO the object being authenticated
	 * 
	 * @return val
	 * 			Boolean the returned boolean value
	 */
	public boolean authenticate(AuthVO authvo) {
		Authentication token=new UsernamePasswordAuthenticationToken(authvo.getUserName(),authvo.getPassword());
		
		try{
			token = authenticationManager.authenticate(token);
			SecurityContextHolder.getContext().setAuthentication(token);

		}catch(AuthenticationException ex){
			// report error
			System.out.println("ERROR: " + ex);
		}
		
		if(!token.isAuthenticated()){
			return false;
		}
		
		return true;
	}
	
	public boolean test() {
		return true;
	}
	

}
