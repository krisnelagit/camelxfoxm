<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%-- 
    Document   : CustomerSearch
    Created on : 30-Jul-2015, 11:37:29
    Author     : user
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Customer Search</title> 
        <link href="css/jquery-ui search mod.css" rel="stylesheet" type="text/css" />
        <script src="js/jquery-ui.js"></script>        
        <script>
            $(document).ready(function () {
                $('#vehicle').hide();
                $('#customername').hide();
                $('#mobile').show();
                $('#searchoption').val('mobile');
            });

            function searchElement(b) {
                if ($(b).val() === "mobile") {
                    $('#vehicle').hide();
                    $('#customername').hide();
                    $('#mobile').show();
                }
                if ($(b).val() === "vehicle") {
                    $('#vehicle').show();
                    $('#customername').hide();
                    $('#mobile').hide();
                }
                if ($(b).val() === "customer") {
                    $('#vehicle').hide();
                    $('#mobile').hide();
                    $('#customername').show();
                }
            }

            function getcustomermobile() {
                var mobileno = $("#mobileno").val();
                $.ajax({
                    url: "getcustomerdetailsearch",
                    dataType: 'json',
                    type: 'POST',
                    data: {
                        mobileno: mobileno
                    }, success: function (data) {
                        //adding the data to source array for autocomplete
                        var availableTags = [];
                        var sourced = [];
                        var mappingd = {};
                        for (var i = 0; i < data.length; i++) {
                            availableTags.push({label: data[i].mobilenumber, value: data[i].id});
                        }
                        for (var i = 0; i < availableTags.length; ++i) {
                            sourced.push(availableTags[i].label);
                            mappingd[availableTags[i].label] = availableTags[i].value;
                        }
                        //adding the data to source array for autocomplete end! here

                        //autocomplete code begin here
                        $("#mobileno").autocomplete({
                            source: sourced,
                            select: function (event, ui) {
                                var customerid = mappingd[ui.item.value];
                                location.href = "/Karworx/viewCustomerSearchLink?customerid=" + customerid;
                            },
                            change: function () {
                                var val = $(this).val();
                                var exists = $.inArray(val, sourced);
                                if (exists < 0) {
                                    $(this).val("");
                                    return false;
                                } else {

                                }
                            }
                        });
                        //autocomplete code end! here
                    },
                    error: function () {

                    }
                });
            }
            function getcustomervehicle() {
                var vehicleno = $("#vehicleno").val();
                $.ajax({
                    url: "getcustomerdetailvehiclenosearch",
                    dataType: 'json',
                    type: 'POST',
                    data: {
                        vehicleno: vehicleno
                    }, success: function (data) {
                        //adding the data to source array for autocomplete
                        var availableTags = [];
                        var sourced = [];
                        var mappingd = {};
                        for (var i = 0; i < data.length; i++) {
                            availableTags.push({label: data[i].vehiclenumber, value: data[i].customermobilenumber});
                        }
                        for (var i = 0; i < availableTags.length; ++i) {
                            sourced.push(availableTags[i].label);
                            mappingd[availableTags[i].label] = availableTags[i].value;
                        }
                        //adding the data to source array for autocomplete end! here

                        //autocomplete code begin here
                        $("#vehicleno").autocomplete({
                            source: sourced,
                            select: function (event, ui) {
                                var customermobilenumber = mappingd[ui.item.value];

                                $.ajax({
                                    url: "getcustomerdetailsearch",
                                    dataType: 'json',
                                    type: 'POST',
                                    data: {
                                        mobileno: customermobilenumber
                                    }, success: function (data) {
                                        location.href = "/Karworx/viewCustomerSearchLink?customerid=" + data[0].id;
                                    },
                                    error: function () {

                                    }
                                });

                            },
                            change: function () {
                                var val = $(this).val();
                                var exists = $.inArray(val, sourced);
                                if (exists < 0) {
                                    $(this).val("");
                                    return false;
                                } else {

                                }
                            }
                        });
                        //autocomplete code end! here
                    },
                    error: function () {

                    }
                });
            }
            function getcustomername() {
                var name = $("#name").val();
//                alert(name);
                $.ajax({
                    url: "getcustomerdetailnamesearch",
                    dataType: 'json',
                    type: 'POST',
                    data: {
                        customername: name
                    }, success: function (data) {
                        //adding the data to source array for autocomplete
                        var availableTags = [];
                        var sourced = [];
                        var mappingd = {};
                        for (var i = 0; i < data.length; i++) {
                            availableTags.push({label: data[i].name, value: data[i].id});
                        }
                        for (var i = 0; i < availableTags.length; ++i) {
                            sourced.push(availableTags[i].label);
                            mappingd[availableTags[i].label] = availableTags[i].value;
                        }
                        //adding the data to source array for autocomplete end! here

                        //autocomplete code begin here
                        $("#name").autocomplete({
                            source: sourced,
                            select: function (event, ui) {
                                var id = mappingd[ui.item.value];
                                location.href = "/Karworx/viewCustomerSearchLink?customerid="+id;

                            },
                            change: function () {
                                var val = $(this).val();
                                var exists = $.inArray(val, sourced);
                                if (exists < 0) {
                                    $(this).val("");
                                    return false;
                                } else {

                                }
                            }
                        });
                        //autocomplete code end! here
                    },
                    error: function () {

                    }
                });
            }
        </script>
    </head>
    <body>
    <spean style="float: right">
        Search element: <select name="element" id="searchoption" onchange="searchElement(this)">
            <option value="mobile">by Mobile NO</option>
            <option value="vehicle">by Vehicle NO</option>
            <option value="customer">by Name</option>
        </select>
    </spean>
    <h2>Customer search</h2>
    <br />
    <div id="mobile" style="margin: 0 auto;text-align: center">
        <input type="text" id="mobileno" placeholder="enter mobile number.." name="customermobilenumber" style="width: 600px;height: 30px;"  onkeyup="getcustomermobile()" value="" />
    </div>
    <br/>
    <div id="vehicle" style="margin: 0 auto;text-align: center">
        <input type="text" id="vehicleno" placeholder="enter vehicle number.." name="customervehiclenumber" style="width: 600px;height: 30px;"onkeyup="getcustomervehicle()" value="" />
    </div>
    <div id="customername" style="margin: 0 auto;text-align: center">
        <input type="text" id="name" placeholder="enter customer name.." name="customername" style="width: 600px;height: 30px;" onkeyup="getcustomername()" value="" />
    </div>
</body>
</html>
