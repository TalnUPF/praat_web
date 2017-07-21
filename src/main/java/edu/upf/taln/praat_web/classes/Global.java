package edu.upf.taln.praat_web.classes;

import javax.servlet.ServletContext;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import javax.servlet.annotation.WebListener;

@WebListener
public class Global implements ServletContextListener{
	
	private static String initErrorMsg;
	private static String praatLocation;
	
	@Override
	public void contextInitialized(ServletContextEvent sce) {
		try {
            ServletContext context = sce.getServletContext();
            init(context);
          
        } catch (Exception e) {
            initErrorMsg = "Initialization failed!\n";
            System.err.println(initErrorMsg);
        }
	}
	
	private void init(ServletContext context) throws Exception {
		praatLocation = context.getInitParameter("praatLocation");
        if (praatLocation == null) {
            throw new Exception("Initialization failed! (Context parameter for praatLocation not found)");
        }
    }

	@Override
	public void contextDestroyed(ServletContextEvent sce) {
		 System.gc();
	}

	public static String getPraatLocation() {
		return praatLocation;
	}

	public static void setPraatLocation(String praatLocation) {
		Global.praatLocation = praatLocation;
	}
	
	
}
