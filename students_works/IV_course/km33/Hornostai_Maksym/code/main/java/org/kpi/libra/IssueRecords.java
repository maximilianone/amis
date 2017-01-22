package org.kpi.libra;

import java.sql.*;

/**
 * Created by Garret on 20-Jan-17.
 */

public class IssueRecords {

    private String fk_user_login;
    private String fk_book_name;
    private String fk_book_publisher;
    private String status;
    private Date date_of_issue;
    private Date date_of_return;


    public IssueRecords(String fk_user_login, String fk_book_name, String fk_book_publisher, String status, Date date_of_issue,Date date_of_return) {
        this.fk_user_login = fk_user_login;
        this.fk_book_name = fk_book_name;
        this.fk_book_publisher = fk_book_publisher;
        this.status = status;
        this.date_of_issue=date_of_issue;
        this.date_of_return=date_of_return;

    }
    public String getFk_book_name(){
        return fk_book_name;
    }
    public String getFk_user_login(){
        return fk_user_login;
    }
    public String getFk_book_publisher(){
        return fk_book_publisher;
    }
    public String getStatus(){
        return status;
    }
    public Date getDate_of_issue(){
        return date_of_issue;
    }
    public Date getDate_of_return(){
        return date_of_return;
    }
}


