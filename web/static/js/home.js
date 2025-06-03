// 修改后的 window.onload
window.onload = function() {
    const urlParams = new URLSearchParams(window.location.search);
    let activeSection = urlParams.get('activeSection');

    if (!activeSection) activeSection = DEFAULT_ACTIVE_SECTION; // 使用全局变量

    if (activeSection) {
        loadContent(activeSection);
    }
};

// 修改后的 loadContent 函数
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

        // 激活对应的导航项
        const navItem = document.querySelector(`.nav-item[data-section="${sectionId}"]`);
        if (navItem) navItem.classList.add('active');
    }
}