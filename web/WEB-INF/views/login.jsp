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
    <style>
        /* 全局样式 */
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f0f4f8;
            margin: 0;
            padding: 0;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
        }

        .container {
            background-color: white;
            padding: 40px;
            border-radius: 10px;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
            width: 100%;
            max-width: 400px;
            text-align: center;
        }

        h1 {
            color: #2c3e50;
            margin-bottom: 20px;
            font-size: 24px;
        }

        form {
            text-align: left;
        }

        label {
            display: block;
            font-weight: bold;
            margin-bottom: 6px;
            color: #333;
        }

        input[type="text"],
        input[type="password"] {
            width: 100%;
            padding: 10px;
            margin-bottom: 20px;
            border: 1px solid #ccc;
            border-radius: 6px;
            box-sizing: border-box;
            font-size: 14px;
            transition: border-color 0.3s ease;
        }

        input[type="text"]:focus,
        input[type="password"]:focus {
            border-color: #2c3e50;
            outline: none;
        }

        input[type="submit"] {
            width: 100%;
            padding: 12px;
            background-color: #2c3e50;
            color: white;
            border: none;
            border-radius: 6px;
            font-size: 16px;
            cursor: pointer;
            transition: background-color 0.3s ease;
        }

        input[type="submit"]:hover {
            background-color: #34495e;
        }

        .message {
            margin-bottom: 15px;
            font-size: 14px;
        }

        .error {
            color: red;
        }

        .action-link {
            display: inline-block;
            margin-top: 15px;
            padding: 8px 16px;
            background-color: #ecf0f1;
            color: #2c3e50;
            text-decoration: none;
            border-radius: 6px;
            border: 1px solid #ccc;
            transition: all 0.3s ease;
        }

        .action-link:hover {
            background-color: #dce3e5;
        }

        @media (max-width: 500px) {
            .container {
                padding: 20px;
            }

            input[type="submit"] {
                font-size: 14px;
            }
        }
    </style>
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
        <label for="username">用户名:</label>
        <input type="text" id="username" name="username" required value="${loginUser.username}">

        <label for="password">密码:</label>
        <input type="password" id="password" name="password" required value="${loginUser.password}"
               pattern="^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}" title="密码至少一位字母，一位数字，长度至少8位">

        <input type="submit" value="登录">
    </form>

    <!-- 注册 & 忘记密码链接 -->
    <a href="${pageContext.request.contextPath}/api/user/register" class="action-link">前去注册</a>
    <a href="${pageContext.request.contextPath}/api/user/reset" class="action-link">忘记密码</a>
</div>

</body>
</html>
