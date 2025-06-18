# GitHub Metrics Dashboard

A beautiful, modern dashboard for visualizing GitHub repository metrics. This dashboard connects to your API endpoint to display comprehensive repository statistics, pull request activity, contributor information, and more.

## Features

- **Repository Overview**: Display watchers, stars, forks, and basic metrics
- **Pull Request Analytics**: Track PR activity, closure rates, and lifecycle metrics
- **Issue Tracking**: Monitor open/closed issues and resolution rates
- **Contributor Analysis**: Visual breakdown of top contributors
- **Traffic Metrics**: View clones and unique repository views
- **Code Activity**: Track additions and deletions over time
- **Responsive Design**: Works perfectly on desktop and mobile devices

## API Integration

The dashboard connects to the API endpoint: `http://localhost:5103/ghapi/metrics`

Expected JSON structure:
```json
{
  "repository": {
    "watchers": 56,
    "stars": 553,
    "forks": 173,
    "openPullRequests": 3,
    "averagePRPerDay": 0.07,
    "prLifecycleDays": 7.46,
    "clones": 69,
    "uniqueViews": 8530,
    "openIssues": 14,
    "totalIssues": 249,
    "contributors": 23,
    "prClosedRate": 97.56,
    "issuesClosedRate": 94.38
  },
  "prActivity": {
    "last6Months": [
      { "month": "2024-01", "opened": 5, "closed": 7 }
    ]
  },
  "issuesActivity": {
    "last6Months": [
      { "month": "2024-01", "opened": 12, "closed": 15 }
    ]
  },
  "contributors": [
    { "name": "username", "contributions": 45, "percentage": 37.4 }
  ],
  "forksVsClones": {
    "last6Months": [
      { "month": "2024-01", "forks": 15, "clones": 45 }
    ]
  },
  "additionsDeletes": {
    "additions": [85.2, 78.3, 92.1],
    "deletions": [14.8, 21.7, 7.9],
    "months": ["Jan", "Feb", "Mar"]
  }
}
```

## Usage

1. Ensure your API server is running on `http://localhost:5103`
2. Open `index.html` in a web browser
3. The dashboard will automatically load and display metrics
4. Use the refresh button to update data
5. Select different time periods using the dropdown

## Features Overview

### Visual Components

- **Gradient Cards**: Beautiful gradient cards for key metrics (watchers, stars, forks)
- **Gauge Charts**: Circular progress indicators for closure rates
- **Bar Charts**: Activity tracking for PRs and issues
- **Pie Chart**: Contributor distribution visualization
- **Line Charts**: Trend analysis for forks vs clones
- **Stacked Charts**: Code addition/deletion ratios

### Interactive Elements

- **Refresh Button**: Manually update all metrics
- **Date Range Selector**: Filter data by time period
- **Responsive Hover Effects**: Enhanced user interaction
- **Loading States**: Visual feedback during data loading
- **Error Handling**: Graceful fallback with mock data

## Technologies Used

- **HTML5**: Semantic markup structure
- **CSS3**: Modern styling with gradients, backdrop filters, and animations
- **JavaScript ES6+**: Modern JavaScript with async/await and classes
- **Chart.js**: Professional charting library for data visualization
- **Responsive Design**: Mobile-first approach with CSS Grid and Flexbox

## Customization

The dashboard is easily customizable:

- **Colors**: Modify CSS custom properties for color schemes
- **Charts**: Adjust Chart.js configurations for different visualizations
- **Layout**: Modify CSS Grid properties for different layouts
- **API**: Update the API endpoint in `dashboard.js`

## Browser Support

- Chrome (recommended)
- Firefox
- Safari
- Edge

## Demo Mode

If the API is not available, the dashboard will automatically use mock data to demonstrate all features and visualizations.
