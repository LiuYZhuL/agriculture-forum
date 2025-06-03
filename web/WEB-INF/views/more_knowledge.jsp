<%--
  Created by IntelliJ IDEA.
  User: Liu
  Date: 2025/6/2
  Time: 12:00
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>更多知识</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/more_knowledge.css">

</head>
<body>
<div class="header">
    <div class="logo">更多知识</div>
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

<div class="main">
    <c:if test="${not empty sessionScope.user}">
        <div class="post-action">
            <H2>发布知识</H2>
            <form action="${pageContext.request.contextPath}/api/knowledge/add" method="post" enctype="multipart/form-data" id="postForm">
                <!-- 表单项容器 -->
                <div class="form-group">
                    <input type="text" name="title" class="form-input" placeholder="标题">
                </div>

                <div class="form-group">
                    <textarea name="content" class="form-input auto-resize" placeholder="内容"></textarea>
                </div>

                <!-- 文件上传 -->
                <div class="media-upload">
                    <label class="upload-btn">
                        <input type="file" id="imageInput" accept="image/*" multiple hidden>
                        <span>添加图片</span>
                    </label>
                    <label class="upload-btn">
                        <input type="file" id="videoInput" accept="video/*" multiple hidden>
                        <span>添加视频</span>
                    </label>
                    <label class="upload-btn">
                        <input type="file" id="fileInput" accept=".doc,.docx,application/msword,application/vnd.openxmlformats-officedocument.wordprocessingml.document,
                                                                  .ppt,.pptx,application/vnd.ms-powerpoint,application/vnd.openxmlformats-officedocument.presentationml.presentation,
                                                                  .xls,.xlsx,application/vnd.ms-excel,application/vnd.openxmlformats-officedocument.spreadsheetml.sheet,
                                                                  .pdf,application/pdf,
                                                                  .zip,application/zip,
                                                                  .7z,application/x-7z-compressed"
                               multiple hidden>
                        <span>添加附件</span>
                    </label>
                </div>


                <!-- 隐藏的存储容器 -->
                <input type="file" id="hiddenImages" name="images" multiple hidden>
                <input type="file" id="hiddenVideos" name="videos" multiple hidden>
                <input type="file" id="hiddenFiles" name="files" multiple hidden>

                <div class="form-group">
                    <select name="categoryId" class="form-input">
                        <c:forEach items="${categories}" var="category">
                            <option value="${category.id}">${category.name}</option>
                        </c:forEach>
                    </select>
                </div>

                <div class="upload-progress"></div>

                <button type="submit" class="submit-btn">发布</button>
            </form>
        </div>
    </c:if>
    <div class="search-container">
        <form id="searchForm" class="search-form" onsubmit="return false;">
            <input type="text" name="keyword" class="search-input" placeholder="输入关键词...">
            <select name="categoryId" class="search-input">
                <option value="">全部分类</option>
                <c:forEach items="${categories}" var="category">
                    <option value="${category.id}">${category.name}</option>
                </c:forEach>
            </select>
            <button type="button" onclick="performSearch()" class="search-btn">搜索</button>
        </form>
    </div>

    <div class="knowledge-container" id="knowledgeContainer"></div>
    <div id="loading" class="loading-spinner"></div>
</div>
<script src="${pageContext.request.contextPath}/static/js/more_knowledge.js"></script>
</body>
</html>

<script>
    var baseUrl = "${pageContext.request.contextPath}";
</script>

