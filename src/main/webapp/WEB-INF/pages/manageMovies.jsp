<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Movies - MovieMint Admin</title>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .btn-edit, .btn-delete { min-width: 80px; padding: 8px 16px; font-size: 13px; display: inline-block; text-align: center; }
        .schedule-container { border: 1px solid #e9ecef; border-radius: 8px; padding: 20px; margin-top: 10px; background: #f8f9fa; }
        .date-tabs { display: flex; gap: 8px; margin-bottom: 20px; flex-wrap: wrap; }
        .date-tab { padding: 10px 20px; border: 2px solid #ced4da; border-radius: 6px; cursor: pointer; transition: all 0.2s; background: white; font-size: 14px; font-weight: 500; }
        .date-tab:hover { border-color: #dc143c; }
        .date-tab.active { border-color: #dc143c; background: #dc143c; color: white; }
        .time-input-section { display: none; }
        .time-input-section.active { display: block; }
        .time-input-row { display: flex; gap: 10px; align-items: center; margin-bottom: 10px; }
        .time-input-row input[type="time"] { padding: 8px 12px; border: 1px solid #ced4da; border-radius: 6px; font-size: 14px; }
        .add-time-btn { background: #28a745; color: white; border: none; padding: 8px 16px; border-radius: 6px; cursor: pointer; font-size: 14px; }
        .remove-time-btn { background: #dc3545; color: white; border: none; padding: 6px 12px; border-radius: 4px; cursor: pointer; font-size: 13px; }
        .time-list { margin-top: 15px; }
        .time-chip { display: inline-block; padding: 8px 16px; background: #dc143c; color: white; border-radius: 20px; margin: 4px; font-size: 13px; }
        .time-chip .remove { margin-left: 8px; cursor: pointer; font-weight: bold; }
        .conflict-warning { color: #dc3545; font-size: 13px; margin-top: 5px; display: none; }
        .conflict-warning.show { display: block; }
    </style>
</head>
<body>
    <c:if test="${empty user || user.role != 'admin'}">
        <c:redirect url="login"/>
    </c:if>
    
    <div class="dashboard">
        <jsp:include page="adminHeader.jsp" />
        
        <div class="main-content">
            <h1>Manage Movies</h1>
            
            <c:if test="${not empty param.success}">
                <p class="success-message">${param.success}</p>
            </c:if>
            
            <c:if test="${not empty param.error}">
                <p class="error-message">${param.error}</p>
            </c:if>
            
            <div class="action-buttons">
                <button onclick="showAddForm()" class="btn-primary">Add New Movie</button>
            </div>
            
            <!-- Search and Filter Section -->
            <div style="margin: 20px 0; display: flex; gap: 10px; align-items: center;">
                <input type="text" id="searchInput" placeholder="Search movies by title..." style="padding: 10px; border: 1px solid #ced4da; border-radius: 6px; flex: 1;">
                <button onclick="searchMovies()" class="btn-primary" style="padding: 10px 20px;">Search</button>
                <button onclick="clearSearch()" class="btn-secondary" style="padding: 10px 20px;">Clear</button>
            </div>
            
            <div id="addMovieForm" style="display:none;" class="form-container">
                <h2>Add New Movie</h2>
                <form action="${pageContext.request.contextPath}/manageMovies" method="post" enctype="multipart/form-data">
                    <input type="hidden" name="action" value="add">
                    <div class="form-group">
                        <label>Title:</label>
                        <input type="text" name="title" required>
                    </div>
                    <div class="form-group">
                        <label>Genre:</label>
                        <select id="genreSelect" name="genre" onchange="toggleCustomGenre()" required>
                            <option value="">Select Genre</option>
                            <option value="Action">Action</option>
                            <option value="Comedy">Comedy</option>
                            <option value="Drama">Drama</option>
                            <option value="Horror">Horror</option>
                            <option value="Romance">Romance</option>
                            <option value="Sci-Fi">Sci-Fi</option>
                            <option value="Thriller">Thriller</option>
                            <option value="Animation">Animation</option>
                            <option value="Crime">Crime</option>
                            <option value="custom">+ Custom Genre</option>
                        </select>
                    </div>
                    <div class="form-group" id="customGenreDiv" style="display:none;">
                        <label>Custom Genre:</label>
                        <input type="text" id="customGenre" name="customGenre">
                    </div>
                    <div class="form-group">
                        <label>Director:</label>
                        <input type="text" name="director" required>
                    </div>
                    <div class="form-group">
                        <label>Duration (minutes):</label>
                        <input type="number" id="duration" name="duration" required>
                    </div>
                    <div class="form-group">
                        <label>Language:</label>
                        <input type="text" name="language" required>
                    </div>
                    <div class="form-group">
                        <label>Release Date:</label>
                        <input type="date" name="releaseDate" required>
                    </div>
                    <div class="form-group">
                        <label>Start Date (Movie Airing):</label>
                        <input type="date" id="startDate" name="startDate" required>
                    </div>
                    <div class="form-group">
                        <label>End Date (Movie Airing):</label>
                        <input type="date" id="endDate" name="endDate" required>
                    </div>
                    <div class="form-group">
                        <label>Description:</label>
                        <textarea name="description" required></textarea>
                    </div>
                    <div class="form-group">
                        <label>Poster Image:</label>
                        <input type="file" name="posterImage" accept="image/*" required>
                        <small>Upload JPG, PNG, or GIF</small>
                    </div>
                    <div class="form-group">
                        <label>Show Schedule:</label>
                        <div class="schedule-container">
                            <p style="font-size: 14px; color: #6c757d; margin-bottom: 15px;">Select dates between Start Date and End Date, then choose halls and add show times</p>
                            <div class="date-tabs" id="dateTabs"></div>
                            <div id="hallSelection" style="display: none; margin-top: 20px;">
                                <label style="font-weight: 500; margin-bottom: 10px; display: block;">Select Halls:</label>
                                <div style="display: flex; gap: 10px; flex-wrap: wrap; margin-bottom: 20px;">
                                    <div class="date-tab" onclick="toggleHall(this, 'audi01')">Audi 01</div>
                                    <div class="date-tab" onclick="toggleHall(this, 'audi02')">Audi 02</div>
                                    <div class="date-tab" onclick="toggleHall(this, 'audi03')">Audi 03</div>
                                    <div class="date-tab" onclick="toggleHall(this, 'audi04')">Audi 04</div>
                                    <div class="date-tab" onclick="toggleHall(this, 'audi05')">Audi 05</div>
                                </div>
                            </div>
                            <div id="timeInputSections"></div>
                        </div>
                        <input type="hidden" id="scheduleData" name="scheduleData">
                    </div>
                    <button type="submit" class="btn-success">Add Movie</button>
                    <button type="button" onclick="hideAddForm()" class="btn-secondary">Cancel</button>
                </form>
            </div>
            
            <!-- Edit Movie Form -->
            <div id="editMovieForm" style="display:none;" class="form-container">
                <h2>Edit Movie</h2>
                <form action="${pageContext.request.contextPath}/manageMovies" method="post" enctype="multipart/form-data">
                    <input type="hidden" name="action" value="update">
                    <input type="hidden" name="movieId" id="editMovieId">
                    
                    <div class="form-group">
                        <label>Current Poster:</label>
                        <div id="currentPosterPreview" style="margin-top: 10px; margin-bottom: 15px;">
                            <img id="posterImg" src="" alt="Movie Poster" style="max-width: 150px; max-height: 200px; border-radius: 6px; border: 1px solid #ced4da;">
                        </div>
                    </div>
                    
                    <div class="form-group">
                        <label>Update Poster Image (Optional):</label>
                        <input type="file" name="posterImage" accept="image/*" id="editPosterInput" onchange="previewEditImage()">
                        <small>Upload JPG, PNG, or GIF to replace current image</small>
                        <div id="newPosterPreview" style="margin-top: 10px;"></div>
                    </div>
                    
                    <div class="form-group">
                        <label>Title:</label>
                        <input type="text" name="title" id="editTitle" required>
                    </div>
                    <div class="form-group">
                        <label>Genre:</label>
                        <input type="text" name="genre" id="editGenre" required>
                    </div>
                    <div class="form-group">
                        <label>Director:</label>
                        <input type="text" name="director" id="editDirector" required>
                    </div>
                    <div class="form-group">
                        <label>Duration (minutes):</label>
                        <input type="number" name="duration" id="editDuration" required onchange="updateEditSchedule()">
                    </div>
                    <div class="form-group">
                        <label>Language:</label>
                        <input type="text" name="language" id="editLanguage" required>
                    </div>
                    <div class="form-group">
                        <label>Release Date:</label>
                        <input type="date" name="releaseDate" id="editReleaseDate" required>
                    </div>
                    <div class="form-group">
                        <label>Start Date (Movie Airing):</label>
                        <input type="date" id="editStartDate" name="startDate" required onchange="updateEditSchedule()">
                    </div>
                    <div class="form-group">
                        <label>End Date (Movie Airing):</label>
                        <input type="date" id="editEndDate" name="endDate" required onchange="updateEditSchedule()">
                    </div>
                    <div class="form-group">
                        <label>Description:</label>
                        <textarea name="description" id="editDescription" required></textarea>
                    </div>
                    
                    <div class="form-group">
                        <label>Edit Show Schedule:</label>
                        <div class="schedule-container">
                            <p style="font-size: 14px; color: #6c757d; margin-bottom: 15px;">Select dates to manage show times</p>
                            <div class="date-tabs" id="editDateTabs"></div>
                            <div id="editHallSelection" style="display: none; margin-top: 20px;">
                                <label style="font-weight: 500; margin-bottom: 10px; display: block;">Select Halls:</label>
                                <div style="display: flex; gap: 10px; flex-wrap: wrap; margin-bottom: 20px;">
                                    <div class="date-tab" data-hall="audi01" onclick="toggleEditHall(this, 'audi01')">Audi 01</div>
                                    <div class="date-tab" data-hall="audi02" onclick="toggleEditHall(this, 'audi02')">Audi 02</div>
                                    <div class="date-tab" data-hall="audi03" onclick="toggleEditHall(this, 'audi03')">Audi 03</div>
                                    <div class="date-tab" data-hall="audi04" onclick="toggleEditHall(this, 'audi04')">Audi 04</div>
                                    <div class="date-tab" data-hall="audi05" onclick="toggleEditHall(this, 'audi05')">Audi 05</div>
                                </div>
                            </div>
                            <div id="editTimeInputSections"></div>
                        </div>
                        <input type="hidden" id="editScheduleData" name="scheduleData">
                    </div>
                    
                    <button type="submit" class="btn-success">Update Movie</button>
                    <button type="button" onclick="hideEditForm()" class="btn-secondary">Cancel</button>
                </form>
            </div>
            
            <script>
                console.log('JavaScript is loading...');
                // Store all show times from database
                const allShowTimesData = [
                    <c:if test="${not empty allShowTimes}">
                    <c:forEach var="st" items="${allShowTimes}" varStatus="status">
                        {movieId: ${st.movieId}, date: '${st.showDate}', time: '${st.showTime}', hall: '${st.hall}'}<c:if test="${!status.last}">,</c:if>
                    </c:forEach>
                    </c:if>
                ];
                
                // Store movie-specific show times if editing
                const movieShowTimesData = [
                    <c:if test="${not empty movieShowTimes}">
                    <c:forEach var="st" items="${movieShowTimes}" varStatus="status">
                        {movieId: ${st.movieId}, date: '${st.showDate}', time: '${st.showTime}', hall: '${st.hall}'}<c:if test="${!status.last}">,</c:if>
                    </c:forEach>
                    </c:if>
                ];
                console.log('movieShowTimesData:', movieShowTimesData);
                
                // Store all show schedule data (dates, halls, times)
                let schedule = {};
                // Store which halls are selected for current date
                let selectedHalls = [];
                // Store currently selected date
                let currentDate = null;
                
                // Show the add movie form
                function showAddForm() { 
                    document.getElementById('addMovieForm').style.display = 'block';
                }
                
                // Hide the add movie form and reset all data
                function hideAddForm() { 
                    document.getElementById('addMovieForm').style.display = 'none';
                    // Clear all schedule data
                    schedule = {};
                    selectedHalls = [];
                    currentDate = null;
                    // Clear date tabs
                    document.getElementById('dateTabs').innerHTML = '';
                    // Clear time input sections
                    document.getElementById('timeInputSections').innerHTML = '';
                    // Hide hall selection
                    document.getElementById('hallSelection').style.display = 'none';
                }
                
                // When page loads, listen for changes to start and end dates
                document.addEventListener('DOMContentLoaded', function() {
                    document.getElementById('startDate').addEventListener('change', generateDateTabs);
                    document.getElementById('endDate').addEventListener('change', generateDateTabs);
                    
                    // If editMovie is set, show the edit form automatically
                    <c:if test="${not empty editMovie}">
                    showEditForm(${editMovie.movieId}, `${editMovie.title}`, `${editMovie.genre}`, `${editMovie.director}`, ${editMovie.duration}, `${editMovie.language}`, `${editMovie.description}`, `${editMovie.posterImage}`, `${editMovie.startDate}`, `${editMovie.endDate}`, `${editMovie.releaseDate}`);
                    </c:if>
                });
                
                // Create date tabs between start and end date
                function generateDateTabs() {
                    const startDate = document.getElementById('startDate').value;
                    const endDate = document.getElementById('endDate').value;
                    
                    // Exit if dates not selected
                    if (!startDate || !endDate) return;
                    
                    // Convert to date objects
                    const start = new Date(startDate);
                    const end = new Date(endDate);
                    
                    // Check if end date is after start date
                    if (start > end) {
                        alert('End date must be after start date');
                        return;
                    }
                    
                    // Reset all data
                    schedule = {};
                    selectedHalls = [];
                    currentDate = null;
                    const dateTabs = document.getElementById('dateTabs');
                    const timeInputSections = document.getElementById('timeInputSections');
                    dateTabs.innerHTML = '';
                    timeInputSections.innerHTML = '';
                    document.getElementById('hallSelection').style.display = 'none';
                    
                    // Loop through each day from start to end date
                    let current = new Date(start);
                    let isFirst = true;
                    
                    while (current <= end) {
                        // Convert date to string format (YYYY-MM-DD)
                        const dateStr = current.toISOString().split('T')[0];
                        // Create unique key for this date
                        const dateKey = 'date_' + dateStr.replace(/-/g, '');
                        
                        // Store date in schedule object
                        schedule[dateKey] = { date: dateStr, halls: {} };
                        
                        // Create a clickable date tab
                        const tab = document.createElement('div');
                        tab.className = 'date-tab' + (isFirst ? ' active' : '');
                        tab.setAttribute('data-date', dateKey);
                        tab.textContent = formatDate(current);
                        tab.onclick = function() { switchDate(this, dateKey); };
                        dateTabs.appendChild(tab);
                        
                        // For first date, show hall selection
                        if (isFirst) {
                            currentDate = dateKey;
                            document.getElementById('hallSelection').style.display = 'block';
                            console.log('Hall selection shown for first date:', dateKey);
                        }
                        
                        // Move to next day
                        current.setDate(current.getDate() + 1);
                        isFirst = false;
                    }
                }
                
                // Format date as "Mon, Jan 1"
                function formatDate(date) {
                    const days = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
                    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
                    return days[date.getDay()] + ', ' + months[date.getMonth()] + ' ' + date.getDate();
                }
                
                // Show custom genre input if user selects "Custom Genre"
                function toggleCustomGenre() {
                    const select = document.getElementById('genreSelect');
                    const customDiv = document.getElementById('customGenreDiv');
                    const customInput = document.getElementById('customGenre');
                    if (select.value === 'custom') {
                        customDiv.style.display = 'block';
                        customInput.required = true;
                    } else {
                        customDiv.style.display = 'none';
                        customInput.required = false;
                    }
                }
                
                // Switch to a different date and reset hall selection
                function switchDate(element, dateKey) {
                    console.log('Switching to:', dateKey);
                    
                    // Remove active class from all date tabs
                    document.querySelectorAll('.date-tab').forEach(tab => tab.classList.remove('active'));
                    // Add active class to clicked tab
                    element.classList.add('active');
                    // Update current date
                    currentDate = dateKey;
                    
                    // Show hall selection
                    document.getElementById('hallSelection').style.display = 'block';
                    
                    // Remove active class from all hall tabs
                    document.querySelectorAll('#hallSelection .date-tab').forEach(tab => tab.classList.remove('active'));
                    // Reset selected halls
                    selectedHalls = [];
                    
                    // Clear time input sections
                    document.getElementById('timeInputSections').innerHTML = '';
                }
                
                // Toggle hall selection on/off
                function toggleHall(element, hallId) {
                    if (!currentDate) return;
                    
                    // If hall is currently selected (about to be unselected)
                    if (element.classList.contains('active')) {
                        if (schedule[currentDate].halls[hallId] && schedule[currentDate].halls[hallId].length > 0) {
                            if (!confirm("This will clear all times for " + hallId.replace('audi', 'Audi ') + ". Are you sure?")) {
                                return; // Abort
                            }
                        }
                        element.classList.remove('active');
                        selectedHalls = selectedHalls.filter(h => h !== hallId);
                        removeHallSection(hallId);
                    } else {
                        // Hall is unselected (about to be selected)
                        element.classList.add('active');
                        selectedHalls.push(hallId);
                        if (!schedule[currentDate].halls[hallId]) {
                            schedule[currentDate].halls[hallId] = [];
                        }
                        addHallSection(hallId);
                    }
                }
                
                // Create time input section for a hall
                function addHallSection(hallId) {
                    const timeInputSections = document.getElementById('timeInputSections');
                    
                    // Create unique section ID
                    const sectionId = currentDate + '_' + hallId;
                    // Don't create if already exists
                    if (document.getElementById('section_' + sectionId)) return;
                    
                    // Create main section container
                    const section = document.createElement('div');
                    section.id = 'section_' + sectionId;
                    section.style.marginBottom = '20px';
                    section.style.padding = '15px';
                    section.style.border = '1px solid #e9ecef';
                    section.style.borderRadius = '6px';
                    section.style.background = 'white';
                    
                    // Create hall name heading
                    const hallLabel = document.createElement('h4');
                    hallLabel.textContent = hallId.replace('audi', 'Audi ');
                    hallLabel.style.marginBottom = '10px';
                    hallLabel.style.color = '#dc143c';
                    section.appendChild(hallLabel);
                    
                    // Create time input row
                    const timeInputRow = document.createElement('div');
                    timeInputRow.className = 'time-input-row';
                    
                    // Create time input field
                    const timeInput = document.createElement('input');
                    timeInput.type = 'time';
                    timeInput.id = 'timeInput_' + sectionId;
                    timeInput.onchange = function() { validateTime(sectionId); };
                    
                    // Create add time button
                    const addBtn = document.createElement('button');
                    addBtn.type = 'button';
                    addBtn.className = 'add-time-btn';
                    addBtn.textContent = 'Add Time';
                    addBtn.onclick = function() { addTime(sectionId, hallId); };
                    
                    timeInputRow.appendChild(timeInput);
                    timeInputRow.appendChild(addBtn);
                    
                    // Create warning message for time conflicts
                    const warning = document.createElement('div');
                    warning.className = 'conflict-warning';
                    warning.id = 'warning_' + sectionId;
                    warning.textContent = 'Time slot unavailable - conflicts with another show';
                    
                    // Create list to show added times
                    const timeList = document.createElement('div');
                    timeList.className = 'time-list';
                    timeList.id = 'timeList_' + sectionId;
                    
                    section.appendChild(timeInputRow);
                    section.appendChild(warning);
                    section.appendChild(timeList);
                    timeInputSections.appendChild(section);
                }
                
                // Remove time input section for a hall
                function removeHallSection(hallId) {
                    const sectionId = currentDate + '_' + hallId;
                    // Remove the section from page
                    const section = document.getElementById('section_' + sectionId);
                    if (section) section.remove();
                    // Remove from schedule data
                    if (schedule[currentDate] && schedule[currentDate].halls[hallId]) {
                        delete schedule[currentDate].halls[hallId];
                    }
                    // Update hidden form field
                    updateScheduleData();
                }
                
                // Check if new time conflicts with existing times
                function validateTime(sectionId) {
                    // Get movie duration
                    const duration = parseInt(document.getElementById('duration').value) || 0;
                    // Add 30 minute buffer after movie ends
                    const buffer = 30;
                    const totalMinutes = duration + buffer;
                    
                    // Get time input and warning elements
                    const timeInput = document.getElementById('timeInput_' + sectionId);
                    const newTime = timeInput.value;
                    const warning = document.getElementById('warning_' + sectionId);
                    
                    // If no time selected or no duration, no conflict
                    if (!newTime || !duration) {
                        warning.classList.remove('show');
                        return true;
                    }
                    
                    // Extract date and hall from section ID
                    const parts = sectionId.split('_');
                    const dateKey = parts[0] + '_' + parts[1];
                    const hallId = parts[2];
                    
                    // Convert new time to minutes
                    const newStartMinutes = timeToMinutes(newTime);
                    const newEndMinutes = newStartMinutes + totalMinutes;
                    // Get all existing times for this hall
                    const existingTimes = schedule[dateKey].halls[hallId] || [];
                    
                    // Check if new time overlaps with any existing time
                    for (let time of existingTimes) {
                        const existingStartMinutes = timeToMinutes(time);
                        const existingEndMinutes = existingStartMinutes + totalMinutes;
                        
                        // If times overlap, show warning
                        if ((newStartMinutes < existingEndMinutes && newEndMinutes > existingStartMinutes)) {
                            warning.classList.add('show');
                            return false;
                        }
                    }
                    
                    // No conflict found
                    warning.classList.remove('show');
                    return true;
                }
                
                // Convert time string (HH:MM) to total minutes
                function timeToMinutes(time) {
                    const [hours, minutes] = time.split(':').map(Number);
                    return hours * 60 + minutes;
                }
                
                // Add a new show time for a hall
                function addTime(sectionId, hallId) {
                    // Get time from input
                    const timeInput = document.getElementById('timeInput_' + sectionId);
                    const time = timeInput.value;
                    
                    // Check if time is selected
                    if (!time) {
                        alert('Please select a time');
                        return;
                    }
                    
                    // Check for conflicts
                    if (!validateTime(sectionId)) {
                        alert('Cannot add this time - it conflicts with another show (including movie duration and 30min buffer)');
                        return;
                    }
                    
                    // Extract date key from section ID
                    const parts = sectionId.split('_');
                    const dateKey = parts[0] + '_' + parts[1];
                    
                    // Add time to schedule
                    schedule[dateKey].halls[hallId].push(time);
                    // Sort times in order
                    schedule[dateKey].halls[hallId].sort();
                    
                    // Update display
                    renderTimes(sectionId, hallId);
                    // Clear input field
                    timeInput.value = '';
                    // Update hidden form field
                    updateScheduleData();
                }
                
                // Remove a show time from a hall
                function removeTime(sectionId, hallId, time) {
                    // Extract date key from section ID
                    const parts = sectionId.split('_');
                    const dateKey = parts[0] + '_' + parts[1];
                    
                    // Remove time from schedule
                    schedule[dateKey].halls[hallId] = schedule[dateKey].halls[hallId].filter(t => t !== time);
                    // Update display
                    renderTimes(sectionId, hallId);
                    // Update hidden form field
                    updateScheduleData();
                }
                
                // Display all times for a hall
                function renderTimes(sectionId, hallId) {
                    // Get time list element
                    const timeList = document.getElementById('timeList_' + sectionId);
                    // Extract date key from section ID
                    const parts = sectionId.split('_');
                    const dateKey = parts[0] + '_' + parts[1];
                    // Get all times for this hall
                    const times = schedule[dateKey].halls[hallId] || [];
                    
                    // If no times, show message
                    if (times.length === 0) {
                        timeList.innerHTML = '<p style="color: #6c757d; font-size: 13px;">No times added yet</p>';
                        return;
                    }
                    
                    // Create HTML for each time
                    let html = '';
                    times.forEach(time => {
                        // Convert 24-hour time to 12-hour format
                        const [hours, minutes] = time.split(':');
                        const h = parseInt(hours);
                        const ampm = h >= 12 ? 'PM' : 'AM';
                        const displayHour = h % 12 || 12;
                        const formattedTime = displayHour + ':' + minutes + ' ' + ampm;
                        // Create time chip with remove button
                        html += '<span class="time-chip">' + formattedTime + '<span class="remove" onclick="removeTime(\'' + sectionId + '\', \'' + hallId + '\', \'' + time + '\')">×</span></span>';
                    });
                    timeList.innerHTML = html;
                }
                
                // Convert time to 12-hour format
                function formatTime(time) {
                    const parts = time.split(':');
                    const h = parseInt(parts[0]);
                    const ampm = h >= 12 ? 'PM' : 'AM';
                    const displayHour = h % 12 || 12;
                    return displayHour + ':' + parts[1] + ' ' + ampm;
                }
                
                // Update hidden form field with all schedule data
                function updateScheduleData() {
                    const data = [];
                    for (let dateKey in schedule) {
                        for (let hallId in schedule[dateKey].halls) {
                            const times = schedule[dateKey].halls[hallId];
                            times.forEach(time => {
                                data.push(schedule[dateKey].date + '|' + hallId + '|' + time);
                            });
                        }
                    }
                    document.getElementById('scheduleData').value = data.join(',');
                }
                
                // Show edit movie form with movie data
                let editSchedule = {};
                let selectedEditHalls = [];
                let currentEditDate = null;

                function showEditForm(movieId, title, genre, director, duration, language, description, posterImage, startDate, endDate, releaseDate) {
                    console.log('Opening edit form for movie ID:', movieId);
                    
                    document.getElementById('editMovieId').value = movieId;
                    document.getElementById('editTitle').value = title;
                    document.getElementById('editGenre').value = genre;
                    document.getElementById('editDirector').value = director;
                    document.getElementById('editDuration').value = duration;
                    document.getElementById('editLanguage').value = language;
                    document.getElementById('editDescription').value = description;
                    document.getElementById('editReleaseDate').value = releaseDate;
                    document.getElementById('editStartDate').value = startDate;
                    document.getElementById('editEndDate').value = endDate;
                    
                    const posterImg = document.getElementById('posterImg');
                    posterImg.src = '${pageContext.request.contextPath}/images/' + posterImage;
                    
                    document.getElementById('newPosterPreview').innerHTML = '';
                    document.getElementById('editPosterInput').value = '';
                    
                    if (startDate && endDate) {
                        editSchedule = {};
                        selectedEditHalls = [];
                        currentEditDate = null;
                        generateEditDateTabs(startDate, endDate, duration);
                        
                        // PRE-POPULATE EXISTING DATABASE SHOWTIMES!
                        const existingTimes = typeof allShowTimesData !== 'undefined' ? allShowTimesData.filter(st => st.movieId == movieId) : [];
                        if (existingTimes && existingTimes.length > 0) {
                            existingTimes.forEach(st => {
                                const dt = new Date(st.date);
                                const dateStr = dt.toISOString().split('T')[0];
                                const dateKey = 'date_' + dateStr.replace(/-/g, '');
                                
                                if (editSchedule[dateKey]) {
                                    if (!editSchedule[dateKey].halls[st.hall]) {
                                        editSchedule[dateKey].halls[st.hall] = [];
                                    }
                                    const timeStr = st.time.substring(0, 5);
                                    if (!editSchedule[dateKey].halls[st.hall].includes(timeStr)) {
                                       editSchedule[dateKey].halls[st.hall].push(timeStr);
                                       editSchedule[dateKey].halls[st.hall].sort();
                                    }
                                }
                            });
                        }
                        
                        // Trigger re-render of currently visually active hall block unconditionally
                        if (currentEditDate) {
                            const activeTab = document.querySelector('#editDateTabs .date-tab.active');
                            if (activeTab) {
                               switchEditDate(activeTab, currentEditDate);
                            }
                        }
                    }
                    
                    document.getElementById('editMovieForm').style.display = 'block';
                }
                
                // Preview new poster image before upload
                function previewEditImage() {
                    const file = document.getElementById('editPosterInput').files[0];
                    const preview = document.getElementById('newPosterPreview');
                    
                    if (file) {
                        const reader = new FileReader();
                        reader.onload = function(e) {
                            preview.innerHTML = '<img src="' + e.target.result + '" alt="New Poster" style="max-width: 150px; max-height: 200px; border-radius: 6px; border: 1px solid #ced4da; margin-top: 10px;">';
                        };
                        reader.readAsDataURL(file);
                    } else {
                        preview.innerHTML = '';
                    }
                }
                
                // Generate date tabs for edit form
                function generateEditDateTabs(startDateStr, endDateStr, duration) {
                    const start = new Date(startDateStr);
                    const end = new Date(endDateStr);
                    
                    const dateTabs = document.getElementById('editDateTabs');
                    const timeInputSections = document.getElementById('editTimeInputSections');
                    dateTabs.innerHTML = '';
                    timeInputSections.innerHTML = '';
                    document.getElementById('editHallSelection').style.display = 'none';
                    
                    let current = new Date(start);
                    let isFirst = true;
                    
                    while (current <= end) {
                        const dateStr = current.toISOString().split('T')[0];
                        const dateKey = 'date_' + dateStr.replace(/-/g, '');
                        
                        editSchedule[dateKey] = { date: dateStr, halls: {} };
                        
                        const tab = document.createElement('div');
                        tab.className = 'date-tab' + (isFirst ? ' active' : '');
                        tab.setAttribute('data-date', dateKey);
                        tab.textContent = formatDate(current);
                        tab.onclick = function() { switchEditDate(this, dateKey); };
                        dateTabs.appendChild(tab);
                        
                        if (isFirst) {
                            currentEditDate = dateKey;
                            document.getElementById('editHallSelection').style.display = 'block';
                            isFirst = false;
                        }
                        
                        // Increment day explicitly to fix local timezone offset skips
                        current.setUTCDate(current.getUTCDate() + 1);
                    }
                }
                
                // Switch edit date
                function switchEditDate(element, dateKey) {
                    document.querySelectorAll('#editDateTabs .date-tab').forEach(tab => tab.classList.remove('active'));
                    element.classList.add('active');
                    currentEditDate = dateKey;
                    
                    document.getElementById('editHallSelection').style.display = 'block';
                    document.querySelectorAll('#editHallSelection .date-tab').forEach(tab => tab.classList.remove('active'));
                    selectedEditHalls = [];
                    document.getElementById('editTimeInputSections').innerHTML = '';
                    
                    // Dynamically active tabs already selected
                    if (editSchedule[currentEditDate] && editSchedule[currentEditDate].halls) {
                        Object.keys(editSchedule[currentEditDate].halls).forEach(h => {
                            if (editSchedule[currentEditDate].halls[h].length > 0) {
                                const hallTab = document.querySelector(`#editHallSelection .date-tab[data-hall="${h}"]`);
                                if (hallTab) {
                                    toggleEditHall(hallTab, h);
                                }
                            }
                        });
                    }
                }
                
                // Toggle edit hall
                function toggleEditHall(element, hallId) {
                    if (!currentEditDate) return;
                    
                    if (element.classList.contains('active')) {
                        if (editSchedule[currentEditDate].halls[hallId] && editSchedule[currentEditDate].halls[hallId].length > 0) {
                            if (!confirm("This will clear all times for " + hallId.replace('audi', 'Audi ') + ". Are you sure?")) {
                                return; // Abort
                            }
                        }
                        element.classList.remove('active');
                        selectedEditHalls = selectedEditHalls.filter(h => h !== hallId);
                        removeEditHallSection(hallId);
                    } else {
                        element.classList.add('active');
                        selectedEditHalls.push(hallId);
                        if (!editSchedule[currentEditDate].halls[hallId]) {
                            editSchedule[currentEditDate].halls[hallId] = [];
                        }
                        addEditHallSection(hallId);
                    }
                }
                
                // Render specific edit hall times
                function renderEditTimes(sectionId, hallId) {
                    const timeList = document.getElementById('timeList_' + sectionId);
                    const times = editSchedule[currentEditDate].halls[hallId] || [];
                    
                    if (times.length === 0) {
                        timeList.innerHTML = '<p style="color: #6c757d; font-size: 13px;">No times added yet</p>';
                        return;
                    }
                    
                    let html = '';
                    times.forEach(t => {
                        const timeStr = t.length > 5 ? t.substring(0, 5) : t;
                        let hours = 0, minutes = "00";
                        if(timeStr.includes(':')) {
                            const parts = timeStr.split(':');
                            hours = parts[0];
                            minutes = parts[1];
                        }
                        const h = parseInt(hours) || 0;
                        const ampm = h >= 12 ? 'PM' : 'AM';
                        const displayHour = h % 12 || 12;
                        const formattedTime = displayHour + ':' + minutes + ' ' + ampm;
                        html += '<span class="time-chip">' + formattedTime + '<span class="remove" onclick="removeEditTime(\'' + sectionId + '\', \'' + hallId + '\', \'' + timeStr + '\')">×</span></span>';
                    });
                    timeList.innerHTML = html;
                }

                // Add edit hall section
                function addEditHallSection(hallId) {
                    const timeInputSections = document.getElementById('editTimeInputSections');
                    const sectionId = currentEditDate + '_edit_' + hallId;
                    
                    if (document.getElementById('section_' + sectionId)) return;
                    
                    const section = document.createElement('div');
                    section.id = 'section_' + sectionId;
                    section.style.marginBottom = '20px';
                    section.style.padding = '15px';
                    section.style.border = '1px solid #e9ecef';
                    section.style.borderRadius = '6px';
                    section.style.background = 'white';
                    
                    const hallLabel = document.createElement('h4');
                    hallLabel.textContent = hallId.replace('audi', 'Audi ');
                    hallLabel.style.marginBottom = '10px';
                    hallLabel.style.color = '#dc143c';
                    section.appendChild(hallLabel);
                    
                    const timeInputRow = document.createElement('div');
                    timeInputRow.className = 'time-input-row';
                    
                    const timeInput = document.createElement('input');
                    timeInput.type = 'time';
                    timeInput.id = 'timeInput_' + sectionId;
                    
                    const addBtn = document.createElement('button');
                    addBtn.type = 'button';
                    addBtn.className = 'add-time-btn';
                    addBtn.textContent = 'Add Time';
                    addBtn.onclick = function() { addEditTime(sectionId, hallId); };
                    
                    timeInputRow.appendChild(timeInput);
                    timeInputRow.appendChild(addBtn);
                    
                    const timeList = document.createElement('div');
                    timeList.className = 'time-list';
                    timeList.id = 'timeList_' + sectionId;
                    
                    section.appendChild(timeInputRow);
                    section.appendChild(timeList);
                    timeInputSections.appendChild(section);
                    
                    renderEditTimes(sectionId, hallId);
                }
                
                // Remove edit hall section
                function removeEditHallSection(hallId) {
                    const sectionId = currentEditDate + '_edit_' + hallId;
                    const section = document.getElementById('section_' + sectionId);
                    if (section) section.remove();
                    if (editSchedule[currentEditDate] && editSchedule[currentEditDate].halls[hallId]) {
                        delete editSchedule[currentEditDate].halls[hallId];
                    }
                    updateEditScheduleData();
                }
                
                // Add edit time
                function addEditTime(sectionId, hallId) {
                    const timeInput = document.getElementById('timeInput_' + sectionId);
                    const time = timeInput.value;
                    
                    if (!time) {
                        alert('Please select a time');
                        return;
                    }
                    
                    const timeHhMm = time.includes(':') ? time.split(':').slice(0,2).join(':') : time;
                    if (!editSchedule[currentEditDate].halls[hallId].includes(timeHhMm)) {
                        editSchedule[currentEditDate].halls[hallId].push(timeHhMm);
                        editSchedule[currentEditDate].halls[hallId].sort();
                        renderEditTimes(sectionId, hallId);
                    }
                    timeInput.value = '';
                    updateEditScheduleData();
                }

                // Remove edit time
                function removeEditTime(sectionId, hallId, timeHhMm) {
                    if (editSchedule[currentEditDate] && editSchedule[currentEditDate].halls[hallId]) {
                        editSchedule[currentEditDate].halls[hallId] = editSchedule[currentEditDate].halls[hallId].filter(t => t !== timeHhMm);
                    }
                    renderEditTimes(sectionId, hallId);
                    updateEditScheduleData();
                }

                // Update hidden edit schedule data field before submit
                function updateEditScheduleData() {
                    let scheduleDataParams = [];
                    for (const [dateKey, dateData] of Object.entries(editSchedule)) {
                        const dateStr = dateKey.replace('date_', '');
                        const formattedDate = dateStr.slice(0,4) + '-' + dateStr.slice(4,6) + '-' + dateStr.slice(6,8);
                        for (const [hallId, times] of Object.entries(dateData.halls)) {
                            for (const time of times) {
                                scheduleDataParams.push(formattedDate + '|' + hallId + '|' + time);
                            }
                        }
                    }
                    const hiddenField = document.getElementById('editScheduleData');
                    if (hiddenField) {
                        hiddenField.value = scheduleDataParams.join(',');
                    }
                }
                
                // Update edit schedule limits
                function updateEditSchedule() {
                    const startDate = document.getElementById('editStartDate').value;
                    const endDate = document.getElementById('editEndDate').value;
                    const duration = document.getElementById('editDuration').value;
                    
                    if (startDate && endDate) {
                        const start = new Date(startDate);
                        const end = new Date(endDate);
                        if (start > end) {
                            alert('End date must be after start date');
                            return;
                        }
                        
                        // Extract movie string logic and re-generate date tabs while trying to preserve editSchedule
                        let preservedSchedule = JSON.parse(JSON.stringify(editSchedule));
                        editSchedule = {};
                        selectedEditHalls = [];
                        currentEditDate = null;
                        generateEditDateTabs(startDate, endDate, duration);
                        
                        // Copy anything back if the date remains valid
                        for (let dk in preservedSchedule) {
                            if (editSchedule[dk]) {
                                editSchedule[dk].halls = preservedSchedule[dk].halls;
                            }
                        }
                        
                        // Refresh active tab display
                        const activeTab = document.querySelector('#editDateTabs .date-tab.active');
                        if (activeTab) {
                            switchEditDate(activeTab, activeTab.getAttribute('data-date'));
                        }
                    }
                }

                // Hook edit form submit to ensure update runs
                document.addEventListener('DOMContentLoaded', () => {
                    const editForm = document.querySelector('#editMovieForm form');
                    if(editForm) {
                        editForm.addEventListener('submit', () => {
                            if (currentEditDate) {
                                // Add logic to read from DOM to editSchedule dynamically if the user bypassed memory somehow
                                document.querySelectorAll('[id^="section_"').forEach(section => {
                                    if(section.id.includes('_edit_')) {
                                        const hallId = section.id.split('_edit_')[1];
                                        // DOM has elements, they're already in editSchedule if logic doesn't break
                                    }
                                });
                            }
                            updateEditScheduleData();
                        });
                    }
                });
                
                // Hide edit movie form
                function hideEditForm() {
                    document.getElementById('editMovieForm').style.display = 'none';
                }
                
                // Search movies by title
                function searchMovies() {
                    const searchTerm = document.getElementById('searchInput').value.toLowerCase();
                    const rows = document.querySelectorAll('.data-table tbody tr');
                    
                    rows.forEach(row => {
                        const title = row.cells[1].textContent.toLowerCase();
                        if (title.includes(searchTerm)) {
                            row.style.display = '';
                        } else {
                            row.style.display = 'none';
                        }
                    });
                }
                
                // Clear search and show all movies
                function clearSearch() {
                    document.getElementById('searchInput').value = '';
                    const rows = document.querySelectorAll('.data-table tbody tr');
                    rows.forEach(row => {
                        row.style.display = '';
                    });
                }
            </script>
            
            <div class="table-container">
                <table class="data-table">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Name</th>
                            <th>Director</th>
                            <th>Genre</th>
                            <th>Language</th>
                            <th>Duration</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${not empty movies}">
                                <c:forEach var="movie" items="${movies}">
                                    <tr>
                                        <td>${movie.movieId}</td>
                                        <td>${movie.title}</td>
                                        <td>${movie.director}</td>
                                        <td>${movie.genre}</td>
                                        <td>${movie.language}</td>
                                        <td>${movie.duration} mins</td>
                                        <td>
                                            <a href="${pageContext.request.contextPath}/manageMovies?action=edit&id=${movie.movieId}" class="btn-edit">Edit</a>
                                            <a href="${pageContext.request.contextPath}/manageMovies?action=delete&id=${movie.movieId}" class="btn-delete" onclick="return confirm('Are you sure?')">Delete</a>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <tr>
                                    <td colspan="7">No movies found.</td>
                                </tr>
                            </c:otherwise>
                        </c:choose>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</body>
</html>
