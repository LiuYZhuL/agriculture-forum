<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<html>
<head>
    <title>重设密码</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/reset.css">
</head>
<body>

<div class="container">
    <h1>重设密码</h1>

    <!-- 提示信息 -->
    <c:if test="${not empty error}">
        <div class="message error">${error}</div>
    </c:if>
    <c:if test="${not empty newPassword}">
        <div class="message success">${newPassword}</div>
    </c:if>

    <!-- 表单 -->
    <form action="${pageContext.request.contextPath}/api/user/reset" method="post">
        <label for="username">用户名:</label>
        <input type="text" id="username" name="username" required>

        <label for="email">邮箱:</label>
        <input type="email" id="email" name="email" required>

        <label for="password">新密码:</label>
        <input type="password" id="password" name="password" required pattern="^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$"
               title="密码至少一位字母，一位数字，长度至少8位">

        <input type="submit" value="提交">
    </form>

    <!-- 返回登录链接 -->
    <a href="${pageContext.request.contextPath}/api/user/login" class="return-link">想起密码，返回登录</a>
</div>

<script src="${pageContext.request.contextPath}/static/js/reset.js"></script>

</body>
</html>
