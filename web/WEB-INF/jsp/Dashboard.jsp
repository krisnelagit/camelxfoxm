<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%-- 
    Document   : Dashboard
    Created on : 17-Aug-2015, 16:29:57
    Author     : user
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Dashboard</title>
    </head>
    <body>
        <h2>Branch</h2>
        <hr/>
        <br />
        <c:forEach var="ob" items="${branchdt}">
            <!--code changes to redirect to crm dashboard begin here-->
            <c:if test="${sessionScope.USERTYPE.equals('crm')}">
                <a href="crm_Dashboard?prefixid=${ob.prefix}" id="login_pop" >
                </c:if>
            <c:if test="${sessionScope.USERTYPE.equals('subadmin')}">
                <a href="accounts_Dashboard?prefixid=${ob.prefix}" id="login_pop" >
                </c:if>
                <c:if test="${sessionScope.USERTYPE.equals('admin') ||sessionScope.USERTYPE.equals('floor manager')}">
                <a href="gotobranchinfo?prefixid=${ob.prefix}" id="login_pop" >
                    </c:if>
                    <!--code changes to redirect to crm dashboard ends!! here-->

                    <div class="event_box">
                        <h2>${ob.name}</h2>
                        <div class="lable">
                            <img src="images/phone.png" style="width: 15px;height: 17px"  title="Phone" /> <p>${ob.phonenumber}</p>
                        </div>
                        <div class="lable">
                            <img src="images/symbol20.png"  style="width: 15px;height: 17px"  title="Email" /> <p>${ob.email}</p>
                        </div>
                        <div class="lable">
                            <img src="images/map-pointer7.png"  style="width: 16px;height: 17px" title="Address"  /> <p>${ob.address}</p>
                        </div>
                        <div class="lable">
                            <img src="images/prefix.png"  style="width: 15px;height: 17px" title="Prefix" /> <p>${ob.prefix}</p>
                        </div>
                    </div>
                </a> 
            </c:forEach>
    </body>
</html>
