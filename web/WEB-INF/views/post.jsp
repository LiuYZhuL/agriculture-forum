
<%--
  Created by IntelliJ IDEA.
  User: Liu
  Date: 2025/5/28
  Time: 19:10
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<html>
<head>
    <title>${post.title} - 帖子详情</title>
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

        .post-container {
            width: 80%;
            max-width: 1200px;
            margin: 20px auto;
            padding: 20px;
            background: #fff;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        .author-info {
            display: flex;
            align-items: center;
            margin-bottom: 20px;
        }
        .avatar {
            width: 60px;
            height: 60px;
            border-radius: 50%;
            margin-right: 15px;
        }
        .meta-info span {
            display: block;
            color: #666;
            margin: 2px 0;
        }
        .category-tag {
            background: #e8f4ff;
            color: #1890ff;
            padding: 4px 8px;
            border-radius: 4px;
            display: inline-block;
        }
        .post-content {
            margin: 20px 0;
            line-height: 1.6;
            font-size: 16px;
        }
        .attachments {
            margin-top: 30px;
            display: grid;
            grid-gap: 15px;
        }
        .attachment-img {
            max-width: 100%;
            border-radius: 4px;
        }
        .attachment-video {
            width: 100%;
            max-width: 600px;
            background: #000;
        }
    </style>
</head>
<body>
<div class="header">
    <div class="logo">帖子详情</div>
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
<div class="post-container">
    <a href="${not empty header.referer ? header.referer : pageContext.request.contextPath + '/api/dashboard'}"
       style="color: black; text-decoration: none;">
        &lt; 返回
    </a>
    <!-- 作者信息 -->
    <div class="author-info">
        <img src="${pageContext.request.contextPath}/static/uploads/img/${postUser.avatar}" class="avatar" alt="用户头像">
        <div class="meta-info">
            <span style="font-weight: bold;">${postUser.username}</span>
            <span><fmt:formatDate value="${post.createTime}" pattern="yyyy-MM-dd HH:mm"/></span>
        </div>
    </div>

    <!-- 分类标签 -->
    <div class="category-tag">${category.name}</div>

    <!-- 标题 -->
    <h1 style="margin: 20px 0;">${post.title}</h1>

    <!-- 内容 -->
    <div class="post-content">${post.content}</div>

    <!-- 附件展示 -->
    <div class="attachments">
        <c:forEach items="${attachments}" var="attach">
            <c:choose>
                <c:when test="${fn:startsWith(attach.fileType, 'image/')}">
                    <img src="${pageContext.request.contextPath}/static/uploads/attachments/img/${attach.filePath}" class="attachment-img" alt="附件图片">
                </c:when>
                <c:when test="${fn:startsWith(attach.fileType, 'video/')}">
                    <video class="attachment-video" controls>
                        <source src="${pageContext.request.contextPath}/static/uploads/attachments/video/${attach.filePath}" type="${attach.fileType}">
                    </video>
                </c:when>
            </c:choose>
        </c:forEach>
    </div>
</div>
</body>
</html>

