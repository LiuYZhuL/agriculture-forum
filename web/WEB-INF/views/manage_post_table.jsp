<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<div id="postMgt" class="content-section">
    <h2>帖子列表</h2>
    <c:if test="${not empty postMsg}">
        <div style="color: ${postSuccess ? 'green' : 'red'}; margin-bottom: 15px;">
                ${postMsg}
        </div>
    </c:if>
    <form id="postSearchForm">
        <div class="form-group">
            <label for="postId">id:</label>
            <input type="text" id="postId" name="postId" value="${selectPost.postId}">
            <label for="user">用户名:</label>
            <input type="text" id="user" name="user" value="${selectPost.user}">
            <label for="title">标题:</label>
            <input type="text" id="title" name="title" value="${selectPost.title}">
            <label for="sts">状态:</label>
            <select id="sts" name="sts">
                <option value="">全部</option>
                <option value="0" <c:if test="${selectPost.sts == 0}">selected</c:if>>未审核</option>
                <option value="1" <c:if test="${selectPost.sts == 1}">selected</c:if>>已审核</option>
                <option value="2" <c:if test="${selectPost.sts == 2}">selected</c:if>>待修改</option>
            </select>
            <label for="category">分类:</label>
            <select id="category" name="categoryId">
                <option value="">全部</option>
                <c:forEach items="${categories}" var="category">
                    <option value="${category.id}" <c:if test="${selectPost.categoryId == category.id}">selected</c:if>>${category.name}</option>
                </c:forEach>
            </select>
            <label for="isTop">置顶:</label>
            <select id="isTop" name="isTop">
                <option value="">全部</option>
                <option value="0" <c:if test="${selectPost.isTop == 0}">selected</c:if>>否</option>
                <option value="1" <c:if test="${selectPost.isTop == 1}">selected</c:if>>是</option>
            </select>
            <label for="isEssence">精华:</label>
            <select id="isEssence" name="isEssence">
                <option value="">全部</option>
                <option value="0" <c:if test="${selectPost.isEssence == 0}">selected</c:if>>否</option>
                <option value="1" <c:if test="${selectPost.isEssence == 1}">selected</c:if>>是</option>
            </select>
            <button type="button" class="btn btn-primary" onclick="loadPostPage(1)">搜索</button>
        </div>
    </form>
    <table class="category-table">
        <thead>
        <tr>
            <th>帖子ID</th>
            <th>帖子标题</th>
            <th>作者</th>
            <th>分类</th>
            <th>状态</th>
            <th>状态操作</th>
            <th>置顶</th>
            <th>置顶操作</th>
            <th>精华</th>
            <th>精华操作</th>
            <th>发布时间</th>
            <th>浏览量</th>
            <th>帖子操作</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach items="${pagePost.list}" var="post">
            <tr>
                <td>${post.id}</td>
                <td>${post.title}</td>
                <td>${post.username}</td>
                <td>${post.category}</td>
                <td>
                    <c:if test="${post.status == 0}">
                        <span style="color: red;">未审核</span>
                    </c:if>
                    <c:if test="${post.status == 1}">
                        <span style="color: green;">已审核</span>
                    </c:if>
                    <c:if test="${post.status == 2}">
                        <span style="color: gray;">须修改</span>
                    </c:if>
                </td>
                <td>
                    <c:if test="${post.status != 1}">
                        <a href="${pageContext.request.contextPath}/api/post/status?postId=${post.id}&status=1">通过</a>
                    </c:if>
                    <c:if test="${post.status != 2}">
                        <a href="${pageContext.request.contextPath}/api/post/status?postId=${post.id}&status=2">不通过</a>
                    </c:if>
                </td>
                <td>
                    <c:if test="${post.isTop == 0}">
                        <span style="color: red;">否</span>
                    </c:if>
                    <c:if test="${post.isTop == 1}">
                        <span style="color: green;">是</span>
                    </c:if>
                </td>
                <td>
                    <c:if test="${post.isTop != 1}">
                        <a href="${pageContext.request.contextPath}/api/post/top?postId=${post.id}&isTop=1">置顶</a>
                    </c:if>
                    <c:if test="${post.isTop != 0}">
                        <a href="${pageContext.request.contextPath}/api/post/top?postId=${post.id}&isTop=0">取消置顶</a>
                    </c:if>
                </td>
                <td>
                    <c:if test="${post.isEssence == 0}">
                        <span style="color: red;">否</span>
                    </c:if>
                    <c:if test="${post.isEssence == 1}">
                        <span style="color: green;">是</span>
                    </c:if>
                </td>
                <td>
                    <c:if test="${post.isEssence != 1}">
                        <a href="${pageContext.request.contextPath}/api/post/essence?postId=${post.id}&isEssence=1">精华</a>
                    </c:if>
                    <c:if test="${post.isEssence != 0}">
                        <a href="${pageContext.request.contextPath}/api/post/essence?postId=${post.id}&isEssence=0">取消精华</a>
                    </c:if>
                </td>
                <td><fmt:formatDate value="${post.createTime}" pattern="yyyy-MM-dd HH:mm"/></td>
                <td>${post.viewCount}</td>
                <td>
                    <a href="${pageContext.request.contextPath}/api/post/show?postId=${post.id}">详情</a>
                    <a href="${pageContext.request.contextPath}/api/post/delete?postId=${post.id}">删除</a>
                </td>
            </tr>
        </c:forEach>
        </tbody>
    </table>
    <div class="table-container">
        <div style="line-height: 30px;">
            当前第<span class="pageStyle">${pagePost.pageNum}</span>页
            共<span class="pageStyle">${pagePost.pages}</span>页
            总计<span class="pageStyle">${pagePost.total}</span>条
        </div>
        <div>
            <nav aria-label="Page navigation" class="pull-right">
                <ul class="pagination pagination-sm">
                    <li>
                        <button onclick="loadPostPage(1)">首页</button>
                    </li>
                    <c:if test="${pagePost.pageNum != 1}">
                        <li>
                            <button onclick="loadPostPage(${pagePost.pageNum - 1})">上一页</button>
                        </li>
                    </c:if>
                    <c:forEach items="${pagePost.navigatepageNums}" var="itemPage">
                        <c:choose>
                            <c:when test="${pagePost.pageNum == itemPage}">
                                <li class="active">
                                    <button onclick="loadPostPage(${itemPage})" style="background: #666666">${itemPage}</button>
                                </li>
                            </c:when>
                            <c:otherwise>
                                <li>
                                    <button onclick="loadPostPage(${itemPage})">${itemPage}</button>
                                </li>
                            </c:otherwise>
                        </c:choose>
                    </c:forEach>
                    <c:if test="${pagePost.pageNum != pagePost.pages}">
                        <li>
                            <button onclick="loadPostPage(${pagePost.pageNum + 1})">下一页</button>
                        </li>
                    </c:if>
                    <li>
                        <button onclick="loadPostPage(${pagePost.pages})">尾页</button>
                    </li>
                </ul>
            </nav>
        </div>
    </div>
</div>