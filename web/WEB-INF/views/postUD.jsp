<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%--
  Created by IntelliJ IDEA.
  User: Liu
  Date: 2025/5/31
  Time: 1:03
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>修改帖子信息</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/postUD.css">

</head>
<body>
<div class="header">
    <div class="logo">修改</div>
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
<div class="post-action">
    <a href="${not empty header.referer ? header.referer : pageContext.request.contextPath + '/api/dashboard'}"
       style="color: black; text-decoration: none;">
        &lt; 返回
    </a>
    <H2>修改</H2>
    <form action="${pageContext.request.contextPath}/api/post/update" method="post" enctype="multipart/form-data" id="postForm">
        <input type="hidden" name="postId" value="${post.id}">

        <div class="form-group">
            <input type="text" name="title" class="form-input" placeholder="标题" value="${post.title}">
        </div>

        <div class="form-group">
            <textarea name="content" class="form-input auto-resize" placeholder="内容">${post.content}</textarea>
        </div>

        <!-- 原有附件展示 -->
        <div class="form-group">
            <label>已有附件：</label>
            <div class="upload-progress" id="existingAttachments">
                <c:forEach items="${attachments}" var="attach">
                    <div class="preview-item">
                        <c:choose>
                            <c:when test="${fn:startsWith(attach.fileType, 'image/')}">
                                <img src="${pageContext.request.contextPath}/static/uploads/attachments/img/${attach.filePath}"
                                     alt="图片预览" class="preview-media">
                            </c:when>
                            <c:when test="${fn:startsWith(attach.fileType, 'video/')}">
                                <video class="preview-media" controls>
                                    <source src="${pageContext.request.contextPath}/static/uploads/attachments/video/${attach.filePath}"
                                            type="${attach.fileType}">
                                </video>
                            </c:when>
                            <c:otherwise>
                                <div class="file-preview">
                                    <i class="file-icon">📁</i>
                                    <div class="file-info">
                                        <div class="file-name">${attach.filePath}</div>
                                        <div class="file-type">${fn:toLowerCase(attach.fileType)}</div>
                                    </div>
                                </div>
                            </c:otherwise>
                        </c:choose>
                        <button type="button" class="remove-btn" onclick="removeAttachment(this, ${attach.id})">X</button>
                    </div>
                </c:forEach>
            </div>
        </div>

        <!-- 多媒体上传 -->
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
                <input type="file" id="fileInput"
                       accept=".doc,.docx,.ppt,.pptx,.xls,.xlsx,.pdf,.zip,.7z"
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
                    <option value="${category.id}" ${category.id == post.categoryId ? 'selected' : ''}>${category.name}</option>
                </c:forEach>
            </select>
        </div>

        <div class="upload-progress"></div>

        <button type="submit" class="submit-btn">修改</button>
    </form>
</div>
</body>
</html>
<script src="${pageContext.request.contextPath}/static/js/postUD.js"></script>

