window.onpageshow = function(event) {
    if (event.persisted) { // 检测到页面是从缓存载入的
        location.reload(); // 强制刷新页面
    }
};