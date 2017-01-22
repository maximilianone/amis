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
@WebServlet(name = "ShowHistoryServlet", urlPatterns = {"/showHistory"})
public class ShowHistoryServlet extends HttpServlet {

    @Override
    protected  void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException{
        HttpSession session = req.getSession();
        Integer length=0;
        Integer count=0;

        try{
            Class.forName(DRIVER);

            try(Connection conn = DriverManager.getConnection(URL, LOGIN, PASSWORD)) {

                PreparedStatement preparedStatement = conn.prepareStatement(
                        "SELECT * " +
                                "FROM recordings_history_KPI ");
                preparedStatement.executeQuery();

                PreparedStatement preparedS = conn.prepareStatement(
                        "SELECT count(*) total " +
                                "FROM recordings_history_KPI ");
                preparedS.executeQuery();

                ResultSet resultOfS = preparedS.getResultSet();
                ResultSet resultSetSet = preparedStatement.getResultSet();


                if (resultOfS.next()){
                    length = resultOfS.getInt("total");

                    ReservationHistory[] history = new ReservationHistory[length];
                    System.out.println(length);
                    while (resultSetSet.next()) {
                        history[count]=new ReservationHistory(resultSetSet.getString("fk_user_login")
                                ,resultSetSet.getString("fk_book_name")
                                ,resultSetSet.getString("fk_book_publisher"),
                                resultSetSet.getString("status"),
                                resultSetSet.getDate("date_of_issue"),
                                resultSetSet.getDate("date_of_return"),
                                resultSetSet.getTimestamp("changetime"),
                                resultSetSet.getString("action"));
                        count+=1;
                    }
                    session.setAttribute("history", history);
                    preparedS.close();
                    preparedStatement.close();
                    getServletContext().getRequestDispatcher("/showHistory.jsp").forward(req, resp);
                } else {
                    req.setAttribute("cause", "no history");
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



