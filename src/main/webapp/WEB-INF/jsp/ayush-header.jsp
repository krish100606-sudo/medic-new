<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!-- National Tricolor Top Stripe (Government of India) -->
<div class="gov-tricolor-stripe" aria-hidden="true"></div>

<!-- Official Government Micro-Header Bar -->
<div class="gov-micro-header">
    <div class="gov-micro-left">
        <span>भारत सरकार | Government of India</span>
        <span style="color: var(--color-border);">&bull;</span>
        <span>आयुष मंत्रालय | Ministry of Ayush</span>
    </div>
    <div class="gov-micro-right">
        <a href="#mainContent" class="gov-micro-link" style="font-size:0.75rem;">Skip to Main Content</a>
        
        <!-- Font Size Scaling Controls -->
        <div class="a11y-font-group" role="group" aria-label="Font Size Controls">
            <button type="button" class="a11y-font-btn" onclick="if(window.setFontScale) setFontScale('decrease')" title="Decrease font size">A-</button>
            <button type="button" class="a11y-font-btn active" onclick="if(window.setFontScale) setFontScale('reset')" title="Standard font size">A</button>
            <button type="button" class="a11y-font-btn" onclick="if(window.setFontScale) setFontScale('increase')" title="Increase font size">A+</button>
        </div>

        <!-- Bilingual Toggle (EN / HI) -->
        <button type="button" class="lang-toggle-btn" onclick="if(window.toggleLanguage) toggleLanguage()" title="Switch Language / भाषा बदलें">
            <span id="current-lang-text">EN / HI</span>
        </button>
    </div>
</div>

<!-- Official Portal Brand & Emblem Bar -->
<header class="portal-brand-bar">
    <a href="/" class="portal-brand-wrapper">
        <svg class="portal-emblem-svg" viewBox="0 0 100 100" fill="none" xmlns="http://www.w3.org/2000/svg">
            <circle cx="50" cy="50" r="47" stroke="#0B2559" stroke-width="2.5" fill="#FFFFFF"/>
            <circle cx="50" cy="50" r="43" stroke="#1E9E5A" stroke-width="1.2" fill="#F8FAFC"/>
            <path d="M22 68 C32 60, 68 60, 78 68 C68 76, 32 76, 22 68 Z" fill="#F4811F"/>
            <path d="M50 22 L57 37 L73 37 L60 48 L65 64 L50 54 L35 64 L40 48 L27 37 L43 37 Z" fill="#0B2559"/>
            <circle cx="50" cy="45" r="8" stroke="#1E9E5A" stroke-width="2" fill="#FFFFFF"/>
            <circle cx="50" cy="45" r="2.5" fill="#0B2559"/>
            <text x="50" y="85" font-size="6.8" font-weight="900" fill="#0B2559" text-anchor="middle" font-family="'Noto Sans Devanagari', sans-serif">सत्यमेव जयते</text>
        </svg>
        <div class="portal-brand-titles">
            <span class="brand-hindi">आयुष स्वास्थ्य ईएचआर पोर्टल</span>
            <span class="brand-eng">Ayush Clinical EHR & ABDM Digital Health Mission Portal</span>
        </div>
    </a>

    <div class="portal-brand-meta">
        <div class="compliance-badge-pill abdm" title="ABDM Milestone 2 & 3 Certified Gateway">
            <span>ABDM Compliant<br><strong style="font-size:0.68rem;">FHIR/HL7 M2 & M3</strong></span>
        </div>
        <div class="profile-avatar-pill" title="Current Logged In Officer">
            <img src="/images/dr_priya.jpg" alt="Doctor Avatar" class="profile-thumb">
            <div class="profile-info">
                <span class="profile-name">Dr. V. Sharma, MD (Ayu)</span>
                <span class="profile-role">Senior Medical Officer</span>
            </div>
        </div>
    </div>
</header>
