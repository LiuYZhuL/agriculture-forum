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
        .main{
            margin: 0 auto;
            width: 60%;
            height: auto;
            background: #f5f5f5;
        }
        .post-header,
        .knowledge-header{
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 20px;
        }
        .post-header div:last-child {
            margin-left: auto; /* 新增 */
        }
        /* 添加以下样式 */
        .post-action {
            width: 90%;
            margin: 20px auto;
            padding: 5%;
            padding-bottom: 0;

        }

        .form-group {
            margin-bottom: 15px;
        }

        .form-input {
            width: 100%;
            padding: 10px;
            border: none;
            border-bottom: 1px solid #ddd;
            background: transparent;
            resize: none;
            transition: border-color 0.3s;
        }

        .form-input:focus {
            outline: none;
            border-color: #2c3e50;
        }

        .auto-resize {
            min-height: 100px;
            height: auto; /* 移除固定高度 */
            overflow-y: hidden; /* 隐藏垂直滚动条 */
            resize: none; /* 禁用手动调整大小 */
            line-height: 1.5;
            white-space: pre-wrap;
            word-wrap: break-word;
            transition: height 0.2s ease-out; /* 添加平滑过渡效果 */
        }


        .media-upload {
            display: flex;
            gap: 10px;
            margin: 15px 0;
        }

        .upload-btn {
            cursor: pointer;
            padding: 8px 15px;
            border: 1px solid #ddd;
            border-radius: 20px;
            transition: all 0.3s;
        }

        .upload-btn:hover {
            background: #f0f0f0;
        }

        .submit-btn {
            width: 100%;
            padding: 12px;
            background: #2c3e50;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            transition: background 0.3s;
        }

        .submit-btn:hover {
            background: #34495e;
        }

        .upload-progress {
            display: flex;
            gap: 10px;
            flex-wrap: wrap;
            margin-top: 15px;
        }

        .preview-item {
            position: relative;
            height: 100px;
            border-radius: 4px;
            overflow: hidden;
            margin: 5px;
            display: inline-flex; /* 改为行内弹性布局 */
            align-items: center; /* 垂直居中 */
            background: #f8f8f8;
        }

        .preview-media {
            width: auto;
            height: 100%;
            object-fit: contain; /* 保持原始比例 */
        }

        .remove-btn {
            position: absolute;
            top: 2px;
            right: 2px;
            background: rgba(255,0,0,0.7);
            color: white;
            border: none;
            border-radius: 50%;
            cursor: pointer;
            width: 20px;
            height: 20px;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .post-content{
             margin: 20px;
        }
        /* 帖子项容器 */
        .post-item {
            background: white;
            border-radius: 8px;
            padding: 20px;
            margin-bottom: 20px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            transition: transform 0.3s;
            display: flex;
            gap: 20px;
        }

        /* 左侧文字区 */
        .post-left {
            flex: 3;
            min-width: 0; /* 防止内容溢出 */
        }

        .post-title,
        .knowledge-title {
            margin: 0 0 12px 0;
            color: #2c3e50;
            font-size: 18px;
        }

        .post-summary {
            color: #666;
            margin-bottom: 15px;
            line-height: 1.6;
            display: -webkit-box;
            -webkit-line-clamp: 3;
            -webkit-box-orient: vertical;
            overflow: hidden;
        }

        /* 统计信息 */
        .post-stats {
            display: flex;
            gap: 15px;
            font-size: 12px;
            color: #999;
        }

        .post-stats span {
            display: flex;
            align-items: center;
            gap: 4px;
        }

        /* 右侧媒体区 */
        .post-right {
            flex: 1;
            max-width: 200px;
            min-width: 120px;
        }

        .post-media {
            width: 100%;
            height: 120px;
            border-radius: 4px;
            object-fit: cover;
            background: #f8f8f8;
        }

        video.post-media {
            object-fit: contain;
            background: #000;
        }
        /* 用户和分类信息 */
        .post-meta {
            margin-bottom: 10px;
            font-size: 13px;
            color: #666;
            display: flex;
            gap: 15px;
        }

        .post-author {
            color: #2c3e50;
            font-weight: 500;
        }

        .post-category {
            padding: 2px 8px;
            background: #f0f0f0;
            border-radius: 12px;
            font-size: 12px;
        }
        .knowledge-container {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 20px;
            padding: 15px;
        }

        /* 单个知识项样式 */
        .knowledge-item {
            background: white;
            border-radius: 8px;
            overflow: hidden;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            transition: transform 0.3s;
            cursor: pointer;
        }
        .post-item:hover,
        .knowledge-item:hover{
            transform: translateY(-5px);
        }

        /* 媒体区域 */
        .knowledge-media {
            width: 100%;
            height: 200px;
            position: relative;
        }

        .knowledge-media img,
        .knowledge-media video {
            width: 100%;
            height: 100%;
            object-fit: cover;
            border-radius: 8px 8px 0 0;
        }

        /* 内容区域 */
        .knowledge-content {
            padding: 15px;
        }

        .knowledge-title {
            font-size: 16px;
            margin: 0 0 10px 0;
            color: #2c3e50;
            line-height: 1.4;
            display: -webkit-box;
            -webkit-line-clamp: 2;
            -webkit-box-orient: vertical;
            overflow: hidden;
        }

        .knowledge-category {
            font-size: 12px;
            color: #666;
            background: #f3f3f3;
            padding: 4px 8px;
            border-radius: 12px;
            display: inline-block;
            margin-bottom: 8px;
        }

        .knowledge-meta {
            font-size: 12px;
            color: #999;
            margin-bottom: 10px;
            display: flex;
            justify-content: space-between;
        }

        .knowledge-stats {
            display: flex;
            gap: 15px;
            font-size: 12px;
            color: #666;
        }

        .knowledge-stats span {
            display: flex;
            align-items: center;
            gap: 4px;
        }

        /* 响应式设计 */
        @media (max-width: 768px) {
            .knowledge-container {
                grid-template-columns: 1fr;
            }
        }
        .btn {
            display: inline-block;
            padding: 8px 16px;
            background-color: #2c3e50; /* 按钮背景色 */
            color: white; /* 文字颜色 */
            text-decoration: none; /* 去除下划线 */
            border-radius: 4px; /* 圆角 */
            font-size: 14px;
            transition: background-color 0.3s ease; /* 过渡效果 */
        }

        .btn:hover {
            background-color: #34495e; /* 鼠标悬停时的背景色 */
        }

    </style>
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

                        <%-- 媒体内容 --%>
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

                        <%-- 文字内容 --%>
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
                    <!-- 左区（文字内容） -->
                    <div class="post-left">
                        <h3 class="post-title">${postvo.post.title}</h3>
                        <!-- 新增用户和分类信息 -->
                        <div class="post-meta">
                            <span class="post-author">${postvo.user}</span>
                            <span class="post-category">${postvo.category}</span>
                        </div>
                        <div class="post-summary">
                                ${fn:substring(postvo.post.content, 0, 100)}...
                        </div>
                        <!-- 下区（统计信息） -->
                        <div class="post-stats">
                            <span>👁️ ${postvo.viewCount}</span>
                            <span>👍 ${postvo.likeCount}</span>
                            <span>💬 ${postvo.commentCount}</span>
                            <span>⭐ ${postvo.collectionCount}</span>
                        </div>
                    </div>

                    <!-- 右区（媒体内容） -->
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

</body>
</html>
<script>

    // 自动调整文本域高度（保持原有逻辑）
    const autoResize = textarea => {
        textarea.style.height = 'auto';
        textarea.style.height = textarea.scrollHeight + 'px';
    };

    document.querySelectorAll('.auto-resize').forEach(textarea => {
        autoResize(textarea);
        textarea.addEventListener('input', () => autoResize(textarea));
        window.addEventListener('resize', () => autoResize(textarea));
    });
</script>

