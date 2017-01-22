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
@WebServlet(name = "RegistrationServlet", urlPatterns = {"/registration"})
public class RegistrationServlet extends HttpServlet {

    @Override
    protected  void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException{
                try{
                    Class.forName(DRIVER);

                    try(Connection conn = DriverManager.getConnection(URL, LOGIN, PASSWORD)) {
                        CallableStatement cs = conn.prepareCall("{call add_user(?,?,?,?,?,?,?,?)}");
                        String username= req.getParameter("firstname")+" "+req.getParameter("lastname");
                        String email = req.getParameter("uemail");
                        String phone = req.getParameter("phone");
                        String login=req.getParameter("uname");
                        String password=req.getParameter("password");
                        String admin_login="garret";
                        Integer role = 1;

                        cs.setString(1,login);
                        cs.setString(2,username);
                        cs.setString(3,password);
                        cs.setString(4,phone);
                        cs.setString(5,email);
                        cs.setInt(6,role);
                        cs.setString(7,admin_login);

                        cs.registerOutParameter(8,Types.VARCHAR);

                        cs.executeQuery();

                        String registrationStatus = (String) cs.getObject(8);

                        if("success".equalsIgnoreCase(registrationStatus)){
                            HttpSession session = req.getSession();
                            session.setAttribute("user_login", login);
                            getServletContext().getRequestDispatcher("/home.jsp").forward(req, resp);
                        }
                        else {
                            req.setAttribute("cause", registrationStatus);
                            getServletContext().getRequestDispatcher("/error.jsp").forward(req, resp);

                        }
                        cs.close();
                    } catch (SQLException e) {
                        e.printStackTrace();
                    }

                } catch (ClassNotFoundException e) {
                    e.printStackTrace();
                }


        }
    }



