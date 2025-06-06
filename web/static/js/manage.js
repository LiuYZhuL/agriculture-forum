
function loadContent(section) {
    const contentArea = document.querySelector('.content-area');
    // 清空内容区域
    contentArea.innerHTML  = '';
    fetch(`${baseUrl}api/admin/manage/${section}`, {
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
