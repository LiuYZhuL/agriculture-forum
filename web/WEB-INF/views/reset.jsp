<%--
  Created by IntelliJ IDEA.
  User: Liu
  Date: 2025/5/25
  Time: 16:06
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>重设密码</title>
</head>
<body>
<h1>重设密码</h1>
<!-- 显示错误信息 -->
<c:if test="${not empty error}">
    <div style="color: red; margin-bottom: 15px;">
            ${error}
    </div>
</c:if>
<c:if test="${not empty newPassword}">
    <div style="color: green; margin-bottom: 15px;">
            ${newPassword}
    </div>
</c:if>
<!-- 忘记表单 -->

<form action="${pageContext.request.contextPath}/api/user/reset" method="post">
    <label for="username">Username:</label>
    <input type="text" id="username" name="username" required ><br><br>
    <label for="email">Email:</label>
    <input type="email" id="email" name="email" required ><br><br>
    <input type="submit" value="reset">
</form>


<a href="${pageContext.request.contextPath}/api/user/login"
   style="display: inline-block; padding: 6px 12px; background: #eee; border: 1px solid #ccc; text-decoration: none;">
    想起密码，返回登陆
</a>
</body>
</html>
