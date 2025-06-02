<%--
  Created by IntelliJ IDEA.
  User: Liu
  Date: 2025/6/2
  Time: 11:59
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%-- knowledge_fragment.jsp --%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<c:forEach items="${knowledgeVOs}" var="knowledge" varStatus="status">
    <div class="knowledge-item"
         onclick="location.href='${pageContext.request.contextPath}/api/knowledge/detail?postId=${knowledge.post.id}'">

            <%-- 媒体内容 --%>
        <div class="knowledge-media">
            <c:choose>
                <c:when test="${fn:startsWith(knowledge.attachment.fileType, 'image/')}">
                    <img src="${pageContext.request.contextPath}/static/uploads/attachments/img/${knowledge.attachment.filePath}"
                         alt="知识封面">
                </c:when>
                <c:when test="${fn:startsWith(knowledge.attachment.fileType, 'video/')}">
                    <video controls>
                        <source src="${pageContext.request.contextPath}/static/uploads/attachments/video/${knowledge.attachment.filePath}"
                                type="${knowledge.attachment.fileType}">
                    </video>
                </c:when>
            </c:choose>
        </div>

            <%-- 文字内容 --%>
        <div class="knowledge-content">
            <h3 class="knowledge-title">${knowledge.post.title}</h3>
            <div class="knowledge-category">${knowledge.category}</div>
            <div class="knowledge-meta">
                <span class="author">${knowledge.user}</span>
                <span class="date"><fmt:formatDate value="${knowledge.post.createTime}" pattern="yyyy-MM-dd"/></span>
            </div>
            <div class="knowledge-stats">
                <span>👍 ${knowledge.likeCount}</span>
                <span>⭐ ${knowledge.collectionCount}</span>
                <span>👁️ ${knowledge.viewCount}</span>
            </div>
        </div>
    </div>
</c:forEach>

<input type="hidden" id="hasMore" value="${hasMore}">

