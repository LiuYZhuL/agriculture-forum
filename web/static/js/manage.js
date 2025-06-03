// web/static/js/manage.js

window.onload = function() {
    const urlParams = new URLSearchParams(window.location.search);
    let activeSection = urlParams.get('activeSection');

    // 双重保障：优先取URL参数，没有则取全局变量（来自服务端）
    if(!activeSection) activeSection = window.serverActiveSection;

    if(activeSection) {
        // 激活对应导航项并加载内容
        activateNavItem(activeSection);
        loadContent(activeSection);
    } else {
        // 默认激活dashboard
        activateNavItem('dashboard');
        loadContent('dashboard');
    }
};

// 激活导航项
function activateNavItem(sectionId) {
    document.querySelectorAll('.nav-item').forEach(item => {
        if (item.getAttribute('data-section') === sectionId) {
            item.classList.add('active');
        } else {
            item.classList.remove('active');
        }
    });
}

// 加载内容区域
function loadContent(sectionId) {
    // 隐藏所有内容区
    document.querySelectorAll('.content-section').forEach(section => {
        section.style.display = 'none';
    });

    // 显示目标内容
    const targetSection = document.getElementById(sectionId);
    if(targetSection) {
        targetSection.style.display = 'block';
    }
};
function loadContent(sectionId) {
    // 移除所有active状态
    document.querySelectorAll('.nav-item').forEach(item => {
        item.classList.remove('active');
    });

    // 隐藏所有内容区
    document.querySelectorAll('.content-section').forEach(section => {
        section.style.display = 'none';
    });

    // 显示目标内容
    document.getElementById(sectionId).style.display = 'block';
    event.target.classList.add('active');
}
function navigateToPostPage(pageNum) {
    const params = new URLSearchParams({
        postId: document.getElementById('postId').value,
        user: document.getElementById('user').value,
        title: document.getElementById('title').value,
        sts: document.getElementById('sts').value, // 修正参数名为sts
        categoryId: document.getElementById('category').value,
        isTop: document.getElementById('isTop').value,
        isEssence: document.getElementById('isEssence').value,
        pageNum: pageNum
    });
    window.location.href =
        `${baseUrl}/api/admin/manage/post?` + params;
}
// 显示弹窗
function showEditModal(id, name, desc) {
    document.getElementById('editId').value = id;
    document.getElementById('editName').value = name || '';
    document.getElementById('editDesc').value = desc || '';
    document.getElementById('modalOverlay').style.display = 'block';
    document.getElementById('editModal').style.display = 'block';
}

// 关闭弹窗
function closeEditModal() {
    document.getElementById('modalOverlay').style.display = 'none';
    document.getElementById('editModal').style.display = 'none';
}

// 点击遮罩层关闭
document.getElementById('modalOverlay').addEventListener('click', closeEditModal);
