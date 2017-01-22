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
@WebServlet(name = "returnBookServlet", urlPatterns = {"/returnBook"})
public class returnBookServlet extends HttpServlet {
    String command;

    @Override
    protected  void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException{
        HttpSession session = req.getSession();
        try{
            Class.forName(DRIVER);

            try(Connection conn = DriverManager.getConnection(URL, LOGIN, PASSWORD)) {
                CallableStatement cs = conn.prepareCall("{call return_book(?,?,?,?)}");

                command=req.getParameter("command");
                String userLogin = (String) session.getAttribute("user_login");
                if(command.equalsIgnoreCase("thisUser")){
                    userLogin=req.getParameter("user_login");
                }
                String bookName=req.getParameter("book_name");
                String bookPublisher=req.getParameter("book_publisher");

                cs.setString(1,userLogin);
                cs.setString(2,bookName);
                cs.setString(3,bookPublisher);

                cs.registerOutParameter(4,Types.VARCHAR);

                cs.executeQuery();

                String changeStatus = (String) cs.getObject(4);

                if("success".equalsIgnoreCase(changeStatus)){

                    cs.close();
                    if(!command.equalsIgnoreCase("thisUser")){
                        getServletContext().getRequestDispatcher("/personalCabinet").forward(req, resp);
                    }
                    else {
                        String currentUser=req.getParameter("current_user_role");
                        session.setAttribute("current_user_role", currentUser);
                        getServletContext().getRequestDispatcher("/userRecords").forward(req, resp);
                    }
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


