/**
 * 
 */
package jedai.business;

import java.util.HashMap;

import jedai.vo.AuthVO;

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
	public boolean appConnect(IConnection arg0, Object[] arg1) {
		//return false;
		return true;
	}
	
	@Override
	public void appDisconnect(IConnection conn) {
		// TODO Auto-generated method stub
		super.appDisconnect(conn);
	}

	@Override
	public boolean appJoin(IClient client, IScope app) {
		// TODO Auto-generated method stub
		return super.appJoin(client, app);
	}

	@Override
	public void appLeave(IClient client, IScope app) {
		// TODO Auto-generated method stub
		super.appLeave(client, app);
	}

	@Override
	public boolean appStart(IScope app) {
		// TODO Auto-generated method stub
		return super.appStart(app);
	}

	@Override
	public void appStop(IScope app) {
		// TODO Auto-generated method stub
		super.appStop(app);
	}

	@Override
	public boolean roomConnect(IConnection conn, Object[] params) {
		// TODO Auto-generated method stub
		return super.roomConnect(conn, params);
	}

	@Override
	public void roomDisconnect(IConnection conn) {
		// TODO Auto-generated method stub
		super.roomDisconnect(conn);
	}

	@Override
	public boolean roomJoin(IClient client, IScope room) {
		// TODO Auto-generated method stub
		return super.roomJoin(client, room);
	}

	@Override
	public void roomLeave(IClient client, IScope room) {
		// TODO Auto-generated method stub
		super.roomLeave(client, room);
	}

	@Override
	public boolean roomStart(IScope room) {
		// TODO Auto-generated method stub
		return super.roomStart(room);
	}

	@Override
	public void roomStop(IScope room) {
		// TODO Auto-generated method stub
		super.roomStop(room);
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
		}
		if(!token.isAuthenticated()){
			return false;
		}
		return true;
	}


}
