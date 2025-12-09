package com.project.carrentalsystem.config;

import jakarta.servlet.ServletContext;
import jakarta.servlet.ServletException;
import org.springframework.boot.web.servlet.ServletContextInitializer;
import org.springframework.context.annotation.Configuration;

/**
 * Initializes Tomcat servlet context with proper multipart upload handling.
 * 
 * Multipart configuration:
 * - spring.servlet.multipart.max-file-size=50MB (application.properties)
 * - spring.servlet.multipart.max-request-size=50MB (application.properties)
 * - server.tomcat.max-http-form-post-size=52428800 (application.properties)
 * 
 * Tomcat's FileUploadBase may still have a default file count limit of 10.
 * This is mitigated by keeping the form submission to minimal parts.
 */
@Configuration
public class TomcatMultipartInitializer implements ServletContextInitializer {

    @Override
    public void onStartup(ServletContext servletContext) throws ServletException {
        // Try to increase Tomcat's file count limit using reflection
        // This handles the FileCountLimitExceededException for forms with many fields
        try {
            // Try the correct internal field name used by Tomcat 11
            Class<?> fileUploadBaseClass = Class.forName("org.apache.tomcat.util.http.fileupload.FileUploadBase");
            
            // Check all available fields
            java.lang.reflect.Field[] fields = fileUploadBaseClass.getDeclaredFields();
            for (java.lang.reflect.Field field : fields) {
                if (field.getName().toLowerCase().contains("count")) {
                    field.setAccessible(true);
                    if (field.getType() == long.class) {
                        field.setLong(null, 100L);
                        break;
                    }
                }
            }
        } catch (Exception e) {
            // Silently ignore - the application will use the default limit
        }
        
        // Enable async support for better file upload handling
        servletContext.setAttribute("org.apache.catalina.ASYNC_SUPPORTED", true);
    }
}
