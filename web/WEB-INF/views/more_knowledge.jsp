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
        /* 新增搜索样式 */
        .search-container {
            padding: 20px;
            background: #fff;
            margin: 20px auto;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            max-width: 800px;
        }

        .search-form {
            display: grid;
            grid-template-columns: 1fr auto auto;
            gap: 15px;
            align-items: center;
        }

        .search-input {
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 14px;
        }

        .search-btn {
            padding: 10px 20px;
            background: #2c3e50;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            transition: background 0.3s;
        }

        .search-btn:hover {
            background: #34495e;
        }
    </style>
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

</body>
</html>
<script>
    document.addEventListener('DOMContentLoaded', function() {
        // 统一文件存储结构
        const fileGroups = {
            image: {
                input: document.getElementById('imageInput'),
                hidden: document.getElementById('hiddenImages'),
                files: []
            },
            video: {
                input: document.getElementById('videoInput'),
                hidden: document.getElementById('hiddenVideos'),
                files: []
            },
            file: {
                input: document.getElementById('fileInput'),
                hidden: document.getElementById('hiddenFiles'),
                files: []
            }
        };

        // 预览容器
        const previewContainer = document.querySelector('.upload-progress');

        // 通用文件处理函数
        const handleFileUpload = (type, files) => {
            fileGroups[type].files = [...fileGroups[type].files, ...files];
            updateHiddenInputs(type);
            generatePreviews(type, files);
            fileGroups[type].input.value = '';
        };

        // 生成预览
        const generatePreviews = (type, files) => {
            files.forEach(file => {
                const previewItem = createPreviewElement(type, file);
                previewContainer.appendChild(previewItem);
            });
        };

        // 创建预览元素
        const createPreviewElement = (type, file) => {
            const previewItem = document.createElement('div');
            previewItem.className = 'preview-item';

            if (type === 'image' || type === 'video') {
                const reader = new FileReader();
                reader.onload = (e) => {
                    const media = type === 'image'
                        ? createImageElement(e.target.result)
                        : createVideoElement(e.target.result);
                    previewItem.appendChild(media);
                    previewItem.appendChild(createFileInfo(file));
                    previewItem.appendChild(createRemoveButton(type, file, previewItem));
                };
                reader.readAsDataURL(file);
            } else {
                previewItem.innerHTML = `
                    <div class="file-preview">
                        <i class="file-icon">📁</i>
                        <div class="file-info">
                            <div class="file-name">`+file.name+`</div>
                            <div class="file-size">`+(file.size/1024).toFixed(2)+`KB</div>
                        </div>
                        `+createRemoveButton(type, file, previewItem).outerHTML+`
                    </div>
                `;
            }

            return previewItem;
        };

        // 创建删除按钮
        const createRemoveButton = (type, file, previewItem) => {
            const button = document.createElement('button');
            button.className = 'remove-btn';
            button.innerHTML = '×';
            button.onclick = () => {
                fileGroups[type].files = fileGroups[type].files.filter(f =>
                    f.name !== file.name || f.size !== file.size
                );
                previewItem.remove();
                updateHiddenInputs(type);
            };
            return button;
        };

        // 更新隐藏input
        const updateHiddenInputs = (type) => {
            const dataTransfer = new DataTransfer();
            fileGroups[type].files.forEach(file => dataTransfer.items.add(file));
            fileGroups[type].hidden.files = dataTransfer.files;
        };

        // 创建媒体元素
        const createImageElement = (src) => {
            const img = document.createElement('img');
            img.className = 'preview-media';
            img.src = src;
            return img;
        };

        const createVideoElement = (src) => {
            const video = document.createElement('video');
            video.className = 'preview-media';
            video.controls = true;
            video.src = src;
            video.style.objectFit = 'contain';
            return video;
        };

        // 创建文件信息
        const createFileInfo = (file) => {
            const info = document.createElement('div');
            info.className = 'file-info';
            info.innerHTML = `
                <div class="file-name">`+file.name`</div>
                <div class="file-size">`+(file.size/1024).toFixed(2)+`KB</div>
            `;
            return info;
        };

        // 事件监听统一处理
        Object.entries(fileGroups).forEach(([type, group]) => {
            group.input.addEventListener('change', function() {
                if (this.files.length > 0) {
                    handleFileUpload(type, Array.from(this.files));
                }
            });
        });

        // 表单提交处理
        document.getElementById('postForm').addEventListener('submit', function() {
            Object.keys(fileGroups).forEach(type => updateHiddenInputs(type));
        });
    });
    let currentPage = 1;
    let isLoading = false;
    let searchParams = new URLSearchParams();

    // 滚动处理函数
    const scrollHandler = throttle(() => {
        const { scrollTop, scrollHeight, clientHeight } = document.documentElement;
        if (scrollTop + clientHeight >= scrollHeight - 100 && !isLoading) {
            loadMoreKnowledge();
        }
    }, 300);

    // 初始化加载
    window.addEventListener('load', () => {
        window.addEventListener('scroll', scrollHandler);
        loadMoreKnowledge();
    });

    // 搜索功能
    function performSearch() {
        currentPage = 1;
        const formData = new FormData(document.getElementById('searchForm'));
        searchParams = new URLSearchParams(formData);
        document.getElementById('knowledgeContainer').innerHTML = '';
        loadMoreKnowledge();
    }

    // 核心加载函数
    async function loadMoreKnowledge() {
        if (isLoading) return;
        isLoading = true;
        showLoading(true);

        try {
            searchParams.set('page', currentPage);

            const response = await fetch(`${pageContext.request.contextPath}/api/knowledge/search?`+searchParams);
            const html = await response.text();

            const tempDiv = document.createElement('div');
            tempDiv.innerHTML = html;

            document.getElementById('knowledgeContainer').insertAdjacentHTML('beforeend', tempDiv.innerHTML);

            const hasMore = tempDiv.querySelector('#hasMore')?.value === 'true';
            currentPage++;

            if (!hasMore) {
                window.removeEventListener('scroll', scrollHandler);
            }

        } catch (error) {
            console.error('加载失败:', error);
        } finally {
            isLoading = false;
            showLoading(false);
        }
    }

    // 辅助函数（与帖子页面保持一致）
    function throttle(func, limit) {
        let lastFunc;
        let lastRan;
        return function() {
            const context = this;
            const args = arguments;
            if (!lastRan) {
                func.apply(context, args);
                lastRan = Date.now();
            } else {
                clearTimeout(lastFunc);
                lastFunc = setTimeout(() => {
                    if ((Date.now() - lastRan) >= limit) {
                        func.apply(context, args);
                        lastRan = Date.now();
                    }
                }, limit - (Date.now() - lastRan));
            }
        }
    }

    function showLoading(show) {
        document.getElementById('loading').style.display = show ? 'block' : 'none';
    }
</script>

