package jedai.business;

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
import jedai.vo.PasswordRequestVO;
import jedai.vo.RegistrationVO;

/**
 * @author dominickaccattato
 *
 */
public class JRegistrationService {

	protected JavaMailSender mailSender;
	protected VelocityEngine velocityEngine;
	
	/**
	 * @param mailSender
	 */
	public void setMailSender(JavaMailSender mailSender) {
		this.mailSender = mailSender;
	}

	/**
	 * @param velocityEngine
	 */
	public void setVelocityEngine(VelocityEngine velocityEngine) {
		this.velocityEngine = velocityEngine;
	}
	
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
				velocityEngine, "templates/request-password.vm", model);
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
				velocityEngine, "templates/registration-confirmation.vm", model);
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
		user.setUsername(vo.userName);
		user.setPassword(vo.password);
		user.setEmail(vo.email);
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
		
		sendConfirmationEmail(user);
		
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
