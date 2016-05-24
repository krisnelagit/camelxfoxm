<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%-- 
    Document   : ViewGeneralIncomeGrid
    Created on : 31-Jul-2015, 11:03:55
    Author     : user
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>View General Income Grid</title>
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
                        url: "deleteIncomerecord",
                        data: {id: id, deskname: "generalincome"
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
        <a href="createGeneralIncomeLink" class="view">Create</a>
        <h2>General Income</h2>

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
                                <td>Date</td>
                                <td>Invoice no.</td>
                                <td>To</td>
                                <td>Groups</td>
                                <td>Total</td>
                                <td>&nbsp;</td>
                            </tr>
                        </thead>
                        <tbody>
                            <c:set value="1" var="count"></c:set>
                            <c:forEach var="ob" items="${oc.generalincomedtls}">
                                <tr>
                                    <td align="left">${count}</td>
                                    <td align="left"><fmt:formatDate pattern="yyyy-MM-dd" value="${ob.savedate}" /></td>
                                    <td align="left">
                                        <c:choose>
                                            <c:when test="${empty ob.invoiceid}">
                                                N/A
                                            </c:when>
                                            <c:otherwise>
                                                ${ob.invoiceid}
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td align="left">${ob.towards}</td>
                                    <td align="left">${ob.name}</td>
                                    <td align="left">${ob.total}</td>
                                    <td align="left"> 
                                        <a href="viewGeneralIncomeDetails?incomeid=${ob.id}"><img src="images/view.png" width="21" height="13" title="View expenses Details" />&nbsp;&nbsp;&nbsp;&nbsp;</a>&nbsp;&nbsp;<a onclick="confirmdelete('${ob.id}', this);"><img src="images/delete.png" width="16" height="17" /></a>
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
