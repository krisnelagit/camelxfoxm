<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%-- 
    Document   : AddPurchaseOrder
    Created on : 26-May-2015, 15:18:15
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

            $(document).ready(function () {
                var sourcek = [];
                var mappingk = {};
                $(function () {
                    var currentDate = new Date();
                    $(".datepicker").datepicker({dateFormat: 'yy-mm-dd'});
                    $(".datepicker").datepicker("option", "showAnim", 'drop');
                    $(".datepicker").datepicker("setDate", currentDate);
                });

                //car parts item name auto complete will come based on model
//                var carparts = [];
                $(function () {

                    $("input:text[id^='carparts']").live("focus.autocomplete", null, function () {


                        var a = $(this);
                        $(this).autocomplete({
                            source: sourcek,
                            select: function (event, ui) {
                                a.closest('tr').find('#prdid').val(mappingk[ui.item.value]);

                                //for tab key to work edited from here
                                var TABKEY = 9;
                                this.value = ui.item.value;

                                if (event.keyCode == TABKEY) {
                                    event.preventDefault();
                                    this.value = this.value + " ";
                                    $('#carparts').focus();
                                }

                                return false;
//                            $("#prdid").val(mapping[ui.item.value]); // display the selected text
//                                        $("#txtAllowSearchID").val(ui.item.value); // save selected id to hidden input
                            },
                            change: function () {

                                var currentelement = $(this);
                                var val = $(this).val();
                                var exists = $.inArray(val, sourcek);
                                if (exists < 0) {
                                    $(this).val("");
                                    return false;
                                } else {
                                    currentelement.closest('tr').find('.manufacturer').val('');
                                    currentelement.closest('tr').find('.mfgnames').val('');
                                }
                            }
                        }).focus(function () {
                            $(this).autocomplete('search');
                        });
                    });
                });

                //customer vehicle model auto complete
                var vehicle;
                $(function () {
                    vehicle = [
            <c:forEach items="${vehicles}" var="ob">
                        {value: "${ob.id}", label: "${ob.vehiclename}"},
            </c:forEach>
                    ];
                    var source = [];
                    var mapping = {};

                    for (var i = 0; i < vehicle.length; ++i) {
                        source.push(vehicle[i].label);
                        mapping[vehicle[i].label] = vehicle[i].value;
                    }

                    $("input:text[class^='vehicle']").live("focus.autocomplete", null, function () {
                        var curr = $(this);
                        $(this).autocomplete({
                            source: source,
                            select: function (event, ui) {

                                curr.closest('tr').find('.vehicleid').val(mapping[ui.item.value]);



                            },
                            change: function () {

//                            var currentelement = $(this);
                                var val = $(this).val();
                                var exists = $.inArray(val, source);
                                if (exists < 0) {
                                    $(this).val("");
                                    return false;
                                } else {
                                    var vehicleid = curr.closest('tr').find('.vehicleid').val();
                                    $.ajax({
                                        url: "getpurchaseorderpartdata",
                                        type: 'POST',
                                        dataType: 'json',
                                        data: {
                                            id: vehicleid
                                        }, success: function (data) {
                                            if (data) {

                                                sourcek.length = 0;
                                                mappingk.length = 0;
                                                curr.closest('tr').find('#carparts').val("");
                                                curr.closest('tr').find('#costprice').val("");
                                                curr.closest('tr').find('.sellingprice').val("");
                                                curr.closest('tr').find('.quantity').val("");
                                                curr.closest('tr').find('.itemtotal').val("");

                                                for (var i = 0; i < data.length; ++i) {
                                                    sourcek.push(data[i].partname);
                                                    mappingk[data[i].partname] = data[i].id;
                                                }


                                                vehicle.length = 0;
                                            }
                                        }, error: function (jqXHR) {
                                            alert('error at services');
                                        }
                                    });
                                }

                            }
                        }).focus(function () {
//                            $('#carparts').autocomplete('search');
                        });
                    });
                });

                //manufactuer coding beign here
                var manufactuer;
                $(function () {
                    manufactuer = [
            <c:forEach var="ob" items="${manufacturerdtls}">
                        {value: "${ob.id}", label: "${ob.name}"},
            </c:forEach>
                    ];

                    var source = [];
                    var mapping = {};

                    for (var i = 0; i < manufactuer.length; ++i) {
                        source.push(manufactuer[i].label);
                        mapping[manufactuer[i].label] = manufactuer[i].value;
                    }

                    $("input:text[class^='mfgnames']").live("focus.autocomplete", null, function () {
                        var curr = $(this);
                        $(this).autocomplete({
                            source: source,
                            select: function (event, ui) {

                                curr.closest('tr').find('.manufacturer').val(mapping[ui.item.value]);
                                $('.manufacturer').trigger("change");

                            }
                        });
                    });

                });
                //manufacturer coding end here


                //calling vendo dt to get vandor payment terms
                $("#selectedvendor").change(function () {
                    var vendorid = $(this).val();
                    $.ajax({
                        url: "getVendorDetailsurl",
                        dataType: 'json',
                        type: 'POST',
                        data: {
                            vendorid: vendorid
                        },
                        success: function (data) {
                            if (data) {
                                $("#paymentterms").val(data[0].paymentterms);
                            }
                        }, error: function () {
                        }
                    });
                });
                //end of calling payment terms
                
                //change from tax option trigger change
//                $("#alltaxes").change();

            });
        </script>
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
                        if (data !== "no") {
                            console.log("Nitz: "+data);
                            $(a).closest('.mfgnames').find('#costprice').val(data);
                            var sp = Number(data) * 30 / 100;
                            console.log("Nitz:sp "+sp);
                            var finalsp = Number(sp) + Number(data);
                            console.log("finalsp "+finalsp);
                            $(a).closest('.mfgnames').find('.sellingprice').val(finalsp);
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
                var amount = $(b).closest('tr').find('#costprice').val();
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
                var cp = $(b).closest('tr').find('#costprice').val();
                var sp = Number(cp) * 30 / 100;
                var finalsp = Number(sp) + Number(cp);
                $(b).closest('tr').find('.sellingprice').val(finalsp.toFixed(2));
            }

            function addRow(tableID) {
                $('#' + tableID + '').append('<tr><td align="left" valign="top"><INPUT type="checkbox" name="chk"/><input type="hidden" name="partid" value="" id="prdid"/></td><td align="left" valign="top"><input name="vehiclemodel" type="text" class="vehicle" /><input type="hidden" name="branddetailid" class="vehicleid" /></td><td align="left" valign="top"><input name="carparts" type="text" id="carparts" /></td><td align="left" valign="top"><input type="hidden" name="manufacturerid" class="manufacturer" value="" onchange="iambatman(this);previousrates(this);previouspartsrates(this);" /><input type="text" name="mfgname" class="mfgnames" /></td><td align="left" valign="top"><input name="costprice" type="text" id="costprice" onchange="calculatebalanceonCostPrice(this)" onclick="calculatebalanceonCostPrice(this)" style="width: 65px"/>&nbsp;&nbsp;<a href="#" alt="*Vendorwise Price history" class="history"><img src="images/helmet6.png" width="18" height="13" /></a>&nbsp;&nbsp;<a href="#" alt="*Partwise Price history" class="Parthistory"><img src="images/gear39.png" width="16" height="13" /></a></td><td align="left" valign="top"><input name="sellingprice" type="text" class="sellingprice" style="width: 65px"/></td><td align="left" valign="top"><input name="partQuantity"  type="number" max="999999" class="quantity" style="width: 45px" onchange="calculatebalance(this)" onclick="calculatebalance(this)" /></td><td align="left" valign="top"><input name="itemtotal" readonly="" type="number" value="0" class="itemtotal" style="width: 100px"/></td></tr>');
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

            //give grand total
            function getGrandTotal() {
                var mytotal = Number($('#taxamount').val()) + Number($('#sparepartsfinal').val());
                $('#finaltotal').val(mytotal.toFixed(2));
            }

            //gives tax calulation on change of tax
            function taxchange() {
                //calculates vat percentage
                var taxpercent = $("#taxes").val();
                var quantitycount = $("#sparepartsfinal").val();
                var myvat = Number(quantitycount) * Number(taxpercent / 100);
                $("#taxamount").val(myvat.toFixed(2));
            }
            
            //code for new tax function begin here
            function taxfunction(a){
                var splitvar = $(a).val().split(','); 
                $("#taxes").val(splitvar[1]);
                $("#taxid").val(splitvar[0]);
                $(".quantity").change();
            }
            //code for new tax function ends! here


        </script>
    </head>
    <body>
        <a href="PurchaseOrderGridLink" class="view">Back</a>
        <h2>Purchase Order Create</h2>
        <br />
        <form action="addPurchaseOrder" method="POST">        
            <table width="100%" cellpadding="5">
                <tr>
                    <td width="34%" align="left" valign="top">Branch</td>
                    <td width="66%" align="left" valign="top">
                        <select name="branchid" required="" id="branchid">
                            <option value="">--select--</option>
                            <c:forEach var="obb" items="${branchdtls}">            
                                <option value="${obb.id}">${obb.name}</option>
                            </c:forEach>
                        </select>
                    </td>
                </tr>
                <tr>
                    <td width="34%" align="left" valign="top">Date</td>
                    <td width="66%" align="left" valign="top"><input required class="datepicker" type="text" name="date" id="textfield2" /></td>
                </tr>
                <tr>
                    <td width="34%" align="left" valign="top">Vendor name</td>
                    <td width="66%" align="left" valign="top">
                        <select name="vendorid" id="selectedvendor" required="">
                            <option value="">--select--</option>
                            <c:forEach var="obb" items="${vendordt}">            
                                <option value="${obb.id}">${obb.name}</option>
                            </c:forEach>
                        </select>
                    </td>
                </tr>
                <tr>    
                    <td>&nbsp;</td>
                    <td>&nbsp;</td>
                </tr>
            </table>
            <TABLE id="dataTable" border="0" class="CSSTableGenerator">
                <TR>
                    <TD width="" align="left">&nbsp;</TD>
                    <td width="" align="center"><strong>Vehicle Model</strong></td>
                    <td width="" align="center"><strong>Car part name</strong></td>
                    <td width="" align="center"><strong>MFG.</strong></td>
                    <TD width="" align="center"><strong>Cost Price</strong></TD>
                    <TD width="" align="center"><strong>Selling Price</strong></TD>
                    <TD width="" align="center"><strong>QTY.</strong></TD>
                    <TD width="" align="center"><strong>Amount</strong></TD>
                </TR>
                <tr>
                    <td align="left" valign="top"><INPUT type="checkbox" name="chk"/><input type="hidden" name="partid" value="" id="prdid"/></td>
                    <td align="left" valign="top"><input name="vehiclemodel" type="text" class="vehicle" /><input type="hidden" name="branddetailid" class="vehicleid" /></td>
                    <td align="left" valign="top"><input name="carparts" type="text" id="carparts" /></td>
                    <td align="left" valign="top">
                        <input type="hidden" name="manufacturerid" class="manufacturer" value="" onchange="iambatman(this);
                                previousrates(this);
                                previouspartsrates(this);" />
                        <input type="text" name="mfgname" class="mfgnames" />
                    </td>
                    <td align="left" valign="top"><input name="costprice" type="text" id="costprice" onchange="calculatebalanceonCostPrice(this)" onclick="calculatebalanceonCostPrice(this)" style="width: 65px"/>&nbsp;&nbsp;<a href="#" alt="*Vendorwise Price history" class="history"><img src="images/helmet6.png" width="18" height="13" /></a>&nbsp;&nbsp;<a href="#" alt="*Partwise Price history" class="Parthistory"><img src="images/gear39.png" width="16" height="13" /></a></td>
                    <td align="left" valign="top"><input name="sellingprice" type="text" class="sellingprice" style="width: 65px"/></td>
                    <td align="left" valign="top"><input name="partQuantity" type="number" max="999999" class="quantity" style="width: 45px" onchange="calculatebalance(this)" onclick="calculatebalance(this)" /></td>
                    <td align="left" valign="top"><input name="itemtotal" readonly="" type="number" value="0" class="itemtotal" style="width: 100px"/></td>
                </tr>
            </TABLE>
            Spare parts Total :    <input name="sparepartsfinal" readonly="" value="0" type="text" id="sparepartsfinal" />
            <div>
                <INPUT type="button" value="Add Product" onclick="addRow('dataTable')"  class="view3"/>
                <INPUT type="button" value="Delete Selected" onclick="deleteRow('dataTable');
                        calculatebalance(this)"  class="view3"/>
            </div>  
            <br>
            <table width="100%" cellpadding="5">
                <tr>
                    <td width="34%" align="left" valign="top">Tax type</td>
                    <td width="66%" align="left" valign="top">
                        <select name="" id="alltaxes" onchange="taxfunction(this);">
                            <c:forEach var="ob" items="${taxdt}">
                                <option value="${ob.id},${ob.percent}">${ob.name}</option>
                            </c:forEach>
                        </select>
                        <input type="hidden" name="tax" id="taxes" value="${taxdt[0].percent}" />
                        <input type="hidden" name="taxid" id="taxid" value="${taxdt[0].id}" />
                    </td>
                </tr>
                <tr>    
                    <td>Tax amount</td>
                    <td>
                        <input  type="number" step="0.01" min="0" readonly="" id="taxamount" name="taxamount" value="" />
                        <input type="hidden" name="finaltotal" value="0" id="finaltotal" />
                        <input type="hidden" id="paymentterms" name="paymentterms" />
                    </td>
                </tr>
                <tr>    
                    <td>Comment</td>
                    <td>
                        <textarea name="comment" rows="4" maxlength="1000" cols="20">
                        </textarea>
                    </td>
                </tr>
                <tr>    
                    <td>&nbsp;</td>
                    <td><input type="submit" value="Save" class="view3" style="cursor: pointer" onclick="getGrandTotal()" /></td>
                </tr>
            </table>
        </form>
    </body>
</html>


