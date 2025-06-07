
function loadContent(section) {
    const contentArea = document.querySelector('.content-area');
    contentArea.innerHTML = '<div class="loading">加载中...</div>';

    fetch(`${baseUrl}api/admin/manage/${section}`, {
        method: 'GET',
        headers: {
            'Accept': 'text/html',
            'X-Requested-With': 'XMLHttpRequest'
        }
    })
        .then(response => response.text())
        .then(html => {
            contentArea.innerHTML = html;
            setActiveSection(section);
            if(section === 'usermgt') {
                rebindUserMgtEvents();
            }
            if(section === 'categorymgt') {
                rebindCategoryMgtEvents();
            }
            if(section === 'postmgt'){
                rebindPostMgtEvents();
            }
        });
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
// 统一处理搜索和分页请求
function handleSearch(event) {
    event.preventDefault();
    const form = event.target;
    submitUserMgtRequest(new FormData(form));
    return false;
}

function handleCategorySearch(event) {
    event.preventDefault();
    const form = event.target;
    submitCategoryMgtRequest(new FormData(form));
    return false;
}
function handlePostSearch(event) {
    event.preventDefault();
    const form = event.target;
    submitPostMgtRequest(new FormData(form));
    return false;
}

// 通用请求处理函数
function submitUserMgtRequest(formData) {
    const params = new URLSearchParams(formData);

    fetch(`${baseUrl}api/admin/manage/usermgt?${params}`, {
        method: 'GET',
        headers: {
            'Accept': 'text/html',
            'X-Requested-With': 'XMLHttpRequest' // 添加AJAX标识
        }
    })
        .then(response => {
            if (!response.ok) throw new Error('网络响应异常');
            return response.text();
        })
        .then(html => {
            document.querySelector('.content-area').innerHTML = html;
            rebindUserMgtEvents();
        })
        .catch(error => {
            console.error('请求失败:', error);
            showErrorMessage('操作失败，请稍后重试');
        });
}

function submitCategoryMgtRequest(formData) {
    const params = new URLSearchParams(formData);

    fetch(`${baseUrl}api/admin/manage/categorymgt?${params}`, {
        method: 'GET',
        headers: {
            'Accept': 'text/html',
            'X-Requested-With': 'XMLHttpRequest'
        }
    })
        .then(response => response.text())
        .then(html => {
            document.querySelector('.content-area').innerHTML = html;
            rebindCategoryMgtEvents();
        });
}
function submitPostMgtRequest(formData) {
    const params = new URLSearchParams(formData);

    fetch(`${baseUrl}api/admin/manage/postmgt?${params}`, {
        method: 'GET',
        headers: {
            'Accept': 'text/html',
            'X-Requested-With': 'XMLHttpRequest'
        }
    })
        .then(response => {
            if (!response.ok) throw new Error('请求失败');
            return response.text();
        })
        .then(html => {
            document.querySelector('.content-area').innerHTML = html;
            rebindPostMgtEvents();
        })
        .catch(error => {
            console.error('Error:', error);
            showErrorMessage('操作失败，请稍后重试');
        });
}
// 重新绑定事件
function rebindUserMgtEvents() {
    // 绑定搜索表单
    const searchForm = document.getElementById('searchForm');
    if (searchForm) {
        searchForm.onsubmit = handleSearch;
    }

    // 统一绑定分页按钮（替换旧式表单提交）
    document.querySelectorAll('.pagination form').forEach(form => {
        form.onsubmit = function(e) {
            e.preventDefault();
            submitUserMgtRequest(new FormData(this)); // 使用统一请求处理
        };
    });
}

function rebindCategoryMgtEvents() {
    // 绑定搜索表单
    const searchForm = document.getElementById('categorySearchForm');
    if (searchForm) {
        searchForm.onsubmit = handleCategorySearch;
    }

    // 绑定分页按钮
    document.querySelectorAll('.pagination form').forEach(form => {
        form.onsubmit = function(e) {
            e.preventDefault();
            submitCategoryMgtRequest(new FormData(this));
        };
    });
}
function rebindPostMgtEvents() {
    // 绑定搜索表单
    const searchForm = document.getElementById('searchForm');
    if (searchForm) {
        searchForm.onsubmit = handlePostSearch;
    }

    // 绑定分页按钮
    document.querySelectorAll('.pagination form').forEach(form => {
        form.onsubmit = function(e) {
            e.preventDefault();
            submitPostMgtRequest(new FormData(this));
        };
    });
}

// 显示错误消息
function showErrorMessage(msg) {
    const errorDiv = document.createElement('div');
    errorDiv.style.color = 'red';
    errorDiv.textContent = msg;
    document.querySelector('.content-area').prepend(errorDiv);
}

function resetPassword(userId, pageNum){
    const id = document.getElementById('id').value;
    const email = document.getElementById('email').value;
    const username = document.getElementById('username').value;
    const roleId = document.getElementById('roleId').value;
    const status = document.getElementById('status').value;
    console.log(id,email,username,roleId,status);
    const params = new URLSearchParams();
    params.append('id', id);
    params.append('email', email);
    params.append('username', username);
    params.append('roleId', roleId);
    params.append('status', status);
    params.append('pageNum', pageNum);
    console.log(params);
    fetch(`${baseUrl}api/admin/user/reset/`+userId, {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: params
    }).then(response => response.text())
        .then(html => {
            document.querySelector('.content-area').innerHTML = html;
            rebindUserMgtEvents();
        })
        .catch(error => {
            console.error('请求失败:', error);
            showErrorMessage('操作失败，请稍后重试');
        });
}