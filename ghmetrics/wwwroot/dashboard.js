class GitHubMetricsDashboard {    
    constructor() {
        this.apiEndpoint = 'http://localhost:5103/ghapi/metrics';
        this.charts = {};
        this.data = null;
        this.isEditMode = false;
        this.sortable = null;
        this.widgetLayouts = this.loadLayoutFromStorage();
        
        this.init();
    }

    async init() {        
        this.showLoading();
        // Event listeners
        document.getElementById('refreshBtn').addEventListener('click', () => this.refreshData());
        document.getElementById('dateRange').addEventListener('change', () => this.onPeriodChange());
        document.getElementById('editModeBtn').addEventListener('click', () => this.toggleEditMode());
        
        // Initialize layout
        this.initializeLayout();
        
        // Initial data load
        await this.loadData();
        
        this.hideLoading();
    }

    showLoading() {
        document.getElementById('loadingOverlay').style.display = 'flex';
    }

    hideLoading() {
        document.getElementById('loadingOverlay').style.display = 'none';
    }

    showError() {
        document.getElementById('errorMessage').style.display = 'block';
        this.hideLoading();
    }    

    async loadData() {
        try {
            const response = await fetch(this.apiEndpoint);
            
            if (!response.ok) {
                throw new Error(`HTTP error! status: ${response.status}`);
            }
            
            const apiData = await response.json();
            this.rawApiData = apiData; // Store raw data for period changes
            this.data = this.transformApiData(apiData);
            this.updateDashboard();
            
        } catch (error) {
            console.error('Error loading metrics:', error);
            
            // Use mock data for demonstration
            this.data = this.getMockData();
            this.updateDashboard();
            
            // Show error but don't block the demo
            // this.showError();
        }
    }

    getMockData() {
        return {
            repository: {
                watchers: 56,
                stars: 553,
                forks: 173,
                openPullRequests: 3,
                averagePRPerDay: 0.07,
                prLifecycleDays: 7.46,
                clones: 69,
                uniqueViews: 8530,
                openIssues: 14,
                totalIssues: 249,
                contributors: 23,
                prClosedRate: 97.56,
                issuesClosedRate: 94.38
            },
            prActivity: {
                last6Months: [
                    { month: '2024-01', opened: 5, closed: 7 },
                    { month: '2024-02', opened: 3, closed: 4 },
                    { month: '2024-03', opened: 8, closed: 6 },
                    { month: '2024-04', opened: 2, closed: 5 },
                    { month: '2024-05', opened: 6, closed: 8 },
                    { month: '2024-06', opened: 4, closed: 3 }
                ]
            },
            issuesActivity: {
                last6Months: [
                    { month: '2024-01', opened: 12, closed: 15 },
                    { month: '2024-02', opened: 8, closed: 10 },
                    { month: '2024-03', opened: 16, closed: 12 },
                    { month: '2024-04', opened: 5, closed: 8 },
                    { month: '2024-05', opened: 11, closed: 14 },
                    { month: '2024-06', opened: 7, closed: 6 }
                ]
            },
            contributors: [
                { name: 'login', contributions: 45, percentage: 37.4 },
                { name: 'josunefon', contributions: 28, percentage: 23.3 },
                { name: 'CristianEdwards', contributions: 15, percentage: 12.5 },
                { name: 'Maanzdelrio', contributions: 12, percentage: 10.0 },
                { name: 'miloshb', contributions: 8, percentage: 6.7 },
                { name: 'rifmachado', contributions: 6, percentage: 5.0 },
                { name: 'matebarabas', contributions: 4, percentage: 3.3 },
                { name: 'ShachaGoldstein', contributions: 2, percentage: 1.7 }
            ],
            forksVsClones: {
                last6Months: [
                    { month: '2024-01', forks: 15, clones: 45 },
                    { month: '2024-02', forks: 12, clones: 38 },
                    { month: '2024-03', forks: 20, clones: 52 },
                    { month: '2024-04', forks: 8, clones: 35 },
                    { month: '2024-05', forks: 18, clones: 48 },
                    { month: '2024-06', forks: 14, clones: 42 }
                ]
            },
            additionsDeletes: {
                additions: [85.2, 78.3, 92.1, 67.8, 81.4],
                deletions: [14.8, 21.7, 7.9, 32.2, 18.6],
                months: ['Jan', 'Feb', 'Mar', 'Apr', 'May']
            }
        };
    }

    transformApiData(apiData) {
        // Get the current selected period or default to lastSixMonths
        const selectedPeriod = document.getElementById('dateRange')?.value || '6months';
        let currentPeriodData;
        
        switch(selectedPeriod) {
            case '1month':
                currentPeriodData = apiData.lastMonth;
                break;
            case '3months':
                currentPeriodData = apiData.lastThreeMonths;
                break;
            case '6months':
                currentPeriodData = apiData.lastSixMonths;
                break;
            case '1year':
                currentPeriodData = apiData.lastYear;
                break;
            default:
                currentPeriodData = apiData.lastSixMonths;
        }

        // Transform contributors data
        const contributors = currentPeriodData.topTenContributors.map((contributor, index) => {
            const totalPRs = currentPeriodData.topTenContributors.reduce((sum, c) => sum + c.closedPrCount, 0);
            const percentage = totalPRs > 0 ? (contributor.closedPrCount / totalPRs * 100) : 0;
            
            return {
                name: contributor.user,
                contributions: contributor.closedPrCount,
                percentage: percentage
            };
        });

        // Calculate additions/deletions percentage
        const totalChanges = currentPeriodData.totalAdditions + currentPeriodData.totalDeletions;
        const additionsPercent = totalChanges > 0 ? (currentPeriodData.totalAdditions / totalChanges * 100) : 0;
        const deletionsPercent = totalChanges > 0 ? (currentPeriodData.totalDeletions / totalChanges * 100) : 0;

        return {
            repository: {
                watchers: 0, // Not provided by API
                stars: 0, // Not provided by API
                forks: currentPeriodData.forksCount,
                openPullRequests: currentPeriodData.openedPrCount - currentPeriodData.closedPrCount,
                averagePRPerDay: currentPeriodData.openedPrCount / this.getPeriodDays(selectedPeriod),
                prLifecycleDays: currentPeriodData.averageCodingTimeDays,
                clones: currentPeriodData.clonesCount,
                uniqueViews: 0, // Not provided by API
                openIssues: currentPeriodData.openedIssuesCount - currentPeriodData.closedIssuesCount,
                totalIssues: currentPeriodData.openedIssuesCount,
                contributors: currentPeriodData.topTenContributors.length,
                prClosedRate: currentPeriodData.prClosedRate * 100,
                issuesClosedRate: currentPeriodData.issuesClosedRate * 100
            },
            prActivity: {
                last6Months: this.generateTimeSeriesData(currentPeriodData, 'pr', selectedPeriod)
            },
            issuesActivity: {
                last6Months: this.generateTimeSeriesData(currentPeriodData, 'issues', selectedPeriod)
            },
            contributors: contributors,
            forksVsClones: {
                last6Months: this.generateTimeSeriesData(currentPeriodData, 'forks_clones', selectedPeriod)
            },
            additionsDeletes: {
                additions: [additionsPercent],
                deletions: [deletionsPercent],
                months: [this.getCurrentPeriodLabel(selectedPeriod)]
            }
        };
    }

    getPeriodDays(period) {
        switch(period) {
            case '1month': return 30;
            case '3months': return 90;
            case '6months': return 180;
            case '1year': return 365;
            default: return 180;
        }
    }

    getCurrentPeriodLabel(period) {
        switch(period) {
            case '1month': return 'Last Month';
            case '3months': return 'Last 3 Months';
            case '6months': return 'Last 6 Months';
            case '1year': return 'Last Year';
            default: return 'Last 6 Months';
        }
    }

    generateTimeSeriesData(periodData, type, selectedPeriod) {
        // Since the API doesn't provide time series data, we'll create a single data point
        // representing the selected period
        const periodLabel = this.getCurrentPeriodLabel(selectedPeriod);
        
        switch(type) {
            case 'pr':
                return [{
                    month: periodLabel,
                    opened: periodData.openedPrCount,
                    closed: periodData.closedPrCount
                }];
            case 'issues':
                return [{
                    month: periodLabel,
                    opened: periodData.openedIssuesCount,
                    closed: periodData.closedIssuesCount
                }];
            case 'forks_clones':
                return [{
                    month: periodLabel,
                    forks: periodData.forksCount,
                    clones: periodData.clonesCount
                }];
            default:
                return [];
        }
    }    

    updateDashboard() {
        this.updateTopStats();
        this.updateRepoMetrics();
        this.updateChartTitles();
        this.createCharts();
    }

    updateChartTitles() {
        const selectedPeriod = document.getElementById('dateRange')?.value || '6months';
        const periodLabel = this.getCurrentPeriodLabel(selectedPeriod);
        
        document.getElementById('prActivityTitle').textContent = `Opened vs Closed PRs - ${periodLabel}`;
        document.getElementById('issuesActivityTitle').textContent = `Opened vs Closed Issues - ${periodLabel}`;
        document.getElementById('forksVsClonesTitle').textContent = `Forks vs Clones - ${periodLabel}`;
    }

    updateTopStats() {
        const repo = this.data.repository;
        
        document.getElementById('watchersCount').textContent = repo.watchers > 0 ? this.formatNumber(repo.watchers) : 'N/A';
        document.getElementById('starsCount').textContent = repo.stars > 0 ? this.formatNumber(repo.stars) : 'N/A';
        document.getElementById('forksCount').textContent = this.formatNumber(repo.forks);
    }    

    updateRepoMetrics() {
        const repo = this.data.repository;
        
        document.getElementById('openPRs').textContent = this.formatNumber(Math.max(0, repo.openPullRequests));
        document.getElementById('avgPRPerDay').textContent = repo.averagePRPerDay.toFixed(2);
        document.getElementById('prLifecycle').textContent = repo.prLifecycleDays.toFixed(1);
        document.getElementById('clones').textContent = this.formatNumber(repo.clones);
        document.getElementById('uniqueViews').textContent = repo.uniqueViews > 0 ? this.formatNumber(repo.uniqueViews) : 'N/A';
        document.getElementById('openIssues').textContent = this.formatNumber(Math.max(0, repo.openIssues));
        document.getElementById('totalIssues').textContent = this.formatNumber(repo.totalIssues);
        document.getElementById('contributors').textContent = this.formatNumber(repo.contributors);
    }    

    createCharts() {
        // Destroy all existing charts first to prevent memory leaks and layout issues
        Object.values(this.charts).forEach(chart => {
            if (chart) {
                chart.destroy();
            }
        });
        this.charts = {};
        
        // Small delay to ensure DOM is ready
        setTimeout(() => {
            this.createGaugeChart('prClosedRateChart', this.data.repository.prClosedRate, 'prClosedRateValue');
            this.createGaugeChart('issuesClosedRateChart', this.data.repository.issuesClosedRate, 'issuesClosedRateValue');
            this.createPRActivityChart();
            this.createContributorsChart();
            this.createIssuesActivityChart();
            this.createForksVsClonesChart();
            this.createAdditionsChart();
        }, 100);
    }    

    createGaugeChart(canvasId, percentage, valueElementId) {
        const ctx = document.getElementById(canvasId);
        const valueElement = document.getElementById(valueElementId);
        
        if (!ctx || !valueElement) return;
        
        valueElement.textContent = `${percentage.toFixed(1)}%`;
        
        if (this.charts[canvasId]) {
            this.charts[canvasId].destroy();
        }

        this.charts[canvasId] = new Chart(ctx, {
            type: 'doughnut',
            data: {
                datasets: [{
                    data: [percentage, 100 - percentage],
                    backgroundColor: [
                        percentage > 90 ? '#28a745' : percentage > 70 ? '#ffc107' : '#dc3545',
                        '#e9ecef'
                    ],
                    borderWidth: 0
                }]
            },
            options: {
                circumference: Math.PI,
                rotation: Math.PI,
                cutout: '75%',
                plugins: {
                    legend: {
                        display: false
                    },
                    tooltip: {
                        enabled: false
                    }
                },
                responsive: true,
                maintainAspectRatio: true,
                aspectRatio: 1
            }
        });
    }    

    createPRActivityChart() {
        const ctx = document.getElementById('prActivityChart');
        const data = this.data.prActivity.last6Months;
        
        if (!ctx) return;
        
        if (this.charts.prActivityChart) {
            this.charts.prActivityChart.destroy();
        }

        this.charts.prActivityChart = new Chart(ctx, {
            type: 'bar',
            data: {
                labels: data.map(d => d.month),
                datasets: [{
                    label: 'Opened',
                    data: data.map(d => d.opened),
                    backgroundColor: '#0366d6',
                    borderRadius: 4
                }, {
                    label: 'Closed',
                    data: data.map(d => d.closed),
                    backgroundColor: '#28a745',
                    borderRadius: 4
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: true,
                aspectRatio: 2.5,
                scales: {
                    y: {
                        beginAtZero: true,
                        grid: {
                            color: '#f1f3f4'
                        }
                    },
                    x: {
                        grid: {
                            display: false
                        }
                    }
                },
                plugins: {
                    legend: {
                        position: 'top',
                        align: 'end'
                    }
                }
            }
        });
    }    

    createContributorsChart() {
        const ctx = document.getElementById('contributorsChart');
        const contributors = this.data.contributors.slice(0, 8); // Top 8 contributors
        
        if (!ctx || contributors.length === 0) return;
        
        if (this.charts.contributorsChart) {
            this.charts.contributorsChart.destroy();
        }

        const colors = [
            '#0366d6', '#28a745', '#ffc107', '#dc3545', 
            '#6f42c1', '#fd7e14', '#20c997', '#6c757d'
        ];

        this.charts.contributorsChart = new Chart(ctx, {
            type: 'doughnut',
            data: {
                labels: contributors.map(c => c.name),
                datasets: [{
                    data: contributors.map(c => c.percentage),
                    backgroundColor: colors,
                    borderWidth: 2,
                    borderColor: '#fff'
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: true,
                aspectRatio: 1.2,
                plugins: {
                    legend: {
                        position: 'bottom',
                        labels: {
                            boxWidth: 12,
                            padding: 10,
                            font: {
                                size: 11
                            },
                            generateLabels: function(chart) {
                                const data = chart.data;
                                return data.labels.map((label, i) => ({
                                    text: `${label} (${data.datasets[0].data[i].toFixed(1)}%)`,
                                    fillStyle: data.datasets[0].backgroundColor[i],
                                    strokeStyle: data.datasets[0].borderColor,
                                    lineWidth: data.datasets[0].borderWidth
                                }));
                            }
                        }
                    },
                    tooltip: {
                        callbacks: {
                            label: function(context) {
                                return `${context.label}: ${context.parsed.toFixed(1)}%`;
                            }
                        }
                    }
                }
            }
        });
    }    

    createIssuesActivityChart() {
        const ctx = document.getElementById('issuesActivityChart');
        const data = this.data.issuesActivity.last6Months;
        
        if (!ctx) return;
        
        if (this.charts.issuesActivityChart) {
            this.charts.issuesActivityChart.destroy();
        }

        this.charts.issuesActivityChart = new Chart(ctx, {
            type: 'bar',
            data: {
                labels: data.map(d => d.month),
                datasets: [{
                    label: 'Opened',
                    data: data.map(d => d.opened),
                    backgroundColor: '#dc3545',
                    borderRadius: 4
                }, {
                    label: 'Closed',
                    data: data.map(d => d.closed),
                    backgroundColor: '#28a745',
                    borderRadius: 4
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: true,
                aspectRatio: 1.5,
                scales: {
                    y: {
                        beginAtZero: true,
                        grid: {
                            color: '#f1f3f4'
                        }
                    },
                    x: {
                        grid: {
                            display: false
                        }
                    }
                },
                plugins: {
                    legend: {
                        position: 'top',
                        align: 'end'
                    }
                }
            }
        });
    }    

    createForksVsClonesChart() {
        const ctx = document.getElementById('forksVsClonesChart');
        const data = this.data.forksVsClones.last6Months;
        
        if (!ctx) return;
        
        if (this.charts.forksVsClonesChart) {
            this.charts.forksVsClonesChart.destroy();
        }

        this.charts.forksVsClonesChart = new Chart(ctx, {
            type: 'bar',
            data: {
                labels: data.map(d => d.month),
                datasets: [{
                    label: 'Forks',
                    data: data.map(d => d.forks),
                    backgroundColor: '#fd7e14',
                    borderRadius: 4
                }, {
                    label: 'Clones',
                    data: data.map(d => d.clones),
                    backgroundColor: '#0366d6',
                    borderRadius: 4
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: true,
                aspectRatio: 2.5,
                scales: {
                    y: {
                        beginAtZero: true,
                        grid: {
                            color: '#f1f3f4'
                        }
                    },
                    x: {
                        grid: {
                            display: false
                        }
                    }
                },
                plugins: {
                    legend: {
                        position: 'top',
                        align: 'end'
                    }
                }
            }
        });
    }    

    createAdditionsChart() {
        const ctx = document.getElementById('additionsChart');
        const data = this.data.additionsDeletes;
        
        if (!ctx) return;
        
        if (this.charts.additionsChart) {
            this.charts.additionsChart.destroy();
        }

        this.charts.additionsChart = new Chart(ctx, {
            type: 'bar',
            data: {
                labels: data.months,
                datasets: [{
                    label: 'Additions',
                    data: data.additions,
                    backgroundColor: '#28a745',
                    borderRadius: 4
                }, {
                    label: 'Deletions',
                    data: data.deletions,
                    backgroundColor: '#dc3545',
                    borderRadius: 4
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: true,
                aspectRatio: 1.5,
                scales: {
                    x: {
                        stacked: true,
                        grid: {
                            display: false
                        }
                    },
                    y: {
                        stacked: true,
                        beginAtZero: true,
                        max: 100,
                        grid: {
                            color: '#f1f3f4'
                        },
                        ticks: {
                            callback: function(value) {
                                return value + '%';
                            }
                        }
                    }
                },
                plugins: {
                    legend: {
                        position: 'top',
                        align: 'end'
                    },
                    tooltip: {
                        callbacks: {
                            label: function(context) {
                                return `${context.dataset.label}: ${context.parsed.y.toFixed(1)}%`;
                            }
                        }
                    }
                }
            }
        });
    }

    async refreshData() {
        this.showLoading();
        await this.loadData();
        this.hideLoading();
    }    async onPeriodChange() {
        // If we have raw API data, re-transform it for the new period
        if (this.rawApiData) {
            this.data = this.transformApiData(this.rawApiData);
            this.updateDashboard();
        } else {
            // Otherwise, fetch new data
            await this.refreshData();
        }
    }

    // Edit Mode Functionality
    toggleEditMode() {
        this.isEditMode = !this.isEditMode;
        const body = document.body;
        const editBtn = document.getElementById('editModeBtn');
        
        if (this.isEditMode) {
            body.classList.add('edit-mode');
            editBtn.classList.add('active');
            editBtn.innerHTML = `
                <svg width="16" height="16" viewBox="0 0 16 16" fill="currentColor">
                    <path d="M8 15A7 7 0 1 1 8 1a7 7 0 0 1 0 14zm0 1A8 8 0 1 0 8 0a8 8 0 0 0 0 16z"/>
                    <path d="M10.97 4.97a.235.235 0 0 0-.02.022L7.477 9.417 5.384 7.323a.75.75 0 0 0-1.06 1.061L6.97 11.03a.75.75 0 0 0 1.079-.02l3.992-4.99a.75.75 0 0 0-1.071-1.05z"/>
                </svg>
                Lock Layout
            `;
            this.enableSortable();
            this.initializeSizeControls();
            this.showEditModeNotification();
        } else {
            body.classList.remove('edit-mode');
            editBtn.classList.remove('active');
            editBtn.innerHTML = `
                <svg width="16" height="16" viewBox="0 0 16 16" fill="currentColor">
                    <path d="M12.146.146a.5.5 0 0 1 .708 0l3 3a.5.5 0 0 1 0 .708L10.5 8.207l-3-3L12.146.146zM11.207 9.5L9 7.293L3.854 12.438a.5.5 0 0 0-.126.307l-.5 4a.5.5 0 0 0 .553.592l4-.5a.5.5 0 0 0 .307-.126L11.207 9.5z"/>
                </svg>
                Edit Layout
            `;
            this.disableSortable();
            this.saveLayoutToStorage();
            this.hideEditModeNotification();
        }
    }

    enableSortable() {
        const chartsGrid = document.getElementById('chartsGrid');
        this.sortable = Sortable.create(chartsGrid, {
            animation: 150,
            ghostClass: 'sortable-placeholder',
            chosenClass: 'dragging',
            handle: '.move-handle',
            onEnd: () => {
                this.saveCurrentLayout();
                setTimeout(() => this.createCharts(), 200);
            }
        });
    }

    disableSortable() {
        if (this.sortable) {
            this.sortable.destroy();
            this.sortable = null;
        }
    }

    initializeSizeControls() {
        const sizeButtons = document.querySelectorAll('.size-btn');
        sizeButtons.forEach(btn => {
            btn.addEventListener('click', (e) => {
                e.preventDefault();
                e.stopPropagation();
                
                const widget = btn.closest('.chart-container');
                const size = btn.dataset.size;
                const widgetId = widget.dataset.widgetId;
                
                widget.querySelectorAll('.size-btn').forEach(b => b.classList.remove('active'));
                btn.classList.add('active');
                
                this.applyWidgetSize(widget, size);
                this.saveWidgetSize(widgetId, size);
                
                setTimeout(() => {
                    const chartCanvas = widget.querySelector('canvas');
                    if (chartCanvas) {
                        const chartId = chartCanvas.id;
                        this.recreateChart(chartId);
                    }
                }, 100);
            });
        });
    }

    applyWidgetSize(widget, size) {
        widget.classList.remove('widget-small', 'widget-normal', 'widget-large');
        
        switch(size) {
            case 'small':
                widget.classList.add('widget-small');
                break;
            case 'large':
                widget.classList.add('widget-large');
                break;
            default:
                widget.classList.add('widget-normal');
        }
    }

    recreateChart(chartId) {
        const chartMethods = {
            'prClosedRateChart': () => this.createGaugeChart('prClosedRateChart', this.data.repository.prClosedRate, 'prClosedRateValue'),
            'issuesClosedRateChart': () => this.createGaugeChart('issuesClosedRateChart', this.data.repository.issuesClosedRate, 'issuesClosedRateValue'),
            'prActivityChart': () => this.createPRActivityChart(),
            'contributorsChart': () => this.createContributorsChart(),
            'issuesActivityChart': () => this.createIssuesActivityChart(),
            'forksVsClonesChart': () => this.createForksVsClonesChart(),
            'additionsChart': () => this.createAdditionsChart()
        };

        const method = chartMethods[chartId];
        if (method) {
            method();
        }
    }

    showEditModeNotification() {
        const notification = document.createElement('div');
        notification.className = 'edit-mode-notification';
        notification.textContent = '✏️ Edit Mode: Drag widgets to rearrange, use size buttons to resize';
        document.body.appendChild(notification);
        
        setTimeout(() => {
            if (notification.parentNode) {
                notification.parentNode.removeChild(notification);
            }
        }, 4000);
    }

    hideEditModeNotification() {
        const notification = document.querySelector('.edit-mode-notification');
        if (notification) {
            notification.remove();
        }
    }

    initializeLayout() {
        Object.entries(this.widgetLayouts).forEach(([widgetId, layout]) => {
            const widget = document.querySelector(`[data-widget-id="${widgetId}"]`);
            if (widget && layout.size) {
                this.applyWidgetSize(widget, layout.size);
                
                const sizeBtn = widget.querySelector(`[data-size="${layout.size}"]`);
                if (sizeBtn) {
                    widget.querySelectorAll('.size-btn').forEach(b => b.classList.remove('active'));
                    sizeBtn.classList.add('active');
                }
            }
        });
    }

    saveCurrentLayout() {
        const widgets = document.querySelectorAll('[data-widget-id]');
        const layout = [];
        
        widgets.forEach((widget, index) => {
            layout.push({
                id: widget.dataset.widgetId,
                order: index
            });
        });
        
        localStorage.setItem('dashboardLayout', JSON.stringify(layout));
    }

    saveWidgetSize(widgetId, size) {
        this.widgetLayouts[widgetId] = { 
            ...this.widgetLayouts[widgetId], 
            size 
        };
        this.saveLayoutToStorage();
    }

    loadLayoutFromStorage() {
        try {
            const saved = localStorage.getItem('dashboardWidgetLayouts');
            return saved ? JSON.parse(saved) : {};
        } catch (e) {
            return {};
        }
    }

    saveLayoutToStorage() {
        localStorage.setItem('dashboardWidgetLayouts', JSON.stringify(this.widgetLayouts));
    }

    formatNumber(num) {
        if (num >= 1000000) {
            return (num / 1000000).toFixed(1) + 'M';
        } else if (num >= 1000) {
            return (num / 1000).toFixed(1) + 'K';
        }
        return num.toString();
    }

    formatMonth(monthStr) {
        const date = new Date(monthStr + '-01');
        return date.toLocaleDateString('en-US', { month: 'short' });
    }

    // Edit Mode Functionality
    toggleEditMode() {
        this.isEditMode = !this.isEditMode;
        const body = document.body;
        const editBtn = document.getElementById('editModeBtn');
        
        if (this.isEditMode) {
            body.classList.add('edit-mode');
            editBtn.classList.add('active');
            editBtn.innerHTML = `
                <svg width="16" height="16" viewBox="0 0 16 16" fill="currentColor">
                    <path d="M8 15A7 7 0 1 1 8 1a7 7 0 0 1 0 14zm0 1A8 8 0 1 0 8 0a8 8 0 0 0 0 16z"/>
                    <path d="M10.97 4.97a.235.235 0 0 0-.02.022L7.477 9.417 5.384 7.323a.75.75 0 0 0-1.06 1.061L6.97 11.03a.75.75 0 0 0 1.079-.02l3.992-4.99a.75.75 0 0 0-1.071-1.05z"/>
                </svg>
                Lock Layout
            `;
            this.enableSortable();
            this.initializeSizeControls();
            this.showEditModeNotification();
        } else {
            body.classList.remove('edit-mode');
            editBtn.classList.remove('active');
            editBtn.innerHTML = `
                <svg width="16" height="16" viewBox="0 0 16 16" fill="currentColor">
                    <path d="M12.146.146a.5.5 0 0 1 .708 0l3 3a.5.5 0 0 1 0 .708L10.5 8.207l-3-3L12.146.146zM11.207 9.5L9 7.293L3.854 12.438a.5.5 0 0 0-.126.307l-.5 4a.5.5 0 0 0 .553.592l4-.5a.5.5 0 0 0 .307-.126L11.207 9.5z"/>
                </svg>
                Edit Layout
            `;
            this.disableSortable();
            this.saveLayoutToStorage();
            this.hideEditModeNotification();
        }
    }

    enableSortable() {
        const chartsGrid = document.getElementById('chartsGrid');
        this.sortable = Sortable.create(chartsGrid, {
            animation: 150,
            ghostClass: 'sortable-placeholder',
            chosenClass: 'dragging',
            handle: '.move-handle',
            onEnd: () => {
                this.saveCurrentLayout();
                // Recreate charts after layout change
                setTimeout(() => this.createCharts(), 200);
            }
        });
    }

    disableSortable() {
        if (this.sortable) {
            this.sortable.destroy();
            this.sortable = null;
        }
    }

    initializeSizeControls() {
        const sizeButtons = document.querySelectorAll('.size-btn');
        sizeButtons.forEach(btn => {
            btn.addEventListener('click', (e) => {
                e.preventDefault();
                e.stopPropagation();
                
                const widget = btn.closest('.chart-container');
                const size = btn.dataset.size;
                const widgetId = widget.dataset.widgetId;
                
                // Update button states
                widget.querySelectorAll('.size-btn').forEach(b => b.classList.remove('active'));
                btn.classList.add('active');
                
                // Apply size
                this.applyWidgetSize(widget, size);
                
                // Save layout
                this.saveWidgetSize(widgetId, size);
                
                // Recreate chart after size change
                setTimeout(() => {
                    const chartCanvas = widget.querySelector('canvas');
                    if (chartCanvas) {
                        const chartId = chartCanvas.id;
                        this.recreateChart(chartId);
                    }
                }, 100);
            });
        });
    }

    applyWidgetSize(widget, size) {
        // Remove existing size classes
        widget.classList.remove('widget-small', 'widget-normal', 'widget-large');
        
        // Add new size class
        switch(size) {
            case 'small':
                widget.classList.add('widget-small');
                break;
            case 'large':
                widget.classList.add('widget-large');
                break;
            default:
                widget.classList.add('widget-normal');
        }
    }

    recreateChart(chartId) {
        // Map chart IDs to their creation methods
        const chartMethods = {
            'prClosedRateChart': () => this.createGaugeChart('prClosedRateChart', this.data.repository.prClosedRate, 'prClosedRateValue'),
            'issuesClosedRateChart': () => this.createGaugeChart('issuesClosedRateChart', this.data.repository.issuesClosedRate, 'issuesClosedRateValue'),
            'prActivityChart': () => this.createPRActivityChart(),
            'contributorsChart': () => this.createContributorsChart(),
            'issuesActivityChart': () => this.createIssuesActivityChart(),
            'forksVsClonesChart': () => this.createForksVsClonesChart(),
            'additionsChart': () => this.createAdditionsChart()
        };

        const method = chartMethods[chartId];
        if (method) {
            method();
        }
    }

    showEditModeNotification() {
        const notification = document.createElement('div');
        notification.className = 'edit-mode-notification';
        notification.textContent = '✏️ Edit Mode: Drag widgets to rearrange, use size buttons to resize';
        document.body.appendChild(notification);
        
        setTimeout(() => {
            if (notification.parentNode) {
                notification.parentNode.removeChild(notification);
            }
        }, 4000);
    }

    hideEditModeNotification() {
        const notification = document.querySelector('.edit-mode-notification');
        if (notification) {
            notification.remove();
        }
    }    // Layout Management
    initializeLayout() {
        // Define default sizes for widgets
        const defaultSizes = {
            'pr-activity': 'large',
            'forks-clones': 'large',
            'pr-closed-rate': 'normal',
            'issues-closed-rate': 'normal',
            'contributors': 'normal',
            'issues-activity': 'normal',
            'additions-deletions': 'normal'
        };

        // Apply saved sizes to widgets or use defaults
        const allWidgets = document.querySelectorAll('[data-widget-id]');
        allWidgets.forEach(widget => {
            const widgetId = widget.dataset.widgetId;
            let targetSize = 'normal'; // fallback
            
            // Check if we have a saved layout
            if (this.widgetLayouts[widgetId] && this.widgetLayouts[widgetId].size) {
                targetSize = this.widgetLayouts[widgetId].size;
            } 
            // Otherwise use default size
            else if (defaultSizes[widgetId]) {
                targetSize = defaultSizes[widgetId];
            }
            
            // Apply the size
            this.applyWidgetSize(widget, targetSize);
            
            // Update size button states
            const sizeBtn = widget.querySelector(`[data-size="${targetSize}"]`);
            if (sizeBtn) {
                widget.querySelectorAll('.size-btn').forEach(b => b.classList.remove('active'));
                sizeBtn.classList.add('active');
            }
        });
    }

    saveCurrentLayout() {
        const widgets = document.querySelectorAll('[data-widget-id]');
        const layout = [];
        
        widgets.forEach((widget, index) => {
            layout.push({
                id: widget.dataset.widgetId,
                order: index
            });
        });
        
        localStorage.setItem('dashboardLayout', JSON.stringify(layout));
    }

    saveWidgetSize(widgetId, size) {
        this.widgetLayouts[widgetId] = { 
            ...this.widgetLayouts[widgetId], 
            size 
        };
        this.saveLayoutToStorage();
    }

    loadLayoutFromStorage() {
        try {
            const saved = localStorage.getItem('dashboardWidgetLayouts');
            return saved ? JSON.parse(saved) : {};
        } catch (e) {
            return {};
        }
    }

    saveLayoutToStorage() {
        localStorage.setItem('dashboardWidgetLayouts', JSON.stringify(this.widgetLayouts));
    }
}

// Initialize dashboard when DOM is loaded
document.addEventListener('DOMContentLoaded', () => {
    new GitHubMetricsDashboard();
});
