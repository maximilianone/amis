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
@WebServlet(name = "SearchBookServlet", urlPatterns = {"/searcbook"})
public class SearchBookServlet extends HttpServlet {

    @Override
    protected  void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        String searchvalue = req.getParameter("searchvalue");
        searchvalue = "%" + searchvalue + "%";
        String searchparam = req.getParameter("searchparam");
        Integer count = 0;
        Integer length = 0;

        try{
            Class.forName(DRIVER);

            try(Connection conn = DriverManager.getConnection(URL, LOGIN, PASSWORD)) {

                System.out.println(searchparam);
                PreparedStatement preparedStatement = conn.prepareStatement(
                        "SELECT * " +
                                "FROM book_KPI " +
                                "Where " + searchparam + " LIKE '" + searchvalue + "'");
//                preparedStatement.setString(1, searchparam);
                preparedStatement.executeQuery();

                PreparedStatement preparedS = conn.prepareStatement(
                        "SELECT count(*) total " +
                                "FROM book_KPI " +
                                "Where " + searchparam + " LIKE '" + searchvalue + "'");
//                preparedS.setString(1, searchparam);
                preparedS.executeQuery();

                ResultSet resultOfS = preparedS.getResultSet();
                ResultSet resultSetSet = preparedStatement.getResultSet();


                if (resultOfS.next()){
                    length = resultOfS.getInt("total");

                    Book[] books = new Book[length];
                    System.out.println(length);
                    while (resultSetSet.next()) {
                        books[count]=new Book(resultSetSet.getString("book_name")
                                ,resultSetSet.getString("book_author")
                                ,resultSetSet.getString("book_publisher"),
                                resultSetSet.getString("book_section"),
                                resultSetSet.getInt("book_quantity"));
                        count+=1;
                    }
                    session.setAttribute("books", books);
                    preparedS.close();
                    preparedStatement.close();
                    getServletContext().getRequestDispatcher("/showBooks.jsp").forward(req, resp);
                } else {
                    req.setAttribute("cause", "unknown error");
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



