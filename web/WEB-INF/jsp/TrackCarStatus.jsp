<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<%-- 
    Document   : TrackCarStatus
    Created on : 23 Mar, 2016, 9:33:11 AM
    Author     : manish
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
        <link href="css/csstable2.css" rel="stylesheet" type="text/css" />
    </head>
    <body>
        <table width="56%" border="0" cellpadding="5" class="CSSTableGenerator">
    <tr>
      <td width="70%" align="left" valign="top" bgcolor="#1bb2e9" style="color:#FFF"><strong>Process</strong></td>
      <td width="30%" align="left" valign="top" bgcolor="#1bb2e9" style="color:#FFF"><strong>Status</strong></td>
    </tr>
    <tr>
      <td align="left" valign="top" bgcolor="#f4f4f4">Service Checklist ${trackdt.servicechecklist}</td>
      <td align="left" valign="top" bgcolor="#f4f4f4">
    <c:choose>
        <c:when test="${trackdt.servicechecklist=='Yes'}">
            <img src="images/done.png"/>
        </c:when>
        <c:otherwise>
            <img src="images/notdone.png"/>
        </c:otherwise>
    </c:choose>

    <c:choose>
        <c:when test="">
        </c:when>
        <c:otherwise>
        </c:otherwise>
    </c:choose>


          <input type="checkbox" name="checkbox" id="checkbox" />
        <label for="checkbox"></label>
      </td>
    </tr>
    <tr>
      <td align="left" valign="top" bgcolor="#f4f4f4">180 Point Checklist</td>
      <td align="left" valign="top" bgcolor="#f4f4f4"><input type="checkbox" name="checkbox2" id="checkbox2" /></td>
    </tr>
    <tr>
      <td align="left" valign="top" bgcolor="#f4f4f4">Estimate</td>
      <td align="left" valign="top" bgcolor="#f4f4f4"><input type="checkbox" name="checkbox3" id="checkbox3" /></td>
    </tr>
    <tr>
      <td align="left" valign="top" bgcolor="#f4f4f4">Jobsheet</td>
      <td align="left" valign="top" bgcolor="#f4f4f4"><input type="checkbox" name="checkbox4" id="checkbox4" /></td>
    </tr>
    <tr>
      <td align="left" valign="top" bgcolor="#f4f4f4">Spare Requisition</td>
      <td align="left" valign="top" bgcolor="#f4f4f4"><input type="checkbox" name="checkbox5" id="checkbox5" /></td>
    </tr>
    <tr>
      <td align="left" valign="top" bgcolor="#f4f4f4">Jobsheet Verification</td>
      <td align="left" valign="top" bgcolor="#f4f4f4"><input type="checkbox" name="checkbox5" id="checkbox5" /></td>
    </tr>
    <tr>
      <td align="left" valign="top" bgcolor="#f4f4f4">Invoice</td>
      <td align="left" valign="top" bgcolor="#f4f4f4"><input type="checkbox" name="checkbox5" id="checkbox5" /></td>
    </tr>
    <tr>
      <td align="left" valign="top" bgcolor="#f4f4f4">Cleaning</td>
      <td align="left" valign="top" bgcolor="#f4f4f4"><input type="checkbox" name="checkbox5" id="checkbox5" /></td>
    </tr>
    </table>
    </body>
</html>
