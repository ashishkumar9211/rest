package com.webservice.service;

import javax.annotation.Resource;
import javax.ejb.SessionContext;
import javax.ejb.Stateless;
import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.webservice.dto.ActivityLogTO;
import com.webservice.dto.StringUtil;
import com.webservice.model.RestActivityLog;
import com.webservice.model.Users;

/**
 * Employee Implementation 
 *
 * @author  Ashish Kumar
 * @version 1.0
 * @since   2015-08-19 
 */

@Stateless
public class CommonEJBImpl implements CommonEJBIf {

	@PersistenceContext(unitName = "webUnit" )
	private EntityManager em;
	
	@Resource
	private SessionContext sctx;

	private static final Logger logger = LoggerFactory
			.getLogger(CommonEJBImpl.class);

	
	@Override
	public void activityLogIt(ActivityLogTO activityLogTO){
		//set to to entity

		RestActivityLog activityLog = new RestActivityLog();
		activityLog.setPath(activityLogTO.getPath());
		activityLog.setCookies(activityLogTO.getCookies());
		activityLog.setRequestURI(activityLogTO.getRequestURI());
		activityLog.setFormData(activityLogTO.getFormData());
		activityLog.setHeaders(activityLogTO.getHeaders());
		activityLog.setMethod(activityLogTO.getMethod());
		activityLog.setRequestStartTime(activityLogTO.getRequestStartTime());
		activityLog.setRequestStopTime(activityLogTO.getRequestStopTime());
		activityLog.setTotalTimeTaken(activityLogTO.getTotalTimeTaken());

		if(!StringUtil.isNullCombo(activityLogTO.getUserId())){
			Users user = new Users();
			user.setId(Integer.parseInt(activityLogTO.getUserId()));
			activityLog.setUserId(user);
		}
		em.persist(activityLog);
		em.flush();
	}

}
