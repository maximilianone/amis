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
public class TestConnection extends HttpServlet {

    public static void main(String[] args) {
        String userLogin="Drizt";
        Integer count = 0;
        try{
            Class.forName(DRIVER);

            try(Connection conn = DriverManager.getConnection(URL, LOGIN, PASSWORD)) {
                PreparedStatement preparedStatement = conn.prepareStatement(
                        "SELECT * " +
                                "FROM IssuesRecordings "+
                                "WHERE IssuesRecordings.fk_user_login = ?");
                preparedStatement.setString(1, userLogin);
                preparedStatement.executeQuery();

                ResultSet resultSetSet = preparedStatement.getResultSet();
                IssueRecords[] records = new IssueRecords[10];

                while (resultSetSet.next()) {
                    records[count]=new IssueRecords(resultSetSet.getString("fk_user_login")
                            ,resultSetSet.getString("fk_book_name")
                            ,resultSetSet.getString("fk_book_publisher"),
                            resultSetSet.getString("status"),
                            resultSetSet.getDate("date_of_issue"),
                            resultSetSet.getDate("date_of_return"));
                    count+=1;
                }


            } catch (SQLException e) {
                e.printStackTrace();
            }

        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }


    }
}



