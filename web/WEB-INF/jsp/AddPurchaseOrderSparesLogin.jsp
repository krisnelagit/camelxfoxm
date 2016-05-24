<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%-- 
    Document   : AddPurchaseOrderSparesLogin
    Created on : 27-Aug-2015, 15:22:02
    Author     : user
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Add Purchase Order</title>
        <link href="css/csstable.css" rel="stylesheet" type="text/css" /> 
        <script src="js/jquery-1.8.3.js" type="text/javascript"></script>
        <link href="css/jquery-ui_1.css" rel="stylesheet" type="text/css" />
        <script src="js/jquery-ui.js"></script>
        <link href='css/jquery.qtip.css' rel='stylesheet' />
        <script src='js/jquery.qtip.min.js'></script>
        <script>
            //ajax to get max selling price of mfg id
            function iambatman(a) {
                var mfgname = $(a).val();
                var partid = $(a).closest('tr').find('#prdid').val();
                $.ajax({
                    type: 'post',
                    url: 'pricelist',
                    data: {
                        mfgid: mfgname, partid: partid
                    },
                    success: function (data) {
                        if (data != "no") {
                            $(a).closest('tr').find('.costprice').val(data);
                            var sp = Number(data) * 30 / 100;
                            var finalsp = Number(sp) + Number(data);
                            $(a).closest('tr').find('.sellingprice').val(finalsp);
                        }
                    },
                    error: function () {
                    }
                });
            }

            //ajax to get previous selling price of mfg id for partid
            function previousrates(a) {
                var curr = $(this);
                var mfgname = $(a).val();

                var partid = $(a).closest('tr').find('#prdid').val();
                var vendorid = $('#selectedvendor').val();
                $.ajax({
                    url: 'pricelistvendorwisehistory',
                    dataType: 'json',
                    type: 'post',
                    data: {
                        mfgid: mfgname, partid: partid, vendorid: vendorid
                    },
                    success: function (data) {
                        if (data) {
                            var t = "<table><tr><th>Selling</th><th>QTY.</th><th>Date</th></tr>";
                            for (var i = 0; i < data.length; i++) {
                                t = t + "<tr><td>" + data[i].sellingprice + "</td><td>" + data[i].quantity + "</td><td>" + data[i].modifydate + "</td></tr>";
                            }
                            t = t + "</table>";


                            $(a).closest('tr').find('.history').qtip({
                                content: {
                                    text: t,
                                    title: function (event, api) {
                                        return $(this).attr('alt');
                                    }
                                }
                            });

                        }
                    },
                    error: function () {
                        alert("error..!");
                    }
                });
            }

            //ajax to get previous selling price of mfg id for partid
            function previouspartsrates(a) {
                var curr = $(this);
                var mfgname = $(a).val();

                var partid = $(a).closest('tr').find('#prdid').val();
                $.ajax({
                    url: 'pricelistpartwisehistory',
                    dataType: 'json',
                    type: 'post',
                    data: {
                        mfgid: mfgname, partid: partid
                    },
                    success: function (data) {
                        if (data) {
                            var t = "<table><tr><th>Selling</th><th>QTY.</th><th>Date</th></tr>";
                            for (var i = 0; i < data.length; i++) {
                                t = t + "<tr><td>" + data[i].sellingprice + "</td><td>" + data[i].quantity + "</td><td>" + data[i].modifydate + "</td></tr>";
                            }
                            t = t + "</table>";


                            $(a).closest('tr').find('.Parthistory').qtip({
                                content: {
                                    text: t,
                                    title: function (event, api) {
                                        return $(this).attr('alt');
                                    }
                                }
                            });

                        }
                    },
                    error: function () {
                        alert("error..!");
                    }
                });
            }

            //calculate total part price on quantity change
            function calculatebalance(b) {
                var tmp;
                var quantitycount = 0;
                var quantity = $(b).val();
                var amount = $(b).closest('tr').find('.costprice').val();
                tmp = quantity * amount;
                $(b).closest('tr').find('.itemtotal').val(tmp);

                var table = document.getElementById("dataTable");
                var rowCount = table.rows.length;
                //calculates final total of spareparts and inside is calulation of vat tax
                for (var i = 1; i < rowCount; i++) {
                    var row = table.rows[i];
                    var qty = row.cells[7].childNodes[0];
                    quantitycount = Number(quantitycount) + Number(qty.value);
                    $("#sparepartsfinal").val(quantitycount);

                    //calculates vat percentage
                    var taxpercent = $("#taxes").val();
                    var myvat = Number(quantitycount) * Number(taxpercent / 100);
                    $("#taxamount").val(myvat.toFixed(2));
                }
                quantitycount = 0;
            }

            //calculate total part price on quantity change
            function calculatebalanceonCostPrice(b) {
                var tmp;
                var quantitycount = 0;
                var amount = $(b).val();
                var quantity = $(b).closest('tr').find('.quantity').val();
                tmp = quantity * amount;
                $(b).closest('tr').find('.itemtotal').val(tmp);

                var table = document.getElementById("dataTable");
                var rowCount = table.rows.length;
                //calculates final total of spareparts and inside is calulation of vat tax
                for (var i = 1; i < rowCount; i++) {
                    var row = table.rows[i];
                    var qty = row.cells[7].childNodes[0];
                    quantitycount = Number(quantitycount) + Number(qty.value);
                    $("#sparepartsfinal").val(quantitycount);

                    //calculates vat percentage
                    var taxpercent = $("#taxes").val();
                    var myvat = Number(quantitycount) * Number(taxpercent / 100);
                    $("#taxamount").val(myvat.toFixed(2));
                }
                quantitycount = 0;
                var cp = $(b).closest('tr').find('.costprice').val();
                var sp = Number(cp) * 30 / 100;
                var finalsp = Number(sp) + Number(cp);
                $(b).closest('tr').find('.sellingprice').val(finalsp.toFixed(2));
            }
            
            //delete rows
            function deleteRow(tableID) {
                try {
                    var table = document.getElementById(tableID);
                    var rowCount = table.rows.length;
                    for (var i = 0; i < rowCount; i++) {
                        var row = table.rows[i];
                        var chkbox = row.cells[0].childNodes[0];
                        if (null != chkbox && true == chkbox.checked) {
                            if (rowCount <= 1) {
                                alert("Cannot delete all the rows.");
                                break;
                            }
                            table.deleteRow(i);
                            rowCount--;
                            i--;
                        }
                    }

                } catch (e) {
                    alert(e);
                }
            }
        </script>
    </head>
    <body>
        <h2>Purchase Order create</h2>
        <br />
        <form action="savepurchaseorder" method="POST">
            <TABLE id="dataTable" border="0" class="CSSTableGenerator">
                <TR>
                    <TD width="" align="left">&nbsp;</TD>
                    <td width="" align="center"><strong>Vehicle Model</strong></td>
                    <td width="" align="center"><strong>Car part name</strong></td>
                    <td width="" align="center"><strong>Vendor name</strong></td>
                    <td width="" align="center"><strong>MFG.</strong></td>
                    <TD width="" align="center"><strong>Cost Price</strong></TD>
                    <TD width="" align="center"><strong>Selling Price</strong></TD>
                    <TD width="" align="center"><strong>QTY.</strong></TD>
                    <TD width="" align="center"><strong>Amount</strong></TD>
                </TR>
                <c:forEach var="ob" items="${podto}">
                    <tr>
                        <td align="left" valign="top"><INPUT type="checkbox" name="chk"/><input type="hidden" name="partid" value="${ob.partid}" id="prdid"/><input type="hidden" name="jobdetailid" value="${ob.jobdetailid}" id="jobdetailid"/></td>
                        <td align="left" valign="top">${ob.vehiclename}<input type="hidden" name="branddetailid" value="${ob.vehicleid}" class="vehicleid" /></td>
                        <td align="left" valign="top">${ob.partname}<input type="hidden" name="branchid" value="${ob.branchid}" /></td>
                        <td align="left" valign="top">
                            <select name="vendorid" id="selectedvendor">
                                <option value="" disabled selected="">--select--</option>
                                <c:forEach var="obb" items="${ob.vendordetails}">            
                                    <option value="${obb.id}">${obb.name}</option>
                                </c:forEach>
                            </select>
                        </td>
                        <td align="left" valign="top">
                            <select name="manufacturerid" class="manufacturer" onchange="iambatman(this);
                                previousrates(this);
                                previouspartsrates(this);">
                                <option value="" disabled selected="">--select--</option>
                                <c:forEach var="obc" items="${ob.manufacturerdetails}">            
                                    <option value="${obc.id}">${obc.name}</option>
                                </c:forEach>
                            </select>
                        </td>
                        <td align="left" valign="top"><input name="costprice" type="text" class="costprice" onchange="calculatebalanceonCostPrice(this)" onclick="calculatebalanceonCostPrice(this)" style="width: 65px"/>&nbsp;&nbsp;<a href="#" alt="*Vendorwise Price history" class="history"><img src="images/helmet6.png" width="18" height="13" /></a>&nbsp;&nbsp;<a href="#" alt="*Partwise Price history" class="Parthistory"><img src="images/gear39.png" width="16" height="13" /></a></td>
                        <td align="left" valign="top"><input name="sellingprice" type="text" class="sellingprice" style="width: 65px"/></td>
                        <td align="left" valign="top"><input name="partQuantity" type="number" max="999999" class="quantity" style="width: 45px" onchange="calculatebalance(this)" onclick="calculatebalance(this)" /></td>
                        <td align="left" valign="top"><input name="itemtotal" readonly="" type="number" value="0" class="itemtotal" style="width: 100px"/></td>
                    </tr>
                </c:forEach>            
            </TABLE>
            <div>
                <INPUT type="button" value="Delete Selected" onclick="deleteRow('dataTable');
                        calculatebalance(this)"  class="view3"/>
            </div>
            <center>
                <input type="submit" value="Save" class="view3" style="cursor: pointer" /> <a href="lowQuantityPartPageLink" style="padding-top: 8px;padding-bottom: 7px" class="view2">Cancel</a>
            </center> 

        </form>
    </body>
</html>
