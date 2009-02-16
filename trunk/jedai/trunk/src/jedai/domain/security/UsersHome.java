package jedai.domain.security;

// Generated Feb 5, 2009 3:36:59 PM by Hibernate Tools 3.2.4.CR1

import java.util.List;
import javax.naming.InitialContext;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.hibernate.LockMode;
import org.hibernate.SessionFactory;
import org.hibernate.classic.Session;
import org.hibernate.criterion.Example;

/**
 * Home object for domain model class Users.
 * @see jedai.domain.security.Users
 * @author Hibernate Tools
 */
public class UsersHome {

	private static final Log log = LogFactory.getLog(UsersHome.class);

	private static SessionFactory sessionFactory;

//	protected SessionFactory getSessionFactory() {
//		try {
//			return (SessionFactory) new InitialContext()
//					.lookup("SessionFactory");
//		} catch (Exception e) {
//			log.error("Could not locate SessionFactory in JNDI", e);
//			throw new IllegalStateException(
//					"Could not locate SessionFactory in JNDI");
//		}
//	}

	public void setSessionFactory(SessionFactory factory) {
		System.out.println("factory: " + factory);
		UsersHome.sessionFactory = factory;
	}
	
	public void persist(Users transientInstance) {
		log.debug("persisting Users instance");
		Session session = sessionFactory.getCurrentSession();
		
		try {	
			session.beginTransaction();
			session.persist(transientInstance);
			session.flush();
			session.getTransaction().commit();
			log.debug("persist successful");
		} catch (RuntimeException re) {
			log.error("persist failed", re);
			throw re;
		} finally {
			if (session.isOpen()) {
				session.close();
			}
		}
	}

	public void attachDirty(Users instance) {
		log.debug("attaching dirty Users instance");
		Session session = sessionFactory.getCurrentSession();
		
		try {	
			session.beginTransaction();
			session.saveOrUpdate(instance);
			session.flush();
			session.getTransaction().commit();
			log.debug("attach successful");
		} catch (RuntimeException re) {
			log.error("attach failed", re);
			throw re;
		} finally {
			if (session.isOpen()) {
				session.close();
			}
		}
	}

	public void attachClean(Users instance) {
		log.debug("attaching clean Users instance");
		Session session = sessionFactory.getCurrentSession();
		
		try {	
			session.beginTransaction();
			session.lock(instance, LockMode.NONE);
			session.flush();
			session.getTransaction().commit();
			log.debug("attach successful");
		} catch (RuntimeException re) {
			log.error("attach failed", re);
			throw re;
		} finally {
			if (session.isOpen()) {
				session.close();
			}
		}
	}

	public void delete(Users persistentInstance) {
		log.debug("deleting Users instance");
		Session session = sessionFactory.getCurrentSession();
		
		try {	
			session.beginTransaction();
			session.delete(persistentInstance);
			session.flush();
			session.getTransaction().commit();
			log.debug("delete successful");
		} catch (RuntimeException re) {
			log.error("delete failed", re);
			throw re;
		} finally {
			if (session.isOpen()) {
				session.close();
			}
		}
	}

	public Users merge(Users detachedInstance) {
		log.debug("merging Users instance");
		Session session = sessionFactory.getCurrentSession();
		
		try {	
			session.beginTransaction();
			Users result = (Users) session.merge(
					detachedInstance);
			session.flush();
			session.getTransaction().commit();
			log.debug("merge successful");
			return result;
		} catch (RuntimeException re) {
			log.error("merge failed", re);
			throw re;
		} finally {
			if (session.isOpen()) {
				session.close();
			}
		}
	}

	public Users findById(java.lang.String id) {
		log.debug("getting Users instance with id: " + id);
		Session session = sessionFactory.getCurrentSession();
		
		try {	
			session.beginTransaction();
			Users instance = (Users) session.get(
					"jedai.domain.security.Users", id);
			if (instance == null) {
				log.debug("get successful, no instance found");
			} else {
				log.debug("get successful, instance found");
			}
			session.flush();
			session.getTransaction().commit();
			return instance;
		} catch (RuntimeException re) {
			log.error("get failed", re);
			throw re;
		} finally {
			if (session.isOpen()) {
				session.close();
			}
		}
	}

	public List findByExample(Users instance) {
		log.debug("finding Users instance by example");
		Session session = sessionFactory.getCurrentSession();
		
		try {	
			session.beginTransaction();
			List results = session.createCriteria(
					"jedai.domain.security.Users")
					.add(Example.create(instance)).list();
			log.debug("find by example successful, result size: "
					+ results.size());
			session.flush();
			session.getTransaction().commit();
			return results;
		} catch (RuntimeException re) {
			log.error("find by example failed", re);
			throw re;
		} finally {
			if (session.isOpen()) {
				session.close();
			}
		}
	}
}
