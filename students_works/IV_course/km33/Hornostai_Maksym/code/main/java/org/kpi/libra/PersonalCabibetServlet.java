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
@WebServlet(name = "PersonalCabibetServlet", urlPatterns = {"/personalCabinet"})
public class PersonalCabibetServlet extends HttpServlet {

    @Override
    protected  void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException{
        HttpSession session = req.getSession();
        final String userLogin = (String) session.getAttribute("user_login");
        Integer count = 0;
        Integer length = 0;
        try{
            Class.forName(DRIVER);

            try(Connection conn = DriverManager.getConnection(URL, LOGIN, PASSWORD)) {
                PreparedStatement ps = conn.prepareStatement(
                        "SELECT user_name, user_password, user_telephon, user_email " +
                                "FROM Users_KPI " +
                                "WHERE user_login = '" + userLogin + "'");
                ps.executeQuery();

                PreparedStatement preparedStatement = conn.prepareStatement(
                        "SELECT * " +
                                "FROM recordings_KPI "+
                                "WHERE recordings_KPI.fk_user_login = ?");
                preparedStatement.setString(1, userLogin);
                preparedStatement.executeQuery();

                PreparedStatement preparedS = conn.prepareStatement(
                        "SELECT count(*) total " +
                                "FROM recordings_KPI "+
                                "WHERE recordings_KPI.fk_user_login = ?");
                preparedS.setString(1, userLogin);
                preparedS.executeQuery();

                ResultSet resultOfS = preparedS.getResultSet();
                ResultSet resSet = ps.getResultSet();
                ResultSet resultSetSet = preparedStatement.getResultSet();

                if (resSet.next()) {
                    req.setAttribute("user_name", resSet.getString(1));
                    req.setAttribute("user_password", resSet.getString(2));
                    req.setAttribute("user_phone", resSet.getString(3));
                    req.setAttribute("user_email", resSet.getString(4));
                    if (resultOfS.next()){
                        length = resultOfS.getInt("total");
                    }
                    IssueRecords[] records = new IssueRecords[length];
                    System.out.println(length);
                    while (resultSetSet.next()) {
                        records[count]=new IssueRecords(resultSetSet.getString("fk_user_login")
                                ,resultSetSet.getString("fk_book_name")
                                ,resultSetSet.getString("fk_book_publisher"),
                                resultSetSet.getString("status"),
                                resultSetSet.getDate("date_of_issue"),
                                resultSetSet.getDate("date_of_return"));
                        count+=1;
                    }
                    session.setAttribute("records", records);
                    preparedS.close();
                    ps.close();
                    preparedStatement.close();
                    getServletContext().getRequestDispatcher("/personalCabinet.jsp").forward(req, resp);
                } else {
                    req.setAttribute("cause", "something went wrong");
                    ps.close();
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



