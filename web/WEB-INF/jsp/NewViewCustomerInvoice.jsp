<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%-- 
    Document   : NewViewCustomerInvoice
    Created on : 3 Dec, 2015, 9:19:06 AM
    Author     : pc2
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Invoice</title>

        <style type="text/css"><!-- 
            body,div,table,thead,tbody,tfoot,tr,th,td,p { font-family:"Verdana"; font-size:x-small }
            -->
        </style>
        <link href="css/jquery-ui_1.css" rel="stylesheet" type="text/css" />
        <script src="js/jquery-ui.js"></script>
        <link rel="stylesheet" href="css/tablegrid.css" />
        <!--<script type="text/javascript" src="js/jquery-1.11.2.min.js"></script>-->
        <script type="text/javascript" src="js/jspdf.debug.js"></script>
        <script type="text/javascript">
            function test_value() {
                var junkVal = document.getElementById('amttotal').value;
                junkVal = Math.floor(junkVal);
                var obStr = new String(junkVal);
                numReversed = obStr.split("");
                actnumber = numReversed.reverse();
                if (Number(junkVal) >= 0) {
                    //do nothing
                }
                else {
                    alert('wrong Number cannot be converted');
                    return false;
                }
                if (Number(junkVal) == 0) {
                    document.getElementById('finalamtwords').innerHTML = obStr + '' + 'Rupees Zero Only';
                    return false;
                }
                if (actnumber.length > 9) {
                    alert('Oops!!!! the Number is too big to covertes');
                    return false;
                }
                var iWords = ["Zero", " One", " Two", " Three", " Four", " Five", " Six", " Seven", " Eight", " Nine"];
                var ePlace = ['Ten', ' Eleven', ' Twelve', ' Thirteen', ' Fourteen', ' Fifteen', ' Sixteen', ' Seventeen', ' Eighteen', 'Nineteen'];
                var tensPlace = ['dummy', ' Ten', ' Twenty', ' Thirty', ' Forty', ' Fifty', ' Sixty', ' Seventy', ' Eighty', ' Ninety'];
                var iWordsLength = numReversed.length;
                var totalWords = "";
                var inWords = new Array();
                var finalWord = "";
                j = 0;
                for (i = 0; i < iWordsLength; i++) {
                    switch (i)
                    {
                        case 0:
                            if (actnumber[i] == 0 || actnumber[i + 1] == 1) {
                                inWords[j] = '';
                            }
                            else {
                                inWords[j] = iWords[actnumber[i]];
                            }
                            inWords[j] = inWords[j];
                            break;
                        case 1:
                            tens_complication();
                            break;
                        case 2:
                            if (actnumber[i] == 0) {
                                inWords[j] = '';
                            }
                            else if (actnumber[i - 1] != 0 && actnumber[i - 2] != 0) {
                                inWords[j] = iWords[actnumber[i]] + ' Hundred and';
                            }
                            else {
                                inWords[j] = iWords[actnumber[i]] + ' Hundred';
                            }
                            break;
                        case 3:
                            if (actnumber[i] == 0 || actnumber[i + 1] == 1) {
                                inWords[j] = '';
                            }
                            else {
                                inWords[j] = iWords[actnumber[i]];
                            }
                            if (actnumber[i + 1] != 0 || actnumber[i] > 0) { //here
                                inWords[j] = inWords[j] + " Thousand";
                            }
                            break;
                        case 4:
                            tens_complication();
                            break;
                        case 5:
                            if (actnumber[i] == "0" || actnumber[i + 1] == 1) {
                                inWords[j] = '';
                            }
                            else {
                                inWords[j] = iWords[actnumber[i]];
                            }
                            if (actnumber[i + 1] != 0 || actnumber[i] > 0) {   //here 
                                inWords[j] = inWords[j] + " Lakh";
                            }
                            break;
                        case 6:
                            tens_complication();
                            break;
                        case 7:
                            if (actnumber[i] == "0" || actnumber[i + 1] == 1) {
                                inWords[j] = '';
                            }
                            else {
                                inWords[j] = iWords[actnumber[i]];
                            }
                            if (actnumber[i + 1] != 0 || actnumber[i] > 0) { // changed here
                                inWords[j] = inWords[j] + " Crore";
                            }
                            break;
                        case 8:
                            tens_complication();
                            break;
                        default:
                            break;
                    }
                    j++;
                }
                function tens_complication() {
                    if (actnumber[i] == 0) {
                        inWords[j] = '';
                    }
                    else if (actnumber[i] == 1) {
                        inWords[j] = ePlace[actnumber[i - 1]];
                    }
                    else {
                        inWords[j] = tensPlace[actnumber[i]];
                    }
                }
                inWords.reverse();
                for (i = 0; i < inWords.length; i++) {
                    finalWord += inWords[i];
                }
                return finalWord;
            }
            function convert_amount_into_amttotal_paisa() {

                var finalWord1 = test_value();
                var finalWord2 = "";
                var val = document.getElementById('amttotal').value;
                var actual_val = document.getElementById('amttotal').value;
                document.getElementById('amttotal').value = val;
                if (val.indexOf('.') != -1)
                {
                    val = val.substring(val.indexOf('.') + 1, val.length);
                    if (val == '0' || val == '00') {
                        finalWord2 = "zero paisa only";
                    }
                    else {
                        document.getElementById('amttotal').value = val;
                        finalWord2 = test_value() + " paisa only";
                    }
                    document.getElementById('finalamtwords').innerHTML = finalWord1 + " Rupees and " + finalWord2;
                }
                else {
                    //finalWord2 =  " Zero paisa only";
                    document.getElementById('finalamtwords').innerHTML = finalWord1 + " Rupees Only";
                }
                document.getElementById('amttotal').value = actual_val;
            }
        </script>
        <script>
            //called on ready
            $(document).ready(function () {
                $("#comments").val("");
                $("#dialogPaymentDetail").hide();
                $("#dialogmailDetail").hide();
                $("#send").hide();
                $("#senturmail").hide();
                $("#sendError").hide();
                convert_amount_into_amttotal_paisa();
                
                //code written to display mail comment box begin here
                $(".mailclick").click(function (e){
                    e.preventDefault();
                    
//                    var invoicehistoryid = $(this).attr('href');
                    $("#dialogmailDetail").dialog({
                        modal: true,
                        effect: 'drop',
                        width: 500,
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
                
                //code written here to show payment history begins here
                $(".paymenthistory").click(function (e) {
                    e.preventDefault();
                    var invoicehistoryid = $(this).attr('href');
                    $(".toremove").remove();

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
                                $('#paymenttable').append('<tr class="toremove"><td align="center" >' + data[i].income_date + '</td><td>' + data[i].towards + '</td><td align="right">' + data[i].mode + '</td><td align="right">' + data[i].total + '</td></tr>');
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
                
                
            });
            //calls print function
            function CallPrint(strid) {
//                $("#divPrint11").html('');
//                $("#divPrint11").append($("#table_id").eq(0).clone()).html();

                var prtContent = document.getElementById(strid);
                var strOldOne = prtContent.innerHTML;
                var WinPrint = window.open('', '', 'letf=0,top=0,width=1500,height=400,toolbar=0,scrollbars=0,sta­tus=0');
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
                var pdf = new jsPDF('p', 'pt', 'a4');
                source = $('#testcase')[0];
                specialElementHandlers = {
                    // element with id of "bypass" - jQuery style selector
                    '#bypassme': function (element, renderer) {
                        // true = "handled elsewhere, bypass text extraction"
                        return true
                    }
                };
                margins = {
                    top: 80,
                    bottom: 60,
                    left: 40,
                    width: 522
                };
                pdf.fromHTML(
                        source, // HTML string or DOM elem ref.
                        margins.left, // x coord
                        margins.top, {// y coord
                            'width': margins.width, // max width of content on PDF
                            'elementHandlers': specialElementHandlers
                        },
                function (dispose) {
                    // dispose: object with X, Y of the last line add to the PDF 
                    //          this allow the insertion of new lines after html
                    // Making Data URI
                    var out = pdf.output('datauristring');
                    //ajax call to send mail begin here
                    var customerName = $("#customername").val();
                    var customerEmail = $("#customeremail").val();
                    var emailComments = $("#comments").val();
                    $.ajax({
                        url: "sendmailinfo",
                        type: 'POST',
                        data: {
                            customerName: customerName,
                            customerEmail: customerEmail,
                            mypdfbase: out,
                            emailcomments: emailComments
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
                    //ajax call to send mail ends!! here
                }, margins);
            }
            //mod send mail function to test written on 06-11-2015 ends!! here

            //mod code witten here is modification to show dialog and allow user to write cusotom mail message begin here
            function showcommentsdialog() {
                $("#dialogmailDetail").show();
                //our add comment dialog
                $("#dialogmailDetail").dialog({
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
            //mod code witten here is modification to show dialog and allow user to write cusotom mail message ends! here

        </script>

    </head>

    <body text="#000000">
        <a href="${param.invoiceid}" onclick="" class="view button-001 paymenthistory"><img src="images/wallet33.png" width="15" height="13"/>&nbsp;History</a> <a href="#" class="view button-001 mailclick">Send Mail</a>  <a href="invoiceMasterLink" class="view button-001">Back</a><a href="#" class="view button-001" onclick="printContent('printdiv')">Print</a>
        <c:choose>
                <c:when test="${invoiceDt.isPaid=='No'}">
                <a href="editInvoiceDetailsLink?invoiceid=${invoiceDt.id}" class="view button-001">Edit</a>
            </c:when>
        </c:choose>      
        <label id="send"><h2>Sending mail <img src="images/ajax-loader.gif" alt="loader View"></h2></label><label id="senturmail"><h2>Mail sent successfully <img src="images/MB__mail_icon.png" alt="loader View"></h2></label><label id="sendError"><h2>Please Check Your Connectivity</h2></label>

    <br/>
    <br/>
    <br/>
    <br/>
        <div id="testcase">
            <div id="printdiv">
            <div id="printdivinside">
        <table cellspacing="0" border="0">
            <colgroup width="26"></colgroup>
            <colgroup width="210"></colgroup>
            <colgroup width="147"></colgroup>
            <colgroup width="166"></colgroup>
            <colgroup width="81"></colgroup>
            <colgroup width="87"></colgroup>
            <colgroup width="81"></colgroup>
            <colgroup width="91"></colgroup>
            <tbody><tr>
                    <td style="border-top: 1px solid #3c3c3c; border-bottom: 1px solid #3c3c3c; border-left: 1px solid #3c3c3c; border-right: 1px solid #3c3c3c" colspan="8" height="16" align="center"><b>TAX INVOICE</b></td>
                </tr>
                <tr>
                    <td style="border-top: 1px solid #3c3c3c; border-bottom: 1px solid #3c3c3c; border-left: 1px solid #3c3c3c; border-right: 1px solid #3c3c3c" colspan="4" rowspan="6" height="109" align="left" valign="top"><b>KAR-WORX &amp; SPA INDIA PVT. LTD                                                                                                          Arch no. 25/26, Below Mahalaxmi Bridge,Off. Dr. E. Moses Road,     Mumbai - 400034.                                                                                                         Tel No.: 022-40028004/5.                                                                                            Email: customer.first@karworx.com</b></td>
                    <td style="border-top: 1px solid #3c3c3c; border-bottom: 1px solid #3c3c3c; border-left: 1px solid #3c3c3c; border-right: 1px solid #3c3c3c" colspan="4" rowspan="6" align="center" valign="top"><b><br><img src="images/karworx logo.png" width="139" height="105" hspace="56" vspace="4">
                        </b></td>
                </tr>
                <tr>
                </tr>
                <tr>
                </tr>
                <tr>
                </tr>
                <tr>
                </tr>
                <tr>
                </tr>
                <tr>
                    <td style="border-bottom: 1px solid #3c3c3c; border-left: 1px solid #3c3c3c" height="1" align="left"><br></td>
                    <td style="border-bottom: 1px solid #3c3c3c" align="left"><br></td>
                    <td style="border-bottom: 1px solid #3c3c3c" align="left"><br></td>
                    <td style="border-bottom: 1px solid #3c3c3c" align="left"><br></td>
                    <td style="border-bottom: 1px solid #3c3c3c; border-left: 1px solid #3c3c3c" align="left"><br></td>
                    <td style="border-bottom: 1px solid #3c3c3c" align="left"><br></td>
                    <td style="border-bottom: 1px solid #3c3c3c" align="left"><br></td>
                    <td style="border-bottom: 1px solid #3c3c3c; border-right: 1px solid #3c3c3c" align="left"><br></td>
                </tr>
                <tr>
                    <td style="border-top: 1px solid #3c3c3c; border-bottom: 1px solid #3c3c3c; border-left: 1px solid #3c3c3c" colspan="4" rowspan="6" height="91" align="left" valign="top">Customer                                                                                                                                                                                     MR. BINAY SHAH<input type="hidden" id="customername" name="customername" value="${customerinvoiceDt.customer_name}" /><input type="hidden" name="customeremail" id="customeremail" value="${customerinvoiceDt.email}" /><input type="hidden" name="amttotal" id="amttotal" value="${invoiceDt.amountTotal}" /><br>M: 9892604567</td>
                    <td style="border-top: 1px solid #3c3c3c; border-bottom: 1px solid #3c3c3c; border-left: 1px solid #3c3c3c; border-right: 1px solid #3c3c3c" colspan="2" rowspan="2" align="left" valign="middle">INVOICE NO-2238</td>
                    <td style="border-top: 1px solid #3c3c3c; border-bottom: 1px solid #3c3c3c; border-left: 1px solid #3c3c3c; border-right: 1px solid #3c3c3c" colspan="2" rowspan="2" align="left" valign="middle">Date :25.09.2015</td>
                </tr>
                <tr>
                </tr>
                <tr>
                    <td style="border-top: 1px solid #3c3c3c; border-bottom: 1px solid #3c3c3c; border-left: 1px solid #3c3c3c; border-right: 1px solid #3c3c3c" colspan="2" rowspan="2" align="left" valign="middle">Vehicle No:                  MH 01 BB 6055                            </td>
                    <td style="border-top: 1px solid #3c3c3c; border-bottom: 1px solid #3c3c3c; border-left: 1px solid #3c3c3c; border-right: 1px solid #3c3c3c" colspan="2" rowspan="2" align="left" valign="middle">Other Ref.(s) JOB: 2520</td>
                </tr>
                <tr>
                </tr>
                <tr>
                    <td style="border-top: 1px solid #3c3c3c; border-bottom: 1px solid #3c3c3c; border-left: 1px solid #3c3c3c; border-right: 1px solid #3c3c3c" colspan="2" rowspan="2" align="left" valign="middle">Vehicle Name:                      HYUNDAI I20                  </td>
                    <td style="border-top: 1px solid #3c3c3c; border-bottom: 1px solid #3c3c3c; border-left: 1px solid #3c3c3c; border-right: 1px solid #3c3c3c" colspan="2" rowspan="2" align="left" valign="middle">Kilometer (KM): </td>
                </tr>
                <tr>
                </tr>
                <tr>
                    <td style="border-top: 1px solid #3c3c3c; border-bottom: 1px solid #3c3c3c; border-left: 1px solid #3c3c3c; border-right: 1px solid #3c3c3c" rowspan="2" height="35" align="center">SR No.</td>
                    <td style="border-top: 1px solid #3c3c3c; border-bottom: 1px solid #3c3c3c; border-left: 1px solid #3c3c3c" colspan="3" rowspan="2" align="center" valign="top">Description of Goods</td>
                    <td style="border-top: 1px solid #3c3c3c; border-bottom: 1px solid #3c3c3c; border-left: 1px solid #3c3c3c; border-right: 1px solid #3c3c3c" rowspan="2" align="center" valign="top">Quantity</td>
                    <td style="border-top: 1px solid #3c3c3c; border-bottom: 1px solid #3c3c3c; border-left: 1px solid #3c3c3c; border-right: 1px solid #3c3c3c" rowspan="2" align="center" valign="top">Rate</td>
                    <td style="border-top: 1px solid #3c3c3c; border-bottom: 1px solid #3c3c3c; border-left: 1px solid #3c3c3c; border-right: 1px solid #3c3c3c" rowspan="2" align="center" valign="top">Per</td>
                    <td style="border-top: 1px solid #3c3c3c; border-bottom: 1px solid #3c3c3c; border-left: 1px solid #3c3c3c; border-right: 1px solid #3c3c3c" rowspan="2" align="center" valign="top">Amount</td>
                </tr>
                <tr>
                </tr>
                <tr>
                    <td style="border-top: 1px solid #3c3c3c; border-left: 1px solid #3c3c3c" height="15" align="center" valign="top"><br></td>
                    <td style="border-top: 1px solid #3c3c3c; border-left: 1px solid #3c3c3c" align="left" valign="top"><b>PARTS</b></td>
                    <td style="border-top: 1px solid #3c3c3c" align="center" valign="top"><br></td>
                    <td style="border-top: 1px solid #3c3c3c; border-right: 1px solid #3c3c3c" align="center" valign="top"><br></td>
                    <td style="border-top: 1px solid #3c3c3c; border-left: 1px solid #3c3c3c" align="center" valign="top"><br></td>
                    <td style="border-top: 1px solid #3c3c3c; border-left: 1px solid #3c3c3c; border-right: 1px solid #3c3c3c" align="center" valign="top" sdnum="16393;0;&quot;Rs.&quot;#,##0"><br></td>
                    <td style="border-top: 1px solid #3c3c3c" align="center" valign="top"><br></td>
                    <td style="border-left: 1px solid #3c3c3c; border-right: 1px solid #3c3c3c" align="center" sdnum="16393;0;&quot;Rs.&quot;#,##0"><br></td>
                </tr>
                <!--loop here parts data--> 
                <tr>
                    <td style="border-left: 1px solid #3c3c3c" height="15" align="center" valign="top" sdval="1" sdnum="16393;">1</td>
                    <td style="border-left: 1px solid #3c3c3c" align="left" valign="top">CLUTCH PLATE PRESSURE PLATE SET</td>
                    <td align="center" valign="top"><br></td>
                    <td style="border-right: 1px solid #3c3c3c" align="center" valign="top"><br></td>
                    <td style="border-left: 1px solid #3c3c3c; border-right: 1px solid #3c3c3c" align="center" valign="top" sdval="1" sdnum="16393;">1</td>
                    <td style="border-left: 1px solid #3c3c3c; border-right: 1px solid #3c3c3c" align="center" valign="top" sdval="7150" sdnum="16393;0;&quot;Rs.&quot;#,##0">Rs.7,150</td>
                    <td style="border-left: 1px solid #3c3c3c" align="center" valign="top">NOS</td>
                    <td style="border-left: 1px solid #3c3c3c; border-right: 1px solid #3c3c3c" align="center" sdval="7150" sdnum="16393;0;&quot;Rs.&quot;#,##0">Rs.7,150</td>
                </tr>
                <tr>
                    <td style="border-left: 1px solid #3c3c3c" height="15" align="center" valign="top"><br></td>
                    <td style="border-bottom: 1px solid #3c3c3c; border-left: 1px solid #3c3c3c" align="left" valign="top"><br></td>
                    <td style="border-bottom: 1px solid #3c3c3c" align="center" valign="top"><br></td>
                    <td style="border-bottom: 1px solid #3c3c3c; border-right: 1px solid #3c3c3c" align="center" valign="top"><br></td>
                    <td style="border-left: 1px solid #3c3c3c" align="center" valign="top"><br></td>
                    <td style="border-left: 1px solid #3c3c3c; border-right: 1px solid #3c3c3c" align="center" valign="top" sdnum="16393;0;&quot;Rs.&quot;#,##0"><br></td>
                    <td align="center" valign="top"><br></td>
                    <td style="border-left: 1px solid #3c3c3c; border-right: 1px solid #3c3c3c" align="center" sdnum="16393;0;&quot;Rs.&quot;#,##0"><br></td>
                </tr>
                <tr>
                    <td style="border-left: 1px solid #3c3c3c; border-right: 1px solid #3c3c3c" height="15" align="center" valign="top"><br></td>
                    <td style="border-top: 1px solid #3c3c3c; border-bottom: 1px solid #3c3c3c; border-left: 1px solid #3c3c3c" align="left" valign="top"><b>Total Parts</b></td>
                    <td style="border-top: 1px solid #3c3c3c; border-bottom: 1px solid #3c3c3c" align="center" valign="top"><br></td>
                    <td style="border-top: 1px solid #3c3c3c; border-bottom: 1px solid #3c3c3c" align="center" valign="top"><br></td>
                    <td style="border-top: 1px solid #3c3c3c; border-bottom: 1px solid #3c3c3c; border-left: 1px solid #3c3c3c; border-right: 1px solid #3c3c3c" align="center" valign="top"><br></td>
                    <td style="border-top: 1px solid #3c3c3c; border-bottom: 1px solid #3c3c3c; border-left: 1px solid #3c3c3c; border-right: 1px solid #3c3c3c" align="center" valign="top" sdnum="16393;0;&quot;Rs.&quot;#,##0"><br></td>
                    <td style="border-top: 1px solid #3c3c3c; border-bottom: 1px solid #3c3c3c; border-left: 1px solid #3c3c3c" align="center" valign="top"><br></td>
                    <td style="border-top: 1px solid #3c3c3c; border-bottom: 1px solid #3c3c3c; border-left: 1px solid #3c3c3c; border-right: 1px solid #3c3c3c" align="center" valign="top" sdval="14090" sdnum="16393;0;&quot;Rs.&quot;#,##0"><b>Rs.14,090</b></td>
                </tr>
                <tr>
                    <td style="border-left: 1px solid #3c3c3c; border-right: 1px solid #3c3c3c" height="15" align="center" valign="top"><br></td>
                    <td style="border-top: 1px solid #3c3c3c; border-bottom: 1px solid #3c3c3c; border-left: 1px solid #3c3c3c" align="left" valign="top"><br></td>
                    <td style="border-top: 1px solid #3c3c3c; border-bottom: 1px solid #3c3c3c" align="center" valign="top"><br></td>
                    <td style="border-top: 1px solid #3c3c3c; border-bottom: 1px solid #3c3c3c" align="center" valign="top"><b>VAT 12.5%</b></td>
                    <td style="border-top: 1px solid #3c3c3c; border-bottom: 1px solid #3c3c3c; border-left: 1px solid #3c3c3c; border-right: 1px solid #3c3c3c" align="center" valign="top"><br></td>
                    <td style="border-top: 1px solid #3c3c3c; border-bottom: 1px solid #3c3c3c; border-left: 1px solid #3c3c3c; border-right: 1px solid #3c3c3c" align="center" valign="top" sdnum="16393;0;&quot;Rs.&quot;#,##0"><br></td>
                    <td style="border-top: 1px solid #3c3c3c; border-bottom: 1px solid #3c3c3c; border-left: 1px solid #3c3c3c" align="center" valign="top"><br></td>
                    <td style="border-top: 1px solid #3c3c3c; border-bottom: 1px solid #3c3c3c; border-left: 1px solid #3c3c3c; border-right: 1px solid #3c3c3c" align="center" valign="top" sdval="1761.25" sdnum="16393;0;&quot;Rs.&quot;#,##0">Rs.1,761</td>
                </tr>
                <tr>
                    <td style="border-left: 1px solid #3c3c3c; border-right: 1px solid #3c3c3c" height="15" align="center" valign="top"><br></td>
                    <td style="border-top: 1px solid #3c3c3c; border-bottom: 1px solid #3c3c3c; border-left: 1px solid #3c3c3c" align="left" valign="top"><b>Total Parts with Tax</b></td>
                    <td style="border-top: 1px solid #3c3c3c; border-bottom: 1px solid #3c3c3c" align="center" valign="top"><br></td>
                    <td style="border-top: 1px solid #3c3c3c; border-bottom: 1px solid #3c3c3c" align="center" valign="top"><br></td>
                    <td style="border-top: 1px solid #3c3c3c; border-bottom: 1px solid #3c3c3c; border-left: 1px solid #3c3c3c; border-right: 1px solid #3c3c3c" align="center" valign="top"><br></td>
                    <td style="border-top: 1px solid #3c3c3c; border-bottom: 1px solid #3c3c3c; border-left: 1px solid #3c3c3c; border-right: 1px solid #3c3c3c" align="center" valign="top" sdnum="16393;0;&quot;Rs.&quot;#,##0"><br></td>
                    <td style="border-top: 1px solid #3c3c3c; border-bottom: 1px solid #3c3c3c; border-left: 1px solid #3c3c3c" align="center" valign="top"><br></td>
                    <td style="border-top: 1px solid #3c3c3c; border-bottom: 1px solid #3c3c3c; border-left: 1px solid #3c3c3c; border-right: 1px solid #3c3c3c" align="center" valign="top" sdval="15851.25" sdnum="16393;0;&quot;Rs.&quot;#,##0"><b>Rs.15,851</b></td>
                </tr>
                <tr>
                    <td style="border-left: 1px solid #3c3c3c; border-right: 1px solid #3c3c3c" height="15" align="center" valign="top"><br></td>
                    <td align="left" valign="top"><b><br></b></td>
                    <td align="center" valign="top"><br></td>
                    <td align="center" valign="top"><br></td>
                    <td style="border-top: 1px solid #3c3c3c; border-left: 1px solid #3c3c3c; border-right: 1px solid #3c3c3c" align="center" valign="top"><br></td>
                    <td style="border-top: 1px solid #3c3c3c; border-right: 1px solid #3c3c3c" align="center" valign="top" sdnum="16393;0;&quot;Rs.&quot;#,##0"><br></td>
                    <td style="border-top: 1px solid #3c3c3c; border-right: 1px solid #3c3c3c" align="center" valign="top"><br></td>
                    <td style="border-top: 1px solid #3c3c3c; border-right: 1px solid #3c3c3c" align="center" valign="top" sdnum="16393;0;&quot;Rs.&quot;#,##0"><b><br></b></td>
                </tr>
                <tr>
                    <td style="border-left: 1px solid #3c3c3c; border-right: 1px solid #3c3c3c" height="15" align="center" valign="top"><b><br></b></td>
                    <td align="left" valign="top"><b>LABOUR</b></td>
                    <td align="center" valign="top"><b><br></b></td>
                    <td align="center" valign="top"><b><br></b></td>
                    <td style="border-left: 1px solid #3c3c3c; border-right: 1px solid #3c3c3c" align="center" valign="top"><b><br></b></td>
                    <td style="border-right: 1px solid #3c3c3c" align="center" valign="top" sdnum="16393;0;&quot;Rs.&quot;#,##0"><b><br></b></td>
                    <td style="border-right: 1px solid #3c3c3c" align="center" valign="top"><b><br></b></td>
                    <td style="border-right: 1px solid #3c3c3c" align="center" valign="top" sdnum="16393;0;&quot;Rs.&quot;#,##0"><b><br></b></td>
                </tr>
                <tr>
                    <td style="border-left: 1px solid #3c3c3c; border-right: 1px solid #3c3c3c" height="15" align="center" valign="top" sdval="1" sdnum="16393;">1</td>
                    <td align="left" valign="top">GEAR BOX OVERHAUL</td>
                    <td align="center" valign="top"><br></td>
                    <td align="center" valign="top"><br></td>
                    <td style="border-left: 1px solid #3c3c3c; border-right: 1px solid #3c3c3c" align="center" valign="top"><br></td>
                    <td style="border-right: 1px solid #3c3c3c" align="center" valign="top" sdnum="16393;0;&quot;Rs.&quot;#,##0"><br></td>
                    <td style="border-right: 1px solid #3c3c3c" align="center" valign="top"><br></td>
                    <td style="border-right: 1px solid #3c3c3c" align="center" sdval="2800" sdnum="16393;0;&quot;Rs.&quot;#,##0">Rs.2,800</td>
                </tr>
                <tr>
                    <td style="border-left: 1px solid #3c3c3c; border-right: 1px solid #3c3c3c" height="15" align="center" valign="top" sdval="2" sdnum="16393;">2</td>
                    <td align="left" valign="top">FLYWHEEL SKIMMING &amp; MACHINING</td>
                    <td align="center" valign="top"><br></td>
                    <td align="center" valign="top"><br></td>
                    <td style="border-left: 1px solid #3c3c3c; border-right: 1px solid #3c3c3c" align="center" valign="top"><br></td>
                    <td style="border-right: 1px solid #3c3c3c" align="center" valign="top" sdnum="16393;0;&quot;Rs.&quot;#,##0"><br></td>
                    <td style="border-right: 1px solid #3c3c3c" align="center" valign="top"><br></td>
                    <td style="border-right: 1px solid #3c3c3c" align="center" sdval="800" sdnum="16393;0;&quot;Rs.&quot;#,##0">Rs.800</td>
                </tr>
                <tr>
                    <td style="border-left: 1px solid #3c3c3c; border-right: 1px solid #3c3c3c" height="15" align="center" valign="top" sdval="3" sdnum="16393;">3</td>
                    <td align="left" valign="top">WIPER ASSY OVERHAUL</td>
                    <td align="center" valign="top"><br></td>
                    <td align="center" valign="top"><br></td>
                    <td style="border-left: 1px solid #3c3c3c; border-right: 1px solid #3c3c3c" align="center" valign="top"><br></td>
                    <td style="border-right: 1px solid #3c3c3c" align="center" valign="top" sdnum="16393;0;&quot;Rs.&quot;#,##0"><br></td>
                    <td style="border-right: 1px solid #3c3c3c" align="center" valign="top"><br></td>
                    <td style="border-right: 1px solid #3c3c3c" align="center" sdval="650" sdnum="16393;0;&quot;Rs.&quot;#,##0">Rs.650</td>
                </tr>
                <tr>
                    <td style="border-left: 1px solid #3c3c3c; border-right: 1px solid #3c3c3c" height="15" align="center" valign="top"><br></td>
                    <td style="border-left: 1px solid #3c3c3c" align="left" valign="top"><br></td>
                    <td align="center" valign="top"><br></td>
                    <td align="center" valign="top"><br></td>
                    <td style="border-left: 1px solid #3c3c3c; border-right: 1px solid #3c3c3c" align="center" valign="top"><br></td>
                    <td style="border-right: 1px solid #3c3c3c" align="center" valign="top" sdnum="16393;0;&quot;Rs.&quot;#,##0"><br></td>
                    <td style="border-right: 1px solid #3c3c3c" align="center" valign="top"><br></td>
                    <td style="border-right: 1px solid #3c3c3c" align="center" sdnum="16393;0;&quot;Rs.&quot;#,##0"><br></td>
                </tr>
                <tr>
                    <td style="border-left: 1px solid #3c3c3c; border-right: 1px solid #3c3c3c" height="15" align="center" valign="top"><br></td>
                    <td style="border-top: 1px solid #3c3c3c; border-bottom: 1px solid #3c3c3c; border-left: 1px solid #3c3c3c" align="left" valign="top"><b><br></b></td>
                    <td style="border-top: 1px solid #3c3c3c; border-bottom: 1px solid #3c3c3c" align="center" valign="top"><br></td>
                    <td style="border-top: 1px solid #3c3c3c; border-bottom: 1px solid #3c3c3c" align="center" valign="top"><br></td>
                    <td style="border-top: 1px solid #3c3c3c; border-bottom: 1px solid #3c3c3c; border-left: 1px solid #3c3c3c; border-right: 1px solid #3c3c3c" align="center" valign="top"><br></td>
                    <td style="border-top: 1px solid #3c3c3c; border-bottom: 1px solid #3c3c3c; border-left: 1px solid #3c3c3c; border-right: 1px solid #3c3c3c" align="center" valign="top" sdnum="16393;0;&quot;Rs.&quot;#,##0"><br></td>
                    <td style="border-top: 1px solid #3c3c3c; border-bottom: 1px solid #3c3c3c; border-left: 1px solid #3c3c3c" align="center" valign="top"><br></td>
                    <td style="border-top: 1px solid #3c3c3c; border-bottom: 1px solid #3c3c3c; border-left: 1px solid #3c3c3c; border-right: 1px solid #3c3c3c" align="center" valign="top" sdval="4250" sdnum="16393;0;&quot;Rs.&quot;#,##0"><b>Rs.4,250</b></td>
                </tr>
                <tr>
                    <td style="border-left: 1px solid #3c3c3c; border-right: 1px solid #3c3c3c" height="15" align="center" valign="top"><br></td>
                    <td style="border-top: 1px solid #3c3c3c; border-bottom: 1px solid #3c3c3c; border-left: 1px solid #3c3c3c" align="left" valign="top"><br></td>
                    <td style="border-top: 1px solid #3c3c3c; border-bottom: 1px solid #3c3c3c" align="center" valign="top"><br></td>
                    <td style="border-top: 1px solid #3c3c3c; border-bottom: 1px solid #3c3c3c" align="center" valign="top"><b>Service Tax 14%</b></td>
                    <td style="border-top: 1px solid #3c3c3c; border-bottom: 1px solid #3c3c3c; border-left: 1px solid #3c3c3c; border-right: 1px solid #3c3c3c" align="center" valign="top"><br></td>
                    <td style="border-top: 1px solid #3c3c3c; border-bottom: 1px solid #3c3c3c; border-left: 1px solid #3c3c3c; border-right: 1px solid #3c3c3c" align="center" valign="top" sdnum="16393;0;&quot;Rs.&quot;#,##0"><br></td>
                    <td style="border-top: 1px solid #3c3c3c; border-bottom: 1px solid #3c3c3c; border-left: 1px solid #3c3c3c" align="center" valign="top"><br></td>
                    <td style="border-top: 1px solid #3c3c3c; border-bottom: 1px solid #3c3c3c; border-left: 1px solid #3c3c3c; border-right: 1px solid #3c3c3c" align="center" valign="top" sdval="595" sdnum="16393;0;&quot;Rs.&quot;#,##0">Rs.595</td>
                </tr>
                <tr>
                    <td style="border-left: 1px solid #3c3c3c; border-right: 1px solid #3c3c3c" height="15" align="center" valign="top"><br></td>
                    <td style="border-top: 1px solid #3c3c3c; border-bottom: 1px solid #3c3c3c; border-left: 1px solid #3c3c3c" align="left" valign="top"><b>Total Labor with Tax</b></td>
                    <td style="border-top: 1px solid #3c3c3c; border-bottom: 1px solid #3c3c3c" align="center" valign="top"><br></td>
                    <td style="border-top: 1px solid #3c3c3c; border-bottom: 1px solid #3c3c3c" align="center" valign="top"><br></td>
                    <td style="border-top: 1px solid #3c3c3c; border-bottom: 1px solid #3c3c3c; border-left: 1px solid #3c3c3c; border-right: 1px solid #3c3c3c" align="center" valign="top"><br></td>
                    <td style="border-top: 1px solid #3c3c3c; border-bottom: 1px solid #3c3c3c; border-left: 1px solid #3c3c3c; border-right: 1px solid #3c3c3c" align="center" valign="top" sdnum="16393;0;&quot;Rs.&quot;#,##0"><br></td>
                    <td style="border-top: 1px solid #3c3c3c; border-bottom: 1px solid #3c3c3c; border-left: 1px solid #3c3c3c" align="center" valign="top"><br></td>
                    <td style="border-top: 1px solid #3c3c3c; border-bottom: 1px solid #3c3c3c; border-left: 1px solid #3c3c3c; border-right: 1px solid #3c3c3c" align="center" valign="top" sdval="4845" sdnum="16393;0;&quot;Rs.&quot;#,##0"><b>Rs.4,845</b></td>
                </tr>
                <tr>
                    <td style="border-top: 1px solid #3c3c3c; border-bottom: 1px solid #3c3c3c; border-left: 1px solid #3c3c3c; border-right: 1px solid #3c3c3c" rowspan="2" height="30" align="center"><br></td>
                    <td style="border-top: 1px solid #3c3c3c; border-bottom: 1px solid #3c3c3c; border-left: 1px solid #3c3c3c; border-right: 1px solid #3c3c3c" colspan="3" rowspan="2" align="right"><label id="finalamtwords"></label><b>GRAND TOTAL</b></td>
                    <td style="border-top: 1px solid #3c3c3c; border-bottom: 1px solid #3c3c3c; border-left: 1px solid #3c3c3c; border-right: 1px solid #3c3c3c" rowspan="2" align="center"><br></td>
                    <td style="border-top: 1px solid #3c3c3c; border-bottom: 1px solid #3c3c3c; border-left: 1px solid #3c3c3c; border-right: 1px solid #3c3c3c" rowspan="2" align="center"><br></td>
                    <td style="border-top: 1px solid #3c3c3c; border-bottom: 1px solid #3c3c3c; border-left: 1px solid #3c3c3c; border-right: 1px solid #3c3c3c" rowspan="2" align="center"><br></td>
                    <td style="border-top: 1px solid #3c3c3c; border-bottom: 1px solid #3c3c3c; border-left: 1px solid #3c3c3c; border-right: 1px solid #3c3c3c" rowspan="2" align="center" sdval="20696.25" sdnum="16393;0;&quot;Rs.&quot;#,##0"><b>Rs.20,696</b></td>
                </tr>
                <tr>
                </tr>
                <tr>
                    <td style="border-top: 1px solid #3c3c3c; border-bottom: 1px solid #3c3c3c; border-left: 1px solid #3c3c3c; border-right: 1px solid #3c3c3c" colspan="8" rowspan="15" height="234" align="left" valign="top">                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        BILL No                                                                                                                                                                                                                                                                                                                                                         Company's VAT TIN             27650980309V                                                                                                                                                                                                                                                                                  Company's CST No              27650980309C                                                                                                                                                                                                                                                                                        Company's Service Tax No    AADCB0214DSD001                                                                                                                                                                                                                                                                     Company's PAN                    AADCB0214D                                                                                                                                                                                                                                                                                            Declaration                                                                                                                                                                                                                                                                                                                                                   "I/We hereby certify that my/our Registration Certificate under the Maharashtra Value Added Tax Act, 2002 is in force on the date on which the                                                                          state of the goods specified in this invoice is made by me/us and the transaction of sale covered by this Tax Invoice has been effected by me/us                                                                     and it shall be accounted for in the turnover of sales while filing of return and due tax, if payable on the sale has been paid or shall be paid.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          </td>
                </tr>
                <tr>
                </tr>
                <tr>
                </tr>
                <tr>
                </tr>
                <tr>
                </tr>
                <tr>
                </tr>
                <tr>
                </tr>
                <tr>
                </tr>
                <tr>
                </tr>
                <tr>
                </tr>
                <tr>
                </tr>
                <tr>
                </tr>
                <tr>
                </tr>
                <tr>
                </tr>
                <tr>
                </tr>
                <tr>
                    <td style="border-top: 1px solid #3c3c3c; border-bottom: 1px solid #3c3c3c; border-left: 1px solid #3c3c3c; border-right: 1px solid #3c3c3c" colspan="4" rowspan="4" height="66" align="left">Requested jobs performed satisfactorily and vehicle received in good condition.</td>
                </tr>
                <tr>
                </tr>
                <tr>
                </tr>
                <tr>
                    <td style="border-bottom: 1px solid #3c3c3c; border-left: 1px solid #3c3c3c; border-right: 1px solid #3c3c3c" colspan="4" align="right">Authorised Signatory</td>
                </tr>
            </tbody></table>
                 </div>
            </div>
        </div>
        <!-- ************************************************************************** -->
<!-- email comments dialog code begin here-->
        <div id="dialogmailDetail" title="Add Comments">
            <table border="0">                    
                <tr>
                    <td><strong>Date</strong></td>
                    <td>
                        <textarea name="" id="comments" rows="7" cols="50">
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


    </body></html>