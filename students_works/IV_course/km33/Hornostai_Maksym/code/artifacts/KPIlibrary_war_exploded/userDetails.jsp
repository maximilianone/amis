<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Bookshelf</title>
    <style>
        body {margin:0;
            background-color:#DCDCDC;}

        ul {
            list-style-type: none;
            margin: 0;
            padding: 0;
            overflow: hidden;
            background-color: #333;
            position: fixed;
            top: 0;
            width: 100%;
        }

        li {
            float: left;
            width: 25%;
        }

        li a {
            display: block;
            color: white;
            text-align: center;
            padding: 14px 20px;
            text-decoration: none;
        }

        li a:hover:not(.active) {
            background-color: #111;
        }

        .active {
            background-color: #2F4F4F;
        }
        .regi {
            float: right;
            background-color: #333;
            display: block;
            text-align: center;
            padding: 10px;
            color: white;
            text-decoration: none;
        }
        a.regi:hover{
            background-color: #111;
        }
        input.regi:hover{
            background-color: #111;
        }
        button.regi:hover{
            background-color: #111;
        }
        .regi > a{
            color: white;
            text-decoration: none;
        }
        .loginDialog {
            position: fixed;
            top: 0;
            right: 0;
            bottom: 0;
            left: 0;
            background: rgba(0,0,0,0.8);
            z-index: 99999;
            opacity:0;
            transition: opacity 400ms ease-in;
            pointer-events: none;
        }
        .loginDialog:target {
            opacity:1;
            pointer-events: auto;
        }

        .loginDialog > div {
            width: 400px;
            position: relative;
            margin: 10% auto;
            padding: 5px 20px 13px 20px;
            border-radius: 10px;
            background: #fff;
        }
        .close {
            background: #606061;
            color: #FFFFFF;
            line-height: 25px;
            position: absolute;
            right: -12px;
            text-align: center;
            top: -10px;
            width: 24px;
            text-decoration: none;
            font-weight: bold;
            border-radius: 12px;
            box-shadow: 1px 1px 3px #000;
        }

        .button{
            background-color:  #333;
            color: white;
            font-size: 15px;
            padding: 5px 50px
        }

        .button:hover {
            background-color: #111;
        }

        .close:hover { background: #111; }
    </style>
    <script src="jquery-3.1.1.min.js">
    </script>
    <script src="jquery.maskedinput.min.js">
    </script>
    <script src="jquery.validate.js">
    </script>

</head>
<body>
<ul>
    <li><a href="home.jsp">Home</a></li>
    <li><a href="books.jsp">Books</a></li>
    <li><a href="contact.jsp">Contact</a></li>
    <li><a href="about.jsp">About</a></li>
</ul>

<c:if test="${empty sessionScope.user_login}">

    <div style="float: right;margin-top:50px;padding:0px 10px;">
        <a class="regi" href="#login">Log in</a>
        <a class="regi" href="register.jsp">Register</a>
    </div>
</c:if>
<c:if test="${!empty sessionScope.user_login}">
    <form method="post" action="authorization">
        <div style="float: right;margin-top:50px;padding:0px 10px;">
            <input type="hidden" name="command" value="logout">
            <button class="regi" type="submit" formaction="personalCabinet"><a>${sessionScope.user_login} cabinet</a></button>
            <input type="submit" class="regi" value="Logout"/>
        </div>
    </form>
</c:if>
<form method="post" action="authorization">
    <div id="login" class="loginDialog">
        <div>
            <a href="#close" title="Close" class="close">X</a>
            <table style="border:#111; border-radius: 4px;">
                <tr>
                    <td height="2px"><h3>Username:</h3></td>
                    <td style="width:25%;"><input type="text" pattern="[A-Za-z0-9]{4,}" placeholder="Enter Username" name="uname" required></td>
                </tr>
                <tr>
                    <td height="2px"><h3>Password:</h3></td>
                    <td><input type="password" pattern="[A-Za-z0-9]{4,}" placeholder="Enter Password" name="psw" required ></td>
                </tr>
            </table>
            <input type="hidden" name="command" value="login">
            <center><button class="button" type="submit">Login</button></center>
        </div>
    </div>
</form>
<c:if test="${!empty sessionScope.admin_login}">

    <br><br><div style="padding:20px;margin-top:30px;height:200px;">
    <h2>${sessionScope.current_user}</h2>
    <div style="background-color:#F5FFFA;">
        <h3>User name: ${sessionScope.current_user_name}</h3>
        <h3>User telephon: ${sessionScope.current_user_telephone}</h3>
        <h3>User email: ${sessionScope.current_user_email}</h3>
        <br><c:if test="${empty sessionScope.usersDetails}">
        <center><h2>No records</h2></center>
    </c:if>
        <center>
            <c:if test="${!empty sessionScope.usersDetails}">
                <table border="1">
                    <tr>
                        <th></th>
                        <th><h3>Book Name</h3></th>
                        <th><h3>Book Publisher</h3></th>
                        <th><h3>Book status</h3></th>
                        <th><h3>Date of issue</h3></th>
                        <th><h3>Date of return</h3></th>
                    </tr>
                    <c:set var="count" value="1" scope="page" />
                    <c:set var="statufOfRecord" value="reserved" scope="page" />
                    <c:forEach items="${sessionScope.usersDetails}" var="objectList">
                        <tr>
                            <td><b>"${count}"</b></td>
                            <form method="post" action="returnBook">
                                <input type="hidden" name="user_login" value="${sessionScope.current_user}">
                                <input type="hidden" name="command" value="thisUser">
                                <input type="hidden" value="${sessionScope.current_user}" name="current_user">
                                <input type="hidden" value="${sessionScope.current_user_name}" name="current_user_name">
                                <input type="hidden" value="${sessionScope.current_user_telephone}" name="current_user_telephone">
                                <input type="hidden" value="${sessionScope.current_user_email}" name="current_user_email">
                                <input type="hidden" value="${sessionScope.current_user_role}" name="current_user_role">
                                <td><c:out value="${objectList.fk_book_name}" />
                                    <input type="hidden" value="${objectList.fk_book_name}" name="book_name"></td>
                                <td><c:out value="${objectList.fk_book_publisher}" />
                                    <input type="hidden" value="${objectList.fk_book_publisher}" name="book_publisher"></td>
                                <td><c:out value="${objectList.status}" /></td>
                                <td><c:out value="${objectList.date_of_issue}" /></td>
                                <td><c:out value="${objectList.date_of_return}" /></td>
                                    <td><button type="submit">cancel</button></td>
                                <c:if test="${objectList.status==statufOfRecord}">
                                    <td><button type="submit" formaction="changeRecordStatus">change status to loaned</button></td>
                                </c:if>
                            <c:set var="count" value="${count + 1}" scope="page"/>
                            </form>
                        </tr>
                    </c:forEach>
                </table>
        </center>
        </c:if>
        <br><br>
        <center>
        <form method="post" action="showAllUsers">
            <input type="hidden" name="required_user" value="">
            <input type="hidden" name="user_admin" value="${sessionScope.current_user}">
            <button class="button" type="submit">Back</button>
            <c:if test="${sessionScope.role>1}">
                <input type="hidden" name="userForRecord" value="${sessionScope.current_user}">
                <a href="reserveAsAdmin.jsp"><button class="button" type="button">Add record</button></a>
            </c:if>
            <c:if test="${sessionScope.role > 2}">
                <input type="hidden" value="${sessionScope.current_user}" name="current_user">
                <input type="hidden" value="${sessionScope.current_user_name}" name="current_user_name">
                <input type="hidden" value="${sessionScope.current_user_telephone}" name="current_user_telephone">
                <input type="hidden" value="${sessionScope.current_user_email}" name="current_user_email">
                <input type="hidden" value="${sessionScope.current_user_role}" name="current_user_role">
                <c:if test="${sessionScope.current_user_role<2}">
                    <input type="hidden" name="futureRole" value="2">
            <button class="button" type="submit" formaction="changeRole">Make admin</button>
                </c:if>
                <c:if test="${sessionScope.current_user_role>1 && sessionScope.current_user_role<3}">
                    <input type="hidden" name="futureRole" value="1">
                    <button class="button" type="submit" formaction="changeRole">Make ordinary user</button>
                </c:if>
            </c:if>
        </form>
        </center>
        <br><br>
    </div>
</div>
</c:if>
<BR>
</body>
</html>
