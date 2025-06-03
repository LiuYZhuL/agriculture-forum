<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<html>
<head>
    <title>注册</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/register.css">
</head>
<body>

<div class="container">
    <h1>注册</h1>

    <!-- 错误提示 -->
    <c:if test="${not empty error}">
        <div class="message error">${error}</div>
    </c:if>

    <!-- 注册表单 -->
    <form action="${pageContext.request.contextPath}/api/user/register" method="post">
        <label for="username">用户名:</label>
        <input type="text" id="username" name="username" required value="${registerUser.username}">

        <label for="password">密码:</label>
        <input type="password" id="password" name="password" required value="${registerUser.password}"
               pattern="^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}" title="密码至少一位字母，一位数字，长度至少8位">

        <label for="email">邮箱:</label>
        <input type="email" id="email" name="email" required value="${registerUser.email}">

        <input type="submit" value="注册">
    </form>

    <!-- 返回登录链接 -->
    <a href="${pageContext.request.contextPath}/api/user/login" class="return-link">已有账号，返回登录</a>
</div>

<script src="${pageContext.request.contextPath}/static/js/register.js"></script>

</body>
</html>
