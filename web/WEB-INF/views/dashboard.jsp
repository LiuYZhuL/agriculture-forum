<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>农业知识论坛 - 首页</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/dashboard.css">
</head>

<body>
<!-- ########## 头部导航 ########## -->
<header class="header">
    <h1 class="logo">农业知识论坛</h1>

    <nav class="user-info" aria-label="用户导航">
        <c:choose>
            <c:when test="${empty sessionScope.user}">
                <span class="login-tip">访问权限提示</span>
                <div class="dropdown-menu" role="menu">
                    <a href="${pageContext.request.contextPath}/api/user/login" role="menuitem">登录</a>
                    <a href="${pageContext.request.contextPath}/api/user/register" role="menuitem">注册</a>
                </div>
            </c:when>

            <c:otherwise>
                <img class="user-avatar"
                     src="${pageContext.request.contextPath}/static/uploads/img/${sessionScope.user.avatar}"
                     alt="${sessionScope.user.username}的头像"
                     width="40"
                     height="40">

                <span class="welcome-text">欢迎，${sessionScope.user.username}</span>

                <div class="dropdown-menu" role="menu">
                    <a href="${pageContext.request.contextPath}/api/dashboard" role="menuitem">🏠 首页</a>
                    <a href="${pageContext.request.contextPath}/api/user/home" role="menuitem">👤 用户中心</a>
                    <c:if test="${sessionScope.user.roleId == 2}">
                        <a href="${pageContext.request.contextPath}/api/admin/manage/" role="menuitem">⚙️ 管理员中心</a>
                    </c:if>
                    <hr class="menu-divider">
                    <a href="${pageContext.request.contextPath}/api/user/logout" role="menuitem">🚪 登出</a>
                </div>
            </c:otherwise>
        </c:choose>
    </nav>
</header>

<!-- ########## 错误提示 ########## -->
<c:if test="${not empty error}">
    <div class="error-message" role="alert">
        ⚠️ ${error}
    </div>
</c:if>

<!-- ########## 主体内容 ########## -->
<main class="main">
    <!-- 知识推荐板块 -->
    <section class="knowledge" aria-labelledby="knowledge-title">
        <header class="section-header">
            <h2 id="knowledge-title">📚 推荐知识</h2>
            <a href="${pageContext.request.contextPath}/api/knowledge/more"
               class="btn more-link"
               aria-label="查看全部知识文章">
                查看更多 →
            </a>
        </header>

        <div class="knowledge-grid">
            <c:forEach items="${knowledgeVOs}" var="knowledge">
                <article class="card knowledge-card"
                         onclick="location.href='${pageContext.request.contextPath}/api/knowledge/detail?postId=${knowledge.post.id}'"
                         role="article">
                    <div class="card-media">
                        <c:choose>
                            <c:when test="${fn:startsWith(knowledge.attachment.fileType, 'image/')}">
                                <img src="${pageContext.request.contextPath}/static/uploads/attachments/img/${knowledge.attachment.filePath}"
                                     alt="${knowledge.post.title}封面图"
                                     loading="lazy">
                            </c:when>
                            <c:when test="${fn:startsWith(knowledge.attachment.fileType, 'video/')}">
                                <video controls preload="metadata">
                                    <source src="${pageContext.request.contextPath}/static/uploads/attachments/video/${knowledge.attachment.filePath}"
                                            type="${knowledge.attachment.fileType}">
                                </video>
                            </c:when>
                        </c:choose>
                    </div>

                    <div class="card-body">
                        <h3 class="card-title">${knowledge.post.title}</h3>
                        <span class="category-tag">${knowledge.category}</span>
                        <div class="card-meta">
                            <span class="author">👤 ${knowledge.user}</span>
                            <time class="date" datetime="<fmt:formatDate value="${knowledge.post.createTime}" pattern="yyyy-MM-dd"/>">
                                📅 <fmt:formatDate value="${knowledge.post.createTime}" pattern="yyyy-MM-dd"/>
                            </time>
                        </div>
                        <div class="card-stats">
                            <span title="点赞数">👍 ${knowledge.likeCount}</span>
                            <span title="收藏数">⭐ ${knowledge.collectionCount}</span>
                            <span title="浏览数">👁️ ${knowledge.viewCount}</span>
                        </div>
                    </div>
                </article>
            </c:forEach>
        </div>
    </section>

    <!-- 帖子推荐板块 -->
    <section class="post" aria-labelledby="post-title">
        <header class="section-header">
            <h2 id="post-title">💬 热门讨论</h2>
            <a href="${pageContext.request.contextPath}/api/post/more"
               class="btn more-link"
               aria-label="查看全部讨论帖子">
                查看更多 →
            </a>
        </header>

        <div class="post-list">
            <c:forEach items="${postVOs}" var="postvo">
                <article class="card post-card"
                         onclick="location.href='${pageContext.request.contextPath}/api/post/detail?postId=${postvo.post.id}'"
                         role="article">
                    <div class="card-content">
                        <h3 class="card-title">${postvo.post.title}</h3>
                        <div class="post-meta">
                            <span class="author">👤 ${postvo.user}</span>
                            <span class="category-tag">${postvo.category}</span>
                        </div>
                        <p class="card-excerpt">
                                ${fn:substring(postvo.post.content, 0, 100)}...
                        </p>
                        <div class="card-stats">
                            <span title="浏览数">👁️ ${postvo.viewCount}</span>
                            <span title="点赞数">👍 ${postvo.likeCount}</span>
                            <span title="评论数">💬 ${postvo.commentCount}</span>
                            <span title="收藏数">⭐ ${postvo.collectionCount}</span>
                        </div>
                    </div>

                    <c:if test="${not empty postvo.attachment}">
                        <div class="card-media">
                            <c:choose>
                                <c:when test="${fn:startsWith(postvo.attachment.fileType, 'image/')}">
                                    <img src="${pageContext.request.contextPath}/static/uploads/attachments/img/${postvo.attachment.filePath}"
                                         alt="${postvo.post.title}封面图"
                                         loading="lazy"
                                         onerror="this.style.display='none'">
                                </c:when>
                                <c:when test="${fn:startsWith(postvo.attachment.fileType, 'video/')}">
                                    <video controls preload="metadata">
                                        <source src="${pageContext.request.contextPath}/static/uploads/attachments/video/${postvo.attachment.filePath}"
                                                type="${postvo.attachment.fileType}">
                                    </video>
                                </c:when>
                            </c:choose>
                        </div>
                    </c:if>
                </article>
            </c:forEach>
        </div>
    </section>
</main>

<script src="${pageContext.request.contextPath}/static/js/dashboard.js" defer></script>
</body>
</html>
