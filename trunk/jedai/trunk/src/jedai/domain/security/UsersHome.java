package jedai.domain.security;

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

import java.util.List;
import javax.naming.InitialContext;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.hibernate.Hibernate;
import org.hibernate.LockMode;
import org.hibernate.Query;
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
	
	/**
	 * @param email
	 * @return
	 */
	public Users findByEmail(java.lang.String email) {
		log.debug("getting Users instance with email: " + email);
		Session session = sessionFactory.getCurrentSession();
		
		Users instance = null;
		
		try {	
			session.beginTransaction();

			Query query = session.createQuery("FROM jedai.domain.security.Users WHERE email = :email");
			query.setString("email", email);
			query.setReadOnly(true);
			
			Object o = query.uniqueResult();
			if (o != null) {
				if (o instanceof Users) {
					instance = (Users) o;
				} else {
					//log.warn("User type was not returned. '{}' was returned", instance
					//		.getClass().getName());
				}
			} else {
				log.info("User was null");
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
