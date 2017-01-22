<%@ page import="org.kpi.libra.IssueRecords" %><%--
  Created by IntelliJ IDEA.
  User: Garret
  Date: 21-Jan-17
  Time: 00:50
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>Title</title>
</head>
<body>
<table>
    <c:forEach items="${sessionScope.userss}" var="objectList">
            <tr>

                <td><c:out value="${objectList.user_login}" /></td>
                <%--<td>${object.field2}</td>--%>
                <%--<td>${object.field3}</td>--%>
            </tr>
    </c:forEach>
    </table>
</body>
</html>
