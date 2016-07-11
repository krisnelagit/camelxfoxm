<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%-- 
    Document   : ViewInsuranceCompanyPayment
    Created on : 1 Jul, 2016, 4:19:39 PM
    Author     : nityanand
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Invoice insurance</title>
        <link href="css/csstable.css" rel="stylesheet" type="text/css" />
        <script>
            $(document).ready(function () {
                $(".amount").change(function () {
                    var amount = parseFloat($(this).val() || 0);
                    var total = $(this).closest("tr").find(".totalamount").val();
                    var savevalue=amount.toFixed(2);
                    console.log(total);
                    console.log(amount);
                    if (amount < total) {
                        $(this).val(0);
                        alert("Please enter Total Rs.");
                    } else if (amount > total) {
                        $(this).val(0);
                        alert("Please enter Total Rs.");
                    }else{
                        $(this).val(savevalue);
                        console.log(savevalue);
                    }
                });
            });
        </script>
    </head>
    <body>
        <a href="onlyInsuranceinvoice" class="view">Back</a>

        <h2>Insurance Company Payment</h2>
        <br />
        <form action="insurancepayment" method="POST">
            <table width="100%" cellpadding="5">
                <tr>
                    <td width="31%" align="left" valign="top">Invoice no.</td>
                    <td width="69%" align="left" valign="top"><label for="textfield"></label>
                        <label for="select"></label>   
                        ${invoiceDt.invoiceid}
                    </td>
                </tr>
                <tr>
                    <td width="31%" align="left" valign="top">Customer mobile number</td>
                    <td width="69%" align="left" valign="top"><label for="textfield"></label>
                        <label for="select">${invoiceDt.customermobilenumber}</label>                     
                    </td>
                </tr>
                <tr>
                    <td width="31%" align="left" valign="top">Customer name</td>
                    <td width="69%" align="left" valign="top"><label for="textfield"></label>
                        <label for="select">${invoiceDt.customer_name}</label>                     
                    </td>
                </tr>
                <tr>
                    <td width="31%" align="left" valign="top">Transaction email</td>
                    <td width="69%" align="left" valign="top"><label for="textfield"></label>
                        <label for="select">${invoiceDt.transactionmail}</label>                     
                    </td>
                </tr>
                <tr>
                    <td width="31%" align="left" valign="top">Vehicle Model</td>
                    <td width="69%" align="left" valign="top"><label for="textfield"></label>
                        <label for="select">${invoiceDt.vehiclename}</label>                     
                    </td>
                </tr>
                <tr>
                    <td width="31%" align="left" valign="top">Vehicle Number</td>
                    <td width="69%" align="left" valign="top"><label for="textfield"></label>
                        <label for="select">${invoiceDt.vehiclenumber}</label>                     
                    </td>
                </tr>
                <tr>
                    <td width="31%" align="left" valign="top">Insurance Company</td>
                    <td width="69%" align="left" valign="top"><label for="textfield"></label>
                        <label for="select">${invoiceDt.insurancecompanyname}</label>                     
                    </td>
                </tr>
                <tr>
                    <td width="31%" align="left" valign="top">Insurance Type</td>
                    <td width="69%" align="left" valign="top"><label for="textfield"></label>
                        <label for="select">${invoiceDt.insurancetype}</label>                     
                    </td>
                </tr>
                <tr>
                    <td width="31%" align="left" valign="top">Claim Number</td>
                    <td width="69%" align="left" valign="top"><label for="textfield"></label>
                        <label for="select">${invoiceDt.claimnumber}</label>                     
                    </td>
                </tr>
                <c:choose>
                    <c:when test="${empty finalcomments}">

                    </c:when>
                    <c:otherwise>
                        <tr>
                            <td align="left" valign="top">Estimated delivery date</td>
                            <td align="left" valign="top">
                                <label for="textfield3">
                                    ${deliverydate}   
                                </label>
                            </td>
                        </tr>
                        <tr>
                            <td align="left" valign="top">Final comments</td>
                            <td align="left" valign="top">
                                <label for="textfield3">
                                    ${finalcomments}   
                                </label>
                            </td>
                        </tr>
                    </c:otherwise>
                </c:choose>
            </table>
            <TABLE id="dataTable" border="0" class="CSSTableGenerator">
                <TR>
                    <TD width="" align="left">&nbsp;</TD>
                    <td width="" align="center"><strong>Name</strong></td>
                    <td width="" align="center"><strong>MFG.</strong></td>
                    <TD width="" align="center"><strong>QTY.</strong></TD>
                    <TD width="" align="center"><strong>Price</strong></TD>
                    <TD width="" align="center"><strong>Insurance %</strong></TD>
                    <TD width="" align="center"><strong>Ins.Liability</strong></TD>
                    <TD width="" align="center"><strong>Total Rs.</strong></TD>
                    <TD width="" align="center"><strong>Balance Rs.</strong></TD>
                    <TD width="" align="center"><strong>Amount</strong></TD>
                </TR>
                <c:set value="1" var="count"></c:set>
                <c:forEach var="ob" items="${labourandpartdt}">
                    <tr>
                        <td align="left" valign="top">${count}</td>
                        <td align="left" valign="top">${ob.itemname}</td>
                        <td align="left" valign="top">${ob.mfgname}</td>
                        <td align="left" valign="top">${ob.quantity}</td>
                        <td align="left" valign="top">${ob.sellingprice}</td>
                        <td align="left" valign="top">${ob.insurancepercent}</td>
                        <td align="left" valign="top">${ob.insurancecompanyamount}</td>
                        <td align="left" valign="top">
                            ${ob.total}
                            <input type="hidden" name="" value="${ob.total}" class="totalamount" />
                        </td>
                        <td align="left" valign="top">${ob.balance}</td>
                        <td align="left" valign="top">
                            <input type="text" name="amount" value="${ob.paidamount}" class="amount" />                            
                            <input type="hidden" name="ispaid" value="${ob.isinsurancepaid}" />
                            <input type="hidden" name="balance" value="${ob.balance}" />
                            <input type="hidden" name="total" value="${ob.total}" />
                            <input type="hidden" name="partid" value="${ob.invoicedetailid}" />
                        </td>
                    </tr>
                    <c:set value="${count+1}" var="count"></c:set>
                </c:forEach>
            </TABLE>
            <br/>
            <TABLE id="dataTable1" border="0" class="CSSTableGenerator">
                <TR>
                    <TD width="4%" align="left">&nbsp;</TD> 
                    <td width="24%" align="left"><strong>Service Name</strong></td>
                    <TD width="23%" align="center"><strong>Description</strong></TD>
                    <TD width="4%" align="center"><strong>Insurance %</strong></TD>
                    <TD width="4%" align="center"><strong>Ins.Liability</strong></TD>
                    <TD width="4%" align="center"><strong>Total Rs.</strong></TD>
                    <TD width="4%" align="center"><strong>Balance Rs.</strong></TD>
                    <TD width="8%" align="center"><strong>Amount</strong></TD>
                </TR>
                <c:set value="1" var="count"></c:set>
                <c:forEach var="ob" items="${labourinventorydt}">
                    <tr>
                        <td align="left" valign="top">${count}</td>
                        <td align="left" valign="top">${ob.name}</td>
                        <td align="left" valign="top">${ob.description}</td>
                        <td align="left" valign="top">${ob.serviceinsurancepercent}</td>
                        <td align="left" valign="top">${ob.companyinsurance}</td>
                        <td align="left" valign="top">
                            ${ob.total}
                            <input type="hidden" name="" value="${ob.total}" class="totalamount" />
                        </td>
                        <td align="left" valign="top">${ob.balance}</td>
                        <td align="left" valign="top"> 
                            <input type="text" name="serviceamount" value="${ob.paidamount}" class="amount" />
                            <input type="hidden" name="serviceispaid" value="${ob.isinsurancepaid}" />
                            <input type="hidden" name="servicebalance" value="${ob.balance}" />
                            <input type="hidden" name="servicetotal" value="${ob.total}" />
                            <input type="hidden" name="serviceid" value="${ob.labourdetailid}" />
                        </td>
                    </tr> 
                    <c:set value="${count+1}" var="count"></c:set>               
                </c:forEach>
            </TABLE>
            <center>        
                <input type="submit" value="Save" class="view3" style="cursor: pointer"/>
            </center>
        </form>

    </body>
</html>
