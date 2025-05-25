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
</head>
<body>
    <h1>登录</h1>
    <!-- 显示错误信息 -->
    <c:if test="${not empty error}">
        <div style="color: red; margin-bottom: 15px;">
                ${error}
        </div>
    </c:if>
    <!-- 登录表单 -->
    <form action="${pageContext.request.contextPath}/api/user/login" method="post">
        <label for="username">Username:</label>
        <input type="text" id="username" name="username" required value="${loginUser.username}"><br><br>
        
        <label for="password">Password:</label>
        <input type="password" id="password" name="password" required value="${loginUser.password}"
               pattern="^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}" title="密码至少一位字母，一位数字，长度至少8位"><br><br>
        
        <input type="submit" value="Login">
    </form>
    <a href="${pageContext.request.contextPath}/api/user/register"
       style="display: inline-block; padding: 6px 12px; background: #eee; border: 1px solid #ccc; text-decoration: none;">
     前去注册
    </a>
</body>
</html>