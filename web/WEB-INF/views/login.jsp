<%--
  Created by IntelliJ IDEA.
  User: Liu
  Date: 2025/5/25
  Time: 15:28
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<html>
<head>
    <title>登录</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <!-- 引入 Font Awesome 图标库 -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">

    <!-- 引入登录页专属样式 -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/login.css">
</head>
<body>

<div class="container">
    <h1>登录</h1>

    <!-- 错误提示 -->
    <c:if test="${not empty error}">
        <div class="message error">${error}</div>
    </c:if>

    <!-- 登录表单 -->
    <form action="${pageContext.request.contextPath}/api/user/login" method="post">
        <label for="username"><i class="fas fa-user"></i> 用户名:</label>
        <input type="text" id="username" name="username" required value="${loginUser.username}">

        <label for="password"><i class="fas fa-lock"></i> 密码:</label>
        <input type="password" id="password" name="password" required value="${loginUser.password}"
               pattern="^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}" title="密码至少一位字母，一位数字，长度至少8位">

        <input type="submit" value="登录">
    </form>

    <!-- 注册 & 忘记密码链接 -->
    <a href="${pageContext.request.contextPath}/api/user/register" class="action-link">前去注册</a>
    <a href="${pageContext.request.contextPath}/api/user/reset" class="action-link">忘记密码</a>
</div>

<!-- 引入登录页专属 JS（可选） -->
<script src="${pageContext.request.contextPath}/static/js/login.js"></script>

</body>
</html>
