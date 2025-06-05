<%--
  Created by IntelliJ IDEA.
  User: Liu
  Date: 2025/6/6
  Time: 0:14
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Title</title>
</head>
<body>
<c:if test="${not empty sessionScope.user}">
    <div class="post-action">
        <H2>发表帖子</H2>
        <form action="${pageContext.request.contextPath}/api/post/add" method="post" enctype="multipart/form-data" id="postForm">
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
</body>
</html>
