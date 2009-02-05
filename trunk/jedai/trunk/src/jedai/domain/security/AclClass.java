package jedai.domain.security;

// Generated Feb 5, 2009 9:48:08 AM by Hibernate Tools 3.2.4.CR1

import java.util.HashSet;
import java.util.Set;
import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import static javax.persistence.GenerationType.IDENTITY;
import javax.persistence.Id;
import javax.persistence.OneToMany;
import javax.persistence.Table;
import javax.persistence.UniqueConstraint;

/**
 * AclClass generated by hbm2java
 */
@Entity
@Table(name = "ACL_CLASS", uniqueConstraints = @UniqueConstraint(columnNames = "CLASS"))
public class AclClass implements java.io.Serializable {

	private Long id;
	private String class_;
	private Set<AclObjectIdentity> aclObjectIdentities = new HashSet<AclObjectIdentity>(
			0);

	public AclClass() {
	}

	public AclClass(String class_) {
		this.class_ = class_;
	}

	public AclClass(String class_, Set<AclObjectIdentity> aclObjectIdentities) {
		this.class_ = class_;
		this.aclObjectIdentities = aclObjectIdentities;
	}

	@Id
	@GeneratedValue(strategy = IDENTITY)
	@Column(name = "ID", unique = true, nullable = false)
	public Long getId() {
		return this.id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	@Column(name = "CLASS", unique = true, nullable = false, length = 100)
	public String getClass_() {
		return this.class_;
	}

	public void setClass_(String class_) {
		this.class_ = class_;
	}

	@OneToMany(cascade = CascadeType.ALL, fetch = FetchType.LAZY, mappedBy = "aclClass")
	public Set<AclObjectIdentity> getAclObjectIdentities() {
		return this.aclObjectIdentities;
	}

	public void setAclObjectIdentities(
			Set<AclObjectIdentity> aclObjectIdentities) {
		this.aclObjectIdentities = aclObjectIdentities;
	}

}
