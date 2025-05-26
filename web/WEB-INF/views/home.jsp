<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%--
  Created by IntelliJ IDEA.
  User: Liu
  Date: 2025/5/25
  Time: 15:28
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>用户中心</title>
    <style type="text/css">
        .preview { width: 150px; height: 150px; border-radius: 50%; overflow: hidden; }
        #avatarPreview { width: 100%; height: 100%; object-fit: cover; }
        .sidebar {
            background: #34495e;
        }
        .nav-menu {
            list-style: none;
            display: inline-block;
        }

        .nav-item {
            padding: 12px 20px;
            color: #ecf0f1;
            cursor: pointer;
            transition: 0.3s;
            float: left;
        }

        .nav-item:hover,
        .nav-item.active {
            background: #3a5169;
            border-top: 4px solid #2c3e50;
        }

    </style>
</head>
<body>

<h1>用户中心</h1>
<div class="sidebar">
    <ul class="nav-menu">
        <li class="nav-item active" onclick="loadContent('avatar')">我的头像</li>
        <li class="nav-item" onclick="loadContent('info')">我的信息</li>
        <li class="nav-item" onclick="loadContent('change')">修改密码</li>
        <li class="nav-item" onclick="loadContent('collect')">我的收藏</li>
        <li class="nav-item">栏目5（待开发）</li>
        <li class="nav-item">栏目6（待开发）</li>
    </ul>
</div>
    <div id="avatar" class="content-section">
        <c:if test="${not empty msgAvatar}">
            <div style="color: red; margin-bottom: 15px;">
                    ${msgAvatar}
            </div>
        </c:if>
        <form action="${pageContext.request.contextPath}/api/user/avatar" method="post"
              enctype="multipart/form-data">
            <div class="preview">
                <img id="avatarPreview"
                     src="${pageContext.request.contextPath}/static/uploads/img/${sessionScope.user.avatar}"
                     alt="当前头像">
            </div>
            <input type="file" name="avatar" accept="image/*" required
                   onchange="document.getElementById('avatarPreview').src = window.URL.createObjectURL(this.files[0])">
            <button type="submit">上传新头像</button>
        </form>
    </div>
    <div id="info" class="content-section" style="display: none;">
        <c:if test="${not empty msgUpdate}">
            <div style="color: red; margin-bottom: 15px;">
                    ${msgUpdate}
            </div>
        </c:if>
        <form action="${pageContext.request.contextPath}/api/user/update" method="post">
            <label for="username">用户名:</label>
            <input type="text" id="username" name="username" value="${sessionScope.user.username}">
            <label for="email">邮箱:</label>
            <input type="text" id="email" name="email" value="${sessionScope.user.email}">
            <input type="submit" value="修改个人信息">
        </form>
    </div>
    <div id="change" class="content-section" style="display: none;">
        <c:if test="${not empty msgChange}">
            <div style="color: red; margin-bottom: 15px;">
                    ${msgChange}
            </div>
        </c:if>
        <form action="${pageContext.request.contextPath}/api/user/change" method="post">
            <label for="password">旧密码:</label>
            <input type="password" id="password" name="password" required>
            <label for="newPassword">新密码:</label>
            <input type="password" id="newPassword" name="newPassword" required>
            <input type="submit" value="修改密码">
        </form>
    </div>
    <div id="collect" class="content-section" style="display: none;">
        <c:if test="${not empty msgCollect}">
            <div style="color: red; margin-bottom: 15px;">
                    ${msgCollect}
            </div>
        </c:if>
        <label for="collect">我的收藏（待开发）</label>
    </div>

<a href="${pageContext.request.contextPath}/api/dashboard"
   style="display: inline-block; padding: 6px 12px; background: #eee; border: 1px solid #ccc; text-decoration: none;">
    返回首页
</a>
</body>
</html>
<script>
    // 在原有script中添加
    window.onload = function() {
        const urlParams = new URLSearchParams(window.location.search);
        let activeSection = urlParams.get('activeSection');
        if(!activeSection) activeSection = "${activeSection}";
        if (activeSection) {
            loadContent(activeSection); // 调用已有的切换函数
        }
    };

    // 内容切换逻辑
    function loadContent(sectionId) {
        // 移除所有active状态
        document.querySelectorAll('.nav-item').forEach(item => {
            item.classList.remove('active');
        });

        // 隐藏所有内容区
        document.querySelectorAll('.content-section').forEach(section => {
            section.style.display = 'none';
        });

        // 显示目标内容
        document.getElementById(sectionId).style.display = 'block';
        event.target.classList.add('active');
    }
</script>