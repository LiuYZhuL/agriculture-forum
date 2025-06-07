// web/static/js/post.js

// 初始化常量
let currentPage = 1;
let hasMore = true;
let isLoading = false;
let currentParentComment = null; // 当前回复的父级评论

// 滚动加载控制
const handleScroll = () => {
    const { scrollTop, scrollHeight, clientHeight } = document.documentElement;
    if (scrollTop + clientHeight >= scrollHeight - 5 && !isLoading && hasMore) {
        loadMoreComments();
    }
};
window.addEventListener('scroll', handleScroll);

// 加载更多评论
async function loadMoreComments() {
    isLoading = true;
    showLoading(true);

    try {
        const response = await fetch(`${baseUrl}api/comment/page?postId=${postId}&page=${currentPage}`);
        const html = await response.text();
        const tempDiv = document.createElement('div');
        tempDiv.innerHTML = html;

        // 追加新评论
        const newComments = tempDiv.querySelector('#commentsContainer').innerHTML(html);
        document.getElementById('commentsContainer').insertAdjacentHTML('beforeend', newComments);

        // 检查是否还有更多
        hasMore = tempDiv.querySelector('#hasMore')?.value === 'true';
        if (!hasMore) window.removeEventListener('scroll', handleScroll);
        currentPage++;
    } catch (error) {
        console.error('Error loading more comments:', error)
    } finally {
        isLoading = false;
        showLoading(false);
    }
}

// 评论输入框控制
document.getElementById('commentsContainer').addEventListener('click', function(e) {
    // 回复按钮点击
    if (e.target.classList.contains('reply-btn')) {
        const commentItem = e.target.closest('.comment-item');
        currentParentComment = {
            id: commentItem.dataset.commentId,
            username: commentItem.querySelector('.comment-username').textContent
        };
        showCommentInput(`@${currentParentComment.username} `);
    }

    // 删除按钮点击
    if (e.target.classList.contains('delete-btn')) {
        const commentId = e.target.dataset.id;
        deleteComment(commentId);
    }
});

// 显示输入框
function showCommentInput(placeholder = '') {
    const inputBox = document.getElementById('commentInputBox');
    const textarea = document.getElementById('commentContent');
    textarea.value = placeholder;
    inputBox.style.display = 'block';
    textarea.focus();
}

// 提交评论
async function submitComment() {
    const content = document.getElementById('commentContent').value.trim();
    if (!content) return;

    const formData = new URLSearchParams();
    formData.append('postId', postId);
    formData.append('userId', userId);
    formData.append('content', content);
    if (currentParentComment) formData.append('parentId', currentParentComment.id);


    fetch(`${baseUrl}api/comment/add`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: formData
    }).then(response => {
        showAlert('评论成功');
        resetInput();
        //  刷新页面
        window.location.reload();
    });


}

// 删除评论

function deleteComment(commentId){
    if (!confirm('确定要删除该评论吗？')) return;

    fetch(`${baseUrl}api/comment/delete/${commentId}`, {
        method: 'DELETE'
    }).then(response => {
        if (!response.ok) throw new Error('HTTP错误状态码: ' + response.status);
        return response.json();
    })
        .then(data => {
            if (data.success) {
                document.querySelector(`[data-comment-id="${commentId}"]`).remove();
                showAlert('删除成功');
                window.location.reload();
            } else {
                throw new Error(data.message);
            }
        })
        .catch(error => {
            showAlert('删除失败: ' + error.message);
        });
}

// 点赞/收藏切换
async function toggleInteraction(type) {
    const btn = document.getElementById(`${type}Btn`);
    const isActive = btn.classList.contains(type === 'like' ? 'liked' : 'collected');

    const response = await fetch(`${baseUrl}api/post/${type}?postId=${postId}`, {
        method: 'POST'
    }).then(() => {
        btn.classList.toggle(type === 'like' ? 'liked' : 'collected');
        const countSpan = btn.querySelector('span:last-child');
        countSpan.textContent = isActive ?
            parseInt(countSpan.textContent) - 1 :
            parseInt(countSpan.textContent) + 1;
        showAlert(`${type === 'like' ? '点赞' : '收藏'}操作成功`);
        window.location.reload();
    }).catch(error => {
        showAlert('操作失败: ' + error.message);
    });
}

// 辅助函数
function showLoading(show) {
    document.getElementById('loading').style.display = show ? 'block' : 'none';
}

function showAlert(message) {
    alert(message); // 可替换为更优雅的弹窗组件
}

function resetInput() {
    document.getElementById('commentContent').value = '';
    document.getElementById('commentInputBox').style.display = 'none';
    currentParentComment = null;
}
