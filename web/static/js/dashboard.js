document.addEventListener("DOMContentLoaded", function () {
    // 自动调整文本域高度（保持原有逻辑）
    const autoResize = textarea => {
        textarea.style.height = 'auto';
        textarea.style.height = textarea.scrollHeight + 'px';
    };

    document.querySelectorAll('.auto-resize').forEach(textarea => {
        autoResize(textarea);
        textarea.addEventListener('input', () => autoResize(textarea));
        window.addEventListener('resize', () => autoResize(textarea));
    });
});
