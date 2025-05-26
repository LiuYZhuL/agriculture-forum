<%@ page contentType="text/html;charset=UTF-8" language="java" %>
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
    </style>
</head>
<body>

<h1>管理员系统</h1>
<div class="sidebar">
    <ul class="nav-menu">
        <li class="nav-item active" onclick="loadContent('dashboard')">控制台</li>
        <li class="nav-item" onclick="loadContent('userMgt')">用户列表</li>
        <li class="nav-item" onclick="loadContent('contentMgt')">修改用户状态</li>
        <li class="nav-item" onclick="loadContent('systemConfig')">修改用户角色</li>
        <li class="nav-item" onclick="loadContent('auditLog')">获取用户信息</li>
    </ul>
</div>

<div class="content-area">
    <div id="dashboard" class="content-section">
        <h2>系统概览</h2>
        <p>这里是管理员控制台，待添加统计信息和快捷操作。</p>
    </div>

    <div id="userMgt" class="content-section" style="display: none;">
        <h2>用户列表</h2>
        <div class="table-container">
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
                <c:forEach items="${userList}" var="user">
                    <tr>
                        <td>${user.id}</td>
                        <td>${user.username}</td>
                        <td>${user.email}</td>
                        <td>${user.roleId == 1 ? '管理员' : '普通用户'}</td>
                        <td>${user.status == 1 ? '正常' : '锁定'}</td>
                        <td><fmt:formatDate value="${user.createTime}" pattern="yyyy-MM-dd HH:mm"/></td>
                        <td><fmt:formatDate value="${user.lastLoginTime}" pattern="yyyy-MM-dd HH:mm"/></td>
                        <td>
                            <button onclick="editUser(${user.id})">编辑</button>
                            <button onclick="changeStatus(${user.id}, ${user.status == 1 ? 0 : 1})">
                                    ${user.status == 1 ? '锁定' : '解锁'}
                            </button>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </div>
    </div>
    </div>


    <div id="contentMgt" class="content-section" style="display: none;">
        <h2>修改用户状态</h2>
        <form id="statusForm"action="${pageContext.request.contextPath}/api/admin/manage" method="post">
            <div>
                <label for="userId">用户ID:</label>
                <input type="number" id="userId" name="userId" required>
            </div>
            <div>
                <label for="status">状态:</label>
                <select id="status" name="status" required>
                    <option value="1">启用</option>
                    <option value="0">禁用</option>
                </select>
            </div>
            <button type="submit">更新状态</button>
        </form>

        <p>修改用户状态</p>
    </div>

    <div id="systemConfig" class="content-section" style="display: none;">
        <h2>修改用户角色</h2>
        <p>修改用户角色</p>
    </div>

    <div id="auditLog" class="content-section" style="display: none;">
        <h2>获取用户信息</h2>
        <p>获取用户信息</p>
    </div>

</div>

<script>
    // 内容切换逻辑（与原有逻辑一致）
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
