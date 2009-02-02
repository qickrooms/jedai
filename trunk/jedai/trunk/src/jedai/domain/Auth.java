package jedai.domain;

import java.io.Serializable;

import javax.persistence.Transient;

import jedai.vo.AuthVO;

public class Auth implements Serializable {

	private static final long serialVersionUID = 108374100L;
	
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
	
	@Transient
	public AuthVO getVO() {
		AuthVO vo = new AuthVO();
		vo.setPassword(password);
		vo.setUserName(userName);
		return vo;
	}

	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result
				+ ((password == null) ? 0 : password.hashCode());
		result = prime * result
				+ ((userName == null) ? 0 : userName.hashCode());
		return result;
	}

	@Override
	public boolean equals(Object obj) {
		if (this == obj)
			return true;
		if (obj == null)
			return false;
		if (getClass() != obj.getClass())
			return false;
		final Auth other = (Auth) obj;
		if (password == null) {
			if (other.password != null)
				return false;
		} else if (!password.equals(other.password))
			return false;
		if (userName == null) {
			if (other.userName != null)
				return false;
		} else if (!userName.equals(other.userName))
			return false;
		return true;
	}

	
	
}
