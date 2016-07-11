<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%-- 
    Document   : ViewInvoiceOfInsurance
    Created on : 20-Mar-2015, 13:48:41
    Author     : user
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>View Invoice</title>
        <link rel="stylesheet" type="text/css" href="css/jquery.dataTables.css">        
        <script src="js/jquery.dataTables.js"></script>
        <script>
            $(document).ready(function () {
                $('#table_id').DataTable();
            });
        </script>
        <script>
            function confirmdelete(id, ob) {
                var res = confirm('Are you sure to delete?');
                if (res === true)
                {
                    $(ob).closest('tr').find('td').fadeOut(600,
                            function () {
                                $(ob).parents('tr:first').remove();
                            });

                    $.ajax({
                        type: "post",
                        url: "deleteinvoicerecord",
                        data: {id: id, deskname: "invoice", immediateup: "jobsheet", idcolumnname: "jobno"
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
        <a href="invoiceMasterLink" class="view">Back</a>&nbsp;

        <h2>Insurance Invoice</h2>

        <br />
        <table class="display tablestyle" id="table_id">
            <thead>
                <tr>
                    <td>Date</td>
                    <td>Id.</td>
                    <td>Customer</td>
                    <td>Car</td>
                    <td>Vehicle No.</td>
                    <td>Insurance</td>
                    <td>Balance</td>
                    <td>Total</td>
                    <td>&nbsp;</td>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="ob" items="${invoiceListDt}">
                    <tr>
                        <td align="left">${ob.invoicedate}</td>
                        <td align="left">${ob.invoiceid}</td>
                        <td align="left">${ob.customer_name}</td>
                        <td align="left">${ob.vehiclename}</td>
                        <td align="left">${ob.vehiclenumber}</td>
                        <td align="left">${ob.insurancecompany}</td>
                        <td align="left">${ob.balanceamount}</td>
                        <td align="left">${ob.companytotal}</td>
                        <td align="left">
                            <c:if test="${!sessionScope.USERTYPE.equals('spares')}">
                                <c:choose>
                                    <c:when test="${ob.ispaid=='No'}">
                                        <a href="makePaymentLink?invoiceid=${ob.invoiceid}&custno=${ob.customer_id}" title="Make Payment"><img src="images/Bill_with_dollar_sign_and_coins_24.png" width="22" height="19" /></a>
                                        </c:when>
                                    </c:choose>
                                <a href="viewInsuranceCompanyPaymentLink?invoiceid=${ob.invoiceid}" title="View Liability Invoice"><img src="images/auto-insurance.png" width="21" height="13" /></a>

                            </c:if>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </body>
</html>
