

// 修改后的 loadContent 函数
function loadContent(section) {
    const contentArea = document.querySelector('.content-area');
    // 清空内容区域
    contentArea.innerHTML  = '';
    fetch(`${baseUrl}api/user/${section}`, {
        method: 'GET',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
    })
        .then(response => response.text())
        .then(html => {
            contentArea.innerHTML = html;

            setActiveSection(section);
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

loadContent(currentContent);

// 显示头像修改模态框
function showAvatarEditor() {
    const modal = document.getElementById('avatarModal');
    modal.style.display = 'block';
}

// 关闭头像修改模态框
function closeAvatarEditor() {
    const modal = document.getElementById('avatarModal');
    modal.style.display = 'none';
}

// 预览选择的头像
function previewSelectedAvatar() {
    const input = document.getElementById('avatarFile');
    const preview = document.getElementById('previewAvatar');

    if (input.files && input.files[0]) {
        const reader = new FileReader();

        reader.onload = function(e) {
            preview.src = e.target.result;
        }

        reader.readAsDataURL(input.files[0]);
    }
}

// 提交头像修改
function submitAvatarChange() {
    const input = document.getElementById('avatarFile');
    const btn = document.querySelector('#avatarModal button');
    const originalBtnText = btn.innerHTML;

    // 验证文件选择
    if (!input.files || !input.files[0]) {
        alert('请先选择要上传的图片');
        return;
    }

    // 显示加载状态
    btn.innerHTML = '⏳ 上传中...';
    btn.disabled = true;

    const formData = new FormData();
    formData.append('avatar', input.files[0]);

    fetch(`${baseUrl}api/user/avatar`, {
        method: 'POST',
        body: formData
    })
        .then(response => {
            if (!response.ok) throw new Error(`HTTP错误! 状态码: ${response.status}`);
            return response.text();
        })
        .then(html => {
            // 创建临时容器解析HTML
            const tempDiv = document.createElement('div');
            tempDiv.innerHTML = html;

            // 提取avatar-section内容
            const newContent = tempDiv.querySelector('.content-section');

            // 替换现有内容
            const contentArea = document.querySelector('.content-area');
            const oldSection = contentArea.querySelector('.content-section');

            if (oldSection && newContent) {
                oldSection.replaceWith(newContent);
            } else {
                contentArea.innerHTML = html;
            }

            // 重新绑定事件
            initGlobalEvents()
            refreshHeaderComponent();
            closeAvatarEditor();

        })
        .catch(error => {
            console.error('上传失败:', error);
            alert(`头像更新失败: ${error.message}`);
        })
        .finally(() => {
            // 恢复按钮状态
            btn.innerHTML = originalBtnText;
            btn.disabled = false;
        });
}

// 初始化头像相关事件
function initAvatarEvents() {
    const editMask = document.querySelector('.edit-mask');
    if (editMask) {
        editMask.onclick = showAvatarEditor;
    }

    const fileInput = document.getElementById('avatarFile');
    if (fileInput) {
        fileInput.onchange = previewSelectedAvatar;
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
// 显示信息修改模态框
function showInfoEditor() {
    const modal = document.getElementById('infoModal');
    modal.style.display = 'block';

    // 初始化表单值
    document.getElementById('editUsername').value =
        document.getElementById('displayUsername').textContent;
    document.getElementById('editEmail').value =
        document.getElementById('displayEmail').textContent;
}

// 关闭信息修改模态框
function closeInfoEditor() {
    document.getElementById('infoModal').style.display = 'none';
}

// 提交信息修改
// 提交信息修改（适配视图返回）
function submitInfoChange() {
    const btn = document.querySelector('.btn-save');
    const originalBtnText = btn.innerHTML;

    // 手动获取表单值
    const formData = new FormData();
    formData.append('username', document.getElementById('editUsername').value);
    formData.append('email', document.getElementById('editEmail').value);

    btn.innerHTML = '⏳ 保存中...';
    btn.disabled = true;

    fetch(`${baseUrl}api/user/update`, {
        method: 'POST',
        body: formData
    })
        .then(response => response.text())
        .then(html => {
            console.log('服务端响应:', html); // 查看实际返回内容
            // 统一替换逻辑
            const contentArea = document.querySelector('.content-area');
            const tempDiv = document.createElement('div');
            tempDiv.innerHTML = html;

            // 获取新内容（保持与头像模块相同的选择器）
            const newContent = tempDiv.querySelector('.content-section');

            // 清空后插入（严格遵循先清空后添加原则）
            contentArea.innerHTML = '';
            if (newContent) {
                contentArea.appendChild(newContent.cloneNode(true)); // 深度克隆
            }

            // 关闭模态框（与头像模块逻辑一致）
            closeInfoEditor();

            // 重新绑定事件（新增初始化）
            initGlobalEvents();
            refreshHeaderComponent();

            // 显示服务端消息（保持与头像模块相同提示方式）
            const serverMsg = tempDiv.querySelector('.alert');
            if (serverMsg) {
                showToast(serverMsg.textContent, 'success');
            }
        })
        .catch(error => {
            console.error('修改失败:', error);
            showToast('修改失败，请稍后重试', 'error');
        })
        .finally(() => {
            btn.innerHTML = originalBtnText;
            btn.disabled = false;
        });
}

// 新增全局事件绑定（与头像模块保持统一）
function initGlobalEvents() {
    initInfoEvents();
    initAvatarEvents();
}


// 初始化信息相关事件
function initInfoEvents() {
    const editBtn = document.querySelector('.btn-edit');

    if (editBtn) editBtn.onclick = showInfoEditor;
}

// 通用Toast提示
function showToast(message, type) {
    const toast = document.createElement('div');
    toast.className = `toast toast-${type}`;
    toast.textContent = message;
    document.body.appendChild(toast);

    setTimeout(() => {
        toast.remove();
    }, 3000);
}

// 显示密码修改模态框
function showPasswordEditor() {
    // 重置表单内容
    document.getElementById('oldPassword').value = '';
    document.getElementById('newPassword').value = '';
    document.getElementById('confirmPassword').value = '';

    // 清除错误状态
    const errorContainer = document.getElementById('clientError');
    errorContainer.style.display = 'none';
    document.getElementById('errorText').textContent = '';

    // 清除输入框错误样式
    ['oldPassword', 'newPassword', 'confirmPassword'].forEach(id => {
        document.getElementById(id).classList.remove('error');
    });

    // 显示模态框
    document.getElementById('passwordModal').style.display = 'block';
}

// 关闭密码修改模态框
function closePasswordEditor() {
    // 重置表单内容
    document.getElementById('oldPassword').value = '';
    document.getElementById('newPassword').value = '';
    document.getElementById('confirmPassword').value = '';

    // 清除错误状态
    const errorContainer = document.getElementById('clientError');
    errorContainer.style.display = 'none';
    document.getElementById('errorText').textContent = '';

    // 清除输入框错误样式
    ['oldPassword', 'newPassword', 'confirmPassword'].forEach(id => {
        document.getElementById(id).classList.remove('error');
    });

    document.getElementById('passwordModal').style.display = 'none';
}

// 提交密码修改
function submitPasswordChange() {
    const btn = document.querySelector('#passwordModal .btn-save');
    const originalText = btn.innerHTML; // 保存原始按钮文本
    const errorContainer = document.getElementById('clientError');
    const errorText = document.getElementById('errorText');

    // 重置所有状态
    btn.disabled = false;
    btn.innerHTML = originalText;
    errorContainer.style.display = 'none';
    errorText.textContent = '';
    // 验证逻辑
    const oldPassword = document.getElementById('oldPassword').value;
    const newPassword = document.getElementById('newPassword').value;
    const confirmPassword = document.getElementById('confirmPassword').value;

    if (!oldPassword || !newPassword || !confirmPassword) {
        errorText.textContent = '所有字段都必须填写';
        errorContainer.style.display = 'block';
        return;
    }

    if (newPassword !== confirmPassword) {
        errorText.textContent = '两次输入的新密码不一致';
        errorContainer.style.display = 'block';
        return;
    }

    const formData = new FormData();
    formData.append('password', oldPassword);
    formData.append('newPassword', newPassword);

    btn.innerHTML = '⏳ 提交中...';
    btn.disabled = true;

    fetch(`${baseUrl}api/user/change`, {
        method: 'POST',
        body: formData
    })
        .then(response => response.text())
        .then(html => {
            const tempDiv = document.createElement('div');
            tempDiv.innerHTML = html;
            const newContent = tempDiv.querySelector('.content-section');
            // 无论成功失败都恢复按钮
            btn.disabled = false;
            btn.innerHTML = originalText;

            // 统一内容替换逻辑
            if (newContent) {
                document.querySelector('.content-area').innerHTML = '';
                document.querySelector('.content-area').appendChild(newContent);
            }

            // 使用现有提示系统
            const serverMsg = tempDiv.querySelector('.alert');
            if (serverMsg) {
                showToast(serverMsg.textContent, 'success');
            } else {
                showToast('密码修改成功', 'success');
            }

            closePasswordEditor();
            initGlobalEvents(); // 复用全局事件绑定
        })
        .catch(error => {
            // 网络错误时恢复按钮
            btn.disabled = false;
            btn.innerHTML = originalText;
            console.error('修改失败:', error);
            errorText.textContent = '网络请求失败，请检查连接';
            errorContainer.style.display = 'block';
        })
        .finally(() => {
            btn.innerHTML = originalText;
            btn.disabled = false;
        });
}

