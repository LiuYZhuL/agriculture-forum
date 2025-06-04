document.addEventListener('DOMContentLoaded', function() {
    let currentPage = 1;
    let isLoading = false;
    let currentKeyword = '';
    let currentCategory = '';

    // 绑定搜索按钮事件
    document.querySelector('#searchForm button').addEventListener('click', performSearch);

    // 滚动事件监听
    window.addEventListener('scroll', handleScroll);

    function handleScroll() {
        const { scrollTop, scrollHeight, clientHeight } = document.documentElement;
        if (scrollTop + clientHeight >= scrollHeight - 5 && !isLoading) {
            loadMoreKnows();
        }
    }

    function performSearch() {
        currentPage = 1;
        currentKeyword = document.querySelector('input[name="keyword"]').value;
        currentCategory = document.querySelector('select[name="category"]').value;
        document.getElementById('knowledgeContainer').innerHTML = '';
        loadMoreKnows();
    }

    async function loadMoreKnows() {
        if (isLoading) return;

        isLoading = true;
        document.getElementById('loading').style.display = 'block';

        try {
            const params = new URLSearchParams({
                page: currentPage,
                keyword: currentKeyword,
                category: currentCategory
            });

            const response = await fetch(`${baseUrl}api/knowledge/search?${params}`);
            const html = await response.text();

            document.getElementById('knowledgeContainer').insertAdjacentHTML('beforeend', html);
            currentPage++;

            // 修改原代码中的判断逻辑
            const knowledgeContainer = document.getElementById('knowledgeContainer');
            const lastHasMore = knowledgeContainer.lastElementChild?.querySelector('#hasMore');
            if (!lastHasMore || lastHasMore.value !== 'true') {
                window.removeEventListener('scroll', handleScroll);
            }

        } catch (error) {
            console.error('Error:', error);
        } finally {
            isLoading = false;
            document.getElementById('loading').style.display = 'none';
        }
    }
});