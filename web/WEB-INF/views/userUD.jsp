<%--
  Created by IntelliJ IDEA.
  User: Liu
  Date: 2025/5/26
  Time: 23:06
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>管理员修改用户信息</title>
    <style>
        .preview { width: 150px; height: 150px; border-radius: 50%; overflow: hidden; }
        #avatarPreview { width: 100%; height: 100%; object-fit: cover; }

    </style>
</head>
<body>
<h1>管理员修改用户信息</h1>
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
<a href="${pageContext.request.contextPath}/api/admin/manage/user"
   style="display: inline-block; padding: 6px 12px; background: #eee; border: 1px solid #ccc; text-decoration: none;">
    返回用户列表
</a>
</body>
</html>
