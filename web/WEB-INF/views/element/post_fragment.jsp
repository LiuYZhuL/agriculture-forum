<%--
  Created by IntelliJ IDEA.
  User: Liu
  Date: 2025/6/2
  Time: 10:57
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<c:forEach items="${postVOs}" var="postvo">
    <div class="post-item" onclick="location.href='${pageContext.request.contextPath}/api/post/detail?postId=${postvo.post.id}'">
        <div class="post-left">
            <h3 class="post-title">${postvo.post.title}</h3>
            <div class="post-meta">
                <span class="post-author">${postvo.user}</span>
                <span class="post-category">${postvo.category}</span>
            </div>
            <div class="post-summary">
                    ${fn:substring(postvo.post.content, 0, 100)}...
            </div>
            <div class="post-stats">
                <span>👁️ ${postvo.viewCount}</span>
                <span>👍 ${postvo.likeCount}</span>
                <span>💬 ${postvo.commentCount}</span>
                <span>⭐ ${postvo.collectionCount}</span>
            </div>
        </div>
        <div class="post-right">
            <c:if test="${not empty postvo.attachment}">
                <c:choose>
                    <c:when test="${fn:startsWith(postvo.attachment.fileType, 'image/')}">
                        <img src="${pageContext.request.contextPath}/static/uploads/attachments/img/${postvo.attachment.filePath}"
                             class="post-media"
                             alt="封面图"
                             onerror="this.style.display='none'">
                    </c:when>
                    <c:when test="${fn:startsWith(postvo.attachment.fileType, 'video/')}">
                        <video class="post-media" controls>
                            <source src="${pageContext.request.contextPath}/static/uploads/attachments/video/${postvo.attachment.filePath}" type="${postvo.attachment.fileType}">
                        </video>
                    </c:when>
                </c:choose>
            </c:if>
        </div>
    </div>
</c:forEach>

<input type="hidden" id="hasMore" value="${hasMore}">
