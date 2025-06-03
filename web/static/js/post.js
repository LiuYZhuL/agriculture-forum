// web/static/js/post.js

let currentPage = 1;
let isLoading = false;

// 滚动监听
const scrollHandler = () => {
    const { scrollTop, scrollHeight, clientHeight } = document.documentElement;
    const threshold = 100;
    if (scrollTop + clientHeight >= scrollHeight - threshold && !isLoading) {
        loadMoreComments();
    }
};

window.addEventListener('scroll', scrollHandler);

function removeScrollListener() {
    window.removeEventListener('scroll', scrollHandler);
}

async function loadMoreComments() {
    isLoading = true;
    showLoading(true);

    try {
        const response = await fetch(`${CONTEXT_PATH}/api/comment/page?postId=${POST_ID}&page=` + currentPage);
        const html = await response.text();

        const tempDiv = document.createElement('div');
        tempDiv.innerHTML = html;

        // 追加评论内容
        document.getElementById('commentsContainer').insertAdjacentHTML('beforeend', tempDiv.innerHTML);

        // 判断是否还有更多评论
        const hasMoreElement = tempDiv.querySelector('#hasMore');
        const hasMore = hasMoreElement ? hasMoreElement.value === 'true' : false;
        if (!hasMore) {
            removeScrollListener();
        }

        currentPage++;
    } catch (error) {
        console.error('加载失败:', error);
    } finally {
        isLoading = false;
        showLoading(false);
    }
}

function showLoading(show) {
    document.getElementById('loading').style.display = show ? 'block' : 'none';
}

// 初始化加载
loadMoreComments();

const commentInputBox = document.getElementById('commentInputBox');
const commentContent = document.getElementById('commentContent');

let currentReplyTo = null; // 当前回复目标用户名
let currentParentId = null; // 当前回复的目标评论 ID

// 显示评论输入框并插入 @ 用户名
function showChildComments(btn, username, parentId) {
    currentReplyTo = username;
    currentParentId = parentId;

    // 设置输入框内容
    commentContent.value = '@' + username;
    commentContent.focus();

    // 显示输入框
    commentInputBox.style.display = 'block';
}

function showCommentInputBox() {
    commentContent.focus();
    commentInputBox.style.display = 'block';
}

// 提交评论
function submitComment() {
    const content = commentContent.value.trim();
    if (!content) return;

    const params = new URLSearchParams();
    params.append('postId', POST_ID);
    params.append('userId', USER_ID);
    params.append('content', content);

    if (currentParentId !== null && currentParentId !== '') {
        params.append('parentId', currentParentId);
    }

    fetch(`${CONTEXT_PATH}/api/comment/add`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: params
    }).then(() => {
        alert('评论成功！');
        window.location.reload();
    }).catch(error => {
        console.error('提交评论失败:', error);
        alert('评论失败，请稍后再试。');
    });

    // 清空并隐藏输入框
    commentContent.value = '';
    commentInputBox.style.display = 'none';

    // 重置状态
    currentReplyTo = null;
    currentParentId = null;
}

// 点击非输入框区域隐藏
document.addEventListener('click', function (event) {
    const isClickInside = commentInputBox.contains(event.target);
    const isReplyButton = event.target.classList.contains('reply-btn');
    const isCommentButton = event.target.closest('#commentBtn') !== null;

    if (!isClickInside && !isReplyButton && !isCommentButton && commentInputBox.style.display === 'block') {
        commentInputBox.style.display = 'none';
        commentContent.value = '';
        currentReplyTo = null;
        currentParentId = null;
    }
});

function toggleLike() {
    const btn = document.getElementById('likeBtn');
    const isLiked = btn.classList.contains('liked');

    fetch(`${CONTEXT_PATH}/api/post/like?postId=${POST_ID}`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded'
        },
    })
        .then(() => {
            window.location.reload();
        })
        .catch(err => {
            console.error(err);
            alert('网络错误');
        });
}

function toggleFavorite() {
    const btn = document.getElementById('favoriteBtn');
    const isCollected = btn.classList.contains('collected');

    fetch(`${CONTEXT_PATH}/api/post/collect?postId=${POST_ID}`, {
        method: 'POST'
    })
        .then(() => {
            window.location.reload();
        })
        .catch(err => {
            console.error(err);
            alert('网络错误');
            alert('网络错误');
        });
}

function deleteComment(commentId, btnElement) {
    if (!confirm('确定要删除这条评论吗？')) return;

    fetch(`${CONTEXT_PATH}/api/comment/delete`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: 'commentId=' + commentId
    })
        .then(() => {
            alert('删除成功！');
            window.location.reload();
        })
        .catch(error => {
            console.error('删除评论失败:', error);
            alert('删除失败，请稍后再试。');
        });
}
