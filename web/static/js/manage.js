// web/static/js/manage.js

document.addEventListener("DOMContentLoaded", function () {
    const urlParams = new URLSearchParams(window.location.search);
    let activeSection = urlParams.get('activeSection');

    // 双重保障：优先取URL参数，没有则取Model中的值
    if (!activeSection) activeSection = "${activeSection}";

    if (activeSection) loadContent(activeSection);
});

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
    const targetSection = document.getElementById(sectionId);
    if (targetSection) {
        targetSection.style.display = 'block';
        event.target.classList.add('active');
    }
}

function navigateToPostPage(pageNum) {
    const params = new URLSearchParams({
        postId: '${selectPost.postId}',
        user: '${selectPost.user}',
        title: '${selectPost.title}',
        status: '${selectPost.sts}',
        categoryId: '${selectPost.categoryId}',
        isTop: '${selectPost.isTop}',
        isEssence: '${selectPost.isEssence}',
        pageNum: pageNum
    });
    window.location.href = '${pageContext.request.contextPath}/api/admin/manage/post?' + params;
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
