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
@WebServlet(name = "ChangeStatusServlet", urlPatterns = {"/changeRecordStatus"})
public class ChangeStatusServlet extends HttpServlet {

    @Override
    protected  void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException{
        HttpSession session = req.getSession();
        final String userLogin = req.getParameter("current_user");
        final String bookName = req.getParameter("book_name");
        final String bookPublisher = req.getParameter("book_publisher");
        final String role = "loaned";
        try{
            Class.forName(DRIVER);

            try(Connection conn = DriverManager.getConnection(URL, LOGIN, PASSWORD)) {
                CallableStatement cs = conn.prepareCall("{call change_status(?,?,?,?,?)}");

                cs.setString(1,userLogin);
                cs.setString(2,bookName);
                cs.setString(3,bookPublisher);
                cs.setString(4,role);

                cs.registerOutParameter(5,Types.VARCHAR);

                cs.executeQuery();

                String changeStatus = (String) cs.getObject(5);

                if("success".equalsIgnoreCase(changeStatus)){
                    cs.close();
                    getServletContext().getRequestDispatcher("/userRecords").forward(req, resp);
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


