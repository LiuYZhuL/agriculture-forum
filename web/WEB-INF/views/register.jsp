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
    <title>注册</title>
</head>
<body>
<h1>注册</h1>
<!-- 显示错误信息 -->
<c:if test="${not empty error}">
    <div style="color: red; margin-bottom: 15px;">
            ${error}
    </div>
</c:if>
<!-- 注册表单 -->
<form action="${pageContext.request.contextPath}/api/user/register" method="post">
    <label for="username">用户:</label>
    <input type="text" id="username" name="username" required value="${registerUser.username}"><br><br>

    <label for="password">密码:</label>
    <input type="password" id="password" name="password" required value="${registerUser.password}"
           pattern="^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}" title="密码至少一位字母，一位数字，长度至少8位"><br><br>
    <label for="email">邮箱:</label>
    <input type="email" id="email" name="email" required value="${registerUser.email}"><br><br>
    <input type="submit" value="注册">
</form>
<a href="${pageContext.request.contextPath}/api/user/login"
   style="display: inline-block; padding: 6px 12px; background: #eee; border: 1px solid #ccc; text-decoration: none;">
   已有账号，返回登陆
</a>
</body>
</html>
