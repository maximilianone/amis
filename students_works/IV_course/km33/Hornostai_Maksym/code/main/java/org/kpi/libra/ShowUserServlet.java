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
@WebServlet(name = "ShowUserServlet", urlPatterns = {"/showAllUsers"})
public class ShowUserServlet extends HttpServlet {

    @Override
    protected  void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        final String userLogin = (String) session.getAttribute("user_login");
        Integer adminRole = (Integer) session.getAttribute("role");
        String requiredUser = req.getParameter("required_user");
        requiredUser = "%" + requiredUser + "%";
        Integer count = 0;
        Integer length = 0;
        if (adminRole > 2){
            adminRole+=1;
        }

        try{
            Class.forName(DRIVER);

            try(Connection conn = DriverManager.getConnection(URL, LOGIN, PASSWORD)) {

                PreparedStatement preparedStatement = conn.prepareStatement(
                        "SELECT * " +
                                "FROM users_KPI " +
                                "Where user_name LIKE '" + requiredUser + "' and user_role < ?");
                preparedStatement.setInt(1, adminRole);
                preparedStatement.executeQuery();

                PreparedStatement preparedS = conn.prepareStatement(
                        "SELECT count(*) total " +
                                "FROM users_KPI " +
                                "Where user_name LIKE '" + requiredUser + "' and user_role < ?");
                preparedS.setInt(1, adminRole);
                preparedS.executeQuery();

                ResultSet resultOfS = preparedS.getResultSet();
                ResultSet resultSetSet = preparedStatement.getResultSet();


                if (resultOfS.next()){
                        length = resultOfS.getInt("total");

                    Users[] userss = new Users[length];
                    System.out.println(length);
                    while (resultSetSet.next()) {
                        userss[count]=new Users(resultSetSet.getString("user_login")
                                ,resultSetSet.getString("user_name")
                                ,resultSetSet.getString("user_password"),
                                resultSetSet.getString("user_telephon"),
                                resultSetSet.getString("user_email"),
                                resultSetSet.getInt("user_role"));
                        count+=1;
                    }
                    session.setAttribute("userss", userss);
                    preparedS.close();
                    preparedStatement.close();
                    getServletContext().getRequestDispatcher("/showAllUsers.jsp").forward(req, resp);
                } else {
                    req.setAttribute("cause", "no users");
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



