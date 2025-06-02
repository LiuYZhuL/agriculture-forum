
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
        /* 评论容器 */
        .comments-section {
            margin-top: 40px;
        }

        .comment-item {
            border-bottom: 1px solid #eee;
            padding-bottom: 15px;
            margin-bottom: 15px;
        }

        .comment-header {
            display: flex;
            align-items: center;
            gap: 10px;
            margin-bottom: 8px;
        }

        .comment-avatar {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            object-fit: cover;
        }

        .comment-username {
            font-weight: bold;
            color: #333;
        }

        .comment-time {
            font-size: 12px;
            color: #999;
        }

        .comment-content {
            margin-left: 50px;
            margin-top: 5px;
        }

        .reply-btn {
            background: none;
            border: none;
            color: #1890ff;
            cursor: pointer;
            font-size: 14px;
            margin-left: 50px;
            margin-top: 5px;
        }

        .reply-btn:hover {
            text-decoration: underline;
        }

        .child-comments {
            margin-left: 60px;
            margin-top: 10px;
        }

        .child-comment {
            margin-bottom: 10px;
        }

        .child-comment .comment-header {
            gap: 5px;
        }

        .child-comment .comment-username {
            font-size: 14px;
        }


        /* 固定评论输入框到底部 */
        #commentInputBox {
            position: fixed;
            bottom: 0;
            left: 0;
            right: 0;
            background: white;
            padding: 10px 20px;
            box-shadow: 0 -2px 8px rgba(0, 0, 0, 0.1);
            z-index: 1000;
            transition: all 0.3s ease;
        }

        /* 防止输入框遮挡页面内容 */
        body {
            padding-bottom: 120px; /* 给固定输入框留出空间 */
        }

        #commentInputBox textarea {
            width: 100%;
            resize: none;
        }
        .action-buttons {
            margin: 20px 0;
            display: flex;
            gap: 15px;
        }

        .action-btn {
            padding: 8px 16px;
            border: none;
            border-radius: 20px;
            font-size: 14px;
            font-weight: 500;
            cursor: pointer;
            display: inline-flex;
            align-items: center;
            gap: 6px;
            transition: all 0.3s ease;
        }

        .action-btn.like {
            background-color: #e7f2ff;
            color: #1890ff;
        }

        .action-btn.like:hover {
            background-color: #d6ebff;
        }

        .action-btn.favorite {
            background-color: #fff2e8;
            color: #fa8c16;
        }

        .action-btn.favorite:hover {
            background-color: #ffe9db;
        }

        .action-btn.comment {
            background-color: #e6fffb;
            color: #13c2c2;
        }

        .action-btn.comment:hover {
            background-color: #d6f9f6;
        }

        /* 徽章数字 */
        .action-btn span {
            background-color: #fff;
            color: #666;
            padding: 2px 8px;
            border-radius: 15px;
            font-size: 12px;
            min-width: 20px;
            text-align: center;
        }
        .action-btn.like.liked {
            background-color: #d6ebff;
            color: #1890ff;
        }

        .action-btn.favorite.collected {
            background-color: #ffe9db;
            color: #fa8c16;
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
    <!-- 附件下载 -->
    <h2>附件下载:</h2>
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
    let currentPage = 1;
    let isLoading = false;

    // 滚动监听
    const scrollHandler = () => {
        const { scrollTop, scrollHeight, clientHeight } = document.documentElement;
        const threshold = 100;
        if (scrollTop + clientHeight >= scrollHeight - threshold && !isLoading) {
            loadMoreComments();
        }
    };
    window.addEventListener('scroll', scrollHandler);
    function removeScrollListener() {
        window.removeEventListener('scroll', scrollHandler); // 使用同一函数引用
    }


    async function loadMoreComments() {
        isLoading = true;
        showLoading(true);

        try {
            const response = await fetch(`${pageContext.request.contextPath}/api/comment/page?postId=${post.id}&page=`+currentPage);
            const html = await response.text();

            const tempDiv = document.createElement('div');
            tempDiv.innerHTML = html;

            // 追加评论内容
            document.getElementById('commentsContainer').insertAdjacentHTML('beforeend',
                tempDiv.innerHTML);

            // 修复分页状态判断
            const hasMoreElement = tempDiv.querySelector('#hasMore');
            const hasMore = hasMoreElement ? hasMoreElement.value === 'true' : false;
            if (!hasMore) {
                removeScrollListener();
            }
            currentPage++;

        } catch (error) {
            console.error('加载失败:', error);
        } finally {
            isLoading = false;
            showLoading(false);
        }
    }

    function showLoading(show) {
        document.getElementById('loading').style.display = show ? 'block' : 'none';
    }

    // 初始化加载
    loadMoreComments();

    const commentInputBox = document.getElementById('commentInputBox');
    const commentContent = document.getElementById('commentContent');

    let currentReplyTo = null; // 当前回复目标用户名
    let currentParentId = null; // 当前回复的目标评论 ID

    // 显示评论输入框并插入 @ 用户名
    function showChildComments(btn, username, parentId) {
        currentReplyTo = username;
        currentParentId = parentId;

        // 设置输入框内容
        commentContent.value = `@`+ username;
        commentContent.focus();

        // 显示输入框
        commentInputBox.style.display = 'block';
    }
    function showCommentInputBox() {
        commentContent.focus();
        commentInputBox.style.display = 'block';
    }

    // 提交评论
    function submitComment() {
        const content = commentContent.value.trim();
        if (!content) return;

        console.log('提交评论:', content);
        // 调用后端接口保存评论
        const params = new URLSearchParams();
        params.append('postId', '${post.id}');
        params.append('userId', '${sessionScope.user.id}');
        params.append('content', content);

        // 只有当 currentParentId 存在时才添加
        if (currentParentId !== null && currentParentId !== '') {
            params.append('parentId', currentParentId);
        }
        fetch( '${pageContext.request.contextPath}/api/comment/add', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
            },
            body: params
        }).then(() => {
            alert('评论成功！');
            window.location.reload();
        }).catch(error => {
            console.error('提交评论失败:', error);
            alert('评论失败，请稍后再试。');
        });
        // 清空并隐藏输入框
        commentContent.value = '';
        commentInputBox.style.display = 'none';

        // 重置状态
        currentReplyTo = null;
        currentParentId = null;
    }

    // 插入评论到 DOM（示例）
    function insertCommentToDOM(content, replyTo, parentId) {
        // 正确选择父评论容器
        const parentEl = document.querySelector(`[data-comment-id=`+ parentId +`]`);
        if (!parentEl) return;

        // 获取 child-comments 容器，如果没有就创建一个
        let container = parentEl.querySelector('.child-comments');
        if (!container) {
            container = document.createElement('div');
            container.className = 'child-comments';
            container.style.display = 'block'; // 显示容器
            container.style.background = '#f5f5f5';
            container.style.padding = '10px';
             container.style.marginTop = '10px';
            parentEl.appendChild(container);
        }

        // 创建子评论 DOM 元素
        const div = document.createElement('div');
        div.className = 'child-comment';

        div.innerHTML = `
        <div class="comment-header">
            <img src="${sessionScope.user.avatar}" class="comment-avatar" />
            <span class="comment-username">${sessionScope.user.username}</span>
            <span class="comment-time">刚刚</span>
        </div>
        <div class="comment-content">@` +replyTo + content +`</div>`;
        // 接口返回评论数据

    }


    // 点击非输入框区域隐藏
    document.addEventListener('click', function (event) {
        const isClickInside = commentInputBox.contains(event.target);
        const isReplyButton = event.target.classList.contains('reply-btn');
        const isCommentButton = event.target.closest('#commentBtn') !== null;

        if (!isClickInside && !isReplyButton && !isCommentButton && commentInputBox.style.display === 'block') {
            commentInputBox.style.display = 'none';
            commentContent.value = '';
            currentReplyTo = null;
            currentParentId = null;
        }
    });

    function toggleLike() {
        const postId = ${post.id};
        const btn = document.getElementById('likeBtn');
        const isLiked = btn.classList.contains('liked');

        fetch('${pageContext.request.contextPath}/api/post/like?postId=' + postId, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
            },
        })
            .then(() => {
                window.location.reload();
            })
            .catch(err => {
                console.error(err);
                alert('网络错误');
            });
    }

    function toggleFavorite() {
        const postId = ${post.id};
        const btn = document.getElementById('favoriteBtn');
        const isCollected = btn.classList.contains('collected');

        fetch('${pageContext.request.contextPath}/api/post/collect?postId=' + postId, {
            method: 'POST'
        })
            .then(() => {
                window.location.reload();
            })
            .catch(err => {
                console.error(err);
                alert('网络错误');
            });
    }


</script>
