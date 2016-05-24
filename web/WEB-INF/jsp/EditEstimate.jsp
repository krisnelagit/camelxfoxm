<%-- 
    Document   : EditEstimate
    Created on : 04-May-2015, 12:49:15
    Author     : user
--%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Edit Estimate</title>
        <link href="css/csstable.css" rel="stylesheet" type="text/css" />
        <link rel="stylesheet" href="css/jquery-ui.css" />
        <script src="js/jquery-1.8.3.js" type="text/javascript"></script>
        <script src="js/jquery-ui.js" type="text/javascript"></script>
        <SCRIPT language="javascript">
            //add rows
            function addRow(tableID) {
                                if (tableID === "dataTable") {
                                    $('#' + tableID + '').append('<tr><td align="left" valign="top"><INPUT type="checkbox" class="test" name="chk"/><input type="hidden" name="part_type" value="part" /><input type="hidden" name="newpartlistid" id="partlistid" /></td><td align="left" valign="top"><input name="newpartname" type="text" id="partname" /></td><td align="left" valign="top"> <select name="fivePrice" class="fivePrice" style="width: 100px" onchange="iambatman(this)"><option selected="" disabled="">--select--</option></select></td><td align="left" valign="top"><textarea name="newdescription" maxlength="1000" id="textfield2"></textarea></td><td align="left" valign="top"><input name="newquantity" type="number" class="quantity" style="width: 60px" value="1" onchange="calculatebalance(this)" onclick="calculatebalance(this)" /></td><td align="left" valign="top"><input name="newpartrs" style="width: 60px" type="number" step="0.01" class="sellingprice" onchange="calculatebalance(this)" onclick="calculatebalance(this)" /></td><td align="left" valign="top"><input name="newlabourrs" style="width: 60px" type="number" step="0.01" id="textfield6" /></td><td align="left" valign="top"><input name="newtotalpartrs" readonly="" type="number" class="itemtotal" style="width: 100px"/></td><td align="left" valign="top"><a onClick="deleteRow1(this)"><img src="images/delete.png" width="16" height="17" /></a></td></tr>');
                                } else {
                            $('#' + tableID + '').append('<tr><td align="left" valign="top"><INPUT type="checkbox" name="chk"/><input type="hidden" name="labour_type" value="service" /><input type="hidden" name="newserviceid" value="" id="serviceid"/><input type="hidden" name="serviceAction" class="serviceAction"/></td><td align="left" valign="top"><input name="newservicename" type="text" id="labour" /></td><td align="left" valign="top"><textarea name="newlabourdescription" class="labourdescription" id="textfield2"></textarea></td><td align="left" valign="top"><input name="newservicetotal" type="text" class="charges" /></td><td align="left" valign="top"><a onClick="deleteRow1(this)"><img src="images/delete.png" width="16" height="17" /></a></td></tr>');
                            }
                        }

            //car parts autocomplete
            var partlist;
            $(function () {
                partlist = [
            <c:forEach var="oba" items="${partdtls}">
                    {value: "${oba.id}", label: "${oba.name}"},
            </c:forEach>
                ];
                var source = [];
                var mapping = {};
                for (var i = 0; i < partlist.length; ++i) {
                    source.push(partlist[i].label);
                    mapping[partlist[i].label] = partlist[i].value;
                }
                $("input:text[id^='partname']").live("focus.autocomplete", null, function () {
                    var curr = $(this);
                    $(this).autocomplete({
                        source: source,
                        select: function (event, ui) {
                            curr.closest('tr').find("#partlistid").val(mapping[ui.item.value]);
                        }
                    });
                });
            });

            function deleteRow1(ob) {
                $(ob).closest("tr").remove();
            }

            //car parts item name auto complete will come based on car model
            var carparts = [];
            $(function () {

                $("input:text[id^='partname']").live("focus.autocomplete", null, function () {
                    var source = [];
                    var mapping = {};
                    for (var i = 0; i < carparts.length; ++i) {
                        source.push(carparts[i].label);
                        mapping[carparts[i].label] = carparts[i].value;
                    }
                    var a = $(this);
                    $(this).autocomplete({
                        source: source,
                        select: function (event, ui) {
                            a.closest('tr').find('#partlistid').val(mapping[ui.item.value]);
//                            $("#prdid").val(mapping[ui.item.value]); // display the selected text
//                                        $("#txtAllowSearchID").val(ui.item.value); // save selected id to hidden input
                        },
                        change: function () {

                            var currentelement = $(this);
                            var val = $(this).val();
                            var exists = $.inArray(val, source);
                            if (exists < 0) {
                                return false;
                            } else {
                                currentelement.closest('tr').find('option').remove();
//                                var amount = a.closest('tr').find('#prdid').val();
                                var partid = a.closest('tr').find("#partlistid").val();
                                $.ajax({
                                    url: "getLastFivePricesEstimate",
                                    dataType: 'json',
                                    type: 'POST',
                                    data: {
                                        id: partid
                                    },
                                    success: function (data) {
                                        if (data)
                                        {
                                            currentelement.closest('tr').find('.fivePrice').append('<option value="" disabled selected>--select--</option>');
                                            for (var i = 0; i < data.length; i++)
                                            {
                                                currentelement.closest('tr').find('.fivePrice').append('<option value="' + data[i].maxprice + '">' + data[i].maxprice + '</option>');
                                            }
                                        }
                                    }, error: function () {
                                    }
                                });
                            }
                        }
                    });
                });
            });
            //ajax to get max selling price of mfg id
            function iambatman(a) {
                var amountselected = $(a).val();
                var quantity= $(a).closest('tr').find('.quantity').val();
                var partid = $(a).closest('tr').find('#partlistid').val();
                $(a).closest('tr').find('.sellingprice').val("0");
                
                $(a).closest('tr').find('.sellingprice').val(amountselected);
                        var finalpartrs=amountselected*quantity;
                        $(a).closest('tr').find('.itemtotal').val(finalpartrs);
                        
                
            }
            
            //calculate total part price
            function calculatebalance(b) {
                var qty = Number($(b).closest('tr').find('.quantity').val());
                var percost=Number($(b).closest('tr').find('.sellingprice').val());
                var totalprice=qty*percost;
                $(b).closest('tr').find('.itemtotal').val(totalprice);
            }
            //labour auto complete            
            var labour;
            $(function () {
                labour = [
            <c:forEach var="ob" items="${services}">
                    {value: "${ob.id}", label: "${ob.name}"},
            </c:forEach>
                ];
                var source = [];
                var mapping = {};
                for (var i = 0; i < labour.length; ++i) {
                    source.push(labour[i].label);
                    mapping[labour[i].label] = labour[i].value;
                }

                $("input:text[id^='labour']").live("focus.autocomplete", null, function () {
                    var curr = $(this);
                    $(this).autocomplete({
                        source: source,
                        select: function (event, ui) {
                            

                            curr.closest('tr').find("#serviceid").val(mapping[ui.item.value]); // display the selected text
                            curr.closest('tr').find('option').remove();
                                var labourid = curr.closest('tr').find("#serviceid").val();
                                var carType = $("#vehicletype").val();
                                $.ajax({
                                    url: "getservicedata",
                                    dataType: 'json',
                                    type: 'POST',
                                    data: {
                                        serviceid: labourid, carid: carType
                                    },
                                    success: function (data) {
                                        if (data)
                                        {
                                            for (var i = 0; i < data.length; i++) {
                                                curr.closest('tr').find('.labourdescription').val(data[i].description);
                                                curr.closest('tr').find('.charges').val(data[i].rate);
                                            }
                                            var servicename=curr.closest('tr').find("#labour").val(); // display the selected text 
                                            curr.closest('tr').find(".serviceAction").val(servicename);                                            
                                        }
                                    }, error: function () {
                                    }
                                }); 
                        },
                        change: function () {

                            var currentelement = $(this);
                            var val = $(this).val();
                            var exists = $.inArray(val, source);
                            if (exists < 0) {
                                
                                return false;
                            } else {
                                currentelement.closest('tr').find('option').remove();
                                var labourid = curr.closest('tr').find("#serviceid").val();
                                var carType = $("#vehicletype").val();
                                $.ajax({
                                    url: "getservicedata",
                                    dataType: 'json',
                                    type: 'POST',
                                    data: {
                                        serviceid: labourid, carid: carType
                                    },
                                    success: function (data) {
                                        if (data)
                                        {
                                            for (var i = 0; i < data.length; i++) {
                                                currentelement.closest('tr').find('.labourdescription').val(data[i].description);
                                                currentelement.closest('tr').find('.charges').val(data[i].rate);
                                            }
                                            var servicename=currentelement.closest('tr').find("#labour").val(); // display the selected text 
                                            currentelement.closest('tr').find(".serviceAction").val(servicename);                                            
                                        }
                                    }, error: function () {
                                    }
                                });
                            }
                        }
                    });
                });
            });

            $(document).ready(function () {
            
            $(".tabspecific").each(function (i) { $(this).attr('tabindex', i + 1); });

                //customer vehicle model auto complete
                var vehicleid = $("#vehicleid").val();
                $.ajax({
                    url: "getpartdata",
                    type: 'POST',
                    dataType: 'json',
                    data: {
                        id: vehicleid
                    }, success: function (data) {
                        if (data) {
                            for (var i = 0; i < data.length; i++) {
                                carparts.push({
                                    value: "" + data[i].id + "",
                                    label: "" + data[i].partname + ""
                                });
                            }
                        }
                    }, error: function (jqXHR) {
                        alert('error at services');
                    }
                });
            });
        </SCRIPT>
    </head>
    <body>
        <form action="updateEstimate" method="post">
            <input type="hidden" name="cvid" value="${estimatedtncustdt.cvid}" />
            <input type="hidden" name="branddetailids" id="vehicleid" value="${estimatedtncustdt.branddetailid}" />
            <a href="estimate.html" class="view">Back</a>
            <!--<a href="#" class="view" style="margin-right:10px;">Email</a>-->
            <h2>Estimate</h2>
            <br />
            <table width="100%" cellpadding="5">
                <tr>
                    <td align="left" valign="top">Date</td>
                    <td align="left" valign="top">${estimatedtncustdt.savedate}</td>
                </tr>
                <tr>
                    <td align="left" valign="top">Estimate No.</td>
                    <td align="left" valign="top">${estimatedtncustdt.estid} <input type="hidden" name="estimateid" value="${estimatedtncustdt.estid}" /> </td>
                </tr>
                <tr>
                    <td width="31%" align="left" valign="top">Customer name</td>
                    <td width="69%" align="left" valign="top"><label for="textfield"></label>
                        ${estimatedtncustdt.name}</td>
                </tr>
                <tr>
                    <td align="left" valign="top">Vehicle Model</td>
                    <td align="left" valign="top">${estimatedtncustdt.carmodel}<input type="hidden" name="vehicletype" id="vehicletype" value="${estimatedtncustdt.labourChargeType}" /></td>
                </tr>
                <tr>
                    <td>Vehicle Number</td>
                    <td>${estimatedtncustdt.vehiclenumber}</td>
                </tr>
                <tr>
                    <td>&nbsp;</td>
                    <td>&nbsp;</td>
                </tr>
            </table>
            <c:forEach var="obc" items="${partlistdtls}">
                <input type="hidden" name="allEstDetailIds" value="${obc.estdid}" />
            </c:forEach>

            <hr> 

            <TABLE id="dataTable" border="0" class="CSSTableGenerator">
                <TR>
                    <TD width="8%" align="left">&nbsp;</TD>
                    <td width="39%" align="left"><strong>Name</strong></td>                
                    <TD width="25%" align="center"><strong>Last 5 prices.</strong></TD>
                    <TD width="25%" align="center"><strong>Description</strong></TD>
                    <TD width="25%" align="center"><strong>Qty.</strong></TD>
                    <TD width="25%" align="center"><strong>per item</strong></TD>
                    <TD width="28%" align="center"><strong>Labour Rs.</strong></TD>
                    <TD width="25%" align="center"><strong>Parts Rs.</strong></TD>
                    <TD width="28%" align="center"><strong>Delete</strong></TD>

                </TR>
                <c:forEach var="ob" items="${partlistdtls}">
                    <tr>
                        <td align="left" valign="top"><INPUT type="checkbox" name="chk"/><input type="hidden" name="part_type" value="part" /><input type="hidden" name="estdetailids" value="${ob.estdid}" /><input type="hidden" name="partlistid" id="partlistid" value="${ob.partlistid}" /></td>
                        <td align="left" valign="top"><input name="partname" value="${ob.partname}" type="text" id="partname" /></td>
                        <td align="left" valign="top"> 
                            <select name="fivePrice" class="fivePrice" onchange="iambatman(this)">
                                <option disabled="" selected="">--select--</option>
                                <c:forEach var="obb" items="${ob.listofPrice}">
                                            <option value="${obb.maxprice}">${obb.maxprice}</option>                                        
                                </c:forEach>
                            </select> 
                        </td>
                        <td align="left" valign="top"><textarea name="description" maxlength="1000" id="textfield2">${ob.description}</textarea></td>
                        <td align="left" valign="top"><input name="quantity" type="number" step="0.01" class="quantity tabspecific" style="width: 60px" value="${ob.quantity}" onchange="calculatebalance(this)" onclick="calculatebalance(this)" /></td>
                        <td align="left" valign="top"><input name="partrs" style="width: 60px" type="number" step="0.01" value="${ob.partrs}" class="sellingprice tabspecific" onchange="calculatebalance(this)" onclick="calculatebalance(this)" /></td>
                        <td align="left" valign="top"><input name="labourrs" style="width: 60px" type="number" step="0.01" class="tabspecific" id="textfield6" value="${ob.labourrs}" /></td>
                        <td align="left" valign="top"><input name="totalpartrs" readonly="" type="number" value="${ob.totalpartrs}" class="itemtotal" style="width: 100px"/></td>
                        <td align="left" valign="top"><a onClick="deleteRow1(this)"><img src="images/delete.png" width="16" height="17" /></a></td>
                    </tr>
                </c:forEach>
            </TABLE>
            <!--<div style="float:right; margin-right:80px; margin-top:10px; font-size:16px"><strong>TOTAL: 3000/-</strong></div>-->
            <div>
                <INPUT type="button" value="Add Product" onclick="addRow('dataTable')"  class="view3"/>
            </div>  

            <br />
            <TABLE id="dataTable1" border="0" class="CSSTableGenerator">
                <TR>
                    <TD width="4%" align="left">&nbsp;</TD> 
                    <td width="24%" align="left"><strong>Service Name</strong></td>
                    <TD width="23%" align="center"><strong>Description</strong></TD>
                    <TD width="23%" align="center"><strong>Labour Rs.</strong></TD>
                    <TD width="4%" align="left">&nbsp;</TD> 
                </TR>
                <c:forEach var="ov" items="${servicelistdtls}">
                <tr>
                    <td align="left" valign="top"><INPUT type="checkbox" name="chk"/><input type="hidden" name="labour_type" value="service" /><input type="hidden" name="estdetailids" value="${ov.estdid}" /><input type="hidden" name="serviceestdetailids" value="${ov.estdid}" /><input type="hidden" name="serviceid" value="${ov.partlistid}" id="serviceid"/><input type="hidden" name="serviceAction" class="serviceAction"/></td>
                    <td align="left" valign="top"><input name="servicename" value="${ov.servicename}" type="text" id="labour" /></td>
                    <td align="left" valign="top"><textarea name="labourdescription" class="labourdescription" id="textfield2"> ${ov.description}</textarea></td>
                    <td align="left" valign="top"><input name="servicetotal" value="${ov.labourrs}" type="text" class="charges" /></td>
                    <td align="left" valign="top"><a onClick="deleteRow1(this)"><img src="images/delete.png" width="16" height="17" /></a></td>
                </tr>
                </c:forEach>
            </TABLE>
            <div>
                <INPUT type="button" value="Add Labour" onclick="addRow('dataTable1')"  class="view3"/>
                </div>  
            <br>

            <center>
                <input type="submit" value="Save" class="view3" style="cursor: pointer"/> 
            </center>

            <br />
        </form>
    </body>
</html>

