<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Estimate Mail</title>
        <link href="css/jquery-ui_1.css" rel="stylesheet" type="text/css" />
        <style type="text/css">
            @media print{
                #printdivinside *
                {
                    font-size: 8px !important;
                }
            }  
        </style>
        <script src="js/jquery-ui.js"></script>
        <script type="text/javascript" src="js/jspdf.debug.js"></script>
        <script src="js/nicEdit.js" type="text/javascript"></script>
        <script>
            //called on ready
            $(document).ready(function () {

                nicEditors.allTextAreas();
                $("#comments").val("");
                $("#dialogPaymentDetail").hide();
                $("#dialogmailDetail").hide();
                $("#send").hide();
                $("#senturmail").hide();
                $("#sendError").hide();
                //code to hide unhide confim
                var isconf = "${estcustdtls.confirm_estimate}";
                if (isconf === 'Yes') {
                    $(".unconfirmclick").show();
                    $(".confirmclick").hide();
                } else {
                    $(".unconfirmclick").hide();
                    $(".confirmclick").show();
                }
//                convert_amount_into_amttotal_paisa();

                //code written to display mail comment box begin here
                $(".mailclick").click(function (e) {
                    e.preventDefault();
                    //get customer email in the textbox of comment dialog
                    var customerEmail = $("#customeremail").val();
                    $("#emailList").val('${company_mail},' + customerEmail);
//                    var invoicehistoryid = $(this).attr('href');
                    $("#dialogmailDetail").dialog({
                        modal: true,
                        effect: 'drop',
                        width: 925,
                        height: 300,
                        show: {
                            effect: "drop"
                        },
                        hide: {
                            effect: "drop"
                        }
                    });
                    $("#comments").val("");
                    $("#sendcomments").prop("disabled", false);
                });
                //code written to display mail comment box ends! here

                //code for confirm estimate goes here
                $(".confirmclick").click(function (e) {
                    var result = confirm("Are you sure to confirm");
                    if (result === true) {
                        var id = "${param.estid}";
                        $.ajax({
                            type: "post",
                            url: "confirmEstimate",
                            data: {id: id, deskname: "estimate", values: "Yes"
                            },
                            success: function (data) {
                                if (data === 'Yes') {
                                    $(".unconfirmclick").show();
                                    $(".confirmclick").hide();
                                }
                            },
                            error: function () {
                            }
                        });
                    }

                });
                //code for unconfirm estimate goes here
                $(".unconfirmclick").click(function (e) {
                    var result = confirm("Are you sure to un-confirm");
                    if (result === true) {
                        var id = "${param.estid}";
                        $.ajax({
                            type: "post",
                            url: "confirmEstimate",
                            data: {id: id, deskname: "estimate", values: "No"
                            },
                            success: function (data) {
                                if (data === 'No') {
                                    $(".unconfirmclick").hide();
                                    $(".confirmclick").show();
                                }
                            },
                            error: function () {
                            }
                        });
                    }

                });

                //code written here to show payment history begins here
                $(".paymenthistory").click(function (e) {
                    e.preventDefault();
                    var invoicehistoryid = $(this).attr('href');
                    $.ajax({
                        url: "getPaymentDetails",
                        datatype: 'json',
                        type: 'POST',
                        data: {
                            invoiceid: invoicehistoryid
                        },
                        cache: false,
                        success: function (data) {
                            for (var i = 0; i < data.length; ++i) {
                                $('#paymenttable').append('<tr><td align="center" >' + data[i].income_date + '</td><td>' + data[i].towards + '</td><td align="right">' + data[i].mode + '</td><td align="right">' + data[i].total + '</td></tr>');
                            }

                            //our view payments dialog
                            $("#dialogPaymentDetail").dialog({
                                modal: true,
                                effect: 'drop',
                                width: 600,
                                height: 400,
                                show: {
                                    effect: "drop"
                                },
                                hide: {
                                    effect: "drop"
                                }
                            });
                        }
                    });
                });
                //code written here to show payment history ends! here

                //code for part total details begin here
                var sum = 0;
                $('.price').each(function () {
                    sum += parseFloat($(this).text());
                });
                console.log("price part" + sum);
                var sum1 = 0;
                $('.labourcharges').each(function () {
                    sum1 += parseFloat($(this).text());
                });
                console.log("price labor" + sum1);
                $('#labourrs').html(sum1);
                $('#partsrs').html(sum);
                var grand = sum + sum1;
                console.log("price grand" + grand);
                $('#grandamount').text(grand);
                //code for part total details ends here

                //code for service total details begin here
                var sum2 = 0;
                $('.labourchargesservice').each(function () {
                    sum2 += parseFloat($(this).text());
                });
                $('#servicelabourrs').html(sum2);
                $('#grandserviceamount').text(sum2);
                //code for service total details ends here

                //code for grand total begin here   
                var grandtotalend = Number(grand) + Number(sum2);
                $('#grandpartserviceamount').text(grandtotalend);
                //code for grand total ends! here 

            });
            //calls print function
            function CallPrint(strid) {
//                $("#divPrint11").html('');
//                $("#divPrint11").append($("#table_id").eq(0).clone()).html();

                var prtContent = document.getElementById(strid);
                var strOldOne = prtContent.innerHTML;
                var WinPrint = window.open('', '', 'letf=0,top=0,width=1500,height=400,toolbar=0,scrollbars=0,status=0');
                WinPrint.document.write('<link rel="stylesheet" href="css/tablegrid.css" />');
                WinPrint.document.write(prtContent.innerHTML);
                WinPrint.document.close();
                WinPrint.focus();
                WinPrint.print();
                WinPrint.close();
                prtContent.innerHTML = strOldOne;
            }
            //calls convert to pdf function

            //mod print function begin here
            function printContent(el) {
                var restorepage = document.body.innerHTML;
                var printcontent = document.getElementById(el).innerHTML;
                document.body.innerHTML = printcontent;
                window.print();
                document.body.innerHTML = restorepage;
            }
            //mod print function ends! here

            //mod send mail function to test written on 06-11-2015 begins here
            function convertHTMLtopdf() {
                $("#sendcomments").prop("disabled", true);
                $("#senturmail").hide();
                $("#sendError").hide();
                $("#send").show();
                //invoice name logic                
                var customerdate = $("#custdate").val();
                var customervehicle = $("#custvehicle").val();
                var invoicename = customervehicle + " " + customerdate;
                var customerName = $("#customername").val();
                var customerEmail = $("#emailList").val();
                var emailComments = $('.nicEdit-main').html().substring(0, 20000);
                var out = document.getElementById("printdiv").innerHTML;
//                console.log(out);

                $.ajax({
                    url: "sendmailinfod",
                    type: 'POST',
                    data: {
                        customerName: customerName,
                        customerEmail: customerEmail,
                        mypdfbase: out,
                        emailcomments: emailComments,
                        name: "Estimate for " + invoicename
                    },
                    cache: false,
                    success: function (data) {
                        $("#dialogmailDetail").dialog("close");
                        if (data === 'Yes') {
                            $("#send").hide();
                            $("#senturmail").show();
                        } else {
                            $("#sendError").show();
                        }
                    }, error: function () {
                        alert("i m err");
                    }
                });
            }
            //mod send mail function to test written on 06-11-2015 ends!! here

            //new code to print begins here
            function PrintElem(elem)
            {
                Popup($(elem).html());
            }

            function Popup(data)
            {
                var mywindow = window.open('', 'Print Estimate', 'height=400,width=600');
                mywindow.document.write('<html><head><title>Print Estimate</title>');
                /*optional stylesheet*/ 
//                mywindow.document.write('<link rel="stylesheet" href="css/tablegrid.css" type="text/css" />');
                mywindow.document.write('</head><body >');
                mywindow.document.write(data);
                mywindow.document.write('</body></html>');

                mywindow.document.close(); // necessary for IE >= 10
                mywindow.focus(); // necessary for IE >= 10

                mywindow.print();
                mywindow.close();

                return true;
            }
            //new code to print ends! here



        </script>
    </head>
    <body>


        <a href="#" class="view button-001 unconfirmclick">Un-confirm</a>  <a href="#" class="view button-001 confirmclick">Confirm</a>  <a href="#" class="view button-001 mailclick">Send Mail</a>  <a href="estimate" class="view button-001">Back</a><a href="#" class="view button-001"  onclick="PrintElem('#printdivinside')">Print</a>


        <label id="send"><h2>Sending mail <img src="images/ajax-loader.gif" alt="loader View"></h2></label><label id="senturmail"><h2>Mail sent successfully <img src="images/MB__mail_icon.png" alt="loader View"></h2></label><label id="sendError"><h2>Please Check Your Connectivity</h2></label>
        <h2>Send Estimate</h2>
        <div id="testcase">
            <div id="printdiv">
                <div id="printdivinside">
                    <div>
                        <div  align="center">
                            <div style="display: inline-block;width: 400px; text-align: left">
                                <strong style="font-size:18px">Kar-Worx & Spa India Pvt. Ltd</strong><br>
                                <p>
                                    Arch no. 25/26, Below Mahalaxmi Bridge,Off. Dr. E. Moses Road, Mumbai - 400034. Tel No.: 022-40028004/5. Email: customer.first@karworx.com
                                </p>
                            </div>
                            <div style="display: inline-block;width: 165px; padding-left: 20px">
                                <img src="https://goo.gl/KsVTbt" width="100" />
                            </div>
                        </div>
                        <div align="center"><strong style="font-size:18px">ESTIMATE</strong></div>                    
                    </div>
                    <div class="box1" align="left" style="display: inline-block;">
                        <strong>${estcustdtls.customername}</strong><input type="hidden" id="customername" name="customername" value="${estcustdtls.customername}" />
                        <input type="hidden" name="" id="jspdfdata" value="" /><br />
                        ${estcustdtls.address}<br />
                        ${estcustdtls.mobilenumber}<br />                    
                        ${estcustdtls.email}<br /><input type="hidden" name="customeremail" id="customeremail" value="${estcustdtls.email}" />
                    </div>
                    <div class="box2" align="right" style="display: inline-block; float: right">
                        <strong>Estimate No</strong>&nbsp;:	${param.estid}<br />
                        <strong>Date</strong> :<fmt:formatDate type="date" value="${estcustdtls.pcldate}" /> 
                        <input type="hidden" name="custdate" id="custdate" value="<fmt:formatDate pattern="yyyy-MM-dd" value="${estcustdtls.pcldate}" />" /><br />
                        <strong>Vehicle Make &nbsp;:</strong>${estcustdtls.make} &nbsp; ${estcustdtls.carmodel}<br />
                        <strong>Vehicle No. &nbsp;:</strong>${estcustdtls.vehiclenumber}<input type="hidden" name="custvehicle" id="custvehicle" value="${estcustdtls.vehiclenumber}" /><br />
                        <strong>Kilometer (KM)</strong>&nbsp;:	<c:choose>
                            <c:when test="${empty estcustdtls.km_in}">
                                N/A
                            </c:when>
                            <c:otherwise>
                                ${estcustdtls.km_in}
                            </c:otherwise>
                        </c:choose>
                    </div>
                    <br />
                    <br />
                    <div class="CSSTableGenerator">
                        <table cellspacing="0" cellpadding="2" style="overflow: auto; max-height: 10px; " border="1" width="100%" bordercolor="#ccc">
                            <tr>
                                <td align="left" width="5%"  class="wn1"><strong>Sr.No.</strong></td>
                                <td align="left" width="21%" class="wn1"><strong>Name</strong></td>
                                <td align="left" width="37%" class="wn1"><strong>Description</strong></td>
                                <td align="center" width="5%" class="wn1"><strong>Qty.</strong></td>
                                <td align="center" width="14%" class="wn1"><strong>Per Item</strong></td>
                                <td align="center" width="10%" class="wn1"><strong>Part Rs.</strong></td>
                            </tr>
                            <c:set value="1" var="count"></c:set>
                            <c:forEach var="ob" items="${estpartdtls}">
                                <tr>
                                    <td align="center" >${count}</td>
                                    <td>${ob.partname}</td>
                                    <td>${ob.description}</td>
                                    <td align="center" class="quantity">${ob.quantity}</td>
                                    <td align="center" class="peritem">${ob.partrs}</td>
                                    <td align="center" class="price">${ob.totalpartrs}</td>
                                </tr>
                                <c:set value="${count+1}" var="count"></c:set>
                            </c:forEach>
                            <tr>
                                <!--<td >&nbsp;</td>-->
                                <td>&nbsp;</td>
                                <td>&nbsp;</td>
                                <td align="right"></td>
                                <td>&nbsp;</td>                                
                                <td align="center"><strong>Total Parts</strong></td>
                                <td align="center"><strong><label>Rs.${parttotal}</label></strong></td>
                            </tr>
                            <tr>
                                <!--<td >&nbsp;</td>-->
                                <td>&nbsp;</td>
                                <td>&nbsp;</td>
                                <td align="right"></td>
                                <td>&nbsp;</td>                                
                                <td align="center"><strong>VAT ${taxDetails[0].percent}%</strong></td>
                                <td align="center"><strong><label>Rs.${vat}</label></strong></td>
                            </tr>
                            <tr>
                                <!--<td >&nbsp;</td>-->
                                <td>&nbsp;</td>
                                <td>&nbsp;</td>
                                <td align="right"></td>
                                <td>&nbsp;</td>                                
                                <td align="center"><strong>Total Parts with Tax</strong></td>
                                <td align="center"><strong><label>Rs.${partsum}</label></strong></td>
                            </tr>
                            <!--code for part has ended-->
                            <!--code for services begins here-->
                            <tr>
                                <!--<td >&nbsp;</td>-->
                                <td>&nbsp;</td>
                                <td>&nbsp;</td>
                                <td>&nbsp;</td>
                                <td>&nbsp;</td>
                                <td>&nbsp;</td>
                                <td align="right">&nbsp;</td>
                            </tr>
                            <c:if test="${servicetax=='0.0'}">
                                <tr>
                                    <td style="background-color:#f4f4f4">&nbsp;</td>
                                    <td style="background-color:#f4f4f4">&nbsp;</td>
                                    <td style="background-color:#f4f4f4">&nbsp;</td>
                                    <td style="background-color:#f4f4f4">&nbsp;</td>
                                    <td align="center" style="background-color:#f4f4f4"><strong>GRAND TOTAL</strong></td>
                                    <td align="center" style="background-color:#f4f4f4"><strong><label>Rs.${grandtotal}</label></strong></td>
                                </tr>
                            </c:if>
                        </table>
                        <c:if test="${servicetax ne '0.0'}">
                            <table cellspacing="0" cellpadding="2" style="overflow: auto; max-height: 10px; " border="1" width="100%" bordercolor="#ccc">
                                <tr>
                                    <td width="5%" class="wn1"><strong>Sr. No.&nbsp;</strong></td>
                                    <td width="21%" class="wn1" ><strong>Service Name&nbsp;</strong></td>
                                    <td width="37%" class="wn1" ><strong>Description&nbsp;</strong></td>
                                    <td width="5%" class="wn1" ><strong>&nbsp;</strong></td>
                                    <td width="14%" class="wn1" ><strong>&nbsp;</strong></td>
                                    <td width="10%" class="wn1" align="center"><strong>Labour Rs.&nbsp;</strong></td>
                                </tr>
                                <c:set value="1" var="count"></c:set>
                                <c:forEach var="ob" items="${estservicedtls}">
                                    <tr>
                                        <td>${count}</td>
                                        <td>${ob.servicename}</td>
                                        <td>${ob.description}</td>
                                        <td>&nbsp;</td>
                                        <td>&nbsp;</td>
                                        <td align="center">${ob.labourrs}</td>
                                    </tr>
                                    <c:set value="${count+1}" var="count"></c:set>
                                </c:forEach>
                                <tr>
                                    <td>&nbsp;</td>
                                    <td>&nbsp;</td>
                                    <td>&nbsp;</td>
                                    <td>&nbsp;</td>
                                    <td align="center"><strong>Total Labor</strong></td>
                                    <td align="center"><strong><label>Rs.${laborTotal}</label></strong></td>
                                </tr>
                                <tr>
                                    <td>&nbsp;</td>
                                    <td>&nbsp;</td>
                                    <td>&nbsp;</td>
                                    <td>&nbsp;</td>
                                    <td align="center"><strong>Service Tax ${taxDetails[1].percent}%</strong></td>
                                    <td align="center"><strong><label>Rs.${servicetax}</label></strong></td>
                                </tr>
                                <tr>
                                    <td>&nbsp;</td>
                                    <td>&nbsp;</td>
                                    <td>&nbsp;</td>
                                    <td>&nbsp;</td>
                                    <td align="center"><strong>Total Labor with Tax</strong></td>
                                    <td align="center"><strong><label>Rs.${laborsum}</label></strong></td>
                                </tr>  
                                <tr>
                                    <td style="background-color:#f4f4f4">&nbsp;</td>
                                    <td style="background-color:#f4f4f4">&nbsp;</td>
                                    <td style="background-color:#f4f4f4">&nbsp;</td>
                                    <td style="background-color:#f4f4f4">&nbsp;</td>
                                    <td align="center" style="background-color:#f4f4f4"><strong>GRAND TOTAL</strong></td>
                                    <td align="center" style="background-color:#f4f4f4"><strong><label>Rs.${grandtotal}</label></strong></td>
                                </tr>
                            </table>
                        </c:if>
                        <div style="padding: 7px 7px;">
                            <div class="box3" align="left" style="display: inline-block;">
                                <strong>&nbsp; </strong><br />
                                &nbsp;
                            </div>
                            <div class="box4" style="display: inline-block;float: right">
                                <strong style="float:right">Kar-Worx & Spa India Pvt. Ltd</strong> 
                            </div>
                            <p>
                                <br />
                                <br />
                                <br />
                                <strong>Customer's Signature </strong><br />
                                C.E.S.Tax No: AADCB0214DSD001.  VAT TIN No: 27650980309V wef 26/04/2013.   CST TIN No: 27650980309C wef 26/04/2013.  PAN No: AADCB0214D.                                    
                                <br />
                                <strong>Terms and Conditions</strong><br />
                                1. Disputes if any will be subject to MUMBAI jurisdiction <br />
                                2. Interest @ 18% would be charged on all bills unpaid after 30 days from the date of the bill <br />"I / We hereby certify that my/our R.C. under the Mah. Value Added Tax Act 2002 is in force on the data on which the sale of the goods specified in this Tax Invoice is made by me / us and that the transaction of sale covered by this invoice has been effected by me / us and it shall be accounted for in the turnover of sales while filing of return and the due tax, if any,if any payableon the sale has been paid or shall be paid" 
                            </p>

                        </div>

                    </div>
                </div>
            </div>
        </div>
        <!--payment history dialog code begin here-->
        <div id="dialogPaymentDetail" title="View payment details">
            <table id="paymenttable" class="CSSTableGenerator">                    
                <tr>
                    <td align="left" width="10%"><strong>Date</strong></td>
                    <td align="left" width="24%"><strong>Name</strong></td>
                    <td align="left" width="10%"><strong>Mode</strong></td>
                    <td align="left" width="10%"><strong>Amount(Rs.)</strong></td>
                </tr>

            </table>
        </div>
        <!--payment history dialog code ends! here-->

        <!-- email comments dialog code begin here-->
        <div id="dialogmailDetail" title="Add Comments">
            <table border="0"> 
                <tr>
                    <td><strong>Email</strong></td>
                    <td>
                        <input type="text" name="emailList" style="width: 813px" id="emailList" value="" />
                    </td>
                </tr>
                <tr>
                    <td><strong>Comments</strong></td>
                    <td>
                        <textarea name="area1" id="comments" cols="100">
                        </textarea>
                    </td>
                </tr>
                <tr>
                    <td>&nbsp;</td>
                    <td>
                        <input type="button" value="Send" onclick="convertHTMLtopdf()" class="view3" id="sendcomments" style="cursor: pointer" />
                    </td>
                </tr>
            </table>
        </div>
        <!--email comments dialog code ends! here-->
    </body>
</html>
