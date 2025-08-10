-- ALUI Configuration Analytics and Monitoring
-- Provides performance monitoring, usage analytics, and optimization suggestions
-- Advanced component of the configuration management system

-- Ensure ALUI namespace exists
if not ALUI or not ALUI.Config then
    error("ALUI Configuration system not loaded. Please ensure Config.lua is loaded first.")
end

ALUI.ConfigAnalytics = ALUI.ConfigAnalytics or {}
local Analytics = ALUI.ConfigAnalytics
local Config = ALUI.Config

-- Analytics data storage
Analytics.data = {
    configChanges = {},     -- Track configuration changes over time
    performance = {},       -- Performance metrics
    usage = {},            -- Feature usage statistics
    errors = {},           -- Configuration-related errors
    suggestions = {}       -- Optimization suggestions
}

-- Performance monitoring
Analytics.monitors = {
    uiUpdateTimes = {},
    resizeOperations = {},
    configLoadTimes = {},
    memoryUsage = {}
}

-- Configuration impact analysis
Analytics.impacts = {
    -- Track which config changes affect performance
    performanceImpact = {},
    -- Track which features are most used
    featureUsage = {},
    -- Track common configuration patterns
    patterns = {}
}

-- Start performance monitoring
function Analytics.startMonitoring()
    Analytics.monitoring = true
    Analytics.monitoringStart = getEpoch()
    
    -- Monitor configuration changes
    Config.onChange("", function(value, path)
        Analytics.recordConfigChange(path, value)
    end)
    
    -- Monitor UI performance
    Analytics.setupPerformanceMonitoring()
    
    if Config.get("performance.enableDebugMode") then
        cecho("<green>ALUI Analytics: Performance monitoring started\n")
    end
end

-- Record configuration change
function Analytics.recordConfigChange(path, value)
    local change = {
        path = path,
        value = value,
        timestamp = getEpoch(),
        session = Analytics.monitoringStart
    }
    
    table.insert(Analytics.data.configChanges, change)
    
    -- Analyze impact
    Analytics.analyzeConfigImpact(path, value)
    
    -- Keep only last 1000 changes to prevent memory bloat
    if #Analytics.data.configChanges > 1000 then
        table.remove(Analytics.data.configChanges, 1)
    end
end

-- Analyze configuration impact
function Analytics.analyzeConfigImpact(path, value)
    local category = path:match("^([^%.]+)")
    if not category then return end
    
    -- Record usage by category
    Analytics.data.usage[category] = (Analytics.data.usage[category] or 0) + 1
    
    -- Analyze performance impact for UI changes
    if category == "ui" then
        local beforeTime = getEpoch()
        -- Trigger a UI refresh to measure impact
        tempTimer(0.1, function()
            local afterTime = getEpoch()
            local impactTime = afterTime - beforeTime
            
            Analytics.impacts.performanceImpact[path] = {
                time = impactTime,
                timestamp = getEpoch()
            }
        end)
    end
    
    -- Track color changes
    if category == "colors" then
        Analytics.impacts.featureUsage.colorCustomization = 
            (Analytics.impacts.featureUsage.colorCustomization or 0) + 1
    end
end

-- Setup performance monitoring hooks
function Analytics.setupPerformanceMonitoring()
    -- Monitor resize operations
    local originalResize = GUI.resizeBoxes
    if originalResize then
        GUI.resizeBoxes = function(...)
            local startTime = getEpoch()
            local result = originalResize(...)
            local endTime = getEpoch()
            
            Analytics.recordPerformance("resize", endTime - startTime)
            return result
        end
    end
    
    -- Monitor config load operations
    local originalLoad = Config.load
    if originalLoad then
        Config.load = function(...)
            local startTime = getEpoch()
            local result = originalLoad(...)
            local endTime = getEpoch()
            
            Analytics.recordPerformance("configLoad", endTime - startTime)
            return result
        end
    end
end

-- Record performance metric
function Analytics.recordPerformance(operation, duration)
    if not Analytics.monitors[operation] then
        Analytics.monitors[operation] = {}
    end
    
    table.insert(Analytics.monitors[operation], {
        duration = duration,
        timestamp = getEpoch()
    })
    
    -- Keep only last 100 measurements per operation
    if #Analytics.monitors[operation] > 100 then
        table.remove(Analytics.monitors[operation], 1)
    end
    
    -- Check for performance issues
    Analytics.checkPerformanceThresholds(operation, duration)
end

-- Check performance thresholds and generate suggestions
function Analytics.checkPerformanceThresholds(operation, duration)
    local thresholds = {
        resize = 0.5,      -- 500ms for resize operations
        configLoad = 1.0,  -- 1 second for config loading
        uiUpdate = 0.1     -- 100ms for UI updates
    }
    
    local threshold = thresholds[operation]
    if threshold and duration > threshold then
        Analytics.addSuggestion({
            type = "performance",
            severity = "warning",
            operation = operation,
            duration = duration,
            threshold = threshold,
            message = string.format("Slow %s operation detected (%.2fs)", operation, duration),
            suggestions = Analytics.getPerformanceSuggestions(operation, duration)
        })
    end
