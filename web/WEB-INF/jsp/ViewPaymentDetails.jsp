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
                //code to append new rows here
                $('#irow').click(function () {
                    $('#dataTable tbody').append($("#dataTable tbody tr:last").clone());
                    $('#dataTable tbody tr:last :checkbox').attr('checked', false);
                    $('#dataTable tbody tr:last :text').attr('value', '');
                    $('#dataTable tbody tr:last #mode').change();
                    $('#dataTable tbody tr:last #newamount').val(0);
                });
            });
        </script>

        <script>
            $(function () {
                $(".datepicker").datepicker({dateFormat: 'yy-mm-dd'});
                var currentDate = new Date();
                $(".datepicker").datepicker("setDate", currentDate);
            });

            function iambatman(a) {
                var mode = $(a).val();
                if (mode === "Cheque") {
                    $(a).closest('tr').find('#bankaccount').show();
                    $(a).closest('tr').find("#bankaccount").prop("disabled", false);
                    $(a).closest('tr').find('#cashaccount').hide();
                    $(a).closest('tr').find("#cashaccount").prop("disabled", true);
                    //show cheque k fields
                    $(a).closest('tr').find('#banknames').show();
                    $(a).closest('tr').find('#chequeno').show();
                    $(a).closest('tr').find('#chequedt').show();
                    $(a).closest('tr').find('#chequeno').prop("required", true);
                    $(a).closest('tr').find('#chequedt').prop("required", true);
                    $(a).closest('tr').find('#banknames').prop("required", true);
                    //hide online k fields
                    $(a).closest('tr').find('#transactionno').hide();
                    $(a).closest('tr').find('#transactionno').prop("required", false);
                    $(a).closest('tr').find('#transactiondt').hide();
                    $(a).closest('tr').find('#transactiondt').prop("required", false);
                    //hide card k fields
                    $(a).closest('tr').find('#carddetails').hide();
                    $(a).closest('tr').find('#carddetails').prop("required", false);
                }

                if (mode === "Online") {
                    $(a).closest('tr').find('#bankaccount').show();
                    $(a).closest('tr').find("#bankaccount").prop("disabled", false);
                    $(a).closest('tr').find('#cashaccount').hide();
                    $(a).closest('tr').find("#cashaccount").prop("disabled", true);
                    //hide cheque k fields
                    $(a).closest('tr').find('#banknames').hide();
                    $(a).closest('tr').find('#chequeno').hide();
                    $(a).closest('tr').find('#chequedt').hide();
                    $(a).closest('tr').find('#chequeno').prop("required", false);
                    $(a).closest('tr').find('#chequedt').prop("required", false);
                    $(a).closest('tr').find('#banknames').prop("required", false);
                    //show online k fields
                    $(a).closest('tr').find('#transactionno').show();
                    $(a).closest('tr').find('#transactionno').prop("required", true);
                    $(a).closest('tr').find('#transactiondt').show();
                    $(a).closest('tr').find('#transactiondt').prop("required", true);
                    //hide card k fields
                    $(a).closest('tr').find('#carddetails').hide();
                    $(a).closest('tr').find('#carddetails').prop("required", false);
                }

                if (mode === "Cash") {
                    $(a).closest('tr').find('#bankaccount').hide();
                    $(a).closest('tr').find("#bankaccount").prop("disabled", true);
                    $(a).closest('tr').find('#cashaccount').show();
                    $(a).closest('tr').find("#cashaccount").prop("disabled", false);
                    //hide cheque k fields
                    $(a).closest('tr').find('#banknames').hide();
                    $(a).closest('tr').find('#chequeno').hide();
                    $(a).closest('tr').find('#chequedt').hide();
                    $(a).closest('tr').find('#chequeno').prop("required", false);
                    $(a).closest('tr').find('#chequedt').prop("required", false);
                    $(a).closest('tr').find('#banknames').prop("required", false);
                    //show online k fields
                    $(a).closest('tr').find('#transactionno').hide();
                    $(a).closest('tr').find('#transactionno').prop("required", false);
                    $(a).closest('tr').find('#transactiondt').hide();
                    $(a).closest('tr').find('#transactiondt').prop("required", false);
                    //hide card k fields
                    $(a).closest('tr').find('#carddetails').hide();
                    $(a).closest('tr').find('#carddetails').prop("required", false);
                }

                if (mode === "Card") {
                    $(a).closest('tr').find('#bankaccount').show();
                    $(a).closest('tr').find("#bankaccount").prop("disabled", false);
                    $(a).closest('tr').find('#cashaccount').hide();
                    $(a).closest('tr').find("#cashaccount").prop("disabled", true);
                    //hide cheque k fields
                    $(a).closest('tr').find('#banknames').hide();
                    $(a).closest('tr').find('#chequeno').hide();
                    $(a).closest('tr').find('#chequedt').hide();
                    $(a).closest('tr').find('#chequeno').prop("required", false);
                    $(a).closest('tr').find('#chequedt').prop("required", false);
                    $(a).closest('tr').find('#banknames').prop("required", false);
                    //show online k fields
                    $(a).closest('tr').find('#transactionno').hide();
                    $(a).closest('tr').find('#transactionno').prop("required", false);
                    $(a).closest('tr').find('#transactiondt').hide();
                    $(a).closest('tr').find('#transactiondt').prop("required", false);
                    //hide card k fields
                    $(a).closest('tr').find('#carddetails').show();
                    $(a).closest('tr').find('#carddetails').prop("required", true);
                }
            }

            function calculate() {
                console.log("i m called");
                var fin = "0";
                $('.amount').each(function () {
                    fin = Number(fin) + Number(this.value);
                });
                $("#grandtotal").val(fin);
            }

            function deleterow(a) {
                var result = confirm("Are you sure to delete?");
                if (result === true) {
                    var table = document.getElementById('dataTable');
                    var rowCount = table.rows.length;
                    if (rowCount <= 2) {
                        alert("Cannot delete all the rows."); // break;
                    } else {
                        $(a).closest('tr').remove();
                    }
                    calculate();
                }
            }

            function check() {
                var total = Number(${amount});
                var ouramount = Number(document.getElementById('grandtotal').value);
                if (ouramount !== total)
                {
                    alert("Please make a total of ${amount}");
                    return false;
                }
                return true;
            }
        </script>
    </head>
    <body>
        <a href="viewbillGrid" class="view">Back</a>
        <h2>Payment details</h2>
        <br />
        <form action="insertVendorPayments" method="POST">
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
                        ${expensedtls.expense_billnumber}
                        <input type="hidden" name="expense_billnumber" value="${expensedtls.expense_billnumber}" />
                        <input type="hidden" name="bill_date" value="${expensedtls.bill_date}" />
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
                    <td width="66%" align="left" valign="top">${amount} </td>
                </tr>
                <tr>
                    <td width="34%" align="left" valign="top">Narration</td>
                    <td width="66%" align="left" valign="top">
                        <textarea name="narration" rows="4" cols="20">
                        </textarea>
                    </td>
                </tr>
                <tr>
                    <td width="34%" align="left" valign="top">Grand total</td>
                    <td width="66%" align="left" valign="top">
                        <input type="text" name="grandtotal" id="grandtotal" readonly="" value="" />
                    </td>
                </tr>
            </table>
            <br/><TABLE id="dataTable" border="0" class="CSSTableGenerator">
                <TR>
                    <TD width="" align="left">&nbsp;</TD>
                    <td width="" align="center"><strong>Amount</strong></td>
                    <td width="" align="center"><strong>Payment mode</strong></td>
                    <td width="" align="center"><strong>Details</strong></td>
                </TR>
                <TR>
                    <td align="left" valign="top">
                        <span class="delete1" style="cursor: pointer;"><img onclick="deleterow(this);" src="images/delete.png" alt="Delete" height="20" width="20" ></span>
                    </td>
                    <td align="left" valign="top">
                        <input type="text" name="amounts" value="" class="amount" id="newamount" onkeyup="calculate()" />
                    </td>
                    <td align="left" valign="top">
                        <select name="modes" id="mode" onchange="iambatman(this);"  required="">
                            <option value="Cash" selected >Cash</option>
                            <option value="Cheque">Cheque</option>
                            <option value="Online">Online</option>
                            <option value="Card">Card</option>
                        </select> 
                    </td>
                    <td align="left" id="modeoptions" valign="top">                        
                        <select name="bank_accountids" id="bankaccount">
                            <c:forEach var="ld" items="${bankaccountdtls}">
                                <option value="${ld.id}">${ld.bank_name}</option>
                            </c:forEach>
                        </select>
                        <select name="bank_accountids" id="cashaccount">
                            <c:forEach var="ld" items="${cashaccountdtls}">
                                <option value="${ld.id}">${ld.bank_name}</option>
                            </c:forEach>
                        </select>
                        <input type="text" pattern="^[a-zA-Z]*$" title="Please enter a valid Bank name." placeholder="Enter bank name." maxlength="30" name="banknames" id="banknames">
                        <input type="text" maxlength="10"  name="chequenumbers" id="chequeno" placeholder="Enter cheque no." />
                        <input  class="datepicker" type="text" name="chequedates" id="chequedt" placeholder="Enter cheque date." />
                        <input type="text"  name="transactionnumbers" maxlength="16" id="transactionno" placeholder="Enter transaction no." />
                        <input type="text" name="transactiondates" class="datepicker" id="transactiondt" placeholder="Enter transaction date." />
                        <textarea name="carddetailss" rows="4" maxlength="600" cols="20" id="carddetails" placeholder="Enter card details."></textarea>
                    </td>
                </TR>
            </TABLE> 
            <INPUT type="button" value="Add more." id="irow" class="view3"/>
            <table  width="100%" cellpadding="5">
                <tr>    
                    <td width="34%" align="left" valign="top">&nbsp;</td>
                    <td width="66%" align="left" valign="top"><input type="submit" value="Save" onclick="return check();" class="view3" style="cursor: pointer" />&nbsp;</td>
                </tr>
            </table>
            <br>
            <input type="hidden" name="amountToPay" value="${amount}" />
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
