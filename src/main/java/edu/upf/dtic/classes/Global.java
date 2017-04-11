package edu.upf.dtic.classes;

import javax.servlet.ServletContext;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import javax.servlet.annotation.WebListener;

@WebListener
public class Global implements ServletContextListener{
	//public static final String PRAAT_LOCATION = "/home/ivan/svnTaln/Taln-patents/OtherProjects/praat-master3/Release/praat-master";
	//public static final String PRAAT_LOCATION = "/usr/local/bin/praat-master";
	
	private static String initErrorMsg;
	private static String praatLocation;
	
	@Override
	public void contextInitialized(ServletContextEvent sce) {
		try {
            ServletContext context = sce.getServletContext();
            init(context);
          
        } catch (Exception e) {
            initErrorMsg = "PraatWeb merge service initialization failed!\n";
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
