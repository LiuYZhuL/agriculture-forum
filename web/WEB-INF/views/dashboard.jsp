<%--
  Created by IntelliJ IDEA.
  User: Liu
  Date: 2025/5/25
  Time: 16:13
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<html>
<head>
    <title>首页</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/dashboard.css">
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
        <c:if test="${sessionScope.user != null}">
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

<c:if test="${not empty error}">
    <div style="color: red; margin-bottom: 15px;">
            ${error}
    </div>
</c:if>

<div class="main">
    <div class="knowledge">
        <div class="knowledge-header">
            <div class="knowledge-header-title"><h2>推荐知识</h2></div>
            <div>
                <a href="${pageContext.request.contextPath}/api/knowledge/more" class="btn">查看更多</a>
            </div>
        </div>
        <div class="knowledge-container">
            <c:forEach items="${knowledgeVOs}" var="knowledge" varStatus="status">
                <div class="knowledge-item"
                     onclick="location.href='${pageContext.request.contextPath}/api/knowledge/detail?postId=${knowledge.post.id}'">

                    <div class="knowledge-media">
                        <c:choose>
                            <c:when test="${fn:startsWith(knowledge.attachment.fileType, 'image/')}">
                                <img src="${pageContext.request.contextPath}/static/uploads/attachments/img/${knowledge.attachment.filePath}"
                                     alt="知识封面">
                            </c:when>
                            <c:when test="${fn:startsWith(knowledge.attachment.fileType, 'video/')}">
                                <video controls>
                                    <source src="${pageContext.request.contextPath}/static/uploads/attachments/video/${knowledge.attachment.filePath}"
                                            type="${knowledge.attachment.fileType}">
                                </video>
                            </c:when>
                        </c:choose>
                    </div>

                    <div class="knowledge-content">
                        <h3 class="knowledge-title">${knowledge.post.title}</h3>
                        <div class="knowledge-category">${knowledge.category}</div>
                        <div class="knowledge-meta">
                            <span class="author">${knowledge.user}</span>
                            <span class="date"><fmt:formatDate value="${knowledge.post.createTime}" pattern="yyyy-MM-dd"/></span>
                        </div>
                        <div class="knowledge-stats">
                            <span>👍 ${knowledge.likeCount}</span>
                            <span>⭐ ${knowledge.collectionCount}</span>
                            <span>👁️ ${knowledge.viewCount}</span>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </div>
    </div>

    <div class="post">
        <div class="post-header">
            <div class="post-header-title"><h2>推荐帖子</h2></div>
            <div>
                <a href="${pageContext.request.contextPath}/api/post/more" class="btn">查看更多</a>
            </div>
        </div>
        <div class="post-content">
            <c:forEach items="${postVOs}" var="postvo">
                <div class="post-item" onclick="location.href='${pageContext.request.contextPath}/api/post/detail?postId=${postvo.post.id}'">
                    <div class="post-left">
                        <h3 class="post-title">${postvo.post.title}</h3>
                        <div class="post-meta">
                            <span class="post-author">${postvo.user}</span>
                            <span class="post-category">${postvo.category}</span>
                        </div>
                        <div class="post-summary">
                                ${fn:substring(postvo.post.content, 0, 100)}...
                        </div>
                        <div class="post-stats">
                            <span>👁️ ${postvo.viewCount}</span>
                            <span>👍 ${postvo.likeCount}</span>
                            <span>💬 ${postvo.commentCount}</span>
                            <span>⭐ ${postvo.collectionCount}</span>
                        </div>
                    </div>
                    <div class="post-right">
                        <c:if test="${not empty postvo.attachment}">
                            <c:choose>
                                <c:when test="${fn:startsWith(postvo.attachment.fileType, 'image/')}">
                                    <img src="${pageContext.request.contextPath}/static/uploads/attachments/img/${postvo.attachment.filePath}"
                                         class="post-media"
                                         alt="封面图"
                                         onerror="this.style.display='none'">
                                </c:when>
                                <c:when test="${fn:startsWith(postvo.attachment.fileType, 'video/')}">
                                    <video class="post-media" controls>
                                        <source src="${pageContext.request.contextPath}/static/uploads/attachments/video/${postvo.attachment.filePath}" type="${postvo.attachment.fileType}">
                                    </video>
                                </c:when>
                            </c:choose>
                        </c:if>
                    </div>
                </div>
            </c:forEach>
        </div>
    </div>
</div>

<script src="${pageContext.request.contextPath}/static/js/dashboard.js"></script>
</body>
</html>