end

-- Generate performance suggestions
function Analytics.getPerformanceSuggestions(operation, duration)
    local suggestions = {}
    
    if operation == "resize" then
        table.insert(suggestions, "Consider increasing ui.resizeTimerDelay to reduce frequent resize operations")
        table.insert(suggestions, "Check if ui.guiPadding is set too high causing layout complexity")
    elseif operation == "configLoad" then
        table.insert(suggestions, "Consider enabling performance.cacheSize to speed up config loading")
        table.insert(suggestions, "Check for corrupted configuration file")
    end
    
    return suggestions
end

-- Add optimization suggestion
function Analytics.addSuggestion(suggestion)
    suggestion.id = #Analytics.data.suggestions + 1
    suggestion.timestamp = getEpoch()
    suggestion.acknowledged = false
    
    table.insert(Analytics.data.suggestions, suggestion)
    
    -- Notify user if debug mode is enabled
    if Config.get("performance.enableDebugMode") then
        cecho(f"<yellow>Analytics Suggestion: {suggestion.message}\n")
    end
end

-- Get analytics report
function Analytics.getReport()
    local report = {
        summary = Analytics.getSummary(),
        performance = Analytics.getPerformanceReport(),
        usage = Analytics.getUsageReport(),
        suggestions = Analytics.getSuggestions(),
        patterns = Analytics.getPatterns()
    }
    
    return report
end

-- Get summary statistics
function Analytics.getSummary()
    return {
        monitoringDuration = Analytics.monitoring and (getEpoch() - Analytics.monitoringStart) or 0,
        totalConfigChanges = #Analytics.data.configChanges,
        totalSuggestions = #Analytics.data.suggestions,
        unacknowledgedSuggestions = Analytics.countUnacknowledgedSuggestions(),
        mostChangedCategory = Analytics.getMostChangedCategory(),
        performanceIssues = Analytics.countPerformanceIssues()
    }
end

-- Get performance report
function Analytics.getPerformanceReport()
    local report = {}
    
    for operation, measurements in pairs(Analytics.monitors) do
        if #measurements > 0 then
            local total = 0
            local min = math.huge
            local max = 0
            
            for _, measurement in ipairs(measurements) do
                total = total + measurement.duration
                min = math.min(min, measurement.duration)
                max = math.max(max, measurement.duration)
            end
            
            report[operation] = {
                count = #measurements,
                average = total / #measurements,
                minimum = min,
                maximum = max,
                total = total
            }
        end
    end
    
    return report
end

-- Get usage report
function Analytics.getUsageReport()
    local usage = {}
    
    -- Configuration category usage
    for category, count in pairs(Analytics.data.usage) do
        usage[category] = count
    end
    
    -- Feature usage
    for feature, count in pairs(Analytics.impacts.featureUsage) do
        usage[feature] = count
    end
    
    return usage
end

-- Get suggestions
function Analytics.getSuggestions()
    local suggestions = {
        active = {},
        acknowledged = {}
    }
    
    for _, suggestion in ipairs(Analytics.data.suggestions) do
        if suggestion.acknowledged then
            table.insert(suggestions.acknowledged, suggestion)
        else
            table.insert(suggestions.active, suggestion)
        end
    end
    
    return suggestions
end

-- Get configuration patterns
function Analytics.getPatterns()
    local patterns = {}
    
    -- Most common configuration changes
    local changeCounts = {}
    for _, change in ipairs(Analytics.data.configChanges) do
        changeCounts[change.path] = (changeCounts[change.path] or 0) + 1
    end
    
    patterns.mostChangedSettings = {}
    for path, count in pairs(changeCounts) do
        table.insert(patterns.mostChangedSettings, {path = path, count = count})
    end
    
    -- Sort by frequency
    table.sort(patterns.mostChangedSettings, function(a, b) return a.count > b.count end)
    
    return patterns
end

-- Helper functions
function Analytics.countUnacknowledgedSuggestions()
    local count = 0
    for _, suggestion in ipairs(Analytics.data.suggestions) do
        if not suggestion.acknowledged then
            count = count + 1
        end
    end
    return count
end

function Analytics.getMostChangedCategory()
    local maxCount = 0
    local mostChanged = nil
    
    for category, count in pairs(Analytics.data.usage) do
        if count > maxCount then
            maxCount = count
            mostChanged = category
        end
    end
    
    return mostChanged
end

function Analytics.countPerformanceIssues()
    local count = 0
    for _, suggestion in ipairs(Analytics.data.suggestions) do
        if suggestion.type == "performance" and not suggestion.acknowledged then
            count = count + 1
        end
    end
    return count
end

-- Acknowledge suggestion
function Analytics.acknowledgeSuggestion(suggestionId)
    for _, suggestion in ipairs(Analytics.data.suggestions) do
        if suggestion.id == suggestionId then
            suggestion.acknowledged = true
            suggestion.acknowledgedAt = getEpoch()
            return true
        end
    end
    return false
end

