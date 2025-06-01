<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<html>
<head>
    <title>管理员系统</title>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <style type="text/css">
        .sidebar {
            background: #34495e;
            width: 200px;
            float: left;
            min-height: 500px;
        }
        .nav-menu {
            list-style: none;
            padding: 0;
            margin: 0;
        }
        .nav-item {
            padding: 12px 20px;
            color: #ecf0f1;
            cursor: pointer;
            transition: 0.3s;
        }
        .nav-item:hover,
        .nav-item.active {
            background: #3a5169;
            border-left: 4px solid #2c3e50;
        }
        .content-area {
            margin-left: 220px;
            padding: 20px;
        }
        .content-section {
            display: block !important; /* 强制显示 */
            opacity: 1 !important; /* 覆盖动画效果 */
            animation: none !important;
            background: white;
            padding: 20px;
            border-radius: 5px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        }
        ul,li{list-style: none;}
        li{float: left; display: block; margin-right: 10px;}
        .user-table tr th, .category-table tr th,
        .user-table tr td, .category-table tr td{text-align: center; padding: 10px; background-color: #f2f2f2; border: 1px solid #ddd;}
        .header {
            background: #2c3e50;
            color: white;
            padding: 15px 30px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            box-shadow: 0 2px 5px rgba(0,0,0,0.4);
        }

        .user-info {
            font-size: 16px;
            display: flex;
            align-items: center;
            position: relative;
            cursor: pointer;
        }
        .user-info img {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            object-fit: cover;
            display: block;
            margin-right: 10px;
        }
        .dropdown-menu {
            display: none;
            position: absolute;
            top: 100%;
            right: 0;
            background: white;
            min-width: 160px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.2);
            border-radius: 4px;
            z-index: 1;
        }

        .user-info:hover .dropdown-menu {
            display: block;
        }

        .dropdown-menu a {
            display: block;
            padding: 10px 15px;
            color: #333;
            text-decoration: none;
        }

        .dropdown-menu a:hover {
            background: #f5f5f5;
        }
        .pagination.pagination-sm li {
            float: none;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            height: 30px;
        }

        .pagination.pagination-sm form {
            height: 100%;
            display: flex;
            align-items: center;
        }

        .pagination.pagination-sm input[type="submit"] {
            padding: 0 8px;
            line-height: 30px;
        }

        .loading-indicator {
            text-align: center;
            padding: 20px;
            color: #666;
        }

        .ajax-content {
            opacity: 1 !important;
            animation: none;
        }

        @keyframes fadeIn {
            from { opacity: 0; }
            to { opacity: 1; }
        }
    </style>
</head>
<body>
<div class="header">
    <div class="logo">首页</div>
    <div class="user-info">
        <c:if test="${sessionScope.user == null}">
            <span>还未登录,来登录吧！</span>
            <div class="dropdown-menu">
                <a href="${pageContext.request.contextPath}/api/user/login">登录</a>
                <a href="${pageContext.request.contextPath}/api/user/register">注册</a>
            </div>
        </c:if>
        <c:if test="${sessionScope.user!= null}">
            <img src="${pageContext.request.contextPath}/static/uploads/img/${sessionScope.user.avatar}"
                 alt="头像"
                 style="width: 40px; height: 40px; object-fit: cover;">
            <span>欢迎，${sessionScope.user.username}</span>
            <div class="dropdown-menu">
                <a href="${pageContext.request.contextPath}/api/dashboard">首页</a>
                <a href="${pageContext.request.contextPath}/api/user/home">用户中心</a>
                <c:if test="${sessionScope.user.roleId == 2}">
                    <a href="${pageContext.request.contextPath}/api/admin/manage/">管理员中心</a>
                </c:if>
                <a href="${pageContext.request.contextPath}/api/user/logout">登出</a>
            </div>
        </c:if>
    </div>
</div>
<div class="sidebar">
    <ul class="nav-menu">
        <li class="nav-item active" data-section="dashboard">控制台</li>
        <li class="nav-item" data-section="userMgt">用户列表</li>
        <li class="nav-item" data-section="categoryMgt">分类列表</li>
        <li class="nav-item" data-section="postMgt">帖子列表</li>
        <li class="nav-item" data-section="contentMgt">审核列表（待开发）</li>
        <li class="nav-item">未定功能（待开发）</li>
    </ul>
</div>

<div class="content-area" id="contentContainer">
    <div id="dashboard" class="content-section ajax-content" style="display: block;">
        <h2>系统概览</h2>
        <div class="dashboard-stats">
            <div class="stat-card">
                <h3>用户总数</h3>
                <p id="totalUsers">加载中...</p>
            </div>
            <div class="stat-card">
                <h3>分类总数</h3>
                <p id="totalCategories">加载中...</p>
            </div>
            <div class="stat-card">
                <h3>帖子总数</h3>
                <p id="totalPosts">加载中...</p>
            </div>
        </div>
    </div>
