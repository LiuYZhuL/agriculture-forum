// 在reload.js中改进实现
window.addEventListener('pageshow', function(event) {
    // 同时检测persisted标识和导航类型
    if (event.persisted || performance.navigation.type === 2) {
        window.location.reload();
    }
})
