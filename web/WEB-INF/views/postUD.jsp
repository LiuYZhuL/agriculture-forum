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
    <style>
        /* 新增文件预览样式 */
        .file-preview {
            padding: 8px;
            display: flex;
            align-items: center;
            width: 180px;
        }
        .file-icon {
            font-size: 24px;
            margin-right: 8px;
        }
        .file-info {
            flex: 1;
            overflow: hidden;
        }
        .file-name {
            font-size: 12px;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }
        .file-type {
            font-size: 10px;
            color: #666;
        }

        /* 原有样式保留 */
        .preview { width: 150px; height: 150px; border-radius: 50%; overflow: hidden; }
        #avatarPreview { width: 100%; height: 100%; object-fit: cover; }
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
        .user-info img {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            object-fit: cover;
            display: block;
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
            height: auto;
            overflow-y: hidden;
            resize: none;
            line-height: 1.5;
            white-space: pre-wrap;
            word-wrap: break-word;
            transition: height 0.2s ease-out;
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
            display: inline-flex;
            align-items: center;
            background: #f8f8f8;
        }
        .preview-media {
            width: auto;
            height: 100%;
            object-fit: contain;
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
<script>
    let deletedAttachments = [];
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
                        ? document.createElement('img')
                        : document.createElement('video');
                    media.className = 'preview-media';
                    media.src = e.target.result;
                    if(type === 'video') {
                        media.controls = true;
                        media.style.objectFit = 'contain';
                    }

                    const fileInfo = document.createElement('div');
                    fileInfo.className = 'file-info';
                    fileInfo.innerHTML = `
                        <div>`+file.name+`</div>
                        <div>`+(file.size/1024).toFixed(2)+`KB</div>
                    `;

                    const removeBtn = createRemoveButton(type, file, previewItem);

                    previewItem.appendChild(media);
                    previewItem.appendChild(fileInfo);
                    previewItem.appendChild(removeBtn);
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
                    </div>
                `;
                const removeBtn = createRemoveButton(type, file, previewItem);
                previewItem.appendChild(removeBtn);
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

        // 事件监听
        Object.entries(fileGroups).forEach(([type, group]) => {
            group.input.addEventListener('change', function() {
                if (this.files.length > 0) {
                    handleFileUpload(type, Array.from(this.files));
                }
            });
        });

        // 表单提交事件
        document.getElementById('postForm').addEventListener('submit', function() {
            Object.keys(fileGroups).forEach(type => updateHiddenInputs(type));
        });
    });

    // 自动调整文本框高度
    function autoResize(textarea) {
        textarea.style.height = 'auto';
        textarea.style.height = textarea.scrollHeight + 'px';
    }

    // 删除原有附件
    function removeAttachment(element, attachId) {
        if (confirm("确定要删除这个附件吗？")) {
            deletedAttachments = [...deletedAttachments, attachId];
            const deleteInput = document.createElement('input');
            deleteInput.type = 'hidden';
            deleteInput.name = 'deletedAttachments';
            deleteInput.value = deletedAttachments.join(',');
            document.getElementById('postForm').appendChild(deleteInput);
            element.parentNode.remove();
        }
    }
</script>
