<%--
  Created by IntelliJ IDEA.
  User: Liu
  Date: 2025/5/25
  Time: 16:13
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>首页</title>
</head>
<body>
<a href="${pageContext.request.contextPath}/api/user/register"
   style="display: inline-block; padding: 6px 12px; background: #eee; border: 1px solid #ccc; text-decoration: none;">
    前去注册
</a>

<a href="${pageContext.request.contextPath}/api/user/login"
   style="display: inline-block; padding: 6px 12px; background: #eee; border: 1px solid #ccc; text-decoration: none;">
    前去登陆
</a>
<a href="${pageContext.request.contextPath}/api/user/logout"
   style="display: inline-block; padding: 6px 12px; background: #eee; border: 1px solid #ccc; text-decoration: none;">
    登出
</a>
<a href="${pageContext.request.contextPath}/api/user/home"
   style="display: inline-block; padding: 6px 12px; background: #eee; border: 1px solid #ccc; text-decoration: none;">
    用户中心
</a>
</body>
</html>