</div>

<script>
    $(document).ready(function() {
        // 初始加载控制台
        loadSection('dashboard');

        // 菜单点击事件
        $('.nav-item').click(function() {
            $('.nav-item').removeClass('active');
            $(this).addClass('active');

            const section = $(this).data('section');
            loadSection(section);
        });

        // 加载统计数据
        loadDashboardStats();
    });

    function loadSection(section) {
        // 显示加载状态
        $('#contentContainer').html('<div class="loading-indicator">加载中，请稍候...</div>');

        let url = '${pageContext.request.contextPath}/api/admin/manage/ajax/';
        let params = {};

        switch(section) {
            case 'userMgt':
                url += 'user';
                // 保留搜索条件
                params = {
                    id: $('#id').val() || '',
                    username: $('#username').val() || '',
                    email: $('#email').val() || '',
                    roleId: $('#roleId').val() || '0',
                    status: $('#status').val() || '2'
                };
                break;

            case 'categoryMgt':
                url += 'category';
                params = {
                    searchCategory: $('#searchCategory').val() || '',
                    pageNum: 1
                };
                break;

            case 'postMgt':
                url += 'post';
                params = {
                    postId: $('#postId').val() || '',
                    user: $('#user').val() || '',
                    title: $('#title').val() || '',
                    sts: $('#sts').val() || '',
                    categoryId: $('#category').val() || '',
                    isTop: $('#isTop').val() || '',
                    isEssence: $('#isEssence').val() || '',
                    pageNum: 1
                };
                break;

            case 'dashboard':
                // 控制台不需要AJAX加载
                $('#contentContainer').html(`
                    <div id="dashboard" class="content-section ajax-content" style="display: block;">
                        <h2>系统概览</h2>
                        <div class="dashboard-stats">
                            <div class="stat-card">
                                <h3>用户总数</h3>
                                <p id="totalUsers">加载中...</p>
                            </div>
                            <div class="stat-card">
                                <h3>分类总数</h3>
                                <p id="totalCategories">加载中...</p>
                            </div>
                            <div class="stat-card">
                                <h3>帖子总数</h3>
                                <p id="totalPosts">加载中...</p>
                            </div>
                        </div>
                    </div>
                `);
                loadDashboardStats();
                return;

            default:
                $('#contentContainer').html(`
                    <div class="content-section ajax-content">
                        <h2>${section == 'contentMgt' ? '审核列表' : '功能开发中'}</h2>
                        <p>该功能正在开发中，敬请期待...</p>
                    </div>
                `);
                return;
        }

        // AJAX请求
        $.ajax({
            url: url,
            type: 'GET',
            data: params,
            success: function(data) {
                $('#contentContainer').html(data)
                    .addClass('ajax-content')
                    .data('currentPage', params.pageNum || 1); // 保留当前页码
                updateUrl(section, params); // 更新URL参数
            },
            error: function() {
                $('#contentContainer').html('<div class="error">加载失败，请重试</div>');
            }
        });
    }

    function loadDashboardStats() {
        // 获取统计数据

    }

    // ====================== 分页函数 ======================
    function loadUserPage(pageNum) {
        const params = {
            pageNum: pageNum,
            id: $('#id').val() || '',
            username: $('#username').val() || '',
            email: $('#email').val() || '',
            roleId: $('#roleId').val() || '0',
            status: $('#status').val() || '2'
        };

        $.ajax({
            url: '${pageContext.request.contextPath}/api/admin/manage/ajax/user',
            type: 'GET',
            data: params,
            success: function(data) {
                $('#userMgt').replaceWith(data);
            }
        });
    }

    function loadCategoryPage(pageNum) {
        const params = {
            pageNum: pageNum,
            searchCategory: $('#searchCategory').val() || ''
        };

        $.ajax({
            url: '${pageContext.request.contextPath}/api/admin/manage/ajax/category',
            type: 'GET',
            data: params,
            success: function(data) {
                $('#categoryMgt').replaceWith(data);
            }
        });
    }

    function loadPostPage(pageNum) {
        const params = {
            pageNum: pageNum,
            postId: $('#postId').val() || '',
            user: $('#user').val() || '',
            title: $('#title').val() || '',
            sts: $('#sts').val() || '',
            categoryId: $('#category').val() || '',
            isTop: $('#isTop').val() || '',
            isEssence: $('#isEssence').val() || ''
        };

        $.ajax({
            url: '${pageContext.request.contextPath}/api/admin/manage/ajax/post',
            type: 'GET',
            data: params,
            success: function(data) {
                $('#postMgt').replaceWith(data);
            }
        });
    }
</script>
</body>
</html>