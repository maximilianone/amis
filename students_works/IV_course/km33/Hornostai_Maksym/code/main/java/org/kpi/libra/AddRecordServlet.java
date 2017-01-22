package org.kpi.libra;


import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.*;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.time.ZoneId;
import java.util.Date;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;

import static org.kpi.libra.ConnectionToDataBase.*;
@WebServlet(name = "AddRecordServlet", urlPatterns = {"/addRecord"})
public class AddRecordServlet extends HttpServlet {

    @Override
    protected  void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException{
        try{
            Class.forName(DRIVER);

            try(Connection conn = DriverManager.getConnection(URL, LOGIN, PASSWORD)) {
                CallableStatement cs = conn.prepareCall("{call add_record(?,?,?,?,?,?,?)}");
                HttpSession session = req.getSession();
                final String command =req.getParameter("command");
                String userLogin = (String) session.getAttribute("user_login");
                String status = "reserved";
                if (command.equalsIgnoreCase("asAdmin")) {
                    userLogin = req.getParameter("current_user");
                    final String currentEmail = req.getParameter("current_user_email");
                    final String currentPhone = req.getParameter("current_user_telephone");
                    final String currentName = req.getParameter("current_user_name");
                    final String currentRole = req.getParameter("current_user_role");
                    status = "loaned";
                }
                final String bookName= req.getParameter("bookName");
                final String bookPublisher = req.getParameter("publisher");
                Date returnDate= new SimpleDateFormat("yyyy-MM-dd").parse(req.getParameter("date"));
                LocalDate localDate = LocalDate.now();
                Date currentDate = Date.from(localDate.atStartOfDay(ZoneId.systemDefault()).toInstant());
                if(currentDate.after(returnDate)) {
                    req.setAttribute("cause", "return date cannot be less than current date ");
                    cs.close();
                    getServletContext().getRequestDispatcher("/error.jsp").forward(req, resp);
                }


                cs.setString(1,userLogin);
                cs.setString(2,bookName);
                cs.setString(3,bookPublisher);
                cs.setString(4,status);
                cs.setDate(5,new java.sql.Date(currentDate.getTime()));
                cs.setDate(6,new java.sql.Date(returnDate.getTime()));

                cs.registerOutParameter(7,Types.VARCHAR);

                cs.executeQuery();

                String registrationStatus = (String) cs.getObject(7);

                if("success".equalsIgnoreCase(registrationStatus)){
                    cs.close();
                    if(command.equalsIgnoreCase("asAdmin")) {
                        getServletContext().getRequestDispatcher("/userRecords").forward(req, resp);
                    }
                    getServletContext().getRequestDispatcher("/personalCabinet").forward(req, resp);
                }
                else {
                    req.setAttribute("cause", registrationStatus);
                    cs.close();
                    getServletContext().getRequestDispatcher("/error.jsp").forward(req, resp);

                }
            } catch (SQLException e) {
                e.printStackTrace();
            } catch (ParseException e) {
                e.printStackTrace();
            }

        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }


    }
}



