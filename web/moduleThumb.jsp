<%
    String moduleID = request.getParameter("moduleID");
    String moduleName = request.getParameter("moduleName");
%>
<div>
    <img src="module/<%=moduleID%>/thumbnail.jpg" onerror="this.onerror=null;this.src='module/<%=moduleID%>/thumbnail.png';" alt="<%=moduleName%>">
</div>