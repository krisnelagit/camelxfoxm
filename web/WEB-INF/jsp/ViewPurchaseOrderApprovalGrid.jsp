<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%-- 
    Document   : ViewPurchaseOrderApprovalGrid
    Created on : 06-Jun-2015, 15:57:55
    Author     : user
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>View Purchase Order Approval</title>
        <link rel="stylesheet" type="text/css" href="css/tabs.css">
        <link href="css/jquery-ui_1.css" rel="stylesheet" type="text/css" />
        <script src="js/jquery-ui.js"></script>
        <script>
            $(function () {
                //popup for addng category begin here
                $("#dialognk").hide();
                //on click of edit
                $(".email_link").click(function (e) {
                    e.preventDefault();
                    var poid = $(this).attr('href');
                    $(".limitid").val('');
                    $(".limitname").val('');
                    $.ajax({
                        url: "getPurchaseOrderLimitDetails",
                        datatype: 'json',
                        type: 'POST',
                        data: {
                            poid: poid
                        },
                        cache: false,
                        success: function (data) {

                            if (data) {
                                $(".limitid").val(data[0].id);
                                $(".limitname").val(data[0].finaltotal);

                                $("#dialognk").dialog({
                                    modal: true,
                                    effect: 'drop'
                                });

                                $(".allstatus").prop("required", true);
                            }

                        }
                    });
                });
            });//END FUNCTION
        </script>

        <link rel="stylesheet" type="text/css" href="css/jquery.dataTables.css">
        <script src="js/jquery.dataTables.js"></script>             

        <script>
            $(document).ready(function () {
                $('.tablestyle').DataTable();
            });
        </script>

    </head>
    <body>
        <h2>Purchase Order Approval</h2>

        <br />

        <c:set var="Approved" value="${0}"></c:set>
        <c:set var="Pending" value="${0}"></c:set>
        <c:set var="notapproved" value="${0}"></c:set>

        <c:choose>
            <c:when test="${!sessionScope.USERTYPE.equals('subadmin')}">

                <br /><!--code for tab begin here-->

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
                                        <td>Sr. No.</td>
                                        <td>ID.</td>
                                        <td>Date</td>
                                        <td>Vendor Name</td>
                                        <td>Tax amount</td>
                                        <td>Total</td>
                                        <td>Payment terms</td>
                                        <td>Status</td>
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
                                            <td align="left">${ob.taxamount}</td>
                                            <td align="left">${ob.finaltotal}</td>
                                            <td align="left">${ob.paymentterms}</td>
                                            <td align="left">
                                                <c:choose>
                                                    <c:when test="${ob.isreceived ne 'Received'}">
                                                        <c:choose>
                                                            <c:when test="${ob.status=='Approved'}">
                                                                <a class="email_link" href="${ob.id}">${ob.status}</a>                                    
                                                                <c:set var="Approved" value="${Approved+1}"></c:set>
                                                            </c:when>
                                                            <c:when test="${ob.status=='Pending'}">
                                                                <a class="email_link" href="${ob.id}">${ob.status}</a>                                    
                                                                <c:set var="Pending" value="${Pending+1}"></c:set>
                                                            </c:when>
                                                            <c:when test="${ob.status=='Not approved'}">
                                                                <a class="email_link" href="${ob.id}">${ob.status}</a>                                    
                                                                <c:set var="notapproved" value="${notapproved+1}"></c:set>
                                                            </c:when>
                                                        </c:choose>
                                                    </c:when>
                                                    <c:otherwise>
                                                        ${ob.status}
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                        </tr>  
                                        <c:set value="${count+1}" var="count"></c:set>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </c:forEach>

                    <div id="dialognk" title="Action">
                        <form action="addApprovalStatus" method="POST">
                            <input type="hidden" name="id" class="limitid" value="" />
                            <table width="100%" cellpadding="5">
                                <tr>    
                                    <td>&nbsp;</td>
                                    <td>&nbsp;</td>
                                </tr>
                                <tr>
                                    <td width="34%" align="left" valign="top">Total Amount(Rs.)&nbsp;&nbsp;</td>
                                    <td width="66%" align="left" valign="top"><input readonly="" type="text" name="finaltotal" class="limitname" id="textfield2" /></td>
                                </tr>
                                <tr>
                                    <td width="34%" align="left" valign="top">Status&nbsp;&nbsp;</td>
                                    <td width="66%" align="left" valign="top">
                                        <select name="status" id="allstatus">
                                            <option value="" disabled >--select--</option>
                                            <option value="Approved">Approved</option>
                                            <option value="Pending">Pending</option>
                                            <option value="Not approved">Not approved</option>
                                        </select> 
                                    </td>
                                </tr>
                                <tr>    
                                    <td>&nbsp;</td>
                                    <td>&nbsp;</td>
                                </tr>
                                <tr>
                                    <td>&nbsp;</td>
                                    <td><input type="submit" id="ibutton" value="Save" class="view3" style="cursor: pointer" />&nbsp;&nbsp;&nbsp;</td>
                                </tr>
                                <tr>    
                                    <td>&nbsp;</td>
                                    <td>&nbsp;</td>
                                </tr>
                            </table>
                            <br>
                        </form>
                    </div>
                </c:when>
                <c:otherwise>
                    <br /><!--code for tab begin here-->

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
                                            <td>Sr. No.</td>
                                            <td>ID.</td>
                                            <td>Date</td>
                                            <td>Vendor Name</td>
                                            <td>Tax amount</td>
                                            <td>Total</td>
                                            <td>Payment terms</td>
                                            <td>Status</td>
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
                                                <td align="left">${ob.taxamount}</td>
                                                <td align="left">${ob.finaltotal}</td>
                                                <td align="left">${ob.paymentterms}</td>
                                                <td align="left">
                                                    <c:choose>
                                                        <c:when test="${ob.isreceived ne 'Received'}">
                                                            <c:choose>
                                                                <c:when test="${ob.subadminapproval=='Approved'}">
                                                                    <a class="email_link" href="${ob.id}">${ob.subadminapproval}</a>                                    
                                                                    <c:set var="Approved" value="${Approved+1}"></c:set>
                                                                </c:when>
                                                                <c:when test="${ob.subadminapproval=='Pending'}">
                                                                    <a class="email_link" href="${ob.id}">${ob.subadminapproval}</a>                                    
                                                                    <c:set var="Pending" value="${Pending+1}"></c:set>
                                                                </c:when>
                                                                <c:when test="${ob.subadminapproval=='Not approved'}">
                                                                    <a class="email_link" href="${ob.id}">${ob.subadminapproval}</a>                                    
                                                                    <c:set var="notapproved" value="${notapproved+1}"></c:set>
                                                                </c:when>
                                                            </c:choose>  
                                                        </c:when>
                                                        <c:otherwise>
                                                            ${ob.subadminapproval}
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                            </tr>  
                                            <c:set value="${count+1}" var="count"></c:set>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </c:forEach>

                        <div id="dialognk" title="Action">
                            <form action="addsubApprovalStatus" method="POST">
                                <input type="hidden" name="id" class="limitid" value="" />
                                <table width="100%" cellpadding="5">
                                    <tr>    
                                        <td>&nbsp;</td>
                                        <td>&nbsp;</td>
                                    </tr>
                                    <tr>
                                        <td width="34%" align="left" valign="top">Total Amount(Rs.)&nbsp;&nbsp;</td>
                                        <td width="66%" align="left" valign="top"><input readonly="" type="text" name="finaltotal" class="limitname" id="textfield2" /></td>
                                    </tr>
                                    <tr>
                                        <td width="34%" align="left" valign="top">Status&nbsp;&nbsp;</td>
                                        <td width="66%" align="left" valign="top">
                                            <select name="status" id="allstatus">
                                                <option value="" disabled >--select--</option>
                                                <option value="Approved">Approved</option>
                                                <option value="Pending">Pending</option>
                                                <option value="Not approved">Not approved</option>
                                            </select> 
                                        </td>
                                    </tr>
                                    <tr>    
                                        <td>&nbsp;</td>
                                        <td>&nbsp;</td>
                                    </tr>
                                    <tr>
                                        <td>&nbsp;</td>
                                        <td><input type="submit" id="ibutton" value="Save" class="view3" style="cursor: pointer" />&nbsp;&nbsp;&nbsp;</td>
                                    </tr>
                                    <tr>    
                                        <td>&nbsp;</td>
                                        <td>&nbsp;</td>
                                    </tr>
                                </table>
                                <br>
                            </form>
                        </div>

                    </c:otherwise>
                </c:choose>

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
