# 🏫 School Management App Demo

A comprehensive, multi-platform Flutter application for school management with role-based access control. Students, parents, teachers, staff, and administrators can manage academic performance, attendance, fees, salaries, and more through an intuitive dashboard interface.

[![Flutter](https://img.shields.io/badge/Flutter-3.9+-blue.svg)](https://flutter.dev/)
[![Dart](https://img.shields.io/badge/Dart-3.9+-blue.svg)](https://dart.dev/)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![Platform](https://img.shields.io/badge/Platform-iOS%20%7C%20Android%20%7C%20macOS%20%7C%20Windows%20%7C%20Linux-blue.svg)]()

## 📋 Table of Contents

- [Overview](#-overview)
- [Features](#-features)
- [Tech Stack](#-tech-stack)
- [Project Structure](#-project-structure)
- [Prerequisites](#-prerequisites)
- [Installation](#-installation)
- [Configuration](#-configuration)
- [Running the App](#-running-the-app)
- [Role-Based Features](#-role-based-features)
- [Architecture](#-architecture)
- [API Integration](#-api-integration)
- [Development](#-development)
- [Related Projects](#-related-projects)
- [Contributing](#-contributing)
- [License](#-license)

## 📱 Overview

School Management App Demo is a feature-rich Flutter application designed to modernize school administration and student engagement. Built with clean architecture principles and state management using Provider, it seamlessly integrates with a Node.js backend to provide real-time data synchronization across all user roles.

The app supports **5 distinct user roles** with specialized dashboards and feature sets:
- **Students** - Track grades, attendance, fees, examination schedules
- **Parents** - Monitor student performance and communicate with school
- **Teachers** - Mark attendance, record grades, manage salary records
- **Staff** - View tasks, attendance, and salary history
- **Administrators** - Complete system control with financial and user management

## ✨ Features

### 🔐 Authentication & Security
- **Role-Based Login System** - Secure authentication with JWT tokens
- **Multi-Role Support** - Student, Parent, Teacher, Staff, Admin profiles
- **Session Management** - Automatic token refresh and session handling
- **Secure Credential Storage** - Local secure storage with shared preferences

### 👨‍🎓 Student Dashboard
- **Academic Performance**
  - View grades and GPA
  - Track examination schedules
  - Access academic history and report cards
  - Monitor test results
- **Attendance Tracking**
  - Daily attendance status
  - Monthly attendance summary
  - Attendance statistics
- **Fee Management**
  - View fee structure and invoices
  - Payment history
  - Pending fee notifications
  - Download fee documents
- **Timetable & Schedule**
  - Class timetable
  - Examination schedules
  - Test schedules

### 👨‍👩‍👧 Parent Dashboard
- **Student Monitoring**
  - View all linked children's data
  - Track academic performance
  - Monitor attendance
  - Receive notifications about fees and grades
- **Financial Overview**
  - View children's fee status
  - Payment history
  - Outstanding fees
- **Communication**
  - Access to student announcements
  - Receive important alerts

### 👨‍🏫 Teacher Dashboard
- **Attendance Management**
  - Mark daily attendance for classes
  - Bulk attendance marking
  - View attendance reports
  - Class-wise attendance statistics
- **Grading System**
  - Record student grades
  - Manage examination marks
  - Bulk grade marking
  - View grade history
- **Examination Management**
  - View assigned examinations
  - Mark student examination results
  - Track exam schedules
  - Generate exam reports
- **Personnel Management**
  - View salary information
  - Salary history and statements
  - View personal attendance
  - Check assigned classes and subjects

### 👨‍💼 Staff Dashboard
- **Task Management**
  - View assigned tasks
  - Track task status
  - Update task progress
- **Attendance & Payroll**
  - Mark attendance
  - View attendance history
  - Access salary records
  - Download salary slips
- **Reports**
  - Personal attendance reports
  - Salary history

### 🔧 Administrator Dashboard
- **User Management**
  - Create and manage user accounts
  - Assign roles and permissions
  - Activate/deactivate accounts
  - View user activity logs
- **Academic Management**
  - Manage classes and sections
  - Assign subjects to classes
  - Assign teachers to subjects
  - Class management
- **Attendance Management**
  - Generate attendance reports
  - View daily summaries
  - Attendance analytics
- **Financial Management**
  - **Fee Management**
    - Generate monthly invoices
    - Generate annual invoices
    - Apply discounts and fines
    - Record payments
    - Payment history and audit trails
    - Fee dashboard with statistics
  - **Salary Management**
    - Generate monthly salaries
    - Process salary payments
    - Add bonuses and deductions
    - Salary adjustments
    - View payment history
    - Generate salary reports
- **Reporting & Analytics**
  - Fee collection statistics
  - Attendance analytics
  - Academic performance reports
  - Class-wise summaries
  - Financial summaries

## 🛠 Tech Stack

### Frontend Framework
- **Flutter** (^3.9.2) - Cross-platform framework
- **Dart** (^3.9.2) - Programming language

### State Management
- **Provider** (^6.1.5) - Reactive state management
- **Shared Preferences** (^2.2.2) - Local data persistence

### Navigation & Routing
- **Go Router** (^16.1.0) - Declarative navigation
- **URL Launcher** (^6.3.2) - Deep linking support

### UI & Design
- **Cupertino Icons** (^1.0.8) - iOS-style icons
- **Lucide Icons** (^0.257.0) - Modern icon library
- **Responsive Framework** (^0.2.0) - Responsive design utilities
- **Flutter SpinKit** (^5.2.0) - Loading animations

### Data & File Management
- **HTTP** (^1.5.0) - HTTP client for API calls
- **PDF** (^3.10.7) - PDF generation and viewing
- **Path Provider** (^2.1.1) - File system access
- **Permission Handler** (^11.0.1) - Runtime permissions
- **Open File** (^3.3.2) - Open files with default apps

### Utilities
- **Intl** (^0.20.2) - Internationalization and date formatting
- **FL Chart** (^0.68.0) - Beautiful charts and graphs
- **Table Calendar** (^3.2.0) - Interactive calendar widget

## 📁 Project Structure
