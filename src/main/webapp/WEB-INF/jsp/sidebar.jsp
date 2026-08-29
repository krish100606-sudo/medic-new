<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>

<nav id="sidebar">
    <div class="sidebar-header">
        <div class="icon">+</div>
        HealthData AI
    </div>

    <c:set var="uri" value="${requestScope['jakarta.servlet.forward.servlet_path']}"/>
    <c:if test="${empty uri}">
        <c:set var="uri" value="${pageContext.request.servletPath}"/>
    </c:if>

    <ul class="list-unstyled components">
        <li class="${uri eq '/WEB-INF/jsp/dashboard.jsp' ? 'active' : ''}">
            <a href="${pageContext.request.contextPath}/dashboard"><i class="fa-solid fa-house"></i> Dashboard</a>
        </li>
        <li class="${uri eq '/WEB-INF/jsp/patients.jsp' ? 'active' : ''}">
            <a href="${pageContext.request.contextPath}/patients"><i class="fa-solid fa-users"></i> Patients</a>
        </li>
        <li class="${uri eq '/WEB-INF/jsp/cases.jsp' ? 'active' : ''}">
            <a href="${pageContext.request.contextPath}/cases"><i class="fa-solid fa-file-medical"></i> Cases</a>
        </li>
        <li class="${uri eq '/WEB-INF/jsp/appointments.jsp' ? 'active' : ''}">
            <a href="${pageContext.request.contextPath}/appointments"><i class="fa-solid fa-calendar-check"></i> Appointments</a>
        </li>
        <li class="${uri eq '/WEB-INF/jsp/reports.jsp' ? 'active' : ''}">
            <a href="${pageContext.request.contextPath}/reports"><i class="fa-solid fa-chart-line"></i> Reports</a>
        </li>
    </ul>
    
    <ul class="list-unstyled components" style="margin-top: auto; border-top: 1px solid rgba(255,255,255,0.1);">
        <li class="${uri eq '/WEB-INF/jsp/settings.jsp' ? 'active' : ''}">
            <a href="${pageContext.request.contextPath}/settings"><i class="fa-solid fa-gear"></i> Settings</a>
        </li>
        <li>
            <a href="${pageContext.request.contextPath}/" style="color: #ef4444;"><i class="fa-solid fa-right-from-bracket"></i> Logout</a>
        </li>
    </ul>
</nav>
