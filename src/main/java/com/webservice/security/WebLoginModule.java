
package com.webservice.security;

import java.math.BigInteger;
import java.security.MessageDigest;
import java.security.Principal;
import java.security.acl.Group;
import java.util.Hashtable;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.security.auth.Subject;
import javax.security.auth.login.LoginException;

import org.jboss.security.SimpleGroup;
import org.jboss.security.auth.spi.UsernamePasswordLoginModule;

import com.webservice.service.EmployeeEJBIf;


/**
 * @author Ashish
 *
 */
public class WebLoginModule extends UsernamePasswordLoginModule{

	private SecurityPrincipal sp = null;
	 Subject sub ;
	
	public boolean logout() throws LoginException
	{
		sub.getPrincipals().remove(sp);
		System.out.println("Logging out");
		return super.logout();
	}
	
	
	@Override
	protected boolean validatePassword(String username, String password)
	{
		boolean status = false;	
		Principal p = this.getIdentity();
		sub = new Subject();
		
		System.out.println("password(as param) : "+password);
		if(password==null){
			System.out.println("password empty");
			password = username;
			username = p.getName();
		}else{
			//Do nothing
		}
		
		  if(p instanceof SecurityPrincipal) {					  
			 
			  try {
				  sp = (SecurityPrincipal)p;
				  sp.setUsername(p.getName());
				  sp.setPassword(password);				
				  sp.setSubj(sub);	
				  sp.setColRole(null);; // TODO: fix this.
				  System.out.println("username: "+username);
				  status = isValidUser(username, password);
			  }
			  catch(Exception e) {
				  e.printStackTrace();
				  		  
			  }
		  }
		  System.out.println("final Status: "+status);
		return status;		
	}
	
	@Override
	protected String getUsersPassword() throws LoginException {
		// TODO Auto-generated method stub
		return null;
	}

	public boolean isValidUser(String username, String password)  {
		boolean result=false;
		try{
			final Hashtable<String, String> jndiProperties = new Hashtable<String, String>();
			jndiProperties.put(Context.URL_PKG_PREFIXES, "org.jboss.ejb.client.naming");
			final Context context = new InitialContext(jndiProperties);
			EmployeeEJBIf lif = (EmployeeEJBIf) context.lookup("java:global/webservice/EmployeeEJBImpl!com.webservice.service.EmployeeEJBIf");
			password=hashPassword(password);
			result = lif.checkLogin(username, password);
		}catch(Exception e){
			e.printStackTrace();
			return false;
		}
		return result;
	}
	
	
	@Override
	protected Group[] getRoleSets() throws LoginException {
		try {			
			Group callerPrincipal = new SimpleGroup("CallerPrincipal");
			Group roles = new SimpleGroup("Roles");
	        Group[] groups = {roles,callerPrincipal};	        
	        roles.addMember(new SecurityPrincipal("SecurityAdmin"));
	        callerPrincipal.addMember(sp);
			return groups;
		}
		catch(Exception e) {
			e.printStackTrace();
			throw new LoginException(e.getMessage());
		}

	}
	 private String hashPassword(String password) {
	        String hashword = null;
	        try {
	            MessageDigest md5 = MessageDigest.getInstance("MD5");            
	            md5.update(password.getBytes());
	            BigInteger hash = new BigInteger(1, md5.digest());
	            hashword = hash.toString(16);
	        }catch (Exception e) {
	            e.printStackTrace();
	         }	        
	        return hashword;
	}
	
	
	
}
