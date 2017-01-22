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
@WebServlet(name = "ChangeUserInfoServlet", urlPatterns = {"/changeInfo"})
public class ChangeUserInfoServlet extends HttpServlet {

    @Override
    protected  void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException{
        HttpSession session = req.getSession();
        final String userLogin = (String) session.getAttribute("user_login");
                try{
                    Class.forName(DRIVER);

                    try(Connection conn = DriverManager.getConnection(URL, LOGIN, PASSWORD)) {
                        CallableStatement cs = conn.prepareCall("{call edit_user(?,?,?,?)}");

                        String userName=req.getParameter("user_name");
                        String phone=req.getParameter("user_phone");

                        cs.setString(1,userLogin);
                        cs.setString(2,userName);
                        cs.setString(3,phone);

                        cs.registerOutParameter(4,Types.VARCHAR);

                        cs.executeQuery();

                        String changeStatus = (String) cs.getObject(4);

                        if("success".equalsIgnoreCase(changeStatus)){
                            session.setAttribute("user_name", userName);
                            session.setAttribute("user_phone", phone);
                            req.setAttribute("user_name", userName);
                            req.setAttribute("user_phone", phone);
                            req.setAttribute("user_email", req.getParameter("user_email"));
                            cs.close();
                            getServletContext().getRequestDispatcher("/personalCabinet").forward(req, resp);
                        }
                        else {
                            req.setAttribute("cause", changeStatus);
                            cs.close();
                            getServletContext().getRequestDispatcher("/error.jsp").forward(req, resp);

                        }
                    } catch (SQLException e) {
                        e.printStackTrace();
                    }

                } catch (ClassNotFoundException e) {
                    e.printStackTrace();
                }


        }
    }


