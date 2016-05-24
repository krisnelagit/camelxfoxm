<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%-- 
    Document   : ViewGeneralExpenseGrid
    Created on : 08-Jun-2015, 11:05:23
    Author     : user
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>View General Expense</title>
        <link rel="stylesheet" type="text/css" href="css/tabs.css">
        <link rel="stylesheet" type="text/css" href="css/jquery.dataTables.css">        
        <script src="js/jquery.dataTables.js"></script>
        <script>
            $(document).ready(function () {
                $('.tablestyle').DataTable();
            });
        </script>
        <script>
            function confirmdelete(id, ob)
            {
                var res = confirm('Are you sure to delete?');
                if (res == true)
                {
                    $(ob).closest('tr').find('td').fadeOut(600,
                            function () {
                                $(ob).parents('tr:first').remove();
                            });

                    $.ajax({
                        type: "post",
                        url: "deleterecord",
                        data: {id: id, deskname: "generalexpense"
                        },
                        success: function (data) {
                        },
                        error: function () {
                        }
                    });
                }
            }
        </script>
    </head>
    <body>
        <a href="createGeneralExpensesLink" class="view">Create</a>
        <h2>General Expenses</h2>

        <br>
        <c:set var="Approved" value="${0}"></c:set>
        <c:set var="Pending" value="${0}"></c:set>
        <c:set var="notapproved" value="${0}"></c:set>
            <br><!--code for tab begin here-->

            <ul id="tabs">
            <c:forEach var="ob" items="${branchandpartdetails}">
                <li><a href="#" name="#${ob.branchname}">${ob.branchname}</a></li>
                </c:forEach>
        </ul>  
        <div id="content">
            <c:forEach var="oc" items="${branchandpartdetails}">
                <div id="${oc.branchname}">
            <table class="display tablestyle" id="table_id">
                <thead>
                    <tr>
                        <td>Sr. No.</td>
                        <td>Expense id</td>
                        <td>Bill No.</td>
                        <td>Expense Date</td>
                        <td>To</td>
                        <td>Ledger</td>
                        <td>Groups</td>
                        <td>Total</td>
                        <td>Status</td>
                        <td>&nbsp;</td>
                    </tr>
                </thead>
                <tbody>
                <c:set value="1" var="count"></c:set>
                <c:forEach var="ob" items="${oc.generalexpensedtls}">
                    <tr>
                        <td align="left">${count}</td>
                        <td align="left">${ob.id}</td>
                        <td align="left">
                            <c:choose>
                        <c:when test="${empty ob.expense_billnumber}">
                            N/A
                        </c:when>
                        <c:otherwise>
                            ${ob.expense_billnumber}
                        </c:otherwise>
                    </c:choose>
                        </td>
                        <td align="left">${ob.expense_date}</td>
                        <td align="left">${ob.towards}</td>
                        <td align="left">${ob.accountname}</td>
                        <td align="left">${ob.name}</td>
                        <td align="left">${ob.total}</td>
                        <td align="left">
                            <c:choose>
                                <c:when test="${ob.acceptance=='Approved'}">
                                    ${ob.acceptance}                            
                                    <c:set var="Approved" value="${Approved+1}"></c:set>
                                </c:when>
                                <c:when test="${ob.acceptance=='Pending'}">
                                    ${ob.acceptance}                              
                                    <c:set var="Pending" value="${Pending+1}"></c:set>
                                </c:when>
                                <c:when test="${ob.acceptance=='Not approved'}">
                                    ${ob.acceptance}                                 
                                    <c:set var="notapproved" value="${notapproved+1}"></c:set>
                                </c:when>
                            </c:choose>  
                        </td>
                        <td align="left"> 
                            <a href="viewGeneralExpenseDetails?expenseid=${ob.id}"><img src="images/view.png" width="21" height="13" title="View expenses Details" />&nbsp;&nbsp;&nbsp;&nbsp;</a>&nbsp;&nbsp;<a onclick="confirmdelete('${ob.id}', this);"><img src="images/delete.png" width="16" height="17" /></a>
                        </td>
                    </tr>  
                    <c:set value="${count+1}" var="count"></c:set>
                </c:forEach>
            </tbody>
        </table>
                </div>
            </c:forEach>
            <script>

                function resetTabs() {

                    $("#content > div").hide(); //Hide all content

                    $("#tabs a").attr("id", ""); //Reset id's      

                }



                var myUrl = window.location.href; //get URL

                var myUrlTab = myUrl.substring(myUrl.indexOf("#")); // For localhost/tabs.html#tab2, myUrlTab = #tab2     

                var myUrlTabName = myUrlTab.substring(0, 4); // For the above example, myUrlTabName = #tab



                (function () {

                    $("#content > div").hide(); // Initially hide all content

                    $("#tabs li:first a").attr("id", "current"); // Activate first tab

                    $("#content > div:first").fadeIn(); // Show first tab content



                    $("#tabs a").on("click", function (e) {

                        e.preventDefault();

                        if ($(this).attr("id") == "current") { //detection for current tab
                           

                            return

                        }

                        else {

                            resetTabs();

                            $(this).attr("id", "current"); // Activate this

                            $($(this).attr('name')).fadeIn(); // Show content for current tab

                        }

                    });



                    for (i = 1; i <= $("#tabs li").length; i++) {

                        if (myUrlTab == myUrlTabName + i) {

                            resetTabs();

                            $("a[name='" + myUrlTab + "']").attr("id", "current"); // Activate url tab

                            $(myUrlTab).fadeIn(); // Show url tab content        

                        }

                    }

                })()

            </script>
    </body>
</html>
