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
        <title>Dashboard Transaction</title>
        <link rel="stylesheet" type="text/css" href="css/jquery.dataTables.css">        
        <script src="js/jquery.dataTables.js"></script>
        <script>
            $(document).ready(function () {
                $('.table_id').DataTable();
            });
        </script>
    </head>
    <body>
        <h2>Service Check List</h2>

        <br />
        <table class="table_id">
            <thead>
                <tr>
                    <td>Sr. No.</td>
                    <td>Checklist id.</td>
                    <td>Date</td>
                    <td>Customer Name</td>
                    <td>Brand</td>
                    <td>Model </td>
                    <td>Vehicle N0. </td>
                    <td>&nbsp;</td>
                    <td>&nbsp;</td>
                </tr>
            </thead>
            <tbody>
                <c:set value="1" var="count"></c:set>
                <c:forEach var="ob" items="${servicedtls}">
                    <tr>
                        <td align="left">${count}</td>
                        <td align="left">${ob.cvid}</td>
                        <td align="left">${ob.date}</td>
                        <td align="left">${ob.name}</td>
                        <td align="left">${ob.carbrand}</td>
                        <td align="left">${ob.carmodel}</td>
                        <td align="left">${ob.vehiclenumber}</td>
                        <td align="left">&nbsp;
                        </td>
                        <td align="left"> 
                            <a href="trackCarStatusDashboard?id=${ob.id}&prefixid=${param.prefixid}"><img src="images/bar-chart-reload.png" width="21" height="13" title="View CheckList" />&nbsp;&nbsp;&nbsp;&nbsp;</a>
                        </td>
                    </tr>  
                    <c:set value="${count+1}" var="count"></c:set>
                </c:forEach>

            </tbody>
        </table>
        <br/>
        <br/>
        <br/>

        <h2>180 Point  Check-List</h2>

        <br />
        <table class="table_id">
            <thead>
                <tr>
                    <td>Sr. No.</td>
                    <td>Date</td>
                    <td>180 point id</td>
                    <td>Service Checklist No.</td>
                    <td>Customer name</td>
                    <td>Vehicle No. </td>
                    <td>Model</td>
                    <td>&nbsp;</td>
                </tr>
            </thead>
            <tbody>
                <c:set value="1" var="count"></c:set>
                <c:forEach var="ob" items="${pointchecklistdt}">
                    <tr>
                        <td align="left">${count}</td>
                        <td align="left">${ob.pcldate}</td>
                        <td align="left">${ob.id}</td>
                        <td align="left">${ob.customervehiclesid}</td>
                        <td align="left">${ob.customername}</td>
                        <td align="left">${ob.vehiclenumber}</td>
                        <td align="left">${ob.carmodel}</td>
                        <td align="left">                            
                            <a href="trackCarStatusDashboard?id=${ob.cvid}&prefixid=${param.prefixid}"><img src="images/bar-chart-reload.png" width="21" height="13" title="View CheckList" />&nbsp;&nbsp;&nbsp;&nbsp;</a>
                        </td>
                    </tr>
                    <c:set value="${count+1}" var="count"></c:set>
                </c:forEach>
            </tbody>
        </table>
        <br/>
        <br/>
        <br/>

        <h2>Estimate</h2>

        <br />
        <table class="table_id">
            <thead>
                <tr>
                    <td>Date</td>
                    <td>Estimate no.&nbsp;&nbsp;</td>
                    <td>Customer name</td>
                    <td>Vehicle Model</td>
                    <td>Vehicle No.</td>
                    <td>Customer Approval</td>
                    <td>&nbsp;</td>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="ob" items="${estimatedtls}">
                    <tr>
                        <td align="left">${ob.savedate}</td>
                        <td align="left">${ob.estid}</td>
                        <td align="left">${ob.custname}</td>
                        <td align="left">${ob.carmodel}</td>
                        <td align="left">${ob.vehiclenumber}</td>
                        <td align="left">${ob.approval}</td>
                        <td align="left">
                            <a href="trackCarStatusDashboard?id=${ob.cvid}"><img src="images/bar-chart-reload.png" width="21" height="13" title="View CheckList" />&nbsp;&nbsp;&nbsp;&nbsp;</a>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
        <br/>
        <br/>
        <br/>
        <h2>Jobsheet</h2>
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
                <c:forEach var="ob" items="${jobdtls}">
                    <tr>
                        <td align="left">${count}</td>
                        <td align="left">${ob.jsid}</td>
                        <td align="left">${ob.custname}</td>
                        <td align="left">${ob.carmodel}</td>
                        <td align="left">${ob.vehiclenumber}</td>
                        <td align="left">
                            <a href="trackCarStatusDashboard?id=${ob.cvid}"><img src="images/bar-chart-reload.png" width="21" height="13" title="View CheckList" />&nbsp;&nbsp;&nbsp;&nbsp;</a>
                        </td>
                    </tr>  
                    <c:set value="${count+1}" var="count"></c:set>
                </c:forEach>                
            </tbody>
        </table>
        <br/>
        <br/>
        <br/>
        <h2>Invoice</h2>
        <br />
        <table class="table_id">
            <thead>
                <tr>
                    <td>Date</td>
                    <td>Id.</td>
                    <td>Customer name</td>
                    <td>Mobile no.</td>
                    <td>Vehicle Number</td>
                    <td>Balance Outstanding</td>
                    <td>Total</td>
                    <td>Payment</td>
                    <td>&nbsp;</td>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="ob" items="${invoiceListDt}">
                    <tr>
                        <td align="left">${ob.invoicedate}</td>
                        <td align="left">${ob.invoiceid}</td>
                        <td align="left">${ob.customer_name}</td>
                        <td align="left">${ob.customermobilenumber}</td>
                        <td align="left">${ob.vehiclenumber}</td>
                        <td align="left">${ob.balanceamount}</td>
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
                            <c:if test="${!sessionScope.USERTYPE.equals('spares') && !sessionScope.USERTYPE.equals('crm')}">
                                <c:choose>
                                    <c:when test="${ob.ispaid=='No'}">
                                        <!--condition to edit invoice changes-->
                                        <c:choose>
                                            <c:when test="${sessionScope.USERTYPE.equals('admin')}">
                                                <a href="editInvoiceDetailsLink?invoiceid=${ob.id}"  title="Edit invoice"><img src="images/edit.png" width="16" height="15" /></a>                                                
                                                </c:when>
                                                <c:otherwise>
                                                    <c:if test="${ob.monthcheck==currentmonth}">
                                                    <a href="editInvoiceDetailsLink?invoiceid=${ob.id}" title="Edit invoice"><img src="images/edit.png" width="16" height="15" /></a>
                                                    </c:if>                                            
                                                </c:otherwise>
                                            </c:choose>
                                        <!--condition to edit invoice changes-->

                                        <a href="makePaymentLink?invoiceid=${ob.id}&custno=${ob.customermobilenumber}" title="Make Payment"><img src="images/Bill_with_dollar_sign_and_coins_24.png" width="22" height="19" /></a>
                                        </c:when>
                                    </c:choose>
                                <a onclick="confirmdelete('${ob.id}', this);" title="Delete Invoice"><img src="images/delete.png" width="16" height="17" /></a>

                            </c:if>
                            <!--<a href="viewCustomerInvoice?invoiceid=$ {ob.id}"><img src="images/view.png" width="21" height="13" /></a>&nbsp;&nbsp;-->
                            <a href="viewCustomerInsuranceInvoice?invoiceid=${ob.id}" title="View Invoice"><img src="images/view.png" width="21" height="13" /></a>
                            <a href="viewProformaInvoice?invoiceid=${ob.id}" title="View Proforma Invoice"><img src="images/proforma.png" width="21" height="13" /></a>
                                <c:choose>
                                    <c:when test="${ob.isinsurance=='Yes'}">
                                    <a href="viewLiabilityInvoice?invoiceid=${ob.id}" title="View Liability Invoice"><img src="images/transport.png" width="21" height="13" /></a>
                                    </c:when>
                                    <c:otherwise>
                                    </c:otherwise>
                                </c:choose>                          

                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </body>
</html>
