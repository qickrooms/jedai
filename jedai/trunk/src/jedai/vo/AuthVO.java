package jedai.vo;

import java.io.Serializable;

/**
 * @author dominickaccattato
 */
public class AuthVO implements Serializable {

	private static final long serialVersionUID = 298374120L;
	
	/**
	 * @uml.property name="userName"
	 */
	private String userName;

	/**
	 * @uml.property name="password"
	 */
	private String password;

	/**
	 * @return
	 * @uml.property name="userName"
	 */
	public String getUserName() {
		return userName;
	}

	/**
	 * @param userName
	 * @uml.property name="userName"
	 */
	public void setUserName(String userName) {
		this.userName = userName;
	}

	/**
	 * @return
	 * @uml.property name="password"
	 */
	public String getPassword() {
		return password;
	}

	/**
	 * @param password
	 * @uml.property name="password"
	 */
	public void setPassword(String password) {
		this.password = password;
	}

}