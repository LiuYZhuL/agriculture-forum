// web/static/js/home.js

document.addEventListener("DOMContentLoaded", function () {
    // 页面加载时根据 URL 参数切换内容
    const urlParams = new URLSearchParams(window.location.search);
    let activeSection = urlParams.get('activeSection');
    if (!activeSection) activeSection = "${activeSection}";
    if (activeSection) {
        loadContent(activeSection); // 调用已有的切换函数
    }
});

// 内容切换逻辑
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
