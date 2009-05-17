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

import java.util.HashMap;
import java.util.Map;

import javax.mail.internet.MimeMessage;

import org.apache.velocity.app.VelocityEngine;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.mail.javamail.MimeMessagePreparator;
import org.springframework.ui.velocity.VelocityEngineUtils;

import jedai.business.exceptions.ExistingUserException;
import jedai.domain.security.Authorities;
import jedai.domain.security.AuthoritiesHome;
import jedai.domain.security.AuthoritiesId;
import jedai.domain.security.Users;
import jedai.domain.security.UsersHome;
import jedai.vo.AuthVO;
import jedai.vo.PasswordRequestVO;
import jedai.vo.RegistrationVO;

/**
 * Service for registering new users.
 * 
 * @author dominickaccattato
 *
 */
public class JRegistrationService {

	protected JavaMailSender mailSender;
	protected VelocityEngine velocityEngine;
	
	/**
	 * Sets the mail sender through ioc.
	 * 
	 * @param mailSender
	 */
	public void setMailSender(JavaMailSender mailSender) {
		this.mailSender = mailSender;
	}

	/**
	 * Sets the velocity engine through spring ioc.
	 * 
	 * @param velocityEngine
	 */
	public void setVelocityEngine(VelocityEngine velocityEngine) {
		this.velocityEngine = velocityEngine;
	}
	
	/**
	 * Service layer method for requesting a password.
	 * 
	 * @param passwordRequestVO
	 * @return
	 */
	public boolean requestPassword(PasswordRequestVO passwordRequestVO) {
		Users u = new Users();
		u.setUsername("test");
		u.setPassword("test");
		sendRequestPasswordEmail(u);
		
		return true;
	}
	
	/**
	 * @param user
	 */
	protected void sendRequestPasswordEmail(final Users user) {
		MimeMessagePreparator preparator = new MimeMessagePreparator() {
			public void prepare(MimeMessage mimeMessage) throws Exception {
				MimeMessageHelper message = new MimeMessageHelper(mimeMessage);
				message.setTo("dominick@infrared5.com");
				message.setFrom("daccattato@infrared5.com"); // could be parameterized...
				Map<String, Users> model = new HashMap<String, Users>();
				model.put("user", user);
				String text = VelocityEngineUtils.mergeTemplateIntoString(
				velocityEngine, "request-password.vm", model);
				message.setText(text, true);
			}
		};
		this.mailSender.send(preparator);
	}
	
	/**
	 * @param user
	 */
	protected void sendConfirmationEmail(final Users user) {
		MimeMessagePreparator preparator = new MimeMessagePreparator() {
			public void prepare(MimeMessage mimeMessage) throws Exception {
				MimeMessageHelper message = new MimeMessageHelper(mimeMessage);
				message.setTo("dominick@infrared5.com");
				message.setFrom("daccattato@infrared5.com"); // could be parameterized...
				Map<String, Users> model = new HashMap<String, Users>();
				model.put("user", user);
				String text = VelocityEngineUtils.mergeTemplateIntoString(
				velocityEngine, "registration-confirmation.vm", model);
				message.setText(text, true);
			}
		};
		this.mailSender.send(preparator);
	}

	/**
	 * registers a user with SpringSecurity
	 * 
	 * @param vo
	 * 			RegistrationVO the registration value object being registered
	 * 
	 * @return val
	 * 			Boolean the returned boolean value
	 * 
	 * @throws ExistingUserException
	 */
	public boolean register(RegistrationVO vo) throws ExistingUserException {	
		Users user = new Users();
		user.setUsername(vo.getUserName());
		user.setPassword(vo.getPassword());
		user.setEmail(vo.getEmail());
		user.setEnabled(true);
		UsersHome usersHome = new UsersHome();
		
		// Check for existing user or password
		isValidRegistration(user, usersHome);
		
		// if no exception was thrown, finish
		// persisting the user and their authorities			
		AuthoritiesId authID = new AuthoritiesId();
		authID.setAuthority("ROLE_USER");
		authID.setUsername(vo.getUserName());
				
		Authorities authorities = new Authorities();
		authorities.setId(authID);
		
		AuthoritiesHome authHome = new AuthoritiesHome();
		usersHome.persist(user);
		authHome.persist(authorities);
		
		//sendConfirmationEmail(user);
		
		return true;
	}
	
	/**
	 * Resets a password to a new password.
	 * 
	 * @param auth1
	 * @param auth2
	 * @return
	 */
	public boolean resetPassword(AuthVO auth1, AuthVO auth2) {
		
		//find user based on their email
		UsersHome uh = new UsersHome();
		final Users user = uh.findById(auth1.getUserName());
		
		if(user != null) {
			if(user.getPassword().equals(auth1.getPassword())) {
				user.setPassword(auth2.getPassword());
				
				uh.merge(user);
			}
		}
		
		return true;
	}

	/**
	 * determines if registration is valid
	 * 
	 * @param user
	 * 			Users the user being registered
	 * 
	 * @param uh
	 * 			UsersHome the dao used to register the user
	 * 
	 * @throws ExistingUserException
	 */
	protected void isValidRegistration(Users user, UsersHome uh)
			throws ExistingUserException {
		Users existingUser = uh.findById(user.getUsername());
		if(existingUser != null) {
			// 500 = EXISTING USER
			throw new ExistingUserException("500");
		}
		
		// TODO check for valid email
	}
}
