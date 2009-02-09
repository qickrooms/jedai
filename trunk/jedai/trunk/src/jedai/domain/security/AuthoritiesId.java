package jedai.domain.security;

// Generated Feb 5, 2009 9:48:08 AM by Hibernate Tools 3.2.4.CR1

import javax.persistence.Column;
import javax.persistence.Embeddable;

/**
 * AuthoritiesId generated by hbm2java
 */
@Embeddable
public class AuthoritiesId implements java.io.Serializable {

	private String username;
	private String authority;

	public AuthoritiesId() {
	}

	public AuthoritiesId(String username, String authority) {
		this.username = username;
		this.authority = authority;
	}

	@Column(name = "username", nullable = false, length = 50)
	public String getUsername() {
		return this.username;
	}

	public void setUsername(String username) {
		this.username = username;
	}

	@Column(name = "authority", nullable = false, length = 50)
	public String getAuthority() {
		return this.authority;
	}

	public void setAuthority(String authority) {
		this.authority = authority;
	}

	public boolean equals(Object other) {
		if ((this == other))
			return true;
		if ((other == null))
			return false;
		if (!(other instanceof AuthoritiesId))
			return false;
		AuthoritiesId castOther = (AuthoritiesId) other;

		return ((this.getUsername() == castOther.getUsername()) || (this
				.getUsername() != null
				&& castOther.getUsername() != null && this.getUsername()
				.equals(castOther.getUsername())))
				&& ((this.getAuthority() == castOther.getAuthority()) || (this
						.getAuthority() != null
						&& castOther.getAuthority() != null && this
						.getAuthority().equals(castOther.getAuthority())));
	}

	public int hashCode() {
		int result = 17;

		result = 37 * result
				+ (getUsername() == null ? 0 : this.getUsername().hashCode());
		result = 37 * result
				+ (getAuthority() == null ? 0 : this.getAuthority().hashCode());
		return result;
	}

}
