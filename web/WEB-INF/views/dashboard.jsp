<%--
  Created by IntelliJ IDEA.
  User: Liu
  Date: 2025/5/25
  Time: 16:13
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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
            height: 100%;
            background: #f5f5f5;
        }
        .post-header{
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
                </div>

                <!-- 隐藏的存储容器 -->
                <input type="file" id="hiddenImages" name="images" multiple hidden>
                <input type="file" id="hiddenVideos" name="videos" multiple hidden>

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

    <div class="post">
        <div class="post-header">
            <div class="post-header-title"><h2>推荐帖子</h2></div>
            <div>
                <a href="${pageContext.request.contextPath}/api/">查看更多</a>
            </div>
        </div>
        <div class="post-content">

        </div>
    </div>
</div>

</body>
</html>
<script>
    document.addEventListener('DOMContentLoaded', function() {
        // 存储所有选择的文件
        let allImageFiles = [];
        let allVideoFiles = [];

        // 图片输入框
        const imageInput = document.getElementById('imageInput');
        // 视频输入框
        const videoInput = document.getElementById('videoInput');
        // 隐藏的表单元素
        const hiddenImages = document.getElementById('hiddenImages');
        const hiddenVideos = document.getElementById('hiddenVideos');
        // 预览容器
        const previewContainer = document.querySelector('.upload-progress');

        // 处理文件预览
        function handleFilePreview(files, isImage) {
            Array.from(files).forEach(file => {
                const reader = new FileReader();

                reader.onload = function(e) {
                    const previewItem = document.createElement('div');
                    previewItem.className = 'preview-item';

                    // 创建媒体元素
                    const media = document.createElement(isImage ? 'img' : 'video');
                    media.className = 'preview-media';
                    media.src = e.target.result;

                    if(!isImage) {
                        media.controls = true;
                        media.style.objectFit = 'contain';
                    }

                    // 创建删除按钮
                    const removeBtn = document.createElement('button');
                    removeBtn.className = 'remove-btn';
                    removeBtn.innerHTML = '×';
                    removeBtn.onclick = () => {
                        // 从数组中移除文件
                        const fileList = isImage ? allImageFiles : allVideoFiles;
                        const index = Array.from(fileList).findIndex(f =>
                            f.name === file.name && f.size === file.size
                        );

                        if (index !== -1) {
                            fileList.splice(index, 1);
                            updateHiddenInputs();
                        }

                        // 移除预览
                        previewItem.remove();
                    };

                    // 文件信息
                    const info = document.createElement('div');
                    info.style.cssText = 'padding: 4px; font-size: 12px;';
                    info.textContent = file.name + ' (' + (file.size/1024).toFixed(2) + 'KB)';

                    previewItem.appendChild(media);
                    previewItem.appendChild(removeBtn);
                    previewItem.appendChild(info);
                    previewContainer.appendChild(previewItem);
                };

                reader.readAsDataURL(file);
            });
        }

        // 更新隐藏的输入框
        function updateHiddenInputs() {
            // 创建新的DataTransfer对象
            const imageDataTransfer = new DataTransfer();
            const videoDataTransfer = new DataTransfer();

            // 添加所有图片文件
            allImageFiles.forEach(file => {
                imageDataTransfer.items.add(file);
            });

            // 添加所有视频文件
            allVideoFiles.forEach(file => {
                videoDataTransfer.items.add(file);
            });

            // 更新隐藏input的files
            hiddenImages.files = imageDataTransfer.files;
            hiddenVideos.files = videoDataTransfer.files;
        }

        // 图片选择事件
        imageInput.addEventListener('change', function() {
            if (this.files.length > 0) {
                // 将新文件添加到数组
                allImageFiles = [...allImageFiles, ...this.files];

                // 处理预览
                handleFilePreview(this.files, true);

                // 更新隐藏input
                updateHiddenInputs();

                // 重置输入框允许再次选择
                this.value = '';
            }
        });

        // 视频选择事件
        videoInput.addEventListener('change', function() {
            if (this.files.length > 0) {
                // 将新文件添加到数组
                allVideoFiles = [...allVideoFiles, ...this.files];

                // 处理预览
                handleFilePreview(this.files, false);

                // 更新隐藏input
                updateHiddenInputs();

                // 重置输入框允许再次选择
                this.value = '';
            }
        });

        // 表单提交事件
        document.getElementById('postForm').addEventListener('submit', function() {
            // 确保隐藏input包含所有文件
            updateHiddenInputs();
        });
    });
    function autoResize(textarea) {
        textarea.style.height = 'auto';
        textarea.style.height = textarea.scrollHeight + 'px';
    }

    // 初始化时绑定事件
    document.querySelectorAll('.auto-resize').forEach(textarea => {
        // 初始化设置高度
        autoResize(textarea);

        // 绑定输入事件
        textarea.addEventListener('input', function() {
            autoResize(this);
        });

        // 处理窗口变化
        window.addEventListener('resize', () => autoResize(textarea));
    });


</script>
