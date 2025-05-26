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
        .user-table tr th,
        .user-table tr td{text-align: center; padding: 10px; background-color: #f2f2f2; border: 1px solid #ddd;}
    </style>
</head>
<body>

<h1>管理员系统</h1>
<div class="sidebar">
    <ul class="nav-menu">
        <li class="nav-item active" onclick="loadContent('dashboard')">控制台</li>
        <li class="nav-item" onclick="loadContent('userMgt')">用户列表</li>
        <li class="nav-item" onclick="loadContent('postMgt')">帖子列表</li>
        <li class="nav-item" onclick="loadContent('contentMgt')">审核列表</li>
        <li class="nav-item" onclick="loadContent('asdfasdf')">未定功能</li>
    </ul>
</div>

<div class="content-area">
    <div id="dashboard" class="content-section" style="display: block;">
        <h2>系统概览</h2>
        <p>这里是管理员控制台，待添加统计信息和快捷操作。</p>
    </div>

    <div id="userMgt" class="content-section" style="display: none;">
        <h2>用户列表</h2>
            <table class="user-table">
                <thead>
                <tr>
                    <th>ID</th>
                    <th>用户名</th>
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
                            <a href="${pageContext.request.contextPath}/api/admin/manage?userId=${itemUser.id}">修改</a>
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
                    <ul class="pagination pagination-sm" style="margin: 0px; display: inline-block;">
                        <li>
                            <a href="${pageContext.request.contextPath}/api/admin/manage/user?pageNum=1">首页</a>
                        </li>
                        <c:if test="${pageInfo.pageNum!=1}">
                            <li>
                                <a href="${pageContext.request.contextPath}/api/admin/manage/user?pageNum=${pageInfo.pageNum-1}" aria-label="Previous" class="prePage">
                                    <span aria-hidden="true">上一页</span>
                                </a>
                            </li>
                        </c:if>

                        <c:forEach items="${pageInfo.navigatepageNums}" step="1" var="itemPage">
                            <c:if test="${pageInfo.pageNum == itemPage}">
                                <li class="active">
                                    <a
                                            href="${pageContext.request.contextPath}/api/admin/manage/user?pageNum=${itemPage}">${itemPage}</a>
                                </li>
                            </c:if>
                            <c:if test="${pageInfo.pageNum != itemPage}">
                                <li>
                                    <a
                                            href="${pageContext.request.contextPath}/api/admin/manage/user?pageNum=${itemPage}">${itemPage}</a>
                                </li>
                            </c:if>
                        </c:forEach>
                        <c:if test="${pageInfo.pageNum != pageInfo.pages}">
                            <li>
                                <a href="${pageContext.request.contextPath}/api/admin/manage/user?pageNum=${pageInfo.pageNum+1}" aria-label="Next" class="nextPage">
                                    <span aria-hidden="true">下一页</span>
                                </a>
                            </li>
                        </c:if>
                        <li><a
                                href="${pageContext.request.contextPath}/api/admin/manage/user?pageNum=${pageInfo.pages}">尾页</a>
                        </li>
                    </ul>
                </nav>
            </div>
        </div>
    </div>
</div>


    <div id="postMgt" class="content-section" style="display: none;">
        <h2>帖子列表</h2>
        <p>帖子列表</p>
    </div>

    <div id="contentMgt" class="content-section" style="display: none;">
        <h2>审核列表</h2>
        <p>审核列表</p>
    </div>

    <div id="asdfasdf" class="content-section" style="display: none;">
        <h2>未定</h2>
        <p>未定</p>
    </div>

</body>
<footer>
    <a href="${pageContext.request.contextPath}/api/dashboard"
       style="display: inline-block; padding: 6px 12px; background: #eee; border: 1px solid #ccc; text-decoration: none;">
        返回首页
    </a>
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
</body>
</html>
