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
    <style>
        .header {
            background: #2c3e50;
            color: white;
            padding: 15px 30px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            box-shadow: 0 2px 5px rgba(0,0,0,0.4);
        }
        .user-info {
            font-size: 16px;
            display: flex;
            align-items: center;
        }
        /* 在home.css中添加样式 */
        .user-info img {
            width: 40px;  /* 直径=2*半径 */
            height: 40px;
            border-radius: 50%;
            object-fit: cover; /* 保持比例裁剪 */
            display: block; /* 消除图片底部间隙 */
            margin-right: 10px;
        }
    </style>
</head>
<body>
<div class="header">
    <div class="logo">首页</div>
    <div class="user-info">
        <c:if test="${sessionScope.user == null}">
            未登录
        </c:if>
        <c:if test="${sessionScope.user!= null}">
            <img src="${pageContext.request.contextPath}/static/uploads/img/${sessionScope.user.avatar}"
                 alt="头像"
                 style="width: 40px; height: 40px; object-fit: cover;">
            欢迎，${sessionScope.user.username}
        </c:if>
    </div>
</div>
<c:if test="${not empty error}">
    <div style="color: red; margin-bottom: 15px;">
            ${error}
    </div>
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
