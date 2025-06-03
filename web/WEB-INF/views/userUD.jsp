<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>管理员修改用户信息</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/userUD.css">
</head>
<body>
<div class="header">
    <div class="logo">首页</div>
    <div class="user-info">
        <c:if test="${sessionScope.user == null}">
            <span>还未登录,来登录吧！</span>
            <div class="dropdown-menu">
                <a href="${pageContext.request.contextPath}/api/user/login">登录</a>
                <a href="${pageContext.request.contextPath}/api/user/register">注册</a>
            </div>
        </c:if>
        <c:if test="${sessionScope.user!= null}">
            <img src="${pageContext.request.contextPath}/static/uploads/img/${sessionScope.user.avatar}"
                 alt="头像"
                 style="width: 40px; height: 40px; object-fit: cover;">
            <span>欢迎，${sessionScope.user.username}</span>
            <div class="dropdown-menu">
                <a href="${pageContext.request.contextPath}/api/dashboard">首页</a>
                <a href="${pageContext.request.contextPath}/api/user/home">用户中心</a>
                <c:if test="${sessionScope.user.roleId == 2}">
                    <a href="${pageContext.request.contextPath}/api/admin/manage/">管理员中心</a>
                </c:if>
                <a href="${pageContext.request.contextPath}/api/user/logout">登出</a>
            </div>
        </c:if>
    </div>
</div>
<c:if test="${not empty param.msg}">
    <div style="color: ${param.success ? 'green' : 'red'};">${param.msg}</div>
</c:if>
<form action="${pageContext.request.contextPath}/api/admin/user/update" method="post"
      enctype="multipart/form-data">
    <input type="hidden" name="id" value="${updateUser.id}">
    <div>
        <div class="preview">
            <img id="avatarPreview"
                 src="${pageContext.request.contextPath}/static/uploads/img/${updateUser.avatar}"
                 alt="当前头像">
        </div>
        <input type="file" name="avatar" accept="image/*"
               onchange="document.getElementById('avatarPreview').src = window.URL.createObjectURL(this.files[0])">
    </div>
    <div>
        <label for="username">用户名:</label>
        <input type="text" id="username" name="username" value="${updateUser.username}">
    </div>
    <div>
        <label for="email">邮箱:</label>
        <input type="text" id="email" name="email" value="${updateUser.email}">
    </div>
    <div>
        <label for="roleId">角色：</label>
        <select name="roleId" id="roleId">
            <option value="1" ${updateUser.roleId == 1 ? 'selected' : ''}>用户</option>
            <option value="2" ${updateUser.roleId == 2 ? 'selected' : ''}>管理员</option>
        </select>
    </div>
    <div>
        <label for="status">状态：</label>
        <select name="status" id="status">
            <option value="1" ${updateUser.status == 1 ? 'selected' : ''}>启用</option>
            <option value="0" ${updateUser.status == 0 ? 'selected' : ''}>禁用</option>
        </select>
    </div>
    <input type="submit" value="修改">
</form>
<a href="${not empty header.referer ? header.referer : pageContext.request.contextPath + '/api/dashboard'}"
   style="color: black; text-decoration: none;">
    &lt; 返回
</a>
</body>
</html>
