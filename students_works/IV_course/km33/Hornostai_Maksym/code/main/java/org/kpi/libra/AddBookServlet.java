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
@WebServlet(name = "AddBookServlet", urlPatterns = {"/addBook"})
public class AddBookServlet extends HttpServlet {

    @Override
    protected  void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException{
        try{
            Class.forName(DRIVER);

            try(Connection conn = DriverManager.getConnection(URL, LOGIN, PASSWORD)) {
                CallableStatement cs = conn.prepareCall("{call add_book(?,?,?,?,?,?,?)}");
                String bookName= req.getParameter("bookName");
                String bookAuthor = req.getParameter("author");
                String bookPublisher = req.getParameter("publisher");
                String bookSection=req.getParameter("section");
                Integer bookQuantity=Integer.parseInt(req.getParameter("quantity"));
                String admin_login="garret";

                cs.setString(1,bookName);
                cs.setString(2,bookAuthor);
                cs.setString(3,bookPublisher);
                cs.setString(4,bookSection);
                cs.setInt(5,bookQuantity);
                cs.setString(6,admin_login);

                cs.registerOutParameter(7,Types.VARCHAR);

                cs.executeQuery();

                String registrationStatus = (String) cs.getObject(7);

                if("success".equalsIgnoreCase(registrationStatus)){
                    getServletContext().getRequestDispatcher("/personalCabinet").forward(req, resp);
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



