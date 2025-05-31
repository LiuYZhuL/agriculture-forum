<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
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
        .pagination.pagination-sm li {
            float: none; /* 移除原有浮动 */
            display: inline-flex; /* 改为弹性布局 */
            align-items: center; /* 垂直居中 */
            justify-content: center; /* 水平居中 */
            height: 30px; /* 固定高度 */
        }

        .pagination.pagination-sm form {
            height: 100%;
            display: flex;
            align-items: center;
        }

        .pagination.pagination-sm input[type="submit"] {
            padding: 0 8px;
            line-height: 30px; /* 与容器高度一致 */
        }
        .table tr th,
        .table tr td{text-align: center; padding: 10px; background-color: #f2f2f2; border: 1px solid #ddd;}
        /* 帖子项容器 */
        .post-item {
            background: white;
            border-radius: 8px;
            padding: 20px;
            margin-bottom: 20px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            display: flex;
            gap: 20px;
        }

        /* 左侧文字区 */
        .post-left {
            flex: 3;
            min-width: 0; /* 防止内容溢出 */
        }

        .post-title {
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
        <li class="nav-item" onclick="loadContent('collect')">我的收藏</li>
        <li class="nav-item" onclick="loadContent('post')">我的发帖</li>
        <li class="nav-item" onclick="loadContent('comment')">我的评论（待开发）</li>
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
        <button onclick="location.href='${pageContext.request.contextPath}/api/user/home?activeSection=collect'">查看收藏</button>
        <h2>我的收藏</h2>
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
    <div id="post" class="content-section" style="display: none;">
        <h2>帖子列表</h2>
        <c:if test="${not empty postMsg}">
            <div style="color: ${postSuccess ? 'green' : 'red'}; margin-bottom: 15px;">
                    ${postMsg}
            </div>
        </c:if>
        <!-- 搜索表单 -->
        <form action="${pageContext.request.contextPath}/api/user/post" method="get">
            <div class="form-group">
                <label for="title">标题:</label>
                <input type="text" id="title" name="title" value="${selectPost.title}">
                <label for="sts">状态:</label>
                <select id="sts" name="status">
                    <option value="">全部</option>
                    <option value="0" <c:if test="${selectPost.sts == 0}">selected</c:if>>未审核</option>
                    <option value="1" <c:if test="${selectPost.sts == 1}">selected</c:if>>已审核</option>
                    <option value="2" <c:if test="${selectPost.sts == 2}">selected</c:if>>已删除</option>
                </select>
                <label for="category">分类:</label>
                <select id="category" name="categoryId">
                    <option value="">全部</option>
                    <c:forEach items="${categories}" var="category">
                        <option value="${category.id}" <c:if test="${selectPost.categoryId == category.id}">selected</c:if>>${category.name}</option>
                    </c:forEach>
                </select>
                <label for="isTop">置顶:</label>
                <select id="isTop" name="isTop">
                    <option value="">全部</option>
                    <option value="0" <c:if test="${selectPost.isTop == 0}">selected</c:if>>否</option>
                    <option value="1" <c:if test="${selectPost.isTop == 1}">selected</c:if>>是</option>
                </select>
                <label for="isEssence">精华:</label>
                <select id="isEssence" name="isEssence">
                    <option value="">全部</option>
                    <option value="0" <c:if test="${selectPost.isEssence == 0}">selected</c:if>>否</option>
                    <option value="1" <c:if test="${selectPost.isEssence == 1}">selected</c:if>>是</option>
                </select>
                <button type="submit" class="btn btn-primary">搜索</button>
            </div>
        </form>

        <!-- 帖子表格 -->
        <table class="table">
            <thead>
            <tr>
                <th>帖子标题</th>
                <th>分类</th>
                <th>状态</th>
                <th>置顶</th>
                <th>精华</th>
                <th>发布时间</th>
                <th>浏览量</th>
                <th>操作</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach items="${pagePost.list}" var="post">
                <tr>
                    <td>${post.title}</td>
                    <td>${post.category}</td>
                    <td>
                        <c:if test="${post.status == 0}">
                            <span style="color: red;">未审核</span>
                        </c:if>
                        <c:if test="${post.status == 1}">
                            <span style="color: green;">已审核</span>
                        </c:if>
                        <c:if test="${post.status == 2}">
                            <span style="color: gray;">待修改</span>
                        </c:if>
                    </td>
                    <td>
                        <c:if test="${post.isTop == 0}">
                            <span style="color: red;">否</span>
                        </c:if>
                        <c:if test="${post.isTop == 1}">
                            <span style="color: green;">是</span>
                        </c:if>
                    </td>
                    <td>
                        <c:if test="${post.isEssence == 0}">
                            <span style="color: red;">否</span>
                        </c:if>
                        <c:if test="${post.isEssence == 1}">
                            <span style="color: green;">是</span>
                        </c:if>
                    </td>
                    <td><fmt:formatDate value="${post.createTime}" pattern="yyyy-MM-dd HH:mm"/></td>
                    <td>${post.viewCount}</td>
                    <td>
                        <a href="${pageContext.request.contextPath}/api/post/show?postId=${post.id}">详情</a>
                        <a href="${pageContext.request.contextPath}/api/post/update?postId=${post.id}">修改</a>
                        <a href="${pageContext.request.contextPath}/api/post/delete?postId=${post.id}">删除</a>
                    </td>
                </tr>
            </c:forEach>
            </tbody>
        </table>

        <!-- 分页导航 -->
        <div class="table-container">
            <div style="line-height: 30px;">
                当前第<span class="pageStyle">${pagePost.pageNum}</span>页
                共<span class="pageStyle">${pagePost.pages}</span>页
                总计<span class="pageStyle">${pagePost.total}</span>条
            </div>
            <div>
                <nav aria-label="Page navigation" class="pull-right">
                    <ul class="pagination pagination-sm" style="margin: 0; display: inline-block;">
                        <li>
                            <form action="${pageContext.request.contextPath}/api/user/post" method="get">
                                <input type="hidden" name="postId" value="${selectPost.postId}">
                                <input type="hidden" name="user" value="${selectPost.user}">
                                <input type="hidden" name="title" value="${selectPost.title}">
                                <input type="hidden" name="status" value="${selectPost.sts}">
                                <input type="hidden" name="categoryId" value="${selectPost.categoryId}">
                                <input type="hidden" name="isTop" value="${selectPost.isTop}">
                                <input type="hidden" name="isEssence" value="${selectPost.isEssence}">
                                <input type="hidden" name="pageNum" value="1">
                                <input type="submit" value="首页" style="border: none; background: none;">
                            </form>
                        </li>
                        <c:if test="${pagePost.pageNum != 1}">
                            <li>
                                <form action="${pageContext.request.contextPath}/api/user/post" method="get">
                                    <input type="hidden" name="postId" value="${selectPost.postId}">
                                    <input type="hidden" name="user" value="${selectPost.user}">
                                    <input type="hidden" name="title" value="${selectPost.title}">
                                    <input type="hidden" name="status" value="${selectPost.sts}">
                                    <input type="hidden" name="categoryId" value="${selectPost.categoryId}">
                                    <input type="hidden" name="isTop" value="${selectPost.isTop}">
                                    <input type="hidden" name="isEssence" value="${selectPost.isEssence}">
                                    <input type="hidden" name="pageNum" value="${pagePost.pageNum - 1}">
                                    <input type="submit" value="上一页" style="border: none; background: none;">
                                </form>
                            </li>
                        </c:if>
                        <c:forEach items="${pagePost.navigatepageNums}" var="itemPage">
                            <c:choose>
                                <c:when test="${pagePost.pageNum == itemPage}">
                                    <li class="active">
                                        <form action="${pageContext.request.contextPath}/api/user/post" method="get" style="background: whitesmoke">
                                            <input type="hidden" name="postId" value="${selectPost.postId}">
                                            <input type="hidden" name="user" value="${selectPost.user}">
                                            <input type="hidden" name="title" value="${selectPost.title}">
                                            <input type="hidden" name="status" value="${selectPost.sts}">
                                            <input type="hidden" name="categoryId" value="${selectPost.categoryId}">
                                            <input type="hidden" name="isTop" value="${selectPost.isTop}">
                                            <input type="hidden" name="isEssence" value="${selectPost.isEssence}">
                                            <input type="hidden" name="pageNum" value="${itemPage}">
                                            <input type="submit" value="${itemPage}" style="border: none; background: none;">
                                        </form>
                                    </li>
                                </c:when>
                                <c:otherwise>
                                    <li>
                                        <form action="${pageContext.request.contextPath}/api/user/post" method="get">
                                            <input type="hidden" name="postId" value="${selectPost.postId}">
                                            <input type="hidden" name="user" value="${selectPost.user}">
                                            <input type="hidden" name="title" value="${selectPost.title}">
                                            <input type="hidden" name="status" value="${selectPost.sts}">
                                            <input type="hidden" name="categoryId" value="${selectPost.categoryId}">
                                            <input type="hidden" name="isTop" value="${selectPost.isTop}">
                                            <input type="hidden" name="isEssence" value="${selectPost.isEssence}">
                                            <input type="hidden" name="pageNum" value="${itemPage}">
                                            <input type="submit" value="${itemPage}" style="border: none; background: none;">
                                        </form>
                                    </li>
                                </c:otherwise>
                            </c:choose>
                        </c:forEach>
                        <c:if test="${pagePost.pageNum != pagePost.pages}">
                            <li>
                                <form action="${pageContext.request.contextPath}/api/user/post" method="get">
                                    <input type="hidden" name="postId" value="${selectPost.postId}">
                                    <input type="hidden" name="user" value="${selectPost.user}">
                                    <input type="hidden" name="title" value="${selectPost.title}">
                                    <input type="hidden" name="status" value="${selectPost.sts}">
                                    <input type="hidden" name="categoryId" value="${selectPost.categoryId}">
                                    <input type="hidden" name="isTop" value="${selectPost.isTop}">
                                    <input type="hidden" name="isEssence" value="${selectPost.isEssence}">
                                    <input type="hidden" name="pageNum" value="${pagePost.pageNum + 1}">
                                    <input type="submit" value="下一页" style="border: none; background: none;">
                                </form>
                            </li>
                        </c:if>
                        <li>
                            <form action="${pageContext.request.contextPath}/api/user/post" method="get">
                                <input type="hidden" name="postId" value="${selectPost.postId}">
                                <input type="hidden" name="user" value="${selectPost.user}">
                                <input type="hidden" name="title" value="${selectPost.title}">
                                <input type="hidden" name="status" value="${selectPost.sts}">
                                <input type="hidden" name="categoryId" value="${selectPost.categoryId}">
                                <input type="hidden" name="isTop" value="${selectPost.isTop}">
                                <input type="hidden" name="isEssence" value="${selectPost.isEssence}">
                                <input type="hidden" name="pageNum" value="${pagePost.pages}">
                                <input type="submit" value="尾页" style="border: none; background: none;">
                            </form>
                        </li>
                    </ul>
                </nav>
            </div>
        </div>
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