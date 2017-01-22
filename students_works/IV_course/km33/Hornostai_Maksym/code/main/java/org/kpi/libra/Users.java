package org.kpi.libra;

public class Users {
    private String user_login;
    private String user_name;
    private String user_password;
    private String user_telephon;
    private String user_email;
    private Integer user_role;

    public Users(String user_login, String user_name, String user_password, String user_telephon, String user_email, Integer user_role){
        this.user_login=user_login;
        this.user_name=user_name;
        this.user_password=user_password;
        this.user_telephon=user_telephon;
        this.user_email=user_email;
        this.user_role=user_role;
    }

    public String getUser_login(){return user_login;}
    public String getUser_name(){return user_name;}
    public String getUser_password(){return user_password;}
    public String getUser_telephon(){return  user_telephon;}
    public String getUser_email(){return user_email;}
    public Integer getUser_role(){return  user_role;}
}
