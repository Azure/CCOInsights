# GitHub Metrics Dashboard

A modern, responsive dashboard for visualizing GitHub repository metrics with advanced edit mode capabilities.

## ✨ Features

### 📊 Comprehensive Metrics Display
- **Repository Stats**: Stars, watchers, forks with gradient cards
- **Pull Request Analytics**: Activity charts, closed rates, lifecycle metrics
- **Issue Tracking**: Opened vs closed issues, closure rates
- **Contributor Insights**: Top contributors with percentage breakdown
- **Code Analysis**: Additions/deletions tracking, forks vs clones
- **Time Period Filtering**: 1 month, 3 months, 6 months, or 1 year views

### 🎨 Modern Design
- **Glass-morphism UI**: Transparent cards with backdrop blur effects
- **Responsive Layout**: Optimized for desktop, tablet, and mobile
- **Gradient Backgrounds**: Beautiful color schemes throughout
- **Interactive Charts**: Powered by Chart.js with hover effects
- **Professional Typography**: Clean, readable font stack

### ✏️ Advanced Edit Mode
- **Layout Customization**: Drag and drop widgets to rearrange
- **Widget Resizing**: Small (S), Medium (M), Large (L) size options
- **Live Preview**: Changes apply immediately
- **Persistent Storage**: Layout preferences saved to localStorage
- **Lock/Unlock Toggle**: Edit mode with pencil icon, lock mode for protection

### 🔧 Edit Mode Features
- **Drag & Drop**: Click "Edit Layout" to enable widget movement
- **Size Controls**: S/M/L buttons appear in edit mode for each widget
- **Visual Feedback**: Dashed borders and hover effects during editing
- **Smart Reconstruction**: Charts automatically recreate after layout changes
- **Memory Management**: Prevents memory leaks during chart updates

## 🚀 Quick Start

1. **Open the Dashboard**
   ```
   Open index.html in a web browser
   ```

2. **Configure API Endpoint**
   - Default endpoint: `http://localhost:5103/ghapi/metrics`
   - Mock data used when API unavailable for demo purposes

3. **Customize Layout**
   - Click the "Edit Layout" button (pencil icon) in the header
   - Drag widgets using the move handles
   - Resize widgets using S/M/L buttons
   - Click "Lock Layout" to save and exit edit mode

## 📱 Responsive Design

- **Desktop**: Full-width layout with optimal spacing
- **Tablet**: Responsive grid adapts to medium screens  
- **Mobile**: Single-column layout with touch-friendly controls

## 🛠️ Technology Stack

- **Frontend**: Pure HTML5, CSS3, JavaScript (ES6+)
- **Charts**: Chart.js for data visualization
- **Drag & Drop**: SortableJS for layout customization
- **Storage**: localStorage for layout persistence
- **Icons**: Bootstrap Icons for UI elements

## 🎯 Edit Mode Usage

### Entering Edit Mode
1. Click the "Edit Layout" button in the header
2. Widget controls become visible with dashed borders
3. Notification appears explaining edit functionality

### Moving Widgets
- Use the move handle (four-arrow icon) to drag widgets
- Drop widgets in desired position
- Layout updates automatically

### Resizing Widgets
- Click S/M/L buttons in bottom-right of each widget
- **Small**: Compact size for quick overviews
- **Medium**: Standard size for detailed views
- **Large**: Extended size for comprehensive analysis

### Saving Changes
- Click "Lock Layout" to save and exit edit mode
- Layout preferences stored in browser localStorage
- Changes persist across browser sessions

## 📊 Supported Metrics

### Repository Overview
- Total stars, watchers, and forks
- Open and total issues/pull requests
- Contributor count and activity

### Activity Metrics  
- PR/Issue opened vs closed over time
- Average pull request lifecycle
- Daily activity averages

### Contributor Analytics
- Top contributor breakdown with percentages
- Contribution distribution visualization
- Team collaboration insights

### Code Metrics
- Code additions vs deletions
- Repository clones and forks comparison
- Development velocity tracking

## 🔄 API Integration

The dashboard connects to `http://localhost:5103/ghapi/metrics` and expects JSON data in the following structure:

```json
{
  "lastMonth": { ... },
  "lastThreeMonths": { ... },
  "lastSixMonths": {
    "openedPrCount": 25,
    "closedPrCount": 23,
    "prClosedRate": 0.92,
    "openedIssuesCount": 15,
    "closedIssuesCount": 12,
    "issuesClosedRate": 0.80,
    "forksCount": 45,
    "clonesCount": 123,
    "totalAdditions": 2500,
    "totalDeletions": 450,
    "topTenContributors": [
      {
        "user": "username",
        "closedPrCount": 12
      }
    ],
    "averageCodingTimeDays": 3.5
  },
  "lastYear": { ... }
}
```

## 🎨 Customization

### Color Schemes
- Primary: Purple gradient (#667eea to #764ba2)
- Accent colors: GitHub-inspired blues and greens
- Chart colors: Carefully chosen for accessibility

### Layout Options
- Widget sizes: Small (1 column), Normal (1 column), Large (2 columns)
- Full-width widgets: Span entire row width
- Responsive breakpoints: 1200px, 768px, 480px

## 🚀 Performance Features

- **Chart Optimization**: Memory leak prevention with proper cleanup
- **Responsive Images**: Optimized canvas sizing
- **Efficient Rendering**: Minimal DOM manipulation
- **Storage Management**: Compressed layout data

## 🔒 Browser Compatibility

- Modern browsers with ES6+ support
- Chrome, Firefox, Safari, Edge
- Mobile browsers for responsive experience

## 📝 Development Notes

- Pure vanilla JavaScript (no frameworks)
- Modular code structure for maintainability  
- Comprehensive error handling
- Mock data fallback for development

---

**🎯 Perfect for**: Development teams, project managers, and anyone who wants beautiful, customizable GitHub repository insights with professional drag-and-drop layout capabilities.
