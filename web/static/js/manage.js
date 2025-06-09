
function setHome(section){
    window.location.href = `${baseUrl}api/admin/manage/?section=${section}`;
}
// 修改后的 loadContent 函数
function loadContent(section) {
    const contentArea = document.querySelector('.content-area');
    if (section){
        contentArea.innerHTML  = '';
        fetch(`${baseUrl}api/admin/manage/${section}`, {
            method: 'GET',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        })
            .then(response => response.text())
            .then(html => {
                contentArea.innerHTML = html;
                document.querySelector(".content-section").style.display = "block";
                setActiveSection(section);
            });
    }
    // 清空内容区域
}

// 设置激活状态的函数
function setActiveSection(section) {
    document.querySelectorAll('.nav-item').forEach(item => {
        item.classList.remove('active');
        if (item.getAttribute('data-section') === section) {
            item.classList.add('active');
        }
    });
}

loadContent(currentContent);
// manage.js
function searchUserPage(pageNum) {
    // 收集搜索参数
    const params = new URLSearchParams({
        pageNum: pageNum,
        username: document.getElementById('username').value || '',
        email: document.getElementById('email').value || '',
        roleId: document.getElementById('roleId').value || '',
        status: document.getElementById('status').value || ''
    });

    // 显示加载状态
    const contentArea = document.querySelector('#userMgt');
    contentArea.innerHTML = '<div class="loading">加载中...</div>';

    fetch(`${baseUrl}api/admin/manage/usermgt?${params.toString()}`, {
        method: 'GET',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' }
    })
        .then(response => response.text())
        .then(html => {
            // 创建临时容器解析HTML
            const tempDiv = document.createElement('div');
            tempDiv.innerHTML = html;

            // 提取用户列表内容
            const newContent = tempDiv.querySelector('#userMgt');

            // 替换内容区域
            if (newContent) {
                contentArea.innerHTML = newContent.innerHTML;
                bindUserEvents(); // 绑定新加载内容的事件
            }
        })
        .catch(error => {
            console.error('加载失败:', error);
            contentArea.innerHTML = '<div class="error">加载失败，请稍后重试</div>';
        });
}

// 绑定用户相关事件
function bindUserEvents() {
    // 绑定分页按钮
    document.querySelectorAll('.pagination button').forEach(btn => {
        btn.addEventListener('click', function() {
            const pageNum = parseInt(this.dataset.page) || 1;
            searchUserPage(pageNum);
        });
    });

    // 绑定其他操作按钮
    document.querySelectorAll('.btn-edit').forEach(btn => {
        btn.addEventListener('click', function() {
            const userId = this.dataset.userId;
            editUser(userId);
        });
    });
    // 新增模态框关闭事件
    document.querySelector('.user-modal .close')?.addEventListener('click', closeUserModal);
    document.querySelector('.user-modal .btn-cancel')?.addEventListener('click', closeUserModal);
}

function handleAvatarPreview(event) {
    const input = event.target;
    const preview = document.getElementById('userAvatarPreview');

    if (input.files && input.files[0]) {
        userAvatarFile = input.files[0]; // 存储文件对象
        const reader = new FileReader();
        reader.onload = (e) => {
            preview.src = e.target.result;
        }
        reader.readAsDataURL(userAvatarFile);
    }
}

// 全局状态管理
let userAvatarFile = null; // 存储新上传的头像文件

// 初始化用户模态框事件
function initUserModalEvents() {
    // 头像上传事件
    document.getElementById('avatarInput')?.addEventListener('change', handleAvatarPreview);

    // 表单提交事件
    document.getElementById('userForm')?.addEventListener('submit', function(e) {
        e.preventDefault();
        submitUserChanges();
    });
}

// 头像预览处理

// 打开用户模态框
function editUser(userId) {
    const modalContainer = document.getElementById('userEditModal');

    // 显示加载状态
    modalContainer.innerHTML = '<div class="loading">加载用户信息...</div>';

    fetch(`${baseUrl}api/admin/user/update?userId=${userId}`)
        .then(response => response.text())
        .then(html => {
            modalContainer.innerHTML = html;
            const modal = modalContainer.querySelector('.user-modal');
            modal.style.display = 'block';

            // 初始化事件
            initUserModalEvents();
            // 重置文件状态
            userAvatarFile = null;
        })
        .catch(error => {
            console.error('加载失败:', error);
            modalContainer.innerHTML = `<div class="error">${error.message}</div>`;
            setTimeout(() => modalContainer.innerHTML = '', 2000);
        });
}

