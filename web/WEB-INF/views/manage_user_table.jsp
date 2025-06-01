<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<div id="userMgt" class="content-section">
    <c:if test="${not empty userMsg}">
        <div style="color: ${userSuccess ? 'green' : 'red'};">${userMsg}</div>
    </c:if>
    <form id="userSearchForm">
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
            <button type="button" onclick="loadUserPage(1)">搜索</button>
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
                <td><fmt:formatDate value="${itemUser.createTime}" pattern="yyyy-MM-dd HH:mm"/></td>
                <td><fmt:formatDate value="${itemUser.lastLoginTime}" pattern="yyyy-MM-dd HH:mm"/></td>
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
                <ul class="pagination pagination-sm">
                    <li>
                        <button onclick="loadUserPage(1)">首页</button>
                    </li>
                    <c:if test="${pageInfo.pageNum != 1}">
                        <li>
                            <button onclick="loadUserPage(${pageInfo.pageNum-1})">上一页</button>
                        </li>
                    </c:if>
                    <c:forEach items="${pageInfo.navigatepageNums}" step="1" var="itemPage">
                        <c:if test="${pageInfo.pageNum == itemPage}">
                            <li class="active">
                                <button onclick="loadUserPage(${itemPage})" style="background: #666666">${itemPage}</button>
                            </li>
                        </c:if>
                        <c:if test="${pageInfo.pageNum != itemPage}">
                            <li>
                                <button onclick="loadUserPage(${itemPage})">${itemPage}</button>
                            </li>
                        </c:if>
                    </c:forEach>
                    <c:if test="${pageInfo.pageNum != pageInfo.pages}">
                        <li>
                            <button onclick="loadUserPage(${pageInfo.pageNum+1})">下一页</button>
                        </li>
                    </c:if>
                    <li>
                        <button onclick="loadUserPage(${pageInfo.pages})">尾页</button>
                    </li>
                </ul>
            </nav>
        </div>
    </div>
</div>