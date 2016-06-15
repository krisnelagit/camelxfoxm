<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%-- 
    Document   : CustomerViewEstimate
    Created on : 01-May-2015, 12:19:26
    Author     : user
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Customer View Estimate</title>
        <link href="css/other_style.css" rel="stylesheet" type="text/css" />
        <link href="css/csstable.css" rel="stylesheet" type="text/css" />
        <script>
            $(document).ready(function () {

                $('.selectall').click(function () {
                    if ($(this).is(':checked')) {
                        $(".selectthis").prop("checked", true);
                    } else {
                        $(".selectthis").prop("checked", false);
                    }
                });



                var sum = 0;
                $('.price').each(function () {
                    sum += parseFloat($(this).text());
                });
                var sum1 = 0;
                $('.labourcharges').each(function () {
                    sum1 += parseFloat($(this).text());
                });
                $('#labourrs').html(sum1)
                $('#partsrs').html(sum)
                var grand = sum + sum1;

                $('#grandamount').text(grand);

                //code for service total details begin here
                var sum2 = 0;
                $('.labourchargesservice').each(function () {
                    sum2 += parseFloat($(this).text());
                });
                $('#servicelabourrs').html(sum2)

                $('#grandserviceamount').text(sum2);
                //code for service total details ends here

                //code for grand total begin here   
                var grandtotalend = Number(grand) + Number(sum2);
                $('#grandpartserviceamount').text(grandtotalend);
                //code for grand total ends! here

                //on form submit
                $("#questionaire").submit(function () {
                    var checkedAtLeastOne = false;
                    $('input[type="checkbox"]').each(function () {
                        if ($(this).is(":checked")) {
                            checkedAtLeastOne = true;
                        }
                    });

                    if (checkedAtLeastOne == false) {
                        alert("Atleast one item should be checked");
                        return checkedAtLeastOne;
                    }
                });
            });
        </script>
    </head>
    <body>
        <a href="estimate.html" class="view">Back</a>
        <h2>Estimate</h2>
        <br />
        <form action="addapproved" id="questionaire" method="POST">
            <input type="hidden" name="estimateid" value="${estcustdtls.estimateid}" />
            <input type="hidden" name="cvid" value="${estcustdtls.cvid}" />
            <table width="100%" cellpadding="5">
                <tr>
                    <td align="left" valign="top">Date</td>
                    <td align="left" valign="top">${estcustdtls.pcldate}</td>
                </tr>
                <tr>
                    <td align="left" valign="top">180 Point id</td>
                    <td align="left" valign="top">${estcustdtls.pclid} <input type="hidden" name="pclid" value="${estcustdtls.pclid}" /> </td>
                </tr>
                <tr>
                    <td width="31%" align="left" valign="top">Customer name</td>
                    <td width="69%" align="left" valign="top"><label for="textfield"></label>
                        ${estcustdtls.customername}</td>
                </tr>
                <tr>
                    <td align="left" valign="top">Vehicle Model</td>
                    <td align="left" valign="top">${estcustdtls.carmodel}</td>
                </tr>
                <tr>
                    <td>Vehicle Number</td>
                    <td>${estcustdtls.vehiclenumber}</td>
                </tr>
                <tr>
                    <td>Service-checklist comments</td>
                    <td>${estcustdtls.additionalwork}</td>
                </tr>
                <tr>
                    <td>180point comments</td>
                    <td>${estcustdtls.pclcomments}</td>
                </tr>
                <tr>
                    <td>Comments</td>
                    <td>${estcustdtls.estcomments}</td>
                </tr>