// 提交用户修改
function submitUserChanges() {
    const formData = new FormData();
    const userId = document.getElementById('editUserId').value;

    // 基础信息
    formData.append('id', userId);
    formData.append('username', document.getElementById('editUsername').value);
    formData.append('email', document.getElementById('editEmail').value);
    formData.append('roleId', document.getElementById('editRole').value);
    formData.append('status', document.getElementById('editStatus').value);

    // 添加头像文件
    if (userAvatarFile) {
        formData.append('avatar', userAvatarFile);
    }

    // 按钮状态管理
    const submitBtn = document.querySelector('#userForm .btn-submit');
    const originalText = submitBtn.innerHTML;
    submitBtn.innerHTML = '⏳ 提交中...';
    submitBtn.disabled = true;

    fetch(`${baseUrl}api/admin/user/update`, {
        method: 'POST',
        body: formData
    })
        .then(response => {
            if (!response.ok) {
                // 增加服务器错误信息提取
                return response.json().then(err => Promise.reject(err));
            }
            return response.json();
        })
        .then(data => {

            showToast('用户信息更新成功', 'success');
            closeUserModal();
            // 刷新当前分页
            const currentPage = document.querySelector('.pagination .active')?.textContent || 1;
            searchUserPage(currentPage);
            // 更新全局头部
            refreshHeaderComponent();

        })
        .catch(error => {
            console.error('更新失败:', error);
            showToast(error.message, 'error');
        })
        .finally(() => {
            submitBtn.innerHTML = originalText;
            submitBtn.disabled = false;
        });
}

