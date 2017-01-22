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
@WebServlet(name = "ShowUserDetailsServlet", urlPatterns = {"/userRecords"})
public class ShowUserDetailsServlet extends HttpServlet {

    @Override
    protected  void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException{
        HttpSession session = req.getSession();
        String currentUser= req.getParameter("current_user");
        String currentEmail= req.getParameter("current_user_email");
        String currentPhone= req.getParameter("current_user_telephone");
        String currentName= req.getParameter("current_user_name");
        String currentRole=req.getParameter("current_user_role");

        Integer count = 0;
        Integer length = 0;
        try{
            Class.forName(DRIVER);

            try(Connection conn = DriverManager.getConnection(URL, LOGIN, PASSWORD)) {

                PreparedStatement preparedStatement = conn.prepareStatement(
                        "SELECT * " +
                                "FROM recordings_KPI "+
                                "WHERE recordings_KPI.fk_user_login = ?");
                preparedStatement.setString(1, currentUser);
                preparedStatement.executeQuery();

                PreparedStatement preparedS = conn.prepareStatement(
                        "SELECT count(*) total " +
                                "FROM recordings_KPI "+
                                "WHERE recordings_KPI.fk_user_login = ?");
                preparedS.setString(1, currentUser);
                preparedS.executeQuery();

                ResultSet resultOfS = preparedS.getResultSet();
                ResultSet resultSetSet = preparedStatement.getResultSet();


                    if (resultOfS.next()){
                        length = resultOfS.getInt("total");

                    IssueRecords[] usersDetails = new IssueRecords[length];
                    System.out.println(length);
                    while (resultSetSet.next()) {
                        usersDetails[count]=new IssueRecords(resultSetSet.getString("fk_user_login")
                                ,resultSetSet.getString("fk_book_name")
                                ,resultSetSet.getString("fk_book_publisher"),
                                resultSetSet.getString("status"),
                                resultSetSet.getDate("date_of_issue"),
                                resultSetSet.getDate("date_of_return"));
                        count+=1;
                    }
                    session.setAttribute("usersDetails", usersDetails);
                    session.setAttribute("current_user", currentUser);
                        session.setAttribute("current_user_email", currentEmail);
                        session.setAttribute("current_user_telephone", currentPhone);
                        session.setAttribute("current_user_name", currentName);
                        session.setAttribute("current_user_role", currentRole);
                    preparedS.close();
                    preparedStatement.close();
                    getServletContext().getRequestDispatcher("/userDetails.jsp").forward(req, resp);
                } else {
                    req.setAttribute("cause", "something went wrong");
                    preparedS.close();
                    preparedStatement.close();
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



