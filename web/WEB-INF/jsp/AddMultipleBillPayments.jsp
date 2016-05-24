<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%-- 
    Document   : ViewPaymentDetails
    Created on : 08-Jun-2015, 17:57:33
    Author     : user
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>View Payment Details</title>             
        <link href="css/csstable.css" rel="stylesheet" type="text/css" /> 
        <link href="css/jquery-ui_1.css" rel="stylesheet" type="text/css" />
        <script src="js/jquery-ui.js"></script>
        <script>
            $(document).ready(function () {
                $("#mode").change();
                $('#bankaccount').hide();
                $('#bankaccount').prop("disabled", true);
                $(function () {
                    //payment mode slectiion code begin here start!
                    $("#bank").hide();
                    $("#online").hide();
                    $("#card").hide();
                    $("#mode").change(function () {
                        if ($("#mode").val() === "Cheque") {
                            //code for account managed here
                            $('#bankaccount').show();
                            $('#bankaccount').prop("disabled", false);
                            $('#cashaccount').hide();
                            $('#cashaccount').prop("disabled", true);
                            //code for account managed here
                            $("#bank").show();
                            $("#online").hide();
                            $("#card").hide();
                            $("#banknames").prop("required", true);
                            $("#chequeno").prop("required", true);
                            $("#chequedt").prop("required", true);

                            $("#transactionno").prop("required", false);
                            $("#transactiondt").prop("required", false);
                            $("#carddetails").prop("required", false);
                        }

                        if ($("#mode").val() === "Online") {
                            //code for account managed here
                            $('#bankaccount').show();
                            $('#bankaccount').prop("disabled", false);
                            $('#cashaccount').hide();
                            $('#cashaccount').prop("disabled", true);
                            //code for account managed here
                            $("#online").show();
                            $("#bank").hide();
                            $("#card").hide();
                            $("#transactionno").prop("required", true);
                            $("#transactiondt").prop("required", true);

                            $("#banknames").prop("required", false);
                            $("#chequeno").prop("required", false);
                            $("#carddetails").prop("required", false);
                            $("#chequedt").prop("required", false);

                        }

                        if ($("#mode").val() === "Cash") {
                            //code for account managed here
                            $('#bankaccount').hide();
                            $('#bankaccount').prop("disabled", true);
                            $('#cashaccount').show();
                            $('#cashaccount').prop("disabled", false);
                            //code for account managed here
                            $("#bank").hide();
                            $("#online").hide();
                            $("#card").hide();

                            $("#banknames").prop("required", false);
                            $("#chequeno").prop("required", false);
                            $("#chequedt").prop("required", false);
                            $("#transactionno").prop("required", false);
                            $("#transactiondt").prop("required", false);
                            $("#carddetails").prop("required", false);

                        }

                        if ($("#mode").val() === "Card") {
                            //code for account managed here
                            $('#bankaccount').show();
                            $('#bankaccount').prop("disabled", false);
                            $('#cashaccount').hide();
                            $('#cashaccount').prop("disabled", true);
                            //code for account managed here
                            $("#bank").hide();
                            $("#online").hide();
                            $("#card").show();
                            $("#carddetails").prop("required", true);

                            $("#banknames").prop("required", false);
                            $("#chequeno").prop("required", false);
                            $("#chequedt").prop("required", false);
                            $("#transactionno").prop("required", false);
                            $("#transactiondt").prop("required", false);

                        }
                    });
                    //payment mode coding end!
                });
            });
        </script>

        <script>
            $(function () {
                $(".datepicker").datepicker({dateFormat: 'yy-mm-dd'});
                var currentDate = new Date();
                $(".datepicker").datepicker("setDate", currentDate);
            });
        </script>
    </head>
    <body>
        <a href="viewbillGrid" class="view">Back</a>
        <h2>Payment details</h2>
        <br />
        <form action="insertVendorMultiplePayments" method="POST">
            <input type="hidden" name="id" value="${expensedtls.id}" />
            <input type="hidden" name="expenseid" value="${podids}" />
            <input type="hidden" name="tax" value="${podt.tax}" />
            <input type="hidden" name="taxid" value="${podt.taxid}" />
            <input type="hidden" name="status" value="Approved" />
            <input type="hidden" name="tax_applicable" value="normal" />
            <input type="hidden" name="subadminapproval" value="Approved" />
            <input type="hidden" name="acceptance" value="Approved" />
            <table width="100%" cellpadding="5">
                <tr>
                    <td width="34%" align="left" valign="top">Bill No.</td>
                    <td width="66%" align="left" valign="top">
                        ${billids}
                        <input type="hidden" name="expense_billnumber" value="${billids}" />
                    </td>
                </tr>
                <tr>
                    <td width="34%" align="left" valign="top">Purchase Order No.</td>
                    <td width="66%" align="left" valign="top">
                        ${poids}
                        <input type="hidden" name="purchaseorderid" value="${poids}" />
                    </td>
                </tr>
                <tr>
                    <td width="34%" align="left" valign="top">To</td>
                    <td width="66%" align="left" valign="top">
                        ${expensedtls.vendorname}
                        <input type="hidden" name="towards" value="${expensedtls.vendorname}" />
                        <input type="hidden" name="vendorid" value="${expensedtls.vendorid}" />
                    </td>
                </tr>
                <tr>
                    <td width="34%" align="left" valign="top">Ledger Name<font color="red">*</font></td>
                    <td width="66%" align="left" valign="top">
                        <select name="ledgerid">
                            <c:forEach var="ld" items="${ledgerdtls}">
                                <option value="${ld.id}">${ld.accountname}</option>
                            </c:forEach>
                        </select>
                    </td>
                </tr>
                <tr>
                    <td width="34%" align="left" valign="top">Date</td>
                    <td width="66%" align="left" valign="top">
                        <input type="text" required="" name="expense_date" class="datepicker" id="textfield2" />
                    </td>
                </tr>
                <tr class="total">
                    <td width="34%" align="left" valign="top">Total (Rs.)</td>
                    <td width="66%" align="left" valign="top">
                        ${amount} 
                        <input type="hidden" name="total" value="${amount}" />
                    </td>
                </tr>
                <tr>
                    <td width="34%" align="left" valign="top">Narration</td>
                    <td width="66%" align="left" valign="top">
                        <textarea name="narration" rows="4" cols="20">
                        </textarea>
                    </td>
                </tr>
                <tr>
                    <td width="34%" align="left" valign="top">Payment mode<font color="red">*</font></td>
                    <td width="66%" align="left" valign="top">
                        <select name="mode" id="mode" required="">
                            <option value="Cash" selected >Cash</option>
                            <option value="Cheque">Cheque</option>
                            <option value="Online">Online</option>
                            <option value="Card">Card</option>
                        </select> 
                    </td>
                </tr>
                <tr>
                    <td width="34%" align="left" valign="top">Account</td>
                    <td width="66%" align="left" valign="top">
                        <select name="bank_accountid" id="bankaccount">
                            <c:forEach var="ld" items="${bankaccountdtls}">
                                <option value="${ld.id}">${ld.bank_name}</option>
                            </c:forEach>
                        </select>
                        <select name="bank_accountid" id="cashaccount">
                            <c:forEach var="ld" items="${cashaccountdtls}">
                                <option value="${ld.id}">${ld.bank_name}</option>
                            </c:forEach>
                        </select>
                    </td>
                </tr>
            </table>
            <table id="bank"  width="100%" cellpadding="5">
                <tr>
                    <td width="34%" align="left" valign="top">Bank name</td>
                    <td width="66%" align="left" valign="top"><input type="text" pattern="^[a-zA-Z]*$" title="Please enter a valid Bank name." maxlength="30" name="bankname" id="banknames" /></td>
                </tr>
                <tr>
                    <td width="34%" align="left" valign="top">Cheque no.</td>
                    <td width="66%" align="left" valign="top"><input type="text" maxlength="10"  name="chequenumber" id="chequeno" /></td>
                </tr>
                <tr>
                    <td width="34%" align="left" valign="top">Cheque date</td>
                    <td width="66%" align="left" valign="top">
                        <!--<input type="text" name="chequedate" class="datepicker" id="textfield2" />-->
                        <input  class="datepicker" type="text" name="chequedate" id="chequedt" />
                    </td>
                </tr>
            </table>
            <table id="online"  width="100%" cellpadding="5">
                <tr>
                    <td width="34%" align="left" valign="top">Transaction no.</td>
                    <td width="66%" align="left" valign="top"><input type="text"  name="transactionnumber" maxlength="16" id="transactionno" /></td>
                </tr>
                <tr>
                    <td width="34%" align="left" valign="top">Transaction date</td>
                    <td width="66%" align="left" valign="top"><input type="text" name="transactiondate" class="datepicker" id="transactiondt" /></td>
                </tr>
            </table>
            <table id="card"  width="100%" cellpadding="5">
                <tr>
                    <td width="34%" align="left" valign="top">Details</td>
                    <td width="66%" align="left" valign="top"><textarea name="carddetails" rows="4" maxlength="600" cols="20" id="carddetails"></textarea></td>
                </tr>
            </table>
            <table  width="100%" cellpadding="5">
                <tr>    
                    <td width="34%" align="left" valign="top">&nbsp;</td>
                    <td width="66%" align="left" valign="top"><input type="submit" value="Save" class="view3" style="cursor: pointer" />&nbsp;</td>
                </tr>
            </table>
            <br>
        </form>

        <h3>Part Details</h3>

        <!--code for showing podetails for the bills begins here-->
        <TABLE id="dataTablepod" border="0" class="CSSTableGenerator">
            <TR>
                <td width="" align="center"><strong>Part</strong></td>
                <td width="" align="center"><strong>Manufacturer</strong></td>
                <td width="" align="center"><strong>Sold</strong></td>
                <td width="" align="center"><strong>Quantity</strong></td>
                <td width="" align="center"><strong>Balance Qty.</strong></td>
            </TR>
            <c:forEach var="ob" items="${podetailsdt}">
                <TR>
                    <td align="left" valign="top">
                        ${ob.partname}
                    </td>
                    <td align="left" valign="top">
                        ${ob.mfgname}
                    </td>
                    <td align="left" valign="top">
                        ${ob.sold}
                    </td>
                    <td align="left" valign="top">
                        ${ob.in_qty}
                    </td>
                    <td align="left" valign="top">
                        ${ob.out_qty}
                    </td>
                </TR>
            </c:forEach>
        </TABLE>

        <br/>
        <br/>
        <br/>
        <!--code for showing podetails for the bills ends! here-->

    </body>
</html>
