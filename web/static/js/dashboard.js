document.addEventListener("DOMContentLoaded", function () {
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
});
let addNewAttachments = []; // 临时附件
// 打开新增模态框
function openAddModal() {
    const modal = document.querySelector('.post-modal');
    modal.style.display = 'block';
    document.getElementById('addPostCategory').selectedIndex = 0;

    initAddFileUpload(); // 初始化文件上传
}

// 关闭新增模态框
function closeAddModal() {
    const modal = document.querySelector('.post-modal');
    modal.style.display = 'none';

    // 清空表单内容
    document.getElementById('addPostTitle').value = '';
    document.getElementById('addPostContent').value = '';
    document.getElementById('addPostCategory').selectedIndex = 0;

    // 清空附件预览
    const container = document.getElementById('addNewAttachments');
    container.innerHTML = '';
    addNewAttachments = [];

    // 重置自动调整的文本域高度
    const textarea = document.getElementById('addPostContent');
    textarea.style.height = 'auto';

}

// 初始化新增文件上传
function initAddFileUpload() {
    // 图片上传
    document.getElementById('addImageInput').addEventListener('change', handleAddFileSelect);
    // 视频上传
    document.getElementById('addVideoInput').addEventListener('change', handleAddFileSelect);
    // 文件上传
    document.getElementById('addFileInput').addEventListener('change', handleAddFileSelect);
}

// 处理新增文件选择
function handleAddFileSelect(event) {
    const files = event.target.files;
    const container = document.getElementById('addNewAttachments');
    console.log(files);
    for (let i = 0; i < files.length; i++) {
        const file = files[i];
        const fileType = file.type.split('/')[0];

        // 创建预览元素
        const previewItem = document.createElement('div');
        previewItem.className = 'preview-item';
        previewItem.dataset.fileId = Date.now() + i;

        // 根据文件类型创建预览
        if (fileType === 'image') {
            const reader = new FileReader();
            reader.onload = function(e) {
                const img = document.createElement('img');
                img.className = 'preview-media';
                img.src = e.target.result;
                previewItem.appendChild(img);

                // 添加删除按钮
                const removeBtn = createRemoveButton(file, previewItem);
                previewItem.appendChild(removeBtn);

                container.appendChild(previewItem);
            };
            reader.readAsDataURL(file);
        }
        else if (fileType === 'video') {
            const video = document.createElement('video');
            video.className = 'preview-media';
            video.controls = true;

            const source = document.createElement('source');
            source.src = URL.createObjectURL(file);
            source.type = file.type;
            video.appendChild(source);

            previewItem.appendChild(video);

            // 添加删除按钮
            const removeBtn = createRemoveButton(file, previewItem);
            previewItem.appendChild(removeBtn);

            container.appendChild(previewItem);
        }
        else {
            const filePreview = document.createElement('div');
            filePreview.className = 'file-preview';

            const fileIcon = document.createElement('i');
            fileIcon.className = 'file-icon';
            fileIcon.textContent = '📁';

            const fileInfo = document.createElement('div');
            fileInfo.className = 'file-info';

            const fileName = document.createElement('div');
            fileName.className = 'file-name';
            fileName.textContent = file.name;

            const fileType = document.createElement('div');
            fileType.className = 'file-type';
            fileType.textContent = file.type || '文件';

            fileInfo.appendChild(fileName);
            fileInfo.appendChild(fileType);
            filePreview.appendChild(fileIcon);
            filePreview.appendChild(fileInfo);
            previewItem.appendChild(filePreview);

            // 添加删除按钮
            const removeBtn = createRemoveButton(file, previewItem);
            previewItem.appendChild(removeBtn);

            container.appendChild(previewItem);
        }

        // 保存文件到新附件数组
        addNewAttachments.push({
            id: previewItem.dataset.fileId,
            file: file
        });
    }

    // 重置输入框以允许再次选择相同的文件
    event.target.value = '';
}
function createRemoveButton(file, previewItem) {
    const removeBtn = document.createElement('button');
    removeBtn.type = 'button';
    removeBtn.className = 'remove-btn';
    removeBtn.textContent = 'X';
    removeBtn.onclick = function() {
        // 从DOM中移除预览
        previewItem.remove();

        // 从新附件数组中移除
        const index = addNewAttachments.findIndex(a => a.id === previewItem.dataset.fileId);
        if (index !== -1) {
            addNewAttachments.splice(index, 1);
        }
    };
    return removeBtn;
}

// 提交新增帖子
function submitPostAdd() {
    const title = document.getElementById('addPostTitle').value;
    const content = document.getElementById('addPostContent').value;
    const categoryId = document.getElementById('addPostCategory').value;
    const type = document.getElementById('addPostStatus').value;

    if (!title || !content) {
        showToast('标题和内容不能为空', 'error');
        return;
    }

    const formData = new FormData();
    formData.append('title', title);
    formData.append('content', content);
    formData.append('categoryId', categoryId);
    formData.append('status', type);

    // 添加新附件
    addNewAttachments.forEach(attachment => {
        formData.append('addNewAttachments', attachment.file);
    });

    const btn = document.querySelector('#addPostModal .submit-btn');
    const originalText = btn.textContent;
    btn.textContent = '发布中...';
    btn.disabled = true;

    fetch(`${baseUrl}api/post/add`, {
        method: 'POST',
        body: formData
    })
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                showToast('帖子发布成功', 'success');
                confirm('发布成功');
                closeAddModal();
                // 刷新帖子列表
                setTimeout(() => window.location.reload(), 1500);
            } else {
                throw new Error(data.message);
            }
        })
        .catch(error => {
            console.error('发布失败:', error);
            showToast(`发布失败: ${error.message}`, 'error');
        })
        .finally(() => {
            btn.textContent = originalText;
            btn.disabled = false;
        });
}
function showToast(message, type) {
    const toast = document.createElement('div');
    toast.className = `toast toast-${type}`;
    toast.textContent = message;
    document.body.appendChild(toast);

    setTimeout(() => {
        toast.classList.add('show');
    }, 10);

    setTimeout(() => {
        toast.classList.remove('show');
        setTimeout(() => {
            toast.remove();
        }, 300);
    }, 3000);
}
