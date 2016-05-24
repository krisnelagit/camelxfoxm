<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%-- 
    Document   : ViewSpareRequisitionGrid
    Created on : 02-May-2015, 17:24:23
    Author     : user
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>View Spare Requisition Grid</title>
        <link rel="stylesheet" type="text/css" href="css/tabs.css">
        <link rel="stylesheet" type="text/css" href="css/jquery.dataTables.css">
        <script src="js/jquery.dataTables.js"></script>
        <script>
            $(document).ready(function () {
                $('.tablestyle').DataTable();
                $("#createpo").submit(function () {
                    var checkedAtLeastOne = false;
                    $('input[type="checkbox"]').each(function () {
                        if ($(this).is(":checked")) {
                            checkedAtLeastOne = true;
                        }
                    });

                    if (checkedAtLeastOne === false) {
                        alert("Atleast one item should be checked");
                        return checkedAtLeastOne;
                    }
                });
            });
        </script>
        <script>
            function confirmdelete(id, ob)
            {
                var res = confirm('Are you sure to delete?');
                if (res == true)
                {
                    $(ob).closest('tr').find('td').fadeOut(600,
                            function () {
                                $(ob).parents('tr:first').remove();
                            });

                    $.ajax({
                        type: "post",
                        url: "deleterecord",
                        data: {id: id, deskname: "jobsheet"
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
        <form action="createPurchaseOrderNeeded" id="createpo" method="get">
            <input class="view" type="submit" value="Create Purchase Order" />
            <h2>Estimate to P.O</h2>
            <br />
            <ul id="tabs">
                <c:forEach var="ob" items="${branchandpartdetails}">
                    <li><a href="#" name="#${ob.branchname}">${ob.branchname}</a></li>
                    </c:forEach>
            </ul> 
            <div id="content">
                <c:forEach var="oc" items="${branchandpartdetails}">
                <div id="${oc.branchname}">
                    <table class="display tablestyle" id="table_id">
                        <thead>
                            <tr>
                                <td>Sr. No.</td>
                                <td>Estimate No.</td>
                                <td>Part Name</td>
                                <td>Car brand</td>
                                <td>Car model</td>
                                <td>P.O created</td>
                                <td>&nbsp;</td>
                            </tr>
                        </thead>
                        <tbody>
                            <c:set value="1" var="count"></c:set>
                            <c:forEach var="ob" items="${oc.partdetails}">
                                <tr>
                                    <td align="left">${count}</td>
                                    <td align="left">${ob.estimateid}</td>
                                    <td align="left">${ob.partname}</td>
                                    <td align="left">${ob.brandname}</td>
                                    <td align="left">${ob.carmodel}</td>
                                    <td align="left">${ob.ispurchaseorder_ready}</td>
                                    <td align="left">
                                        <c:choose>
                                            <c:when test="${ob.ispurchaseorder_ready=='No'}">
                                                <input type="checkbox" name="cpiplusjobno" value="${ob.cpiid}*${ob.id}" />
                                            </c:when>
                                        </c:choose>                                
                                    </td>
                                </tr>
                            </c:forEach>                
                        </tbody>
                    </table>
                </div>
                </c:forEach>
        </form>
        <script>

            function resetTabs() {

                $("#content > div").hide(); //Hide all content

                $("#tabs a").attr("id", ""); //Reset id's      

            }



            var myUrl = window.location.href; //get URL

            var myUrlTab = myUrl.substring(myUrl.indexOf("#")); // For localhost/tabs.html#tab2, myUrlTab = #tab2     

            var myUrlTabName = myUrlTab.substring(0, 4); // For the above example, myUrlTabName = #tab



            (function () {

                $("#content > div").hide(); // Initially hide all content

                $("#tabs li:first a").attr("id", "current"); // Activate first tab

                $("#content > div:first").fadeIn(); // Show first tab content



                $("#tabs a").on("click", function (e) {

                    e.preventDefault();

                    if ($(this).attr("id") == "current") { //detection for current tab

                        return

                    }

                    else {

                        resetTabs();

                        $(this).attr("id", "current"); // Activate this

                        $($(this).attr('name')).fadeIn(); // Show content for current tab

                    }

                });



                for (i = 1; i <= $("#tabs li").length; i++) {

                    if (myUrlTab == myUrlTabName + i) {

                        resetTabs();

                        $("a[name='" + myUrlTab + "']").attr("id", "current"); // Activate url tab

                        $(myUrlTab).fadeIn(); // Show url tab content        

                    }

                }

            })()

        </script>  
    </body>
</html>