-- Display analytics report
function Analytics.displayReport()
    local report = Analytics.getReport()
    
    cecho("<cyan>ALUI Configuration Analytics Report\n")
    cecho("<white>=====================================\n")
    
    -- Summary
    cecho("<yellow>Summary:\n")
    cecho(f"<white>  Monitoring Duration: <green>{report.summary.monitoringDuration:.1f}s\n")
    cecho(f"<white>  Total Config Changes: <green>{report.summary.totalConfigChanges}\n")
    cecho(f"<white>  Active Suggestions: <green>{report.summary.unacknowledgedSuggestions}\n")
    if report.summary.mostChangedCategory then
        cecho(f"<white>  Most Changed Category: <green>{report.summary.mostChangedCategory}\n")
    end
    
    -- Performance
    if next(report.performance) then
        cecho("<yellow>Performance:\n")
        for operation, stats in pairs(report.performance) do
            cecho(f"<white>  {operation}: <green>{stats.average:.3f}s avg <dim_grey>({stats.count} samples)\n")
        end
    end
    
    -- Active suggestions
    if #report.suggestions.active > 0 then
        cecho("<yellow>Active Suggestions:\n")
        for i, suggestion in ipairs(report.suggestions.active) do
            if i <= 5 then -- Show only first 5
                cecho(f"<white>  {suggestion.id}: <orange>{suggestion.message}\n")
            end
        end
        if #report.suggestions.active > 5 then
            cecho(f"<dim_grey>  ... and {#report.suggestions.active - 5} more\n")
        end
    end
    
    -- Usage patterns
    if next(report.usage) then
        cecho("<yellow>Most Used Categories:\n")
        local sortedUsage = {}
        for category, count in pairs(report.usage) do
            table.insert(sortedUsage, {category = category, count = count})
        end
        table.sort(sortedUsage, function(a, b) return a.count > b.count end)
        
        for i = 1, math.min(5, #sortedUsage) do
            local item = sortedUsage[i]
            cecho(f"<white>  {item.category}: <green>{item.count} changes\n")
        end
    end
end

-- Analytics command handler
local function handleAnalyticsCommand(action, param)
    action = action and string.lower(action)
    
    if not action or action == "help" then
        cecho("<cyan>ALUI Analytics Commands:\n")
        cecho("<white>  analytics report             <dim_grey>- Show analytics report\n")
        cecho("<white>  analytics start              <dim_grey>- Start monitoring\n")
        cecho("<white>  analytics stop               <dim_grey>- Stop monitoring\n")
        cecho("<white>  analytics clear              <dim_grey>- Clear analytics data\n")
        cecho("<white>  analytics suggest            <dim_grey>- Show optimization suggestions\n")
        cecho("<white>  analytics ack <id>           <dim_grey>- Acknowledge suggestion\n")
        return
    end
    
    if action == "report" then
        Analytics.displayReport()
    elseif action == "start" then
        Analytics.startMonitoring()
        cecho("<green>Analytics monitoring started\n")
    elseif action == "stop" then
        Analytics.monitoring = false
        cecho("<yellow>Analytics monitoring stopped\n")
    elseif action == "clear" then
        Analytics.data = {
            configChanges = {},
            performance = {},
            usage = {},
            errors = {},
            suggestions = {}
        }
        cecho("<yellow>Analytics data cleared\n")
    elseif action == "suggest" then
        local suggestions = Analytics.getSuggestions()
        if #suggestions.active > 0 then
            cecho("<cyan>Active Optimization Suggestions:\n")
            for _, suggestion in ipairs(suggestions.active) do
                cecho(f"<white>  {suggestion.id}: <orange>{suggestion.message}\n")
                if suggestion.suggestions then
                    for _, tip in ipairs(suggestion.suggestions) do
                        cecho(f"<dim_grey>    - {tip}\n")
                    end
                end
            end
        else
            cecho("<green>No active suggestions - your configuration is optimized!\n")
        end
    elseif action == "ack" then
        local id = tonumber(param)
        if id and Analytics.acknowledgeSuggestion(id) then
            cecho(f"<green>Acknowledged suggestion {id}\n")
        else
            cecho("<red>Invalid suggestion ID\n")
        end
    else
        cecho(f"<red>Unknown analytics action: <white>{action}\n")
    end
end

-- Register analytics command
if tempAlias then
    if ALUI.AnalyticsAlias then
        killAlias(ALUI.AnalyticsAlias)
    end
    
    ALUI.AnalyticsAlias = tempAlias("^analytics\\s*(\\w*)\\s*(\\S*)$", function()
        local action = matches[2] and matches[2] ~= "" and matches[2] or nil
        local param = matches[3] and matches[3] ~= "" and matches[3] or nil
        
        handleAnalyticsCommand(action, param)
    end)
end

-- Initialize analytics
function Analytics.init()
    -- Auto-start monitoring if enabled
    if Config.get("performance.enableDebugMode", false) then
        Analytics.startMonitoring()
    end
    
    cecho("<green>ALUI Analytics System initialized. Type 'analytics help' for commands.\n")
end

-- Initialize on load
Analytics.init()

return Analytics
