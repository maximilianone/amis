package org.kpi.libra;


import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

import static org.kpi.libra.ConnectionToDataBase.*;
@WebServlet(name = "AuthorizationServlet", urlPatterns = {"/authorization"})
public class AuthorizationServlet extends HttpServlet {

    @Override
    protected  void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException{
        final String command = req.getParameter("command");
        switch (command){
            case "login":
                try{
                    Class.forName(DRIVER);

                    try(Connection conn = DriverManager.getConnection(URL, LOGIN, PASSWORD)) {
                        CallableStatement cs = conn.prepareCall("{call authorization_u(?,?,?,?)}");
                        String login=req.getParameter("uname");
                        String password=req.getParameter("psw");

                        cs.setString(1,login);
                        cs.setString(2,password);

                        cs.registerOutParameter(3,Types.VARCHAR);
                        cs.registerOutParameter(4,Types.INTEGER);

                        cs.executeQuery();

                        String authorizationStatus = (String) cs.getObject(3);
                        Integer role = (int) cs.getObject(4);

                        if("success".equalsIgnoreCase(authorizationStatus)){
                            HttpSession session = req.getSession();
                            session.setAttribute("user_login", login);
                            session.setAttribute("role", role);
                            if(role>1){
                                session.setAttribute("admin_login", login);
                            }
                            getServletContext().getRequestDispatcher("/home.jsp").forward(req, resp);
                        }
                        else {
                            req.setAttribute("cause", authorizationStatus);
                            getServletContext().getRequestDispatcher("/error.jsp").forward(req, resp);

                        }
                        cs.close();
                        } catch (SQLException e) {
                        e.printStackTrace();
                    }

                } catch (ClassNotFoundException e) {
                    e.printStackTrace();
                }
                break;
            case "logout":
                req.getSession().invalidate();
                getServletContext().getRequestDispatcher("/home.jsp").forward(req, resp);
                break;
            default:
                getServletContext().getRequestDispatcher("/error.jsp").forward(req, resp);
                break;

        }
    }


}
