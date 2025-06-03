<%--
  Created by IntelliJ IDEA.
  User: Liu
  Date: 2025/6/1
  Time: 23:16
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<html>
<head>
    <title>${post.title} - 帖子详情</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/knowledge.css">
</head>
<body>
<div class="header">
    <div class="logo">知识详情</div>
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
    <div class="attachments">
        <c:forEach items="${attachments}" var="attach">
            <c:choose>
                <c:when test="${fn:startsWith(attach.fileType, 'image/')}">
                    <a href="${pageContext.request.contextPath}/static/uploads/attachments/img/${attach.filePath}" download>
                        <span class="attachment-name">${attach.filePath}</span>
                    </a>
                </c:when>
                <c:when test="${fn:startsWith(attach.fileType, 'video/')}">
                    <a href="${pageContext.request.contextPath}/static/uploads/attachments/video/${attach.filePath}" download>
                        <span class="attachment-name">${attach.filePath}</span>
                    </a>
                </c:when>
                <c:otherwise>
                    <a href="${pageContext.request.contextPath}/static/uploads/attachments/file/${attach.filePath}" download>
                        <span class="attachment-name">${attach.filePath}</span>
                    </a>
                </c:otherwise>
            </c:choose>
        </c:forEach>
    </div>
    <!-- 操作按钮 -->
    <div class="action-buttons">
        <button id="likeBtn" onclick="toggleLike()" class="action-btn like ${isLiked ? 'liked' : ''}">
            <c:if test="${isLiked}">
                👍 已点赞 <span id="likeCount">${likeCount}</span>
            </c:if>
            <c:if test="${!isLiked}">
                👍 点赞 <span id="likeCount">${likeCount}</span>
            </c:if>
        </button>

        <button id="favoriteBtn" onclick="toggleFavorite()" class="action-btn favorite ${isCollected ? 'collected' : ''}">
            <c:if test="${isCollected}">
                ⭐ 已收藏 <span id="favoriteCount">${collectionCount}</span>
            </c:if>
            <c:if test="${!isCollected}">
                ⭐ 收藏 <span id="favoriteCount">${collectionCount}</span>
            </c:if>
        </button>
        <button id="commentBtn" onclick="showCommentInputBox()" class="action-btn comment">
            💬 评论 <span id="commentCount">${commentCount}</span>
        </button>
    </div>


</div>
<div class="post-container">
    <h2>评论区:</h2>
    <!-- 评论区 -->
    <!-- 替换原有评论区 -->
    <div class="comments-section" id="commentsContainer"></div>
    <div id="loading" style="display:none;padding:20px;text-align:center;">
        <img src="${pageContext.request.contextPath}/static/images/loading.gif" width="30">
    </div>
    <!-- 评论输入框，默认隐藏 -->
    <div id="commentInputBox" style="display: none;">
        <textarea id="commentContent" placeholder="写下你的评论..." style="width: 100%; height: 80px;"></textarea>
        <button onclick="submitComment()">提交评论</button>
    </div>
</div>

</body>
</html>
<script>
    // 将 JSP 动态数据通过内联脚本注入到 JS 全局变量中
    const CONTEXT_PATH = "${pageContext.request.contextPath}";
    const POST_ID = "${post.id}";
    const USER_ID = "${sessionScope.user.id}";
</script>
<!-- 引入外部 JS 文件 -->
<script src="${pageContext.request.contextPath}/static/js/knowledge.js"></script>
