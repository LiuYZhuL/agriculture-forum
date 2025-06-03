// web/static/js/postUD.js

let deletedAttachments = [];

document.addEventListener('DOMContentLoaded', function () {
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

                const fileInfo = createFileInfo(file);
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
                        <div class="file-name">${file.name}</div>
                        <div class="file-size">${(file.size / 1024).toFixed(2)}KB</div>
                    </div>
                </div>
            `;
            const removeBtn = createRemoveButton(type, file, previewItem);
            previewItem.appendChild(removeBtn);
        }

        return previewItem;
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
            <div class="file-name">${file.name}</div>
            <div class="file-size">${(file.size / 1024).toFixed(2)}KB</div>
        `;
        return info;
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

    // 事件监听统一处理
    Object.entries(fileGroups).forEach(([type, group]) => {
        group.input.addEventListener('change', function () {
            if (this.files.length > 0) {
                handleFileUpload(type, Array.from(this.files));
            }
        });
    });

    // 表单提交处理
    document.getElementById('postForm').addEventListener('submit', function () {
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
