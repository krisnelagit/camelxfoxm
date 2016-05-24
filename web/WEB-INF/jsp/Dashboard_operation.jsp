<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%-- 
    Document   : Dashboard_operation
    Created on : 22-Aug-2015, 12:52:36
    Author     : user
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Dashboard operation</title>
        <link rel="stylesheet" type="text/css" href="css/jquery.dataTables.css">        
        <script src="js/jquery.dataTables.js"></script>
        <script>
            $(document).ready(function () {
                $('.table_id').DataTable();
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
                        data: {id: id, deskname: "customervehicles"
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
        <h2>Today's Service Check List</h2>

        <br />
        <table class="table_id">
            <thead>
                <tr>
                    <td>Sr. No.</td>
                    <td>Checklist id.</td>
                    <td >Date</td>
                    <td >Customer Name</td>
                    <td>Brand</td>
                    <td>Model </td>
                    <td>Vehicle N0. </td>
                    <td>VIN  No.</td>
                    <td>&nbsp;</td>
                </tr>
            </thead>
            <tbody>
                <c:set value="1" var="count"></c:set>
                <c:forEach var="ob" items="${todayServiceCheckListDt}">
                    <tr>
                        <td align="left">${count}</td>
                        <td align="left">${ob.cvid}</td>
                        <td align="left">${ob.date}</td>
                        <td align="left">${ob.name}</td>
                        <td align="left">${ob.carbrand}</td>
                        <td align="left">${ob.carmodel}</td>
                        <td align="left">${ob.vehiclenumber}</td>
                        <td align="left">${ob.vinnumber}</td>                        
                        <td align="left"> 
                            <a href="viewServiceCheckList.html?id=${ob.id}&bdid=${ob.brandid}"><img src="images/view.png" width="21" height="13" title="View Service CheckList" />&nbsp;&nbsp;&nbsp;&nbsp;</a>
                                <c:if test="${!sessionScope.USERTYPE.equals('spares')}">
                                    <c:choose>
                                        <c:when test="${ob.is180ready=='No'}">
                                        <a href="180pointchecklist?id=${ob.cvdid}&branddetailid=${ob.branddetailid}&cvid=${ob.id}&isr=${ob.is180ready}"><img src="images/180_icon.png" width="16" height="14"  title="180 point Check List" />&nbsp;&nbsp;&nbsp;&nbsp;</a>&nbsp;&nbsp;
                                        <a onclick="confirmdelete('${ob.id}', this);"><img src="images/delete.png" width="16" height="17" /></a>
                                        </c:when>
                                    </c:choose>
                                </c:if> 
                        </td>
                    </tr>  
                    <c:set value="${count+1}" var="count"></c:set>
                </c:forEach>

            </tbody>
        </table>
        <br/>
        <br/>
        <br/>

        <h2>Pending 180 point</h2>

        <br />
        <table class="table_id">
            <thead>
                <tr>
                    <td>Sr. No.</td>
                    <td >Date</td>
                    <td >Customer Name</td>
                    <td >Licence No.</td>
                    <td>Brand</td>
                    <td>Model </td>
                    <td>Vehicle N0. </td>
                    <td>VIN  No.</td>
                    <td>&nbsp;</td>
                </tr>
            </thead>
            <tbody>
                <c:set value="1" var="count"></c:set>
                <c:forEach var="ob" items="${pending180Dt}">
                    <tr>
                        <td align="left">${count}</td>
                        <td align="left">${ob.date}</td>
                        <td align="left">${ob.name}</td>
                        <td align="left">${ob.licensenumber}</td>
                        <td align="left">${ob.carbrand}</td>
                        <td align="left">${ob.carmodel}</td>
                        <td align="left">${ob.vehiclenumber}</td>
                        <td align="left">${ob.vinnumber}</td>
                        <td align="left"> 
                            <a href="EditServiceCheckList.html?id=${ob.id}&bdid=${ob.brandid}"><img src="images/edit.png" width="16" height="16"  title="Edit Service Check List" />&nbsp;&nbsp;&nbsp;&nbsp;</a>
                                <c:choose>
                                    <c:when test="${ob.is180ready=='No'}">
                                    <a href="180pointchecklist?id=${ob.cvdid}&branddetailid=${ob.branddetailid}&cvid=${ob.id}&isr=${ob.is180ready}"><img src="images/180_icon.png" width="16" height="14"  title="180 point Check List" />&nbsp;&nbsp;&nbsp;&nbsp;</a>
                                    </c:when>
                                </c:choose>
                            <a href="viewServiceCheckList.html?id=${ob.id}&bdid=${ob.brandid}"><img src="images/view.png" width="21" height="13" title="View Service CheckList" />&nbsp;&nbsp;&nbsp;&nbsp;</a>&nbsp;&nbsp;<a onclick="confirmdelete('${ob.id}', this);"><img src="images/delete.png" width="16" height="17" /></a>
                        </td>
                    </tr>  
                    <c:set value="${count+1}" var="count"></c:set>
                </c:forEach>
            </tbody>
        </table>
        <br/>
        <br/>
        <br/>

        <h2>Completed 180 point</h2>

        <br />
        <table class="table_id">
            <thead>
                <tr>
                    <td>Sr. No.</td>
                    <td >Date</td>
                    <td >Customer Name</td>
                    <td >Licence No.</td>
                    <td>Brand</td>
                    <td>Model </td>
                    <td>Vehicle N0. </td>
                    <td>VIN  No.</td>
                    <td>&nbsp;</td>
                </tr>
            </thead>
            <tbody>
                <c:set value="1" var="count"></c:set>
                <c:forEach var="ob" items="${completed180Dt}">
                    <tr>
                        <td align="left">${count}</td>
                        <td align="left">${ob.date}</td>
                        <td align="left">${ob.name}</td>
                        <td align="left">${ob.licensenumber}</td>
                        <td align="left">${ob.carbrand}</td>
                        <td align="left">${ob.carmodel}</td>
                        <td align="left">${ob.vehiclenumber}</td>
                        <td align="left">${ob.vinnumber}</td>
                        <td align="left"> 
                            <a href="EditServiceCheckList.html?id=${ob.id}&bdid=${ob.brandid}"><img src="images/edit.png" width="16" height="16"  title="Edit Service Check List" />&nbsp;&nbsp;&nbsp;&nbsp;</a>
                                <c:choose>
                                    <c:when test="${ob.is180ready=='No'}">
                                    <a href="180pointchecklist?id=${ob.cvdid}&branddetailid=${ob.branddetailid}&cvid=${ob.id}&isr=${ob.is180ready}"><img src="images/180_icon.png" width="16" height="14"  title="180 point Check List" />&nbsp;&nbsp;&nbsp;&nbsp;</a>
                                    </c:when>
                                </c:choose>
                            <a href="viewServiceCheckList.html?id=${ob.id}&bdid=${ob.brandid}"><img src="images/view.png" width="21" height="13" title="View Service CheckList" />&nbsp;&nbsp;&nbsp;&nbsp;</a>&nbsp;&nbsp;<a onclick="confirmdelete('${ob.id}', this);"><img src="images/delete.png" width="16" height="17" /></a>
                        </td>
                    </tr>  
                    <c:set value="${count+1}" var="count"></c:set>
                </c:forEach>
            </tbody>
        </table>
        <br/>
        <br/>
        <br/>
        <h2>Pending estimate</h2>
        <br />
        <table class="table_id">
            <thead>
                <tr>
                    <td>Sr. No.</td>
                    <td>Date</td>
                    <td>180 point id</td>
                    <td>Service Checklist No.</td>
                    <td>Vehicle No: </td>
                    <td>Model</td>
                    <td>&nbsp;</td>
                </tr>
            </thead>
            <tbody>
                <c:set value="1" var="count"></c:set>
                <c:forEach var="ob" items="${pendingestimateDt}">
                    <tr>
                        <td align="left">${count}</td>
                        <td align="left">${ob.pcldate}</td>
                        <td align="left">${ob.id}</td>
                        <td align="left">${ob.servicechecklistid}</td>
                        <td align="left">${ob.vehiclenumber}</td>
                        <td align="left">${ob.carmodel}</td>
                        <td align="left">
                            <a href="addEstimatePage?pclid=${ob.id}&ises=${ob.estimatestatus}"><img src="images/eslitmate_icon.png" alt="" width="14" height="16" title="Create Estimate"/></a> &nbsp;&nbsp;<a href="edit180pointchecklist?id=${ob.id}&brandid=${ob.branddetailid}" title="Edit 180 point" class="email_link3"><img src="images/edit.png" width="16" height="15"></a>&nbsp;&nbsp;<a href="180pointchecklistviewdetails?pclid=${ob.id}"><img src="images/view.png" width="21" height="13" />&nbsp;&nbsp;</a><img src="images/delete.png" width="16" height="17" /></td>
                        </td>
                    </tr>
                    <c:set value="${count+1}" var="count"></c:set>
                </c:forEach>
            </tbody>
        </table>
        <br/>
        <br/>
        <br/>
        <h2>Completed estimate</h2>
        <br />
        <table class="table_id">
            <thead>
                <tr>
                    <td>Sr. No.</td>
                    <td>Date</td>
                    <td>180 point id</td>
                    <td>Service Checklist No.</td>
                    <td>Vehicle No: </td>
                    <td>Model</td>
                    <td>&nbsp;</td>
                </tr>
            </thead>
            <tbody>
                <c:set value="1" var="count"></c:set>
                <c:forEach var="ob" items="${completedestimateDt}">
                    <tr>
                        <td align="left">${count}</td>
                        <td align="left">${ob.pcldate}</td>
                        <td align="left">${ob.id}</td>
                        <td align="left">${ob.servicechecklistid}</td>
                        <td align="left">${ob.vehiclenumber}</td>
                        <td align="left">${ob.carmodel}</td>
                        <td align="left">
                            <a href="addEstimatePage?pclid=${ob.id}&ises=${ob.estimatestatus}"><img src="images/eslitmate_icon.png" alt="" width="14" height="16" title="Create Estimate"/></a> &nbsp;&nbsp;<a href="edit180pointchecklist?id=${ob.id}&brandid=${ob.branddetailid}" title="Edit 180 point" class="email_link3"><img src="images/edit.png" width="16" height="15"></a>&nbsp;&nbsp;<a href="180pointchecklistviewdetails?pclid=${ob.id}"><img src="images/view.png" width="21" height="13" />&nbsp;&nbsp;</a><img src="images/delete.png" width="16" height="17" /></td>
                        </td>
                    </tr>
                    <c:set value="${count+1}" var="count"></c:set>
                </c:forEach>
            </tbody>
        </table>
        <br/>
        <br/>
        <br/>
        <h2>Pending Jobsheet</h2>
        <br />
        <table class="table_id">
            <thead>
                <tr>
                    <td>Sr. No.</td>
                    <td>Job No.</td>
                    <td>Customer Name</td>
                    <td>Car Model</td>
                    <td>Vehicle No.</td>
                    <td>&nbsp;</td>
                </tr>
            </thead>
            <tbody>
                <c:set value="1" var="count"></c:set>
                <c:forEach var="ob" items="${pendingjobsheetDt}">
                    <tr>
                        <td align="left">${count}</td>
                        <td align="left">${ob.jsid}</td>
                        <td align="left">${ob.custname}</td>
                        <td align="left">${ob.carmodel}</td>
                        <td align="left">${ob.vehiclenumber}</td>
                        <td align="left">
                            <a href="viewTaskLink?jsid=${ob.jsid}"><img src="images/task.png" width="17" height="17" /></a>&nbsp;&nbsp;
                            <a href="converttoinovice?jsid=${ob.jsid}&carbrandid=${ob.branddetailid}&isinc=${ob.isinvoiceconverted}"><img src="images/c_invoiceh.png" width="17" height="17" /></a>&nbsp;&nbsp;
                            <a href="jobVerificationView?jsid=${ob.jsid}&istkdone=${ob.istaskcompleted}"><img src="images/verify.png" width="17" height="17" /></a>&nbsp;&nbsp;<a href="editJobDetailsLink?jsid=${ob.jsid}"><img src="images/edit.png" width="16" height="15"></a>&nbsp;&nbsp;
                            <a onclick="confirmdelete('${ob.id}', this);"><img src="images/delete.png" width="16" height="17" /></a>
                        </td>
                    </tr>  
                    <c:set value="${count+1}" var="count"></c:set>
                </c:forEach>                
            </tbody>
        </table>
        <br/>
        <br/>
        <br/>
        <h2>Today's Invoice</h2>
        <br />
        <table class="table_id">
            <thead>
                <tr>
                    <td>Sr. No.</td>
                    <td>Date</td>
                    <td>Id.</td>
                    <td>Customer name</td>
                    <td>Mobile no.</td>
                    <td>Vehicle Number</td>
                    <td>Total</td>
                    <td>Payment</td>
                    <td>&nbsp;</td>
                </tr>
            </thead>
            <tbody>
                <c:set value="1" var="count"></c:set>
                <c:forEach var="ob" items="${invoiceListDt}">
                    <tr>
                        <td align="left">${count}</td>
                        <td align="left">${ob.savedate}</td>
                        <td align="left">${ob.id}</td>
                        <td align="left">${ob.name}</td>
                        <td align="left">${ob.customermobilenumber}</td>
                        <td align="left">${ob.vehiclenumber}</td>
                        <td align="left">${ob.amountTotal}</td>
                        <td align="left">
                            <c:choose>
                                <c:when test="${ob.ispaid=='No'}">
                                    Not paid
                                </c:when>
                                <c:otherwise>
                                    Paid
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td align="left">
                            <c:choose>
                                <c:when test="${ob.ispaid=='No'}">
                                    <a href="editInvoiceDetailsLink?invoiceid=${ob.id}"><img src="images/edit.png" width="16" height="15" /></a>&nbsp;&nbsp;
                                    <a href="makePaymentLink?invoiceid=${ob.id}&custno=${ob.customermobilenumber}"><img src="images/Bill_with_dollar_sign_and_coins_24.png" width="22" height="19" /></a>&nbsp;&nbsp;
                                    </c:when>
                                </c:choose>
                            <a href="viewCustomerInvoice?invoiceid=${ob.id}"><img src="images/view.png" width="21" height="13" /></a>&nbsp;&nbsp;
                            <a onclick="confirmdelete('${ob.id}', this);"><img src="images/delete.png" width="16" height="17" /></a>
                        </td>
                    </tr>
                    <c:set value="${count+1}" var="count"></c:set>
                </c:forEach>
            </tbody>
        </table>
    </body>
</html>
