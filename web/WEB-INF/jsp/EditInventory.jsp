<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%-- 
    Document   : EditInventory
    Created on : 18 Mar, 2015, 1:17:42 PM
    Author     : pc2
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Edit Inventory</title>
        
        <script>
            function calculatetax(a) {
                console.log("i m in some");
                var splitvar = $(a).val().split(',');
                var costprice = $("#costpriceedit").val();
                console.log("i m in splitvar[1] "+splitvar[1]);
                var qty = $("#quantityedit").val();
                console.log("i m in qty[1] "+qty);
                var actualcost = Number(costprice) * Number(qty);
                var taxamount = Number(splitvar[1]) / 100 * Number(actualcost);
                console.log(taxamount);
                var total = Number(actualcost) + Number(taxamount);
                console.log(total);
                $("#edittotalcost").val(total.toFixed(2));
                $("#edittaxid").val(splitvar[0]);
                console.log("i m in end");
            }

            function calltax() {
                console.log("i m in");
                $("#alltaxes").change();
            }
        </script>
    </head>
    <body>
        <form action="updatetinventory" method="post">

            <input type="hidden" name="id" value="${invdata.id}" />
            <table width="100%" cellpadding="5">

                <tr>
                    <td align="left" valign="top">Brand</td>
                    <td align="left" valign="top"><select name="manufacturerid" id="select" required="">
                            <c:forEach var="ob" items="${manufacturer}">

                                <c:choose>
                                    <c:when test="${invdata.manufacturerid==ob.id}">
                                        <option value="${ob.id}" selected="">${ob.name}</option>
                                    </c:when>
                                    <c:otherwise>
                                        <option value="${ob.id}">${ob.name}</option>
                                    </c:otherwise>
                                </c:choose>


                            </c:forEach>
                        </select></td>
                </tr>
                <tr>
                    <td align="left" valign="top">Vendor Name</td>
                    <td align="left" valign="top"><select name="vendor" id="select2" required="">
                            <c:forEach var="ob" items="${vendor}">
                                <c:choose>
                                    <c:when test="${invdata.vendor==ob.id}">
                                        <option value="${ob.id}" selected="">${ob.name}</option>
                                    </c:when>
                                    <c:otherwise>
                                        <option value="${ob.id}">${ob.name}</option>
                                    </c:otherwise>
                                </c:choose>


                            </c:forEach>
                        </select></td>
                </tr>
                <tr>
                    <td>Quantity</td>
                    <td><label for="textfield2"></label>
                        <input type="text" name="quantity" onchange="calltax()" id="quantityedit" value="${invdata.quantity}" /></td>
                </tr>
                <tr>
                    <td>Cost Price</td>
                    <td><input type="text" name="costprice" onchange="calltax()" id="costpriceedit"  value="${invdata.costprice}"/></td>
                </tr>
                <tr>
                    <td>Selling Price</td>
                    <td><input type="text" name="sellingprice" id="textfield3" value="${invdata.sellingprice}"/></td>
                </tr>
                <tr>
                    <td>Tax</td>
                    <td>
                        <select name="tax" id="alltaxes" onchange="calculatetax(this)">
                            <c:forEach var="ob" items="${taxdt}">
                                <c:choose>
                                    <c:when test="${invdata.taxid==ob.id}">
                                        <option selected="" value="${ob.id},${ob.percent}">${ob.name} (${ob.percent}%)</option>
                                    </c:when>
                                    <c:otherwise>
                                        <option value="${ob.id},${ob.percent}">${ob.name} (${ob.percent}%)</option>
                                    </c:otherwise>
                                </c:choose>                                
                            </c:forEach>
                        </select>
                        <input type="hidden" name="taxid" id="edittaxid" value="${invdata.taxid}" />
                    </td>
                </tr>
                <tr>
                    <td>Total</td>
                    <td>
                        <input type="text" name="totalamount" value="${invdata.totalamount}" id="edittotalcost" />
                    </td>
                </tr>
                <tr>
                    <td>&nbsp;</td>
                    <td>&nbsp;</td>
                </tr>
                <tr>
                    <td>&nbsp;</td>
                    <td> <input type="submit" value="Update" class="view3" /> &nbsp;&nbsp;&nbsp;<input type="reset" value="Reset" class="view3" /></td>
                </tr>
                <tr>
                    <td>&nbsp;</td>
                    <td>&nbsp;</td>
                </tr>
            </table>
            <input type="hidden" name="partid" value="${param.partid}" />
            <input type="hidden" name="type" value="inward" />
        </form>
    </body>
</html>
