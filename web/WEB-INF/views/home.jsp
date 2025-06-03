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
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/home.css">

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
        <li class="nav-item active" data-section="avatar" onclick="loadContent('avatar')">我的头像</li>
        <li class="nav-item" data-section="avatar" onclick="loadContent('info')">我的信息</li>
        <li class="nav-item"  data-section="avatar" onclick="loadContent('change')">修改密码</li>
        <li class="nav-item" data-section="avatar" onclick="loadContent('collect')">我的收藏</li>
        <li class="nav-item"data-section="avatar"  onclick="loadContent('post')">我的发帖</li>
        <li class="nav-item" data-section="avatar" onclick="loadContent('knowledge')">我的知识</li>
        <li class="nav-item" data-section="avatar" onclick="loadContent('comment')">我的评论</li>
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
        <div class="score">
            <a href="${pageContext.request.contextPath}/api/user/score">更新积分</a>
             <div class="score-value">
                当前积分: ${sessionScope.user.score}
            </div>
            <div>
                积分获取方式：发表知识/帖子24h后, 每赞加0.01分, 收藏/评论加0.1分
            </div>
        </div>
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
        <h3>收藏的帖子</h3>
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
        <h3>收藏的知识</h3>
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
    <div id="knowledge" class="content-section" style="display: none;">
        <h2>知识列表</h2>
        <c:if test="${not empty knowledgeMsg}">
            <div style="color: ${knowledgeSuccess ? 'green' : 'red'}; margin-bottom: 15px;">${knowledgeMsg}</div>
        </c:if>
        <!-- 搜索表单 -->
        <form action="${pageContext.request.contextPath}/api/user/knowledge" method="get">
            <div class="form-group">
                <label for="ktitle">标题:</label>
                <input type="text" id="ktitle" name="ktitle" value="${selectK.title}">
                <label for="ksts">状态:</label>
                <select id="ksts" name="ksts">
                    <option value="">全部</option>
                    <option value="3" <c:if test="${selectK.sts == 3}">selected</c:if>>未审核</option>
                    <option value="4" <c:if test="${selectK.sts == 4}">selected</c:if>>已审核</option>
                    <option value="5" <c:if test="${selectK.sts == 5}">selected</c:if>>已删除</option>
                </select>
                <label for="kcategory">分类:</label>
                <select id="kcategory" name="kcategoryId">
                    <option value="">全部</option>
                    <c:forEach items="${categories}" var="category">
                        <option value="${category.id}" <c:if test="${selectPost.categoryId == category.id}">selected</c:if>>${category.name}</option>
                    </c:forEach>
                </select>
                <label for="kisTop">置顶:</label>
                <select id="kisTop" name="kisTop">
                    <option value="">全部</option>
                    <option value="0" <c:if test="${selectK.isTop == 0}">selected</c:if>>否</option>
                    <option value="1" <c:if test="${selectK.isTop == 1}">selected</c:if>>是</option>
                </select>
                <label for="kisEssence">精华:</label>
                <select id="kisEssence" name="kisEssence">
                    <option value="">全部</option>
                    <option value="0" <c:if test="${selectK.isEssence == 0}">selected</c:if>>否</option>
                    <option value="1" <c:if test="${selectK.isEssence == 1}">selected</c:if>>是</option>
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
            <c:forEach items="${pageK.list}" var="k">
                <tr>
                    <td>${k.title}</td>
                    <td>${k.category}</td>
                    <td>
                        <c:if test="${k.status == 3}">
                            <span style="color: red;">未审核</span>
                        </c:if>
                        <c:if test="${k.status == 4}">
                            <span style="color: green;">已审核</span>
                        </c:if>
                        <c:if test="${k.status == 5}">
                            <span style="color: gray;">待修改</span>
                        </c:if>
                    </td>
                    <td>
                        <c:if test="${k.isTop == 0}">
                            <span style="color: red;">否</span>
                        </c:if>
                        <c:if test="${k.isTop == 1}">
                            <span style="color: green;">是</span>
                        </c:if>
                    </td>
                    <td>
                        <c:if test="${k.isEssence == 0}">
                            <span style="color: red;">否</span>
                        </c:if>
                        <c:if test="${k.isEssence == 1}">
                            <span style="color: green;">是</span>
                        </c:if>
                    </td>
                    <td><fmt:formatDate value="${k.createTime}" pattern="yyyy-MM-dd HH:mm"/></td>
                    <td>${k.viewCount}</td>
                    <td>
                        <a href="${pageContext.request.contextPath}/api/post/show?postId=${k.id}">详情</a>
                        <a href="${pageContext.request.contextPath}/api/post/update?postId=${k.id}">修改</a>
                        <a href="${pageContext.request.contextPath}/api/knowledge/delete?postId=${k.id}">删除</a>
                    </td>
                </tr>
            </c:forEach>
            </tbody>
        </table>

        <!-- 分页导航 -->
        <div class="table-container">
            <div style="line-height: 30px;">
                当前第<span class="pageStyle">${pageK.pageNum}</span>页
                共<span class="pageStyle">${pageK.pages}</span>页
                总计<span class="pageStyle">${pageK.total}</span>条
            </div>
            <div>
                <nav aria-label="Page navigation" class="pull-right">
                    <ul class="pagination pagination-sm" style="margin: 0; display: inline-block;">
                        <li>
                            <form action="${pageContext.request.contextPath}/api/user/knowledge" method="get">
                                <input type="hidden" name="ktitle" value="${selectK.title}">
                                <input type="hidden" name="kstatus" value="${selectK.sts}">
                                <input type="hidden" name="kcategoryId" value="${selectK.categoryId}">
                                <input type="hidden" name="kisTop" value="${selectK.isTop}">
                                <input type="hidden" name="kisEssence" value="${selectK.isEssence}">
                                <input type="hidden" name="pageNum" value="1">
                                <input type="submit" value="首页" style="border: none; background: none;">
                            </form>
                        </li>
                        <c:if test="${pageK.pageNum != 1}">
                            <li>
                                <form action="${pageContext.request.contextPath}/api/user/knowledge" method="get">
                                    <input type="hidden" name="ktitle" value="${selectK.title}">
                                    <input type="hidden" name="kstatus" value="${selectK.sts}">
                                    <input type="hidden" name="kcategoryId" value="${selectK.categoryId}">
                                    <input type="hidden" name="kisTop" value="${selectK.isTop}">
                                    <input type="hidden" name="kisEssence" value="${selectK.isEssence}">
                                    <input type="hidden" name="pageNum" value="${pageK.pageNum - 1}">
                                    <input type="submit" value="上一页" style="border: none; background: none;">
                                </form>
                            </li>
                        </c:if>
                        <c:forEach items="${pageK.navigatepageNums}" var="itemPage">
                            <c:choose>
                                <c:when test="${pageK.pageNum == itemPage}">
                                    <li class="active">
                                        <form action="${pageContext.request.contextPath}/api/user/knowledge" method="get" style="background: whitesmoke">
                                            <input type="hidden" name="ktitle" value="${selectK.title}">
                                            <input type="hidden" name="kstatus" value="${selectK.sts}">
                                            <input type="hidden" name="kcategoryId" value="${selectK.categoryId}">
                                            <input type="hidden" name="kisTop" value="${selectK.isTop}">
                                            <input type="hidden" name="kisEssence" value="${selectK.isEssence}">
                                            <input type="hidden" name="pageNum" value="${itemPage}">
                                            <input type="submit" value="${itemPage}" style="border: none; background: none;">
                                        </form>
                                    </li>
                                </c:when>
                                <c:otherwise>
                                    <li>
                                        <form action="${pageContext.request.contextPath}/api/user/knowledge" method="get">
                                            <input type="hidden" name="ktitle" value="${selectK.title}">
                                            <input type="hidden" name="kstatus" value="${selectK.sts}">
                                            <input type="hidden" name="kcategoryId" value="${selectK.categoryId}">
                                            <input type="hidden" name="kisTop" value="${selectK.isTop}">
                                            <input type="hidden" name="kisEssence" value="${selectK.isEssence}">
                                            <input type="hidden" name="pageNum" value="${itemPage}">
                                            <input type="submit" value="${itemPage}" style="border: none; background: none;">
                                        </form>
                                    </li>
                                </c:otherwise>
                            </c:choose>
                        </c:forEach>
                        <c:if test="${pageK.pageNum != pageK.pages}">
                            <li>
                                <form action="${pageContext.request.contextPath}/api/user/knowledge" method="get">
                                    <input type="hidden" name="ktitle" value="${selectK.title}">
                                    <input type="hidden" name="kstatus" value="${selectK.sts}">
                                    <input type="hidden" name="kcategoryId" value="${selectK.categoryId}">
                                    <input type="hidden" name="kisTop" value="${selectK.isTop}">
                                    <input type="hidden" name="kisEssence" value="${selectK.isEssence}">
                                    <input type="hidden" name="pageNum" value="${pageK.pageNum + 1}">
                                    <input type="submit" value="下一页" style="border: none; background: none;">
                                </form>
                            </li>
                        </c:if>
                        <li>
                            <form action="${pageContext.request.contextPath}/api/user/knowledge" method="get">
                                <input type="hidden" name="ktitle" value="${selectK.title}">
                                <input type="hidden" name="kstatus" value="${selectK.sts}">
                                <input type="hidden" name="kcategoryId" value="${selectK.categoryId}">
                                <input type="hidden" name="kisTop" value="${selectK.isTop}">
                                <input type="hidden" name="kisEssence" value="${selectK.isEssence}">
                                <input type="hidden" name="pageNum" value="${pageK.pages}">
                                <input type="submit" value="尾页" style="border: none; background: none;">
                            </form>
                        </li>
                    </ul>
                </nav>
            </div>
        </div>
    </div>
    <%-- 在home.jsp的comment区块添加 --%>
    <div id="comment" class="content-section" style="display: none;">
        <h2>我的评论</h2>
        <c:if test="${not empty commentMsg}">
            <div style="color: ${commentSuccess ? 'green' : 'red'}; margin-bottom: 15px;">
                    ${commentMsg}
            </div>
        </c:if>

        <!-- 评论列表 -->
        <div class="comment-list">
            <c:forEach items="${pageComment.list}" var="comment">
                <div class="comment-item">
                    <div class="comment-header">
                        <img src="${pageContext.request.contextPath}/static/uploads/img/${sessionScope.user.avatar}"
                             class="comment-avatar"
                             alt="用户头像"
                             onerror="this.src='${pageContext.request.contextPath}/static/images/default_avatar.png'">
                        <div class="comment-info">
                            <span class="comment-username">${sessionScope.user.username}</span>
                            <span class="comment-time">
                                <fmt:formatDate value="${comment.createTime}" pattern="yyyy-MM-dd HH:mm"/>
                            </span>
                        </div>
                        <a href="${pageContext.request.contextPath}/api/comment/delete?commentId=${comment.id}"
                           class="comment-delete">删除</a>
                        <a href="${pageContext.request.contextPath}/api/post/detail?postId=${comment.postId}"
                           class="comment-link">
                            查看原帖 →
                        </a>
                    </div>
                    <div class="comment-content">
                            ${fn:escapeXml(comment.content)}
                    </div>
                </div>
            </c:forEach>
        </div>

        <!-- 分页导航 -->
        <div class="table-container">
            <div style="line-height: 30px;">
                当前第<span class="pageStyle">${pageComment.pageNum}</span>页
                共<span class="pageStyle">${pageComment.pages}</span>页
                总计<span class="pageStyle">${pageComment.total}</span>条
            </div>
            <div>
                <nav aria-label="Page navigation" class="pull-right">
                    <ul class="pagination pagination-sm" style="margin: 0; display: inline-block;">
                        <li>
                            <form action="${pageContext.request.contextPath}/api/user/comment" method="get">
                                <input type="hidden" name="pageNum" value="1">
                                <input type="submit" value="首页" style="border: none; background: none;">
                            </form>
                        </li>
                        <c:if test="${pageComment.pageNum != 1}">
                            <li>
                                <form action="${pageContext.request.contextPath}/api/user/comment" method="get">
                                    <input type="hidden" name="pageNum" value="${pageComment.pageNum - 1}">
                                    <input type="submit" value="上一页" style="border: none; background: none;">
                                </form>
                            </li>
                        </c:if>
                        <c:forEach items="${pageComment.navigatepageNums}" var="itemPage">
                            <c:choose>
                                <c:when test="${pageComment.pageNum == itemPage}">
                                    <li class="active">
                                        <form action="${pageContext.request.contextPath}/api/user/comment" method="get" style="background: whitesmoke">
                                            <input type="hidden" name="pageNum" value="${itemPage}">
                                            <input type="submit" value="${itemPage}" style="border: none; background: none;">
                                        </form>
                                    </li>
                                </c:when>
                                <c:otherwise>
                                    <li>
                                        <form action="${pageContext.request.contextPath}/api/user/comment" method="get">
                                            <input type="hidden" name="pageNum" value="${itemPage}">
                                            <input type="submit" value="${itemPage}" style="border: none; background: none;">
                                        </form>
                                    </li>
                                </c:otherwise>
                            </c:choose>
                        </c:forEach>
                        <c:if test="${pageComment.pageNum != pageComment.pages}">
                            <li>
                                <form action="${pageContext.request.contextPath}/api/user/comment" method="get">
                                    <input type="hidden" name="pageNum" value="${pageComment.pageNum + 1}">
                                    <input type="submit" value="下一页" style="border: none; background: none;">
                                </form>
                            </li>
                        </c:if>
                        <li>
                            <form action="${pageContext.request.contextPath}/api/user/comment" method="get">
                                <input type="hidden" name="pageNum" value="${pageComment.pages}">
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
<script>
    // 定义全局变量
    const DEFAULT_ACTIVE_SECTION = "${not empty activeSection ? activeSection : 'avatar'}";
</script>
<script src="${pageContext.request.contextPath}/static/js/home.js"></script>
</html>
