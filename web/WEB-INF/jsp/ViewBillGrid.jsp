<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%-- 
    Document   : ViewVendorPaymentGrid
    Created on : 08-Jun-2015, 11:05:23
    Author     : user
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>View General Expense</title>
        <link href="css/jquery-ui_1.css" rel="stylesheet" type="text/css" />        
        <script src="js/jquery-ui.js"></script>
        <link rel="stylesheet" type="text/css" href="css/jquery.dataTables.css">        
        <script src="js/jquery.dataTables.js"></script>
        <script>
            $(document).ready(function () {
                $('.selection').change(function () {
                    $(this).closest('tr').find('.billids').attr('disabled', !this.checked);
                    $(this).closest('tr').find('.totals').attr('disabled', !this.checked);
                    $(this).closest('tr').find('.poids').attr('disabled', !this.checked);
                    $(this).closest('tr').find('.podids').attr('disabled', !this.checked);
                    $(this).closest('tr').find('.vendorids').attr('disabled', !this.checked);
                });
                $("#dialog").hide();
                $('#table_id').DataTable();

                if ('${param.errmsg}' === "Yes") {
                    $("#dialog").show();
                    $("#dialog").dialog({
                        modal: true,
                        effect: 'drop',
                        show: {
                            effect: "drop"
                        },
                        hide: {
                            effect: "drop"
                        }
                    });
                }
            });
        </script>
    </head>
    <body>
        <!--<a href="createGeneralExpensesLink" class="view">Create</a>-->
        <h2>Vendor Payment</h2>
        <form action="multipleBillPayment" method="POST">
            <input class="view" type="submit" value="Pay">
            <br>
            <table class="display tablestyle" id="table_id">
                <thead>
                    <tr>
                        <td>&nbsp;</td>
                        <td>Sr. No.</td>
                        <td>Bill No.</td>
                        <td>Vendor</td>
                        <td>Total</td>
                        <td>Po id</td>
                        <td>Total</td>
                        <td>Received</td>
                        <td>&nbsp;</td>
                    </tr>
                </thead>
                <tbody>
                    <c:set value="1" var="count"></c:set>
                    <c:forEach var="ob" items="${billdt}">
                        <tr>
                            <td align="left">
                                <input class="selection" readonly="" disabled type="checkbox"/>                              
                                <input class="billids" type="hidden" disabled="" name="billids" value="${ob.expense_billnumber}" />
                                <input class="totals" type="hidden" disabled="" name="total" value="${ob.total}" />
                                <input class="poids" type="hidden" disabled="" name="poid" value="${ob.poid}" />
                                <input class="podids" type="hidden" disabled="" name="podid" value="${ob.podetailid}" />
                                <input class="vendorids" type="hidden" disabled="" name="vendorids" value="${ob.vendorid}" />
                            </td>
                            <td align="left">${count}</td>
                            <td align="left">${ob.expense_billnumber}</td>
                            <td align="left">${ob.vendorname}</td>
                            <td align="left">${ob.total}</td>
                            <td align="left">${ob.poid}</td>
                            <td align="left">${ob.total}</td>
                            <td align="left">${ob.isreceived}</td>
                            <td align="left">
                                <a href="makeVendorPaymentLink?podid=${ob.podetailid}&viz=${ob.total}&poids=${ob.poid}"><img src="images/payments.png" width="18" height="17" title="Payment Details" /></a>
                            </td>
                        </tr>  
                        <c:set value="${count+1}" var="count"></c:set>
                    </c:forEach>
                </tbody>
            </table>
            <div id="dialog" title="Message">
                <br/>
                <br/>
                <center><b>Multiple vendors not allowed</b></center>                    
            </div>
        </form>
    </body>
</html>
