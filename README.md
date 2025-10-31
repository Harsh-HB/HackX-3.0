# WasteWise - Smart Municipal Waste Management System

<div align="center">

![WasteWise Logo](https://img.shields.io/badge/WasteWise-Smart_Waste_Management-2E7D32?style=for-the-badge&logo=recycle&logoColor=white)

**Revolutionizing urban waste management through IoT sensors, AI-driven optimization, and citizen engagement**

[Features](#features) • [Getting Started](#getting-started) • [Architecture](#architecture) • [Documentation](#documentation)

[![Flutter](https://img.shields.io/badge/Flutter-02569B?style=flat-square&logo=flutter&logoColor=white)](https://flutter.dev)
[![React](https://img.shields.io/badge/React-20232A?style=flat-square&logo=react&logoColor=61DAFB)](https://reactjs.org)
[![TypeScript](https://img.shields.io/badge/TypeScript-007ACC?style=flat-square&logo=typescript&logoColor=white)](https://www.typescriptlang.org)
[![Node.js](https://img.shields.io/badge/Node.js-339933?style=flat-square&logo=node.js&logoColor=white)](https://nodejs.org)

</div>

---

## 🌟 Overview

**WasteWise** is a comprehensive smart city waste management platform that bridges the gap between citizens and municipal authorities through real-time monitoring, predictive analytics, and optimized collection routes. The system consists of two integrated applications:

- **📱 Mobile App** (Flutter) - Citizen and Government interfaces
- **🖥️ Web Dashboard** (React + TypeScript) - Real-time monitoring and analytics

### Key Highlights

- 🎯 **Real-time IoT Monitoring** - Live sensor data from 45+ smart bins
- 🤖 **AI Route Optimization** - Predictive maintenance and collection scheduling
- 👥 **Dual User Experience** - Separate interfaces for citizens and government officials
- 📊 **Advanced Analytics** - Comprehensive dashboards with KPI tracking
- 🗺️ **Interactive Maps** - Visual bin monitoring with Leaflet.js
- 📸 **Photo Evidence** - Citizen reports with geolocation and image capture

---

## 📋 Table of Contents

- [Features](#features)
- [Technology Stack](#technology-stack)
- [Architecture](#architecture)
- [Getting Started](#getting-started)
  - [Mobile App Setup](#mobile-app-setup)
  - [Web Dashboard Setup](#web-dashboard-setup)
- [User Roles & Features](#user-roles--features)
- [Project Structure](#project-structure)
- [Contributing](#contributing)
- [License](#license)

---

## ✨ Features

### 🏛️ Government Dashboard (Web & Mobile)

#### Web Dashboard Features
- **📊 Real-time KPI Monitoring**
  - Total bins (45+)
  - Active routes tracking
  - Vehicle utilization (78%)
  - Waste collected metrics
- **🗺️ Interactive Sensor Map**
  - Live bin status visualization (Online/Warning/Critical)
  - Leaflet.js-powered maps
  - One-click route optimization
  - Distance and time calculations
- **🚚 AI Route Optimization**
  - Automatic route generation
  - Multi-vehicle coordination
  - Real-time route status tracking
  - Efficiency metrics
- **🔧 Predictive Maintenance**
  - Weekly trend forecasting
  - Threshold management
  - Maintenance scheduling
  - Historical data analysis
- **🚨 Smart Alert System**
  - Critical bin notifications (85%+ fill)
  - Warning alerts (60%+ fill)
  - Odor index monitoring
  - Priority dispatch recommendations
- **📋 Bin Status Table**
  - Comprehensive bin inventory
  - Real-time fill levels
  - Last emptied timestamps
  - Status filtering

#### Mobile Government Features
- **Quick Access Dashboard**
  - At-a-glance statistics
  - High-fill bin alerts
  - Active routes summary
  - Pending complaints count
- **Bin Monitoring Module**
  - Filterable bin list (status, fill level)
  - Mark bins as emptied
  - Maintenance scheduling
  - Location tracking
- **Routes Management**
  - Create/edit routes
  - Assign drivers
  - Track route status (Scheduled/Active/Completed)
  - Multi-bin route optimization
- **Predictive Analytics**
  - Time-to-fill estimates
  - Maintenance predictions
  - Priority bin identification
  - Automated scheduling

### 👥 Citizen App Features

#### Waste Reporting
- **📸 Photo Capture**
  - Gallery or camera integration
  - Geotagged submissions
  - Multiple issue types
  - Offline submission queue
- **Issue Types**
  - Overflowing bins
  - Uncollected waste
  - Maintenance requests
- **Status Tracking**
  - Real-time complaint updates
  - Pending/Assigned/Resolved tracking
  - Timestamp history

#### Bin Locator
- **📍 Smart Navigation**
  - Distance-based sorting (Haversine formula)
  - Current location tracking
  - One-tap navigation
  - Fill level indicators
- **Visual Feedback**
  - Color-coded status
  - Progress bars
  - Address details
  - Quick report option

#### Complaint Management
- **Status Tracking**
  - Visual status indicators
  - Status advancement
  - Historical records
  - Timestamp tracking

#### Educational Content
- **Waste Tips**
  - Segregation guidelines
  - Best practices
  - Sustainability tips

---

## 🛠️ Technology Stack

### Mobile Application
```
Framework: Flutter 3.9.2+
Language: Dart
UI: Material Design
Key Packages:
  ├── go_router ^12.1.3 - Navigation
  ├── flutter_riverpod ^2.4.9 - State management
  ├── image_picker ^1.1.2 - Camera/gallery
  ├── http ^1.2.2 - API integration
  ├── shared_preferences ^2.3.2 - Local storage
  └── file_picker ^8.1.2 - File operations
```

### Web Dashboard
```
Framework: React 18.3+
Language: TypeScript
Build Tool: Vite
UI Library: shadcn/ui + Tailwind CSS
Key Libraries:
  ├── React Router DOM ^6.30.1 - Routing
  ├── TanStack Query ^5.83.0 - Data fetching
  ├── Leaflet ^1.9.4 - Maps
  ├── Recharts ^2.15.4 - Data visualization
  ├── Radix UI - Component primitives
  ├── Lucide React - Icons
  └── Sonner ^1.7.4 - Toast notifications
```

---

## 🏗️ Architecture

### System Components

```
┌─────────────────────────────────────────────────────────────┐
│                      WasteWise Ecosystem                      │
├─────────────────────────────────────────────────────────────┤
│                                                               │
│  ┌──────────────────┐         ┌──────────────────┐          │
│  │   IoT Sensors    │────────▶│  Data Backend    │          │
│  │  (45+ Smart Bins)│         │  (Google Sheets) │          │
│  └──────────────────┘         └────────┬─────────┘          │
│                                         │                     │
│              ┌──────────────────────────┴──────────┐         │
│              │                                      │         │
│    ┌─────────▼────────┐              ┌────────────▼────────┐│
│    │  Mobile App      │              │   Web Dashboard    ││
│    │  (Flutter)       │              │   (React + TS)     ││
│    │                  │              │                    ││
│    ├──────────────────┤              ├────────────────────┤│
│    │ • Government UI  │              │ • Real-time Maps  ││
│    │ • Citizen UI     │              │ • Route Optimizer ││
│    │ • Bin Monitoring │              │ • KPI Dashboard   ││
│    │ • Report System  │              │ • Predictive AI   ││
│    │ • Route Manager  │              │ • Alert System    ││
│    └──────────────────┘              └────────────────────┘│
│                                                               │
└─────────────────────────────────────────────────────────────┘
```

### Data Flow

1. **IoT Sensors** → Continuously transmit fill levels, odor index, location
2. **Backend** → Aggregates and processes data (currently Google Sheets API)
3. **Mobile App** → Push notifications, citizen reports, route management
4. **Web Dashboard** → Real-time visualization, analytics, optimization

---

## 🚀 Getting Started

### Prerequisites

- **Mobile App**: Flutter SDK 3.9.2+, Dart, Android Studio / Xcode
- **Web Dashboard**: Node.js 18+, npm/yarn/pnpm
- **Git**: For version control

### 📱 Mobile App Setup

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/HackX-3.0.git
   cd HackX-3.0
   ```

2. **Navigate to Mobile App directory**
   ```bash
   cd "Mobile App"
   ```

3. **Install dependencies**
   ```bash
   flutter pub get
   ```

4. **Run the app**
   ```bash
   # For Android
   flutter run -d android
   
   # For iOS
   flutter run -d ios
   
   # For Web
   flutter run -d chrome
   ```

5. **Build release versions**
   ```bash
   # Android APK
   flutter build apk --release
   
   # iOS
   flutter build ios --release
   
   # Web
   flutter build web
   ```

#### Login Credentials

The app supports two user roles:
- **Citizen**: Default role, report waste, locate bins
- **Government**: Access dashboard, manage routes, monitor bins

*Note: Current implementation uses mock authentication for demonstration.*

### 🖥️ Web Dashboard Setup

1. **Navigate to Web Dashboard directory**
   ```bash
   cd "Web Dashboard"
   ```

2. **Install dependencies**
   ```bash
   npm install
   # or
   yarn install
   # or
   pnpm install
   ```

3. **Start development server**
   ```bash
   npm run dev
   # or
   yarn dev
   ```

4. **Open in browser**
   ```
   http://localhost:5173
   ```

5. **Build for production**
   ```bash
   npm run build
   ```

6. **Preview production build**
   ```bash
   npm run preview
   ```

---

## 👤 User Roles & Features

### Government Officials

| Feature | Web Dashboard | Mobile App |
|---------|---------------|------------|
| Real-time Monitoring | ✅ Advanced | ✅ Basic |
| KPI Dashboard | ✅ Detailed | ✅ Summary |
| Interactive Maps | ✅ Full-featured | ✅ List view |
| Route Optimization | ✅ AI-powered | ✅ Manual |
| Predictive Analytics | ✅ Charts & Trends | ✅ ETA estimates |
| Alert Management | ✅ Comprehensive | ✅ Critical only |
| Bin Management | ✅ Bulk operations | ✅ Individual |

### Citizens

| Feature | Mobile App | Description |
|---------|------------|-------------|
| Report Waste | ✅ | Photo + GPS + description |
| Bin Locator | ✅ | Find nearest bins |
| Complaint Tracking | ✅ | Status updates |
| Educational Tips | ✅ | Waste management tips |
| Profile Management | ✅ | Settings & preferences |

---

## 📁 Project Structure

```
HackX-3.0/
│
├── 📱 Mobile App/
│   ├── android/                 # Android native code
│   ├── ios/                     # iOS native code
│   ├── lib/
│   │   ├── main.dart           # App entry point
│   │   ├── splash.dart         # Splash screen
│   │   ├── login.dart          # Authentication
│   │   │
│   │   ├── gov_dashboard.dart  # Government dashboard
│   │   ├── citizen_home.dart   # Citizen home
│   │   │
│   │   ├── bin_monitoring.dart # Bin management
│   │   ├── routes_management.dart # Route creation
│   │   ├── predictive_maintenance.dart # Analytics
│   │   │
│   │   ├── report_waste.dart   # Waste reporting
│   │   ├── bin_locator.dart    # Find bins
│   │   ├── complaint_status.dart # Track complaints
│   │   │
│   │   ├── profile_page.dart   # User profile
│   │   └── settings_page.dart  # App settings
│   │
│   ├── pubspec.yaml            # Dependencies
│   └── README.md               # Mobile app docs
│
├── 🖥️ Web Dashboard/
│   ├── public/                 # Static assets
│   ├── src/
│   │   ├── App.tsx             # Root component
│   │   ├── main.tsx            # Entry point
│   │   ├── index.css           # Global styles
│   │   │
│   │   ├── pages/
│   │   │   ├── Index.tsx       # Main dashboard
│   │   │   └── NotFound.tsx    # 404 page
│   │   │
│   │   ├── components/
│   │   │   ├── dashboard/
│   │   │   │   ├── StatCard.tsx           # KPI cards
│   │   │   │   ├── SensorMap.tsx          # Interactive map
│   │   │   │   ├── RouteOptimization.tsx  # Route visualizer
│   │   │   │   ├── PredictiveMaintenance.tsx # Analytics
│   │   │   │   ├── AlertsPanel.tsx        # Alert system
│   │   │   │   └── BinStatusTable.tsx     # Bin inventory
│   │   │   │
│   │   │   └── ui/             # Reusable UI components
│   │   │
│   │   ├── hooks/
│   │   │   └── useGoogleSheets.ts # Data fetching
│   │   │
│   │   └── utils/
│   │       └── routeOptimization.ts # Route algorithms
│   │
│   ├── package.json            # Dependencies
│   ├── vite.config.ts          # Vite config
│   └── tailwind.config.ts      # Tailwind config
│
└── README.md                    # This file
```

---

## 🎨 Design System

### Color Palette

| Usage | Color | Hex Code |
|-------|-------|----------|
| Primary | Green | `#2E7D32` |
| Success | Teal | `#00695C` |
| Warning | Orange | `#FF6F00` |
| Critical | Red | `#C62828` |
| Info | Cyan | `#00FFFF` |

### Typography

- **Headings**: Inter / SF Pro Display
- **Body**: Inter / SF Pro Text
- **Code**: Fira Code / Menlo

---

## 🔧 Configuration

### Mobile App Configuration

Edit `Mobile App/lib/main.dart` to customize:
- Theme colors
- Default routes
- Supported locales

Edit `Mobile App/pubspec.yaml` to manage:
- Flutter SDK version
- Dependencies
- Assets (fonts, images)

### Web Dashboard Configuration

Edit `Web Dashboard/src/hooks/useGoogleSheets.ts` to:
- Connect to real Google Sheets API
- Configure data refresh intervals
- Customize mock data parameters

Edit `Web Dashboard/vite.config.ts` to:
- Configure build options
- Set up environment variables
- Customize dev server settings

---

## 🧪 Testing

### Mobile App
```bash
cd "Mobile App"
flutter test
```

### Web Dashboard
```bash
cd "Web Dashboard"
npm test
# or
npm run lint
```

---

## 🚧 Roadmap

### Phase 1: Core Features ✅
- [x] Basic bin monitoring
- [x] Citizen reporting system
- [x] Government dashboard
- [x] Route management

### Phase 2: Advanced Features 🚧
- [ ] Real-time notifications
- [ ] Push notifications (mobile)
- [ ] Google Sheets API integration
- [ ] Authentication & authorization
- [ ] Multi-language support

### Phase 3: AI & Analytics 🤖
- [ ] Machine learning predictions
- [ ] Advanced route optimization
- [ ] Anomaly detection
- [ ] Cost optimization algorithms

### Phase 4: Scalability 📈
- [ ] Microservices architecture
- [ ] Database integration (PostgreSQL/MongoDB)
- [ ] Containerization (Docker)
- [ ] Cloud deployment (AWS/GCP/Azure)

---

## 🤝 Contributing

We welcome contributions! Please follow these steps:

1. **Fork the repository**
2. **Create a feature branch** (`git checkout -b feature/AmazingFeature`)
3. **Commit your changes** (`git commit -m 'Add some AmazingFeature'`)
4. **Push to the branch** (`git push origin feature/AmazingFeature`)
5. **Open a Pull Request**

### Contribution Guidelines

- Follow existing code style
- Write clear commit messages
- Add comments for complex logic
- Update documentation
- Test your changes thoroughly

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 📞 Contact & Support

- **Project Lead**: Your Name
- **Email**: your.email@example.com
- **Issues**: [GitHub Issues](https://github.com/yourusername/HackX-3.0/issues)
- **Discussions**: [GitHub Discussions](https://github.com/yourusername/HackX-3.0/discussions)

---

## 🙏 Acknowledgments

- **IoT Team** - For sensor hardware development
- **Design Team** - For UI/UX design
- **Backend Team** - For API development
- **Flutter & React Communities** - For excellent frameworks and libraries

---

## 📊 Project Status

[![Maintenance](https://img.shields.io/badge/Maintained%3F-yes-green.svg)](https://github.com/yourusername/HackX-3.0/graphs/commit-activity)
[![Issues](https://img.shields.io/github/issues/yourusername/HackX-3.0)](https://github.com/yourusername/HackX-3.0/issues)
[![PRs](https://img.shields.io/github/issues-pr/yourusername/HackX-3.0)](https://github.com/yourusername/HackX-3.0/pulls)
[![License](https://img.shields.io/github/license/yourusername/HackX-3.0)](LICENSE)

---

<div align="center">

**Built with ❤️ for sustainable urban living**

![Version](https://img.shields.io/badge/Version-3.0-blue?style=for-the-badge)
![Status](https://img.shields.io/badge/Status-In_Development-yellow?style=for-the-badge)

[⬆ Back to Top](#wastewise---smart-municipal-waste-management-system)

</div>
