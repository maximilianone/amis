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

        div.img {
            margin: 5px;
            border: 1px solid #ccc;
            float: left;
            width: 32%;
            background-color:#111;
        }

        div.img:hover {
            border: 1px solid #111;
        }

        div.img img {
            width: 100%;
            height: auto;
        }

        div.desc {
            padding: 15px;
            text-align: center;
            color:white;
            background-color:#111;
        }
    </style>
</head>
<body>
<ul>
    <li><a href="home.jsp">Home</a></li>
    <li><a  class="active" href="books.jsp">Books</a></li>
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
        </div>>
    </div>
</form>

<br><div style="padding:20px;margin-top:30px;">
    <center><h1>Books cabinet</h1></center>
    <br><center><form method="post" action="searcbook">
    <input type="radio" name="searchparam" value="book_author" required> Author
    <input type="radio" name="searchparam" value="book_name" required> Book name
    <input type="search" name="searchvalue" placeholder="search" pattern="[A-Za-z][A-Za-z ]+{1,}" required>
    <br><br><button class="button" id="btnSubmit" type="submit">Search</button>
</form></center>
    <center>
        <table>
            <tr>
                <td>
                    <form method="post" action="searcbook">
                        <input type="hidden" name="searchparam" value="book_section" required>
                        <input type="hidden" name="searchvalue" value="fiction">
                        <button class="button" type="submit">Fiction</button>
                    </form>
                </td>
                <td>
                    <form method="post" action="searcbook">
                        <input type="hidden" name="searchparam" value="book_section" required>
                        <input type="hidden" name="searchvalue" value="math">
                        <button class="button" type="submit">Math</button>
                    </form>
                </td>
                <td>
                    <form method="post" action="searcbook">
                        <input type="hidden" name="searchparam" value="book_section" required>
                        <input type="hidden" name="searchvalue" value="physics">
                        <button class="button" type="submit">Physics</button>
                    </form>
                </td>
                <td>
                    <form method="post" action="searcbook">
                        <input type="hidden" name="searchparam" value="book_section" required>
                        <input type="hidden" name="searchvalue" value="biology">
                        <button class="button" type="submit">Biology</button>
                    </form>
                </td>
            </tr>
        </table>
    </center>
</div>

<c:if test="${!empty sessionScope.books}">
    <div style="padding:20px;margin-top:30px;height:200px;">
        <div style="background-color:#F5FFFA;">
            <br>
            <center>
                <table border="1">
                    <tr>
                        <th></th>
                        <th><h3>Book Name</h3></th>
                        <th><h3>Book Author</h3></th>
                        <th><h3>Book Publisher</h3></th>
                        <th><h3>Book section</h3></th>
                        <c:if test="${!empty sessionScope.user_login}">
                            <th><h3>Date of return</h3></th>
                        </c:if>
                    </tr>
                    <c:set var="count" value="1" scope="page" />
                    <c:forEach items="${sessionScope.books}" var="objectList">
                        <tr>
                            <td><b>"${count}"</b></td>
                            <form method="post" action="addRecord">
                                <input type="hidden" value="asUser" name="command">
                                <td><c:out value="${objectList.book_name}" />
                                    <input type="hidden" value="${objectList.book_name}" name="bookName"></td>
                                <td><c:out value="${objectList.book_author}" /></td>
                                <td><c:out value="${objectList.book_publisher}" />
                                    <input type="hidden" value="${objectList.book_publisher}" name="publisher"></td>
                                <td><c:out value="${objectList.book_section}" /></td>
                                <c:if test="${!empty sessionScope.user_login}">
                                <td><input type="date" name="date" required></td>
                                    <td><button type="submit">reserve</button></td>
                                </c:if>
                            </form>
                            <c:set var="count" value="${count + 1}" scope="page"/>
                        </tr>
                    </c:forEach>
                </table>
            </center>
            <br><br>
        </div>
    </div>
</c:if>

</body>
</html>
