package org.kpi.libra;

import java.io.*;
import java.util.Properties;
/**
 * Created by Garret on 19-Jan-17.
 */
public class ConnectionToDataBase {

    public static final String DRIVER;
    public static final String URL;
    public static final String LOGIN;
    public static final String PASSWORD;

    static {
        Properties baseProperty = new Properties();
        try{
            ClassLoader classLoader = Thread.currentThread().getContextClassLoader();
            InputStream input = classLoader.getResourceAsStream("config.properties");
            baseProperty.load(input);
        }
        catch (IOException e) {
            e.printStackTrace();
        }

        DRIVER = baseProperty.getProperty("Driver");
        URL = baseProperty.getProperty("URL");
        LOGIN = baseProperty.getProperty("Login");
        PASSWORD = baseProperty.getProperty("Password");

        System.out.println(DRIVER);
        System.out.println(URL);
        System.out.println(LOGIN);
        System.out.println(PASSWORD);
    }
}
