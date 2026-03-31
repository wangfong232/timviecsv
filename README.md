# 🎓 TimViecSV - Student Job Search & Recruitment Platform

**FPT University Capstone Project - Spring 2026**

👥 Meet the Team (SE1972_Nhom7)

|**Member**|**Professional Role**|**Key Module Responsibilities**|
|---|---|---|
|**PhongTQ** (@wangfong232)|**Team Leader / Developer**|Core Foundation, Job Listing, Student Features, Security, UI/UX, Deployment|
|**ManhND** (@nmalhh)|**Developer**|Employer Features, Authentication, UI/UX Enhancement, Testing|
|**BangNX** (@BangThuHai)|**Developer**|Admin Management, Notification System, Security & Governance|

---

### 📖 Project Overview

**TimViecSV** is a solution designed to modernize the connection between student labor and the part-time job market. It seamlessly integrates a student-facing job search interface with a robust employer and admin management dashboard. Our primary focus is on operational security, recruitment transparency, and strict moderation mechanisms to protect the interests of both students and businesses.

---

### 📋 Product Requirements (Module Scope)

Based on our standardized Use Case architecture, the system is divided into five critical pillars:

#### 📋 **1. Job & Recruitment (Core Logic)**

- **Job Posting**: Multi-stage posting workflow including requirements, salary, and benefits.
    
- **Job Listing & Discovery**: Advanced search with multi-tier filters (location, job type, salary) to help students find the right opportunities.
    
- **Employer Approval Workflow**: Strict admin review process for employer accounts to ensure source credibility.
    
- **Status Tracking**: Controls the job posting lifecycle (Active, Closed, Expired) to optimize data display.
    

#### 👨‍🎓 **2. Student Profile & Career**

- **Dynamic Profiling**: Automated creation and updates of personal profiles, skills, and education.
    
- **Resume/CV Management**: Storage and management of online CV versions, ensuring students are ready to apply anytime.
    
- **Visibility Control**: Privacy mechanisms for student profiles against unauthorized viewing.
    

#### 📧 **3. Application & Communication**

- **One-Click Application**: Streamlined application process with optional custom cover letters.
    
- **Application Workflow**: Employers can review candidate profiles and approve or reject applications with specific reasons.
    
- **Real-time Notifications**: Automated system updates for application status and messages from administrators.
    

#### 💰 **4. Transaction & Ledger**

- **Transaction History**: Stores the entire history of applications and interactions between parties.
    
- **Invoice Management**: Generation and management of invoices for premium posting services (if applicable).
    
- **Payment Integration**: (Future Roadmap) Integration with VNPAY for handling service fee transactions.
    

#### 🔐 **5. Auth & Security**

- **Enterprise Authentication**: Multi-layered login/registration with robust validation.
    
- **Role-Based Access Control (RBAC)**: Deep-level authorization based on specific user roles (Student, Employer, Admin).
    

---

### 🔄 Business Workflow & Governance

The system is built upon modern enterprise governance principles:

- **Separation of Duties (SoD)**: A clear boundary between the "Executor" (Student/Employer) and the "Approver" (Admin). No employer account or high-risk posting can be active without admin oversight.
    
- **Immutable Transaction Ledger**: Every key action (Apply, Approve, Reject) is logged into a permanent system ledger, providing a 100% transparent Audit Trail for dispute resolution.
    
- **User Status Management**: An account "Freezing" mechanism allows administrators to immediately disable accounts that violate platform regulations.
    

---

### 🖥 System Design (Architecture)

#### **Role-Based Access Control (RBAC)**

We implement a deep-level authorization filter:

- **Admin**: Strategic oversight, Master Data, Employer Approval, and System Analytics.
    
- **Employer**: Tactical management of job lifecycles and applicant review.
    
- **Student**: Operational focus on job discovery, career management, and applications.
    
- **Guest**: Public access to job listings and registration features.
    

#### **UI/UX & Navigation**

Utilizing the **Bootstrap 4** framework, the system features a Dashboard-centric design . The Screen Flow is logically mapped to specific roles, ensuring a clean, distraction-free interface that minimizes human error.

---

### 🛠 Tech Stack

- **Backend**: Java 8+, Servlet, JSP, JDBC .
    
- **Database**: Microsoft SQL Server 2012+ .
    
- **Security**: Session-based Authentication, URL-pattern Authorization Filters.
    
- **Frontend**: HTML5, CSS3, JavaScript, Bootstrap 4, JSTL .
    
- **Deployment**: Apache Tomcat 8.0+, Apache Ant.
    

**Developed by Team SE1972_Nhom7 - FPT University @ 2026**
