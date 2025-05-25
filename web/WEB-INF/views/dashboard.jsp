<%--
  Created by IntelliJ IDEA.
  User: Liu
  Date: 2025/5/25
  Time: 16:13
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>首页</title>
</head>
<body>
<h1>首页</h1>
<c:if test="${not empty error}">
    <div style="color: red; margin-bottom: 15px;">
            ${error}
    </div>
</c:if>
<c:if test="${not empty sessionScope.user}">
    <h1>欢迎 ${sessionScope.user.username} 光临！</h1>
</c:if>
<c:if test="${empty sessionScope.user}">
    <a href="${pageContext.request.contextPath}/api/user/register"
       style="display: inline-block; padding: 6px 12px; background: #eee; border: 1px solid #ccc; text-decoration: none;">
        前去注册
    </a>
    <a href="${pageContext.request.contextPath}/api/user/login"
       style="display: inline-block; padding: 6px 12px; background: #eee; border: 1px solid #ccc; text-decoration: none;">
        前去登陆
    </a>
</c:if>
<c:if test="${not empty sessionScope.user}">
    <a href="${pageContext.request.contextPath}/api/user/logout"
       style="display: inline-block; padding: 6px 12px; background: #eee; border: 1px solid #ccc; text-decoration: none;">
        登出
    </a>
</c:if>
<a href="${pageContext.request.contextPath}/api/user/home"
   style="display: inline-block; padding: 6px 12px; background: #eee; border: 1px solid #ccc; text-decoration: none;">
    用户中心
</a>
<c:if test="${not empty sessionScope.user and sessionScope.user.roleId == 2}">
    <a href="${pageContext.request.contextPath}/api/admin/manage"
       style="display: inline-block; padding: 6px 12px; background: #eee; border: 1px solid #ccc; text-decoration: none;">
        管理员中心
    </a>
</c:if>

</body>
</html>
