/**
 * 
 */
package jedai.business;

import java.util.HashMap;

import jedai.business.exceptions.ExistingUserException;
import jedai.domain.security.Authorities;
import jedai.domain.security.AuthoritiesHome;
import jedai.domain.security.AuthoritiesId;
import jedai.domain.security.Users;
import jedai.domain.security.UsersHome;
import jedai.vo.AuthVO;
import jedai.vo.RegistrationVO;

import org.red5.server.adapter.ApplicationLifecycle;
import org.red5.server.adapter.MultiThreadedApplicationAdapter;
import org.red5.server.api.IClient;
import org.red5.server.api.IConnection;
import org.red5.server.api.IScope;
import org.springframework.beans.BeansException;
import org.springframework.context.ApplicationContext;
import org.springframework.context.ApplicationContextAware;
import org.springframework.security.Authentication;
import org.springframework.security.AuthenticationException;
import org.springframework.security.AuthenticationManager;
import org.springframework.security.context.SecurityContextHolder;
import org.springframework.security.providers.UsernamePasswordAuthenticationToken;



/**
 * @author dominickaccattato
 *
 */
public class JedaiAuthorizationService extends ApplicationLifecycle implements ApplicationContextAware {

	private MultiThreadedApplicationAdapter application;
	private AuthenticationManager authenticationManager;
	
	public void init() {
		SecurityContextHolder.setStrategyName("jedai.business.JedaiSecurityContextHolderStrategy");
	}
	
	public AuthenticationManager getAuthenticationManager() {
		return authenticationManager;
	}

	public void setAuthenticationManager(AuthenticationManager authenticationManager) {
		this.authenticationManager = authenticationManager;
	}

	@Override
	public void setApplicationContext(ApplicationContext appCtx) throws BeansException {
		this.application = (MultiThreadedApplicationAdapter) appCtx.getBean("web.handler");
		this.application.addListener(this);
	}

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
	
	public boolean register(RegistrationVO vo) throws ExistingUserException {	
		Users user = new Users();
		user.setUsername(vo.userName);
		user.setPassword(vo.password);
		user.setEnabled(true);
		UsersHome usersHome = new UsersHome();
		
		// Check for existing user or password
		isValidRegistration(user, usersHome);
		
		// if no exception was thrown, finish
		// persisting the user and their authorities			
		AuthoritiesId authID = new AuthoritiesId();
		authID.setAuthority("ROLE_USER");
		authID.setUsername(vo.userName);
				
		Authorities authorities = new Authorities();
		authorities.setId(authID);
		
		AuthoritiesHome authHome = new AuthoritiesHome();
		usersHome.persist(user);
		authHome.persist(authorities);
		
		return true;
	}
	
	/**
	 * Determines if registration is valid
	 * 
	 * @param user
	 * @param uh
	 * @throws ExistingUserException
	 */
	private void isValidRegistration(Users user, UsersHome uh)
			throws ExistingUserException {
		Users existingUser = uh.findById(user.getUsername());
		if(existingUser != null) {
			// 500 = EXISTING USER
			throw new ExistingUserException("500");
		}
		
		// TODO check for valid email
	}


}
