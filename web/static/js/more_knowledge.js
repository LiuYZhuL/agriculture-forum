// web/static/js/more_knowledge.js

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
                        <div class="file-name">${file.name}</div>
                        <div class="file-size">${(file.size / 1024).toFixed(2)}KB</div>
                    </div>
                    ${createRemoveButton(type, file, previewItem).outerHTML}
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
            <div class="file-name">${file.name}</div>
            <div class="file-size">${(file.size / 1024).toFixed(2)}KB</div>
        `;
        return info;
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
    document.getElementById('searchForm').addEventListener('submit', function () {
        Object.keys(fileGroups).forEach(type => updateHiddenInputs(type));
    });
});

let currentPage = 1;
let isLoading = false;
let currentKeyword = '';
let currentCategory = '';
let searchParams = new URLSearchParams();

// 初始加载
window.addEventListener('load', () => {
    window.addEventListener('scroll', scrollHandler);
    loadMorePosts();
});

// 滚动监听
const scrollHandler = throttle(() => {
    const { scrollTop, scrollHeight, clientHeight } = document.documentElement;
    const threshold = 500;

    if (scrollTop + clientHeight >= scrollHeight - threshold) {
        loadMorePosts();
    }
}, 500);

function performSearch() {
    currentPage = 1;
    const formData = new FormData(document.getElementById('searchForm'));
    const newParams = new URLSearchParams(formData);
    newParams.set('page', currentPage);
    searchParams = newParams;

    document.getElementById('knowledgeContainer').innerHTML = '';
    loadMorePosts();
}

let hasMore = true;

async function loadMorePosts() {
    if (isLoading || !hasMore) return;

    isLoading = true;
    showLoading(true);

    try {
        const params = new URLSearchParams(searchParams);
        params.set('page', currentPage);

        const response = await fetch(`${baseUrl}/api/knowledge/search?` + params);
        const html = await response.text();

        const tempDiv = document.createElement('div');
        tempDiv.innerHTML = html;

        const loadedItems = tempDiv.querySelectorAll('.knowledge-item').length;

        if (loadedItems > 0) {
            document.getElementById('knowledgeContainer').insertAdjacentHTML('beforeend', tempDiv.innerHTML);
            currentPage++;
        }

        const hasMoreElement = tempDiv.querySelector('#hasMore');
        hasMore = hasMoreElement ? hasMoreElement.value === 'true' : false;

        if (!hasMore) {
            window.removeEventListener('scroll', scrollHandler);
            if (loadedItems === 0 && currentPage > 1) {
                console.log('已加载所有可用内容');
            }
        }
    } catch (error) {
        console.error('加载失败:', error);
        hasMore = false;
    } finally {
        isLoading = false;
        showLoading(false);
    }
}

function throttle(func, limit) {
    let lastFunc;
    let lastRan;
    return function () {
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
    };
}

function showLoading(show) {
    document.getElementById('loading').style.display = show ? 'block' : 'none';
}
