<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%-- 
    Document   : ViewPurchaseOrderGrid
    Created on : 26-May-2015, 12:54:44
    Author     : user
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>View Purchase Order</title>
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
                        data: {id: id, deskname: "purchaseorder"
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
        <a href="create_PurchaseOrderLink" class="view">Create</a>
        <h2>Purchase Order</h2>
        <br>
        <c:set var="Approved" value="${0}"></c:set>
        <c:set var="Pending" value="${0}"></c:set>
        <c:set var="notapproved" value="${0}"></c:set>
        <c:set var="Notreceived" value="${0}"></c:set>
        <c:set var="Received" value="${0}"></c:set>
        <c:set var="Partialreceived" value="${0}"></c:set>


            <br><!--code for tab begin here-->

            <ul id="tabs">
            <c:forEach var="ob" items="${branchandorderdetails}">
                <li><a href="#" name="#${ob.branchname}">${ob.branchname}</a></li>
                </c:forEach>
        </ul>  
        <div id="content">
            <c:forEach var="oc" items="${branchandorderdetails}">
                <div id="${oc.branchname}">
                    <table class="display tablestyle" id="table_id">
                        <thead>
                            <tr>
                                <th>Sr. No.</th>
                                <th>ID.</th>
                                <th>Date</th>
                                <th>Vendor Name</th>
                                <th>Total</th>
                                <th>Payment terms</th>
                                <th>Approval status</th>
                                <th>Receive Status</th>
                                <th>&nbsp;</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:set value="1" var="count"></c:set>
                            <c:forEach var="ob" items="${oc.purchaseorderdt}">
                                <tr>
                                    <td align="left">${count}</td>
                                    <td align="left">${ob.id}</td>
                                    <td align="left">${ob.date}</td>
                                    <td align="left">${ob.vendorname}</td>
                                    <td align="left">${ob.finaltotal}</td>
                                    <td align="left">${ob.paymentterms}</td>
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
                                        <c:choose>
                                            <c:when test="${ob.isreceived=='Not received'}">
                                                ${ob.isreceived}                            
                                                <c:set var="Notreceived" value="${Notreceived+1}"></c:set>
                                            </c:when>
                                            <c:when test="${ob.isreceived=='Received'}">
                                                ${ob.isreceived}                              
                                                <c:set var="Received" value="${Received+1}"></c:set>
                                            </c:when>
                                            <c:when test="${ob.isreceived=='Partial received'}">
                                                ${ob.isreceived}                                 
                                                <c:set var="Partialreceived" value="${Partialreceived+1}"></c:set>
                                            </c:when>
                                        </c:choose>
                                    </td>
                                    <td align="left"> 
                                        <a href="ViewReceivedPurchaseOrderDetails?poid=${ob.id}"><img src="images/incomes1.png" width="18" height="17" title="Receive PO" />&nbsp;&nbsp;&nbsp;&nbsp;</a>
                                        <a href="ViewPurchaseOrderBillDetails?poid=${ob.id}"><img src="images/bill.png" width="18" height="17" title="Add Bill number" />&nbsp;&nbsp;&nbsp;&nbsp;</a>
                                            <c:if test="${!sessionScope.USERTYPE.equals('spares')}">
                                            <a href="ViewPurchaseOrderDetails?poid=${ob.id}"><img src="images/view.png" width="21" height="13" title="View FollowUp Details" />&nbsp;&nbsp;&nbsp;&nbsp;</a>&nbsp;&nbsp;
                                            <a href="" onclick="confirmdelete('${ob.id}', this);"><img src="images/delete.png" width="16" height="17" /></a>
                                            </c:if>
                                            <c:if test="${sessionScope.USERTYPE.equals('spares')}">
                                                <c:choose>
                                                    <c:when test="${(ob.status=='Pending')||(ob.acceptance=='Pending')|| (ob.status=='Not approved')||(ob.acceptance=='Not approved')}">
                                                    <a href="editPurchaseOrderLink?poid=${ob.id}"><img src="images/edit.png" width="16" height="17" title="Edit PO" /></a>
                                                    </c:when>
                                                </c:choose>
                                        </c:if>
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
