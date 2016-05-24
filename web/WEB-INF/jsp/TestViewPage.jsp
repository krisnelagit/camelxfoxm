<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%-- 
    Document   : TestViewPage
    Created on : 25 Mar, 2016, 4:06:44 PM
    Author     : manish
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
        <table style="width:100%">
            <c:forEach var="ob" items="${testdt}">
            <tr>
                <td>${ob.name}</td>
                <td>${ob.rollnumber}</td>
            </tr>
            </c:forEach>
        </table>
    </body>
</html>
