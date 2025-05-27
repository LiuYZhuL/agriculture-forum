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
            width: 200px;
            float: left;
            min-height: 500px;
        }
        .nav-menu {
            list-style: none;
            padding: 0;
            margin: 0;
        }
        .nav-item {
            padding: 12px 20px;
            color: #ecf0f1;
            cursor: pointer;
            transition: 0.3s;
        }
        .nav-item:hover,
        .nav-item.active {
            background: #3a5169;
            border-left: 4px solid #2c3e50;
        }
        .content-area {
            margin-left: 220px;
            padding: 20px;
        }
        .content-section {
            display: none;
            background: white;
            padding: 20px;
            border-radius: 5px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        }
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
            position: relative;
            cursor: pointer;
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
        .dropdown-menu {
            display: none;
            position: absolute;
            top: 100%;
            right: 0;
            background: white;
            min-width: 160px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.2);
            border-radius: 4px;
            z-index: 1;
        }

        .user-info:hover .dropdown-menu {
            display: block;
        }

        .dropdown-menu a {
            display: block;
            padding: 10px 15px;
            color: #333;
            text-decoration: none;
        }

        .dropdown-menu a:hover {
            background: #f5f5f5;
        }

    </style>
</head>
<body>
<div class="header">
    <div class="logo">用户中心</div>
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
<div class="sidebar">
    <ul class="nav-menu">
        <li class="nav-item active" onclick="loadContent('avatar')">我的头像</li>
        <li class="nav-item" onclick="loadContent('info')">我的信息</li>
        <li class="nav-item" onclick="loadContent('change')">修改密码</li>
        <li class="nav-item" onclick="loadContent('collect')">我的收藏（待开发）</li>
        <li class="nav-item" onclick="loadContent('post')">我的发帖（待开发）</li>
        <li class="nav-item">栏目6（待开发）</li>
    </ul>
</div>
<div class="content-area">
    <div id="avatar" class="content-section" style="display: block;">
        <c:if test="${not empty msgAvatar}">
            <div style="color: green; margin-bottom: 15px;">
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
            <div style="color:  green; margin-bottom: 15px;">
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
            <div style="color: green; margin-bottom: 15px;">
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
            <div style="color:  green; margin-bottom: 15px;">
                    ${msgCollect}
            </div>
        </c:if>
        <label for="collect">我的收藏（待开发）</label>
    </div>
    <div id="post" class="content-section" style="display: none;">
        <c:if test="${not empty msgPost}">
            <div style="color:  green; margin-bottom: 15px;">
                    ${msgPost}
            </div>
        </c:if>
        <label for="post">我的发帖（待开发）</label>
    </div>
</div>
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