<%-- 
    Document   : AddCustomer
    Created on : 18-Mar-2015, 16:37:43
    Author     : user
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Add Customer</title>
        <script>
            function customerexist() {

                var customerMobile = $("#mobilenumber").val();
                $.ajax({
                    type: 'POST',
                    url: "checkmobilenumber",
                    data: {mobilenumber: customerMobile},
                    success: function (data) {
                        if (data === "true") {
                            alert("This mobilenumber already exist");
                            return false;
                        } else {
                            $("#newcustomer").submit();
                        }
                        console.log("Hey i m true");

                        return true;

                    },
                    error: function () {

                    }
                });
            }
            $("#newcustomer").submit(function (e) {
                e.preventDefault();
                customerexist();
            });
        </script>
    </head>
    <body>
        <a href="<%=request.getHeader("referer").toString()%>" class="view">Back</a>
        <h2>Customer Create</h2>
        <br />
        <form action="addCustomer" id="newcustomer" method="POST" >        
            <table width="100%" cellpadding="5">
                <tr>
                    <td width="34%" align="left" valign="top">Customer Name</td>
                    <td width="66%" align="left" valign="top"><input type="text" name="name" id="textfield2" /></td>
                </tr>
                <tr>
                    <td width="34%" align="left" valign="top">Address</td>
                    <td width="66%" align="left" valign="top"><textarea name="address" id="address" maxlength="100" rows="4" cols="20"></textarea></td>
                </tr>
                <tr>
                    <td width="34%" align="left" valign="top">Mobile Number</td>
                    <td width="66%" align="left" valign="top"><input type="text" required="" pattern="^[789]\d{9}$" title="Please enter a valid mobilenumber" name="mobilenumber" id="mobilenumber" /></td>
                </tr>
                <tr>
                    <td width="34%" align="left" valign="top">Email</td>
                    <td width="66%" align="left" valign="top"><input type="text" required="" pattern="[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?" title="Please enter a valid email" name="email" id="textfield2" /></td>
                </tr>
                <tr>
                    <td>&nbsp;</td>
                    <td><input type="submit" value="Save" class="view3" style="cursor: pointer" />&nbsp;&nbsp;&nbsp;</td>
                </tr>
                <tr>    
                    <td>&nbsp;</td>
                    <td>&nbsp;</td>
                </tr>
            </table>
            <br>
        </form>
    </body>
</html>
