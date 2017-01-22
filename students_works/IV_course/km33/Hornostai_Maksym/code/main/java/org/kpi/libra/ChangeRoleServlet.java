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
@WebServlet(name = "ChangeRoleServlet", urlPatterns = {"/changeRole"})
public class ChangeRoleServlet extends HttpServlet {

    @Override
    protected  void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException{
        HttpSession session = req.getSession();
        final String userLogin = req.getParameter("user_admin");
        final Integer role = Integer.parseInt(req.getParameter("futureRole"));
        try{
            Class.forName(DRIVER);

            try(Connection conn = DriverManager.getConnection(URL, LOGIN, PASSWORD)) {
                CallableStatement cs = conn.prepareCall("{call change_role(?,?,?)}");

                cs.setString(1,userLogin);
                cs.setInt(2,role);

                cs.registerOutParameter(3,Types.VARCHAR);

                cs.executeQuery();


                String changeStatus = (String) cs.getObject(3);

                if("success".equalsIgnoreCase(changeStatus)){
                    cs.close();
                    getServletContext().getRequestDispatcher("/showAllUsers").forward(req, resp);
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