<!--                <tr>
                    <td>Select all</td>
                    <td><input type="checkbox" name="sample" class="selectall"/></td>
                </tr>-->
                <tr>
                    <td>&nbsp;</td>
                    <td>&nbsp;</td>
                </tr>
            </table>
            <hr>
            <div id="checkboxlist">
                <!--table for car part estimate view begin here-->
                <table id="dataTable" class="CSSTableGenerator" border="0">
                    <tr>
                        <td align="left" width="5%"><strong>Sr.No.</strong></td>
                        <td align="left" width="21%"><strong>Name</strong></td>
                        <td align="left" width="37%"><strong>Description</strong></td>
                        <td align="left" width="5%"><strong>Qty.</strong></td>
                        <td align="center" width="14%"><strong>Per item</strong></td>
                        <td align="center" width="10%"><strong>Part Rs.</strong></td>
                        <!--<td align="center" width="5%"><strong>&nbsp;</strong></td>-->
                    </tr>
                    <c:set value="1" var="count"></c:set>
                    <c:forEach var="ob" items="${estpartdtls}">
                        <tr>
                            <td align="center" valign="middle">${count}</td>
                            <td align="left" valign="top" ><span class="category-spacing">${ob.partname}</span></td>
                            <td align="left" valign="top">${ob.description}</td>
                            <td align="center" valign="middle" class="quantity">${ob.quantity}</td>
                            <td align="center" valign="middle" class="peritem">${ob.partrs}</td>
                            <!--<td align="center" valign="middle" class="labourcharges">$ {ob.labourrs}</td>-->
                            <td align="center" valign="middle" class="price">${ob.totalpartrs}</td>
                            <!--<td align="center" valign="middle"><input type="checkbox" class="selectthis" name="estimatedetails" value="${ob.edid}"></td>-->
                        </tr>
                        <c:set value="${count+1}" var="count"></c:set>
                    </c:forEach>
                    <tr>
                        <td align="center" valign="middle">&nbsp;</td>
                        <td align="left" valign="top">&nbsp;</td>
                        <td align="left" valign="top">&nbsp;</td>
                        <td align="left" valign="top">&nbsp;</td>
                        <!--<td align="left" valign="top">&nbsp;</td>-->
                        <td align="center" valign="middle"><strong>Total Parts</strong></td>
                        <td align="center" valign="middle"><strong><label>Rs.${parttotal}</label></strong></td>
                        <!--<td align="left" valign="top">&nbsp;</td>-->
                    </tr>
                    <tr>
                        <td align="center" valign="middle">&nbsp;</td>
                        <td align="left" valign="top">&nbsp;</td>
                        <td align="left" valign="top">&nbsp;</td>
                        <td align="left" valign="top">&nbsp;</td>
                        <!--<td align="left" valign="top">&nbsp;</td>-->
                        <td align="center" valign="middle"><strong>VAT ${taxDetails[0].percent}%</strong></td>
                        <td align="center" valign="middle"><strong><label>Rs.${vat}</label></strong></td>
                        <!--<td align="left" valign="top">&nbsp;</td>-->
                    </tr>
                    <tr>
                        <td align="center" valign="middle">&nbsp;</td>
                        <td align="left" valign="top">&nbsp;</td>
                        <td align="left" valign="top">&nbsp;</td>
                        <td align="left" valign="top">&nbsp;</td>
                        <!--<td align="left" valign="top">&nbsp;</td>-->
                        <td align="center" valign="middle"><strong>Total Parts with Tax</strong></td>
                        <td align="center" valign="middle"><strong><label>Rs.${partsum}</label></strong></td>
                        <!--<td align="left" valign="top">&nbsp;</td>-->
                    </tr>
                    <c:if test="${servicetax=='0.0'}">
                        <tr>
                            <td align="center" valign="middle">&nbsp;</td>
                            <td align="left" valign="top">&nbsp;</td>
                            <td align="left" valign="top">&nbsp;</td>
                            <td align="left" valign="top">&nbsp;</td>
                            <!--<td align="left" valign="top">&nbsp;</td>-->
                            <td align="center" valign="middle"><strong>GRAND TOTAL</strong></td>
                            <td align="center" valign="middle"><strong><label>Rs.${grandtotal}</label></strong></td>
                            <!--<td align="left" valign="top">&nbsp;</td>-->
                        </tr>
                    </c:if>
                </table>
                <!--table for car part estimate view ends here-->
                <br>
                <br>
                <c:if test="${servicetax ne '0.0'}">
                    <table id="dataTable" class="CSSTableGenerator" border="0">
                        <tr>
                            <td align="left" width="5%"><strong>Sr.No.</strong></td>
                            <td align="left" width="21%"><strong>Service Name</strong></td>
                            <td align="left" width="37%"><strong>Description</strong></td>
                            <td align="center" width="5%"><strong>&nbsp;</strong></td>
                            <td align="center" width="14%"><strong>&nbsp;</strong></td>
                            <td align="center" width="10%"><strong>Labour Rs.</strong></td>
                            <!--<td align="center" width="5%"><strong>&nbsp;</strong></td>-->
                        </tr>
                        <c:set value="1" var="count"></c:set>
                        <c:forEach var="ob" items="${estservicedtls}">
                            <tr>
                                <td align="center" valign="middle">${count}</td>
                                <td align="left" valign="top" ><span class="category-spacing">${ob.servicename}</span></td>
                                <td align="left" valign="top">${ob.description}</td>
                                <td align="left" valign="top">&nbsp;</td>
                                <td align="left" valign="top">&nbsp;</td>
                                <td align="center" valign="middle" class="labourchargesservice">${ob.labourrs}</td>
                                <!--<td align="center" valign="middle"><input type="checkbox" class="selectthis" name="estimatedetails" value="${ob.estdid}"></td>-->
                            </tr>
                            <c:set value="${count+1}" var="count"></c:set>
                        </c:forEach>
                        <tr>
                            <td align="center" valign="middle">&nbsp;</td>
                            <td align="left" valign="top" >&nbsp;</td>
                            <td align="left" valign="top">&nbsp;</td>
                            <td align="left" valign="top">&nbsp;</td>
                            <td align="left" valign="top"><strong>Total Labor</strong></td>
                            <td align="center" valign="middle"><strong><label>Rs.${laborTotal}</label></strong></td>
                            <!--<td align="center" valign="middle">&nbsp;</td>-->
                        </tr>
                        <tr>
                            <td align="center" valign="middle">&nbsp;</td>
                            <td align="left" valign="top" >&nbsp;</td>
                            <td align="left" valign="top">&nbsp;</td>
                            <td align="left" valign="top">&nbsp;</td>
                            <td align="left" valign="top"><strong>Service Tax ${taxDetails[1].percent}%</strong></td>
                            <td align="center" valign="middle"><strong><label>Rs.${servicetax}</label></strong></td>
                            <!--<td align="center" valign="middle">&nbsp;</td>-->
                        </tr>
                        <tr>
                            <td align="center" valign="middle">&nbsp;</td>
                            <td align="left" valign="top" >&nbsp;</td>
                            <td align="left" valign="top">&nbsp;</td>
                            <td align="left" valign="top">&nbsp;</td>
                            <td align="left" valign="top"><strong>Total Labor with Tax</strong></td>
                            <td align="center" valign="middle"><strong><label>Rs.${laborsum}</label></strong></td>
                            <!--<td align="center" valign="middle">&nbsp;</td>-->
                        </tr>
                        <tr>
                            <td align="center" valign="middle">&nbsp;</td>
                            <td align="left" valign="top" >&nbsp;</td>
                            <td align="left" valign="top">&nbsp;</td>
                            <td align="left" valign="top">&nbsp;</td>
                            <td align="left" valign="top"><strong>GRAND TOTAL</strong></td>
                            <td align="center" valign="middle"><strong><label>Rs.${grandtotal}</label></strong></td>
                            <!--<td align="center" valign="middle">&nbsp;</td>-->
                        </tr>
                    </table>
                </c:if>
            </div>
            <!--<br>-->
<!--            <center>
                <input value="Approve" class="view3" style="cursor: pointer" type="submit">
            </center>-->

        </form>
    </body>
</html>