// 关闭模态框
function closeUserModal() {
    const modal = document.querySelector('.user-modal');
    if (modal) {
        modal.style.display = 'none';
        // 清理临时文件
        userAvatarFile = null;
        // 移除DOM
        document.getElementById('userEditModal').innerHTML = '';
    }
}
function refreshHeaderComponent() {
    fetch(`${baseUrl}api/header`,{
        method: 'GET',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' }
    }) // 添加时间戳防止缓存
        .then(response => response.text())
        .then(html => {
            const parser = new DOMParser();
            const doc = parser.parseFromString(html, 'text/html');
            const newHeader = doc.querySelector('.header');

            const oldHeader = document.querySelector('.header');
            if (oldHeader && newHeader) {
                oldHeader.replaceWith(newHeader);
                console.log('Header组件已更新');
            }
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
// 集成到现有功能

// manage.js 新增分类相关功能

/* 分类全局状态 */
let currentEditCategoryId = null;

// 分类分页加载
function searchCategoryPage(pageNum) {
    const params = new URLSearchParams({
        pageNum: pageNum,
        searchCategory: document.getElementById('category').value || ''
    });

    const contentArea = document.querySelector('#categoryMgt');
    contentArea.innerHTML = '<div class="loading">加载中...</div>';

    fetch(`${baseUrl}api/admin/manage/categorymgt?${params}`, {
        method: 'GET',
        headers: { 'Content-Type': 'application/json' }
    })
        .then(response => response.text())
        .then(html => {
            const tempDiv = document.createElement('div');
            tempDiv.innerHTML = html;
            const newContent = tempDiv.querySelector('#categoryMgt');
            if (newContent) {
                contentArea.innerHTML = newContent.innerHTML;
                bindCategoryEvents();
                initCategoryModals();
            }
        })
        .catch(error => {
            console.error('分类加载失败:', error);
            showToast('分类加载失败', 'error');
        });
}

// 绑定分类事件
function bindCategoryEvents() {
    // 分页按钮
    document.querySelectorAll('#categoryMgt .pagination button').forEach(btn => {
        btn.addEventListener('click', function() {
            const pageNum = parseInt(this.textContent) || 1;
            searchCategoryPage(pageNum);
        });
    });

    // 编辑按钮
    document.querySelectorAll('#categoryMgt .btn-edit').forEach(btn => {
        btn.addEventListener('click', function() {
            const categoryId = this.closest('tr').querySelector('td:first-child').textContent;
            editCategory(categoryId);
        });
    });
}
function initCategoryModals() {
    // 新增模态框关闭按钮
    document.querySelector('#categoryAddModal .close')?.addEventListener('click', closeCategoryAddModal);
}
// 打开编辑模态框
function editCategory(categoryId) {
    const modalContainer = document.getElementById('categoryEditModal');


    fetch(`${baseUrl}api/admin/category/update?categoryId=${categoryId}`,{
        method: 'GET'
    })
        .then(response => response.text())
        .then(html => {
            modalContainer.innerHTML = html;
            const modal = modalContainer.querySelector('.category-modal');
            document.querySelector('.category-modal').style.display = 'block';
            addCategoryModalEvents();
        })
        .catch(error => {
            console.error('加载分类失败:', error);
            showToast('加载分类信息失败', 'error');
        });
}
function addCategoryModalEvents() {
    document.querySelector('#categoryEditModal .btn-submit')?.addEventListener('click', submitCategoryChanges);
}

function closeCategoryModal() {
    const modalContainer = document.getElementById('categoryEditModal');
    modalContainer.innerHTML = '';
}
// 提交分类修改
function submitCategoryChanges() {
    const params = new URLSearchParams({
        id: document.getElementById('editCategoryId').value,
        name: document.getElementById('editCategoryName').value,
        description: document.getElementById('editCategoryDesc').value
    });
    console.log(params.toString());
    fetch(`${baseUrl}api/admin/category/update`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: params
    })
        .then(response => response.json())
        .then(data => {
            closeCategoryModal();
            const currentPage = document.querySelector('.pagination .active')?.textContent || 1;
            searchCategoryPage(currentPage); // 刷新当前页
            showToast(data.message, 'success');
        })
        .catch(error => {
            console.error('更新失败:', error);
            showToast(error.message || '更新失败', 'error');
        });
}
function deleteCategory(categoryId){
    if (!confirm('确定要删除该分类吗？')) return;
    fetch(`${baseUrl}api/admin/category/delete?categoryId=${categoryId}`, {
        method: 'DELETE',
    }).then(() => {
        showToast('删除成功', 'success');
        const currentPage = document.querySelector('.pagination .active')?.textContent || 1;
        searchCategoryPage(currentPage); // 刷新当前页

    });
}

// 新增分类
function submitCategoryAdd() {
    const params = new URLSearchParams({
        categoryName: document.getElementById('name').value,
        categoryDesc: document.getElementById('description').value
    });


    fetch(`${baseUrl}api/admin/category/add`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: params
    })
        .then(response => {
            if (!response.ok) return response.json().then(err => { throw err; });
            return response.json();
        })
        .then(data => {
            showToast('分类添加成功', 'success');
            closeCategoryAddModal();
            const currentPage = document.querySelector('.pagination .active')?.textContent || 1;
            searchCategoryPage(currentPage);
        })
        .catch(error => {
            console.error('添加失败:', error);
            showToast(error.message || '添加失败', 'error');
        })
}

// 打开新增模态框
function openCategoryAddModal() {
    const modal = document.getElementById('categoryAddModal');
    modal.style.display = 'block';

    // 清空输入
    document.getElementById('name').value = '';
    document.getElementById('description').value = '';
}

// 关闭分类模态框

function closeCategoryAddModal() {
    document.getElementById('categoryAddModal').style.display = 'none';
}

// 初始化分类模块
function initCategoryModule() {
    bindCategoryEvents();
    // 其他初始化逻辑
}

/* 在页面加载时初始化 */
document.addEventListener('DOMContentLoaded', function() {
    if (document.getElementById('categoryMgt')) {
        initCategoryModule();
    }
});
let currentPostPage = 1;

// 修改状态
function toggleStatus(postId, status) {
    const params = new URLSearchParams({
        postId: postId,
        status: status
    });
    fetch(`${baseUrl}api/post/status`, {
        method: 'POST',
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: params
    })
        .then(() => searchPostPage(currentPostPage))
        .catch(handleError);
}
function toggleKStatus(postId, status) {
    const params = new URLSearchParams({
        postId: postId,
        status: status
    });
    fetch(`${baseUrl}api/post/status`, {
        method: 'POST',
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: params
    })
        .then(() => searchKnowledgePage(currentPostPage))
        .catch(handleError);
}

// 置顶操作
function toggleTop(postId, isTop) {
    const params = new URLSearchParams({
        postId: postId,
        isTop: isTop
    });
    fetch(`${baseUrl}api/post/top`, {
        method: 'POST',
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: params
    })
        .then(() => searchPostPage(currentPostPage))
        .catch(handleError);
}
function toggleKTop(postId, isTop) {
    const params = new URLSearchParams({
        postId: postId,
        isTop: isTop
    });
    fetch(`${baseUrl}api/post/top`, {
        method: 'POST',
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: params
    })
        .then(() => searchKnowledgePage(currentPostPage))
        .catch(handleError);
}
// 精华操作
function toggleEssence(postId, isEssence) {
    const params = new URLSearchParams({
        postId: postId,
        isEssence: isEssence
    });
    fetch(`${baseUrl}api/post/essence`, {
        method: 'POST',
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: params
    })
        .then(() => searchPostPage(currentPostPage))
        .catch(handleError);
}
function toggleKEssence(postId, isEssence) {
    const params = new URLSearchParams({
        postId: postId,
        isEssence: isEssence
    });
    fetch(`${baseUrl}api/post/essence`, {
        method: 'POST',
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: params
    })
        .then(() => searchKnowledgePage(currentPostPage))
        .catch(handleError);
}
// 统一错误处理
function handleError(error) {
    console.error('操作失败:', error);
    showToast(error.message || '操作失败', 'error');
}
function searchPostPage(pageNum){
    const params = new URLSearchParams({
        pageNum: pageNum,
        title: document.getElementById('title').value || '',
        user: document.getElementById('user').value || '',
        category: document.getElementById('category').value || '',
        sts: document.getElementById('sts').value || '',
        isTop: document.getElementById('isTop').value || '',
        isEssence: document.getElementById('isEssence').value || ''
    });
    console.log(params.toString());
    fetch(`${baseUrl}api/admin/manage/postmgt?${params.toString()}`, {
        method: 'GET',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded'
        },
    })
        .then(response => response.text())
        .then(html => {
            console.log('服务端响应:', html); // 查看实际返回内容
            // 统一替换逻辑
            const contentArea = document.querySelector('.content-area');

            contentArea.innerHTML = html;
            document.querySelector(".content-section").style.display = "block";
            setActiveSection('postmgt');
            currentPostPage = pageNum;
        })

}
function searchKnowledgePage(pageNum){
    const params = new URLSearchParams({
        pageNum: pageNum,
        ktitle: document.getElementById('ktitle').value || '',
        kuser: document.getElementById('kuser').value || '',
        kcategory: document.getElementById('kcategory').value || '',
        ksts: document.getElementById('ksts').value || '',
        kisTop: document.getElementById('kisTop').value || '',
        kisEssence: document.getElementById('kisEssence').value || ''
    });
    console.log(params.toString());
    fetch(`${baseUrl}api/admin/manage/knowledgemgt?${params.toString()}`, {
        method: 'GET',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded'
        },
    })
        .then(response => response.text())
        .then(html => {
            console.log('服务端响应:', html); // 查看实际返回内容
            // 统一替换逻辑
            const contentArea = document.querySelector('.content-area');

            contentArea.innerHTML = html;
            document.querySelector(".content-section").style.display = "block";
            setActiveSection('knowledgemgt');
            currentPostPage = pageNum;
        })

}
function postDetail(postId){
    window.location.href = `${baseUrl}api/post/detail?postId=${postId}`;
}
function knowledgeDetail(postId){
    window.location.href = `${baseUrl}api/knowledge/detail?postId=${postId}`;
}
function deletePost(postId) {
    if (!confirm('确定要删除这个帖子吗？')) return;

    fetch(`${baseUrl}api/post/delete/${postId}`, {
        method: 'DELETE',
        headers: {
            'Content-Type': 'application/json'
        }
    })
        .then(response => {
            if (!response.ok) throw new Error('HTTP错误状态码: ' + response.status);
            return response.json();
        })
        .then(data => {
            if (data.success) {
                showToast(data.message, 'success');
                // 获取当前分页并刷新
                const currentPage = document.querySelector('.pagination .active')?.textContent || 1;
                searchPostPage(currentPage);
            } else {
                throw new Error(data.message);
            }
        })
        .catch(error => {
            console.error('删除失败:', error);
            showToast(error.message, 'error');
        });
}
function deleteKnowledge(postId) {
    if (!confirm('确定要删除这篇文章吗？')) return;

    fetch(`${baseUrl}api/post/delete/${postId}`, {
        method: 'DELETE',
        headers: {
            'Content-Type': 'application/json'
        }
    })
        .then(response => {
            if (!response.ok) throw new Error('HTTP错误状态码: ' + response.status);
            return response.json();
        })
        .then(data => {
            if (data.success) {
                showToast(data.message, 'success');
                // 获取当前分页并刷新
                const currentPage = document.querySelector('.pagination .active')?.textContent || 1;
                searchKnowledgePage(currentPage);
            } else {
                throw new Error(data.message);
            }
        })
        .catch(error => {
            console.error('删除失败:', error);
            showToast(error.message, 'error');
        });
}
