<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>管理员系统</title>
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
            display: none;
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
        /* 在home.css中添加样式 */
        .user-info img {
            width: 40px;  /* 直径=2*半径 */
            height: 40px;
            border-radius: 50%;
            object-fit: cover; /* 保持比例裁剪 */
            display: block; /* 消除图片底部间隙 */
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
            float: none; /* 移除原有浮动 */
            display: inline-flex; /* 改为弹性布局 */
            align-items: center; /* 垂直居中 */
            justify-content: center; /* 水平居中 */
            height: 30px; /* 固定高度 */
        }

        .pagination.pagination-sm form {
            height: 100%;
            display: flex;
            align-items: center;
        }

        .pagination.pagination-sm input[type="submit"] {
            padding: 0 8px;
            line-height: 30px; /* 与容器高度一致 */
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
        <li class="nav-item active" onclick="loadContent('dashboard')">控制台</li>
        <li class="nav-item" onclick="loadContent('userMgt')">用户列表</li>
        <li class="nav-item" onclick="loadContent('categoryMgt')">分类列表（待开发）</li>
        <li class="nav-item" onclick="loadContent('postMgt')">帖子列表（待开发）</li>
        <li class="nav-item" onclick="loadContent('contentMgt')">审核列表（待开发）</li>
        <li class="nav-item">未定功能（待开发）</li>
    </ul>
</div>

<div class="content-area">
    <div id="dashboard" class="content-section" style="display: block;">
        <h2>系统概览</h2>
        <p>这里是管理员控制台，待添加统计信息和快捷操作。</p>
    </div>

    <div id="userMgt" class="content-section" style="display: none;">
        <c:if test="${not empty userMsg}">
            <div style="color: ${userSuccess ? 'green' : 'red'};">${userMsg}</div>
        </c:if>
        <form  action="${pageContext.request.contextPath}/api/admin/manage/user" method="get">
            <div>
                <label for="id">ID：</label>
                <input type="text" id="id" name="id" placeholder="请输入ID" value="${selectUser.id}">
                <label for="username">用户名：</label>
                <input type="text" id="username" name="username" placeholder="请输入用户名" value="${selectUser.username}">
                <label for="email">邮箱：</label>
                <input type="text" id="email" name="email" placeholder="请输入邮箱" value="${selectUser.email}">
                <label for="roleId">角色：</label>
                <select name="roleId" id="roleId">
                    <option value="0" ${selectUser.roleId == 0 ? 'selected' : ''}>全部</option>
                    <option value="1" ${selectUser.roleId == 1 ? 'selected' : ''}>用户</option>
                    <option value="2" ${selectUser.roleId == 2 ? 'selected' : ''}>管理员</option>
                </select>
                <label for="status">状态：</label>
                <select name="status" id="status">
                    <option value="2" ${selectUser.status == 2 ? 'selected' : ''}>全部</option>
                    <option value="1" ${selectUser.status == 1 ? 'selected' : ''}>启用</option>
                    <option value="0" ${selectUser.status == 0 ? 'selected' : ''}>禁用</option>
                </select>
                <button type="submit">搜索</button>
            </div>
        </form>
        <h2>用户列表</h2>
            <table class="user-table">
                <thead>
                <tr>
                    <th>ID</th>
                    <th>用户名</th>
                    <th>密码</th>
                    <th>邮箱</th>
                    <th>角色</th>
                    <th>状态</th>
                    <th>创建时间</th>
                    <th>最后登录</th>
                    <th>操作</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach items="${pageInfo.list}" step="1" var="itemUser">
                    <tr>
                        <td>${itemUser.id}</td>
                        <td>${itemUser.username}</td>
                        <td>
                            <a href="${pageContext.request.contextPath}/api/admin/user/reset?userId=${itemUser.id}">重置密码</a>
                        </td>
                        <td>${itemUser.email}</td>
                        <td>
                            <c:if test="${itemUser.roleId==1}">
                                <span style="color: green;">用户</span>
                            </c:if>
                            <c:if test="${itemUser.roleId==2}">
                                <span style="color: blue;">管理员</span>
                            </c:if>
                        </td>
                        <td>
                            <c:if test="${itemUser.status==1}">
                                <span style="color: green;">启用</span>
                            </c:if>
                            <c:if test="${itemUser.status==0}">
                                <span style="color: red;">禁用</span>
                            </c:if>
                        </td>
                        <!-- 创建时间 YYYY-MM-DD HH:mm:ss -->
                        <td>${itemUser.createTime}</td>
                        <td>${itemUser.lastLoginTime}</td>
                        <td>
                            <a href="${pageContext.request.contextPath}/api/admin/user/update?userId=${itemUser.id}">修改</a>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        <div class="table-container">
            <div style="line-height: 30px;">
                当前第<span class="pageStyle">${pageInfo.pageNum}</span>页
                共<span class="pageStyle">${pageInfo.pages}</span>页
                总计<span class="pageStyle">${pageInfo.total}</span>条
            </div>
            <div>
                <nav aria-label="Page navigation" class="pull-right">
                    <ul class="pagination pagination-sm" style="margin: 0; display: inline-block;">
                        <li>
                            <form  action="${pageContext.request.contextPath}/api/admin/manage/user" method="get">
                                <input type="hidden" name="id" value="${selectUser.id}">
                                <input type="hidden" name="username" value="${selectUser.username}">
                                <input type="hidden" name="email" value="${selectUser.email}">
                                <input type="hidden" name="roleId" value="${selectUser.roleId}">
                                <input type="hidden" name="status" value="${selectUser.status}">
                                <input type="hidden" name="pageNum" value="1">
                                <input type="submit" value="首页" style="border: none; background: none;">
                            </form>
                        </li>
                        <c:if test="${pageInfo.pageNum!=1}">
                            <li>
                                <form  action="${pageContext.request.contextPath}/api/admin/manage/user" method="get">
                                    <input type="hidden" name="id" value="${selectUser.id}">
                                    <input type="hidden" name="username" value="${selectUser.username}">
                                    <input type="hidden" name="email" value="${selectUser.email}">
                                    <input type="hidden" name="roleId" value="${selectUser.roleId}">
                                    <input type="hidden" name="status" value="${selectUser.status}">
                                    <input type="hidden" name="pageNum" value="${pageInfo.pageNum-1}">
                                    <input type="submit" value="上一页" style="border: none; background: none;">
                                </form>
                            </li>
                        </c:if>

                        <c:forEach items="${pageInfo.navigatepageNums}" step="1" var="itemPage">
                            <c:if test="${pageInfo.pageNum == itemPage}">
                                <li class="active">
                                    <form  action="${pageContext.request.contextPath}/api/admin/manage/user" method="get" style="background: whitesmoke">
                                        <input type="hidden" name="id" value="${selectUser.id}">
                                        <input type="hidden" name="username" value="${selectUser.username}">
                                        <input type="hidden" name="email" value="${selectUser.email}">
                                        <input type="hidden" name="roleId" value="${selectUser.roleId}">
                                        <input type="hidden" name="status" value="${selectUser.status}">
                                        <input type="hidden" name="pageNum" value="${itemPage}">
                                        <input type="submit" value="${itemPage}" style="border: none; background: none;">
                                    </form>
                                </li>
                            </c:if>
                            <c:if test="${pageInfo.pageNum != itemPage}">
                                <li>
                                    <form  action="${pageContext.request.contextPath}/api/admin/manage/user" method="get">
                                        <input type="hidden" name="id" value="${selectUser.id}">
                                        <input type="hidden" name="username" value="${selectUser.username}">
                                        <input type="hidden" name="email" value="${selectUser.email}">
                                        <input type="hidden" name="roleId" value="${selectUser.roleId}">
                                        <input type="hidden" name="status" value="${selectUser.status}">
                                        <input type="hidden" name="pageNum" value="${itemPage}">
                                        <input type="submit" value="${itemPage}" style="border: none; background: none;">
                                    </form>
                                </li>
                            </c:if>
                        </c:forEach>
                        <c:if test="${pageInfo.pageNum != pageInfo.pages}">
                            <li>
                                <form  action="${pageContext.request.contextPath}/api/admin/manage/user" method="get">
                                    <input type="hidden" name="id" value="${selectUser.id}">
                                    <input type="hidden" name="username" value="${selectUser.username}">
                                    <input type="hidden" name="email" value="${selectUser.email}">
                                    <input type="hidden" name="roleId" value="${selectUser.roleId}">
                                    <input type="hidden" name="status" value="${selectUser.status}">
                                    <input type="hidden" name="pageNum" value="${pageInfo.pageNum+1}">
                                    <input type="submit" value="下一页" style="border: none; background: none;">
                                </form>
                            </li>
                        </c:if>
                        <li>
                            <form  action="${pageContext.request.contextPath}/api/admin/manage/user" method="get">
                                <input type="hidden" name="id" value="${selectUser.id}">
                                <input type="hidden" name="username" value="${selectUser.username}">
                                <input type="hidden" name="email" value="${selectUser.email}">
                                <input type="hidden" name="roleId" value="${selectUser.roleId}">
                                <input type="hidden" name="status" value="${selectUser.status}">
                                <input type="hidden" name="pageNum" value="${pageInfo.pages}">
                                <input type="submit" value="尾页" style="border: none; background: none;">
                            </form>
                        </li>
                    </ul>
                </nav>
            </div>
        </div>
    </div>

    <div id="categoryMgt" class="content-section" style="display: none;">
        <c:if test="${not empty categoryMsg}">
            <div style="color: ${categorySuccess ? 'green' : 'red'}; margin-bottom: 15px;">
                    ${categoryMsg}
            </div>
        </c:if>
        <form action="${pageContext.request.contextPath}/api/admin/manage/category" method="get">
            <div class="form-group">
                <label for="searchCategory">搜索分类：</label>
                <input type="text" id="searchCategory" name="searchCategory" class="form-control" placeholder="请输入分类名称" value="${searchCategory}">
                <button type="submit" class="btn btn-primary">搜索</button>
            </div>

        </form>
        <form action="${pageContext.request.contextPath}/api/admin/category/add" method="post">
            <div class="form-group">
                <label for="categoryName">分类名称：</label>
                <input type="text" id="categoryName" name="categoryName" class="form-control" placeholder="请输入分类名称">
                <label  for="categoryDesc">分类描述：</label>
                <input type="text" id="categoryDesc" name="categoryDesc" class="form-control" placeholder="请输入分类描述">
                <button type="submit" class="btn btn-primary">添加</button>
            </div>
        </form>
        <h2>分类列表</h2>
        <table class="category-table">
            <thead>
            <tr>
                <th>分类ID</th>
                <th>分类名称</th>
                <th>分类描述</th>
                <th>操作</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach items="${pageCategory.list}" var="category">
                <tr>
                    <td>${category.id}</td>
                    <td>${category.name}</td>
                    <td>${category.description}</td>
                    <td>
                        <a href="${pageContext.request.contextPath}/api/admin/category/update?categoryId=${category.id}">修改</a>
                        <a href="${pageContext.request.contextPath}/api/admin/category/delete?categoryId=${category.id}">删除</a>
                    </td>
                </tr>
            </c:forEach>
            </tbody>
        </table>
        <div class="table-container">
            <div style="line-height: 30px;">
                当前第<span class="pageStyle">${pageCategory.pageNum}</span>页
                共<span class="pageStyle">${pageCategory.pages}</span>页
                总计<span class="pageStyle">${pageCategory.total}</span>条
            </div>
            <div>
                <nav aria-label="Page navigation" class="pull-right">
                    <ul class="pagination pagination-sm" style="margin: 0; display: inline-block;">
                        <li>
                            <form  action="${pageContext.request.contextPath}/api/admin/manage/category" method="get">
                                <input type="hidden" name="searchCategory" value="${searchCategory}">
                                <input type="hidden" name="pageNum" value="1">
                                <input type="submit" value="首页" style="border: none; background: none;">
                            </form>
                        </li>
                        <c:if test="${pageCategory.pageNum!=1}">
                            <li>
                                <form  action="${pageContext.request.contextPath}/api/admin/manage/category" method="get">
                                    <input type="hidden" name="searchCategory" value="${searchCategory}">
                                    <input type="hidden" name="pageNum" value="${pageCategory.pageNum-1}">
                                    <input type="submit" value="上一页" style="border: none; background: none;">
                                </form>
                            </li>
                        </c:if>

                        <c:forEach items="${pageCategory.navigatepageNums}" step="1" var="itemPage">
                            <c:if test="${pageCategory.pageNum == itemPage}">
                                <li class="active">
                                    <form  action="${pageContext.request.contextPath}/api/admin/manage/category" method="get" style="background: whitesmoke">
                                        <input type="hidden" name="searchCategory" value="${searchCategory}">
                                        <input type="hidden" name="pageNum" value="${itemPage}">
                                        <input type="submit" value="${itemPage}" style="border: none; background: none;">
                                    </form>
                                </li>
                            </c:if>
                            <c:if test="${pageCategory.pageNum != itemPage}">
                                <li>
                                    <form  action="${pageContext.request.contextPath}/api/admin/manage/category" method="get">
                                        <input type="hidden" name="searchCategory" value="${searchCategory}">
                                        <input type="hidden" name="pageNum" value="${itemPage}">
                                        <input type="submit" value="${itemPage}" style="border: none; background: none;">
                                    </form>
                                </li>
                            </c:if>
                        </c:forEach>
                        <c:if test="${pageCategory.pageNum != pageCategory.pages}">
                            <li>
                                <form  action="${pageContext.request.contextPath}/api/admin/manage/category" method="get">
                                    <input type="hidden" name="searchCategory" value="${searchCategory}">
                                    <input type="hidden" name="pageNum" value="${pageCategory.pageNum+1}">
                                    <input type="submit" value="下一页" style="border: none; background: none;">
                                </form>
                            </li>
                        </c:if>
                        <li>
                            <form  action="${pageContext.request.contextPath}/api/admin/manage/category" method="get">
                                <input type="hidden" name="searchCategory" value="${searchCategory}">
                                <input type="hidden" name="pageNum" value="${pageCategory.pages}">
                                <input type="submit" value="尾页" style="border: none; background: none;">
                            </form>
                        </li>
                    </ul>
                </nav>
            </div>
        </div>
    </div>
    <div id="postMgt" class="content-section" style="display: none;">
        <h2>帖子列表</h2>

        <!-- 搜索表单 -->
        <form action="${pageContext.request.contextPath}/api/admin/manage/post" method="get">
            <div class="form-group">
                <label for="searchPost">搜索帖子：</label>
                <input type="text" id="searchPost" name="searchPost"
                       class="form-control" placeholder="请输入搜索内容"
                       value="${searchPost}">
                <button type="submit" class="btn btn-primary">搜索</button>
            </div>
        </form>

        <!-- 帖子表格 -->
        <table class="category-table">
            <thead>
            <tr>
                <th>帖子ID</th>
                <th>帖子标题</th>
                <th>作者</th>
                <th>发布时间</th>
                <th>操作</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach items="${pagePost.list}" var="post">
                <tr>
                    <td>${post.id}</td>
                    <td>${post.title}</td>
                    <td>${post.author}</td>
                    <td><fmt:formatDate value="${post.createTime}" pattern="yyyy-MM-dd HH:mm"/></td>
                    <td>
                        <a href="${pageContext.request.contextPath}/api/admin/post/update?postId=${post.id}">修改</a>
                        <a href="${pageContext.request.contextPath}/api/admin/post/delete?postId=${post.id}">删除</a>
                    </td>
                </tr>
            </c:forEach>
            </tbody>
        </table>

        <!-- 分页导航 -->
        <div class="table-container">
            <div style="line-height: 30px;">
                当前第<span class="pageStyle">${pagePost.pageNum}</span>页
                共<span class="pageStyle">${pagePost.pages}</span>页
                总计<span class="pageStyle">${pagePost.total}</span>条
            </div>
            <div>
                <nav aria-label="Page navigation" class="pull-right">
                    <ul class="pagination pagination-sm" style="margin: 0; display: inline-block;">
                        <li>
                            <form action="${pageContext.request.contextPath}/api/admin/manage/post" method="get">
                                <input type="hidden" name="searchPost" value="${searchPost}">
                                <input type="hidden" name="pageNum" value="1">
                                <input type="submit" value="首页" style="border: none; background: none;">
                            </form>
                        </li>
                        <c:if test="${pagePost.pageNum != 1}">
                            <li>
                                <form action="${pageContext.request.contextPath}/api/admin/manage/post" method="get">
                                    <input type="hidden" name="searchPost" value="${searchPost}">
                                    <input type="hidden" name="pageNum" value="${pagePost.pageNum - 1}">
                                    <input type="submit" value="上一页" style="border: none; background: none;">
                                </form>
                            </li>
                        </c:if>
                        <c:forEach items="${pagePost.navigatepageNums}" var="itemPage">
                            <c:choose>
                                <c:when test="${pagePost.pageNum == itemPage}">
                                    <li class="active">
                                        <form action="${pageContext.request.contextPath}/api/admin/manage/post" method="get" style="background: whitesmoke">
                                            <input type="hidden" name="searchPost" value="${searchPost}">
                                            <input type="hidden" name="pageNum" value="${itemPage}">
                                            <input type="submit" value="${itemPage}" style="border: none; background: none;">
                                        </form>
                                    </li>
                                </c:when>
                                <c:otherwise>
                                    <li>
                                        <form action="${pageContext.request.contextPath}/api/admin/manage/post" method="get">
                                            <input type="hidden" name="searchPost" value="${searchPost}">
                                            <input type="hidden" name="pageNum" value="${itemPage}">
                                            <input type="submit" value="${itemPage}" style="border: none; background: none;">
                                        </form>
                                    </li>
                                </c:otherwise>
                            </c:choose>
                        </c:forEach>
                        <c:if test="${pagePost.pageNum != pagePost.pages}">
                            <li>
                                <form action="${pageContext.request.contextPath}/api/admin/manage/post" method="get">
                                    <input type="hidden" name="searchPost" value="${searchPost}">
                                    <input type="hidden" name="pageNum" value="${pagePost.pageNum + 1}">
                                    <input type="submit" value="下一页" style="border: none; background: none;">
                                </form>
                            </li>
                        </c:if>
                        <li>
                            <form action="${pageContext.request.contextPath}/api/admin/manage/post" method="get">
                                <input type="hidden" name="searchPost" value="${searchPost}">
                                <input type="hidden" name="pageNum" value="${pagePost.pages}">
                                <input type="submit" value="尾页" style="border: none; background: none;">
                            </form>
                        </li>
                    </ul>
                </nav>
            </div>
        </div>
    </div>

    <div id="contentMgt" class="content-section" style="display: none;">
        <h2>审核列表</h2>
        <p>审核列表</p>
    </div>

</div>



</body>
<footer>
</footer>

<script>
    window.onload = function() {
        const urlParams = new URLSearchParams(window.location.search);
        let activeSection = urlParams.get('activeSection');

        // 双重保障：优先取URL参数，没有则取Model中的值
        if(!activeSection) activeSection = "${activeSection}";

        if(activeSection) loadContent(activeSection);
    };
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
</script>
</html>
