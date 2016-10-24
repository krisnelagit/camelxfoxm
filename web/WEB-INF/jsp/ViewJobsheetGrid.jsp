<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%-- 
    Document   : ViewJobsheetGrid
    Created on : 01-May-2015, 17:38:26
    Author     : user
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>View Jobsheet Grid</title>
        <link rel="stylesheet" type="text/css" href="css/jquery-ui_1.css">
        <script src="js/jquery-ui.js"></script>
        <script>
            $(function () {
                $("#dialognkEditDetail").hide();
                $("#dialog").hide();

                if ('${param.isexist}' === "Yes") {
                    $("#dialog").show();
                    $("#dialog").dialog({
                        modal: true,
                        effect: 'drop',
                        show: {
                            effect: "drop"
                        },
                        hide: {
                            effect: "drop"
                        }
                    });
                }
                //on click of hard delete
                $(".email_link3").click(function (e) {
                    e.preventDefault();
                    var fsid = $(this).attr('href');
                    $("#brid").val('');
                    $("#brandname").text('');
                    $("#brid").val(fsid);
                    $("#dialognkEditDetail").dialog({
                        modal: true,
                        effect: 'drop',
                        show: {
                            effect: "drop"
                        },
                        hide: {
                            effect: "drop"
                        }
                    });

                });
            });//END FUNCTION
        </script>
        <link rel="stylesheet" type="text/css" href="css/jquery.dataTables.css">
        <script src="js/jquery.dataTables.js"></script>
        <script>
            $(document).ready(function () {
                $('#table_id').DataTable();
            });
        </script>
        <script>
            function confirmdelete(id, ob)
            {
                var res = confirm('Are you sure to delete?');
                if (res === true)
                {
                    $(ob).closest('tr').find('td').fadeOut(600,
                            function () {
                                $(ob).parents('tr:first').remove();
                            });

                    $.ajax({
                        type: "post",
                        url: "deleteTransactionrecord",
                        data: {id: id, deskname: "jobsheet", immediateup: "estimate", idcolumnname: "estimateid"
                        },
                        success: function (data) {
                        },
                        error: function () {
                        }
                    });
                }
            }
        </script>
    </head>
    <body>
        <h2>Jobsheet</h2>
        <br />
        <table class="display tablestyle" id="table_id">
            <thead>
                <tr>
                    <td>Sr. No.</td>
                    <td>Job No.</td>
                    <td>Customer Name</td>
                    <td>Car Model</td>
                    <td>Vehicle No.</td>
                    <td>&nbsp;</td>
                </tr>
            </thead>
            <tbody>
                <c:set value="1" var="count"></c:set>
                <c:forEach var="ob" items="${jobdtls}">
                    <tr>
                        <td align="left">${count}</td>
                        <td align="left">${ob.jsid}</td>
                        <td align="left">${ob.custname}</td>
                        <td align="left">${ob.carmodel}</td>
                        <td align="left">${ob.vehiclenumber}</td>
                        <td align="left">
                            <a href="viewTaskLink?jsid=${ob.jsid}"><img src="images/task.png" width="17" height="17" /></a>&nbsp;&nbsp;
                                <c:if test="${!sessionScope.USERTYPE.equals('spares')}">
                                    <c:choose>
                                        <c:when test="${ob.isinvoiceconverted=='No'}">
                                        <a href="editJobDetailsLink?jsid=${ob.jsid}"><img src="images/edit.png" width="16" height="15"></a>&nbsp;&nbsp;
                                    </c:when>
                                </c:choose>
                                <c:choose>
                                    <c:when test="${ob.enableDelete=='Yes'}">
                                        <a onclick="confirmdelete('${ob.jsid}', this);"><img src="images/delete.png" width="16" height="17" /></a>
                                        </c:when>
                                    </c:choose>
                                    <c:choose>
                                        <c:when test="${ob.isrequisitionready=='No'}">
                                        <a href="${ob.jsid}" style="cursor: pointer" class="email_link3" title="Permanent Delete"><img src="images/pdelete.png" width="16" height="17" /></a>
                                        </c:when>
                                    </c:choose>
                            </c:if>
                        </td>
                    </tr>  
                    <c:set value="${count+1}" var="count"></c:set>
                </c:forEach>                
            </tbody>
        </table>
        <!--code for password dialog begin here-->
        <div id="dialognkEditDetail" title="Enter password">
            <form action="permanentDeleteJobsheet" method="POST">        
                <table width="100%" cellpadding="5">
                    <tr>
                    <input type="hidden" name="id" id="brid" value="" />
                    <td width="34%" align="left" valign="top">Password</td>
                    <td width="66%" align="left" valign="top"><input type="password" maxlength="20" required name="password" id="brandname" value="" /></td>
                    </tr>
                    <tr>
                        <td>&nbsp;</td>
                        <td><input type="submit" value="Delete" class="view3" style="cursor: pointer" />&nbsp;&nbsp;&nbsp;</td>
                    </tr>
                    <tr>    
                        <td>&nbsp;</td>
                        <td>&nbsp;</td>
                    </tr>
                </table>
                <br>
            </form>
        </div>
        <!--code for password dialog ends! here-->
                
        <div id="dialog" title="Message">
            <br/>
            <br/>
            <center><b>Incorrect password!</b></center>                    
        </div>
    </body>
</html>
