<%--
  Created by IntelliJ IDEA.
  User: Liu
  Date: 2025/6/2
  Time: 10:05
  To change this template use File | Settings | File Templates.
--%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<c:forEach items="${comments}" var="comment">
    <div class="comment-item" data-comment-id="${comment.id}">
        <div class="comment-header">
            <img src="${pageContext.request.contextPath}/static/uploads/img/${comment.avatar}"
                 class="comment-avatar">
            <span class="comment-username">${comment.username}</span>
            <span class="comment-time"><fmt:formatDate value="${comment.createTime}" pattern="yyyy-MM-dd HH:mm"/></span>
        </div>
        <div class="comment-content">${comment.content}</div>
        <button class="reply-btn" onclick="showChildComments(this, '${comment.username}', ${comment.id})">回复</button>
        <c:if test="${sessionScope.user.id == comment.userId || sessionScope.user.roleId == 2}">
            <button class="delete-btn" onclick="deleteComment(${comment.id}, this)">删除</button>
        </c:if>

        <c:if test="${not empty comment.children}">
            <div class="child-comments">
                <c:forEach items="${comment.children}" var="child">
                    <div class="child-comment">
                        <div class="comment-header">
                            <img src="${pageContext.request.contextPath}/static/uploads/img/${child.avatar}"
                                 class="comment-avatar">
                            <span class="comment-username">${child.username}</span>
                            <span class="comment-time"><fmt:formatDate value="${child.createTime}" pattern="yyyy-MM-dd HH:mm"/></span>
                        </div>
                        <div class="comment-content">${child.content}</div>
                        <button class="reply-btn" onclick="showChildComments(this, '${child.username}', ${comment.id})">回复</button>
                        <c:if test="${sessionScope.user.id == comment.userId || sessionScope.user.roleId == 2}">
                            <button class="delete-btn" onclick="deleteComment(${comment.id}, this)">删除</button>
                        </c:if>
                    </div>
                </c:forEach>
            </div>
        </c:if>
    </div>
</c:forEach>

<%-- 分页控制标记 --%>
<input type="hidden" id="hasMore" value="${hasMore}">

