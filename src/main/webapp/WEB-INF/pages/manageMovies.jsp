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
        body { background: #f0f0f1; }
        .stats-row { display: grid; grid-template-columns: repeat(4, 1fr); gap: 12px; margin-bottom: 18px; }
        .stat-box { background: #fff; border: 1px solid #ddd; border-left: 3px solid #ccc; border-radius: 3px; padding: 14px 16px; }
        .stat-box.red { border-left-color: #c9152f; }
        .stat-box.green { border-left-color: #218a3a; }
        .stat-box.blue { border-left-color: #3498db; }
        .stat-box.amber { border-left-color: #e09000; }
        .stat-box .label { font-size: 11px; font-weight: 600; color: #888; text-transform: uppercase; letter-spacing: 0.3px; margin-bottom: 6px; }
        .stat-box .value { font-size: 24px; font-weight: 700; color: #111; }
        .stat-box .sub { font-size: 11px; color: #aaa; margin-top: 4px; }
        .btn-edit, .btn-delete { min-width: 60px; padding: 5px 11px; font-size: 12px; display: inline-block; text-align: center; }
        .schedule-container { border: 1px solid #ddd; border-radius: 4px; padding: 16px; margin-top: 10px; background: #fafafa; }
        .date-tabs { display: flex; gap: 6px; margin-bottom: 16px; flex-wrap: wrap; }
        .date-tab { padding: 6px 14px; border: 1px solid #ccc; border-radius: 3px; cursor: pointer; background: #fff; font-size: 13px; font-weight: 500; }
        .date-tab:hover { border-color: #c9152f; }
        .date-tab.active { border-color: #c9152f; background: #c9152f; color: #fff; }
        .date-tab.has-data { border-color: #218a3a; border-width: 2px; position: relative; }
        .date-tab.has-data::after { 
            content: ''; 
            position: absolute; 
            top: -4px; 
            right: -4px; 
            width: 8px; 
            height: 8px; 
            background: #218a3a; 
            border-radius: 50%; 
            border: 1px solid white;
        }
        .time-input-section { display: none; }
        .time-input-section.active { display: block; }
        .time-input-row { display: flex; gap: 8px; align-items: center; margin-bottom: 8px; }
        .time-input-row input[type="time"] { padding: 7px 10px; border: 1px solid #ccc; border-radius: 3px; font-size: 13px; }
        .add-time-btn { background: #218a3a; color: #fff; border: none; padding: 7px 14px; border-radius: 3px; cursor: pointer; font-size: 13px; }
        .remove-time-btn { background: #c82333; color: #fff; border: none; padding: 5px 10px; border-radius: 3px; cursor: pointer; font-size: 12px; }
        .time-chip { display: inline-block; padding: 4px 10px; background: #c9152f; color: #fff; border-radius: 3px; margin: 3px; font-size: 12px; }
        .time-chip .remove { margin-left: 6px; cursor: pointer; font-weight: bold; }
        .conflict-warning { color: #c82333; font-size: 12px; margin-top: 4px; display: none; }
        .conflict-warning.show { display: block; }
        .tmdb-search-bar { display: flex; gap: 8px; margin-bottom: 12px; }
        .tmdb-search-bar input { flex: 1; padding: 8px 12px; border: 1px solid #3498db; border-radius: 3px; font-size: 14px; }
        .tmdb-search-bar button { padding: 8px 16px; background: #3498db; color: #fff; border: none; border-radius: 3px; font-size: 13px; font-weight: 600; cursor: pointer; }
        .tmdb-search-bar button:hover { background: #2980b9; }
        .tmdb-results { border: 1px solid #ddd; border-radius: 4px; background: #fff; max-height: 280px; overflow-y: auto; display: none; margin-bottom: 10px; }
        .tmdb-result-item { display: flex; align-items: center; gap: 10px; padding: 9px 12px; cursor: pointer; border-bottom: 1px solid #f0f0f0; }
        .tmdb-result-item:hover { background: #f5f9ff; }
        .tmdb-result-item img { width: 32px; height: 46px; object-fit: cover; border-radius: 2px; flex-shrink: 0; }
        .tmdb-result-title { font-weight: 700; font-size: 13px; color: #1a1a1a; }
        .tmdb-result-meta { font-size: 11px; color: #888; }
        .tmdb-badge { display: inline-block; background: #3498db; color: #fff; font-size: 10px; font-weight: 800; padding: 2px 6px; border-radius: 2px; margin-bottom: 5px; }
        .tmdb-autofill-note { font-size: 12px; color: #3498db; font-weight: 600; margin-bottom: 8px; display: none; }
        .admin-wrap { max-width: 1160px; margin: 0 auto; padding: 24px 20px 40px; }
        .page-header { margin-bottom: 18px; }
        .page-header h1 { font-size: 20px; font-weight: 700; color: #111; margin-bottom: 2px; }
        .page-header p { font-size: 13px; color: #666; }
        .action-buttons { margin-bottom: 12px; }
        @media (max-width: 900px) { .stats-row { grid-template-columns: 1fr 1fr; } }
    </style>
</head>
<body>
    <c:if test="${empty user || user.role != 'admin'}">
        <c:redirect url="login"/>
    </c:if>
    
    <jsp:include page="adminHeader.jsp" />

    <div class="admin-wrap">
        <div class="page-header">
            <h1>Movies</h1>
            <p>Manage the cinema's movie catalog and showtimes.</p>
        </div>

            <div class="stats-row">
                <div class="stat-box red">
                    <div class="label">Total movies</div>
                    <div class="value">${totalMovies}</div>
                    <div class="sub">in catalog</div>
                </div>
                <div class="stat-box green">
                    <div class="label">Now showing</div>
                    <div class="value">${nowShowing}</div>
                    <div class="sub">currently in theaters</div>
                </div>
                <div class="stat-box blue">
                    <div class="label">Upcoming</div>
                    <div class="value">${upcoming}</div>
                    <div class="sub">coming soon</div>
                </div>
                <div class="stat-box amber">
                    <div class="label">Showtimes</div>
                    <div class="value">${totalShowTimes}</div>
                    <div class="sub">active schedules</div>
                </div>
            </div>
            
            <c:if test="${not empty param.success}">
                <p class="success-message">${param.success}</p>
            </c:if>
            
            <c:if test="${not empty param.error}">
                <p class="error-message">${param.error}</p>
            </c:if>
            
            <div class="action-buttons">
                <button onclick="showAddForm()" class="btn-primary">Add New Movie</button>
            </div>
            
            <!-- Filter Bar -->
            <div class="filter-bar">
                <!-- Search Section -->
                <div class="search-section">
                    <form action="${pageContext.request.contextPath}/manageMovies" method="get" class="search-form">
                        <input type="text" name="search" id="searchInput" placeholder="Search by title, genre, or director..." value="${param.search}">
                        <button type="submit" class="btn-filter">Search</button>
                    </form>
                </div>
                
                <div class="divider"></div>
                
                <!-- Filter Section -->
                <form action="${pageContext.request.contextPath}/manageMovies" method="get" class="filters-section">
                    <div class="filter-group">
                        <label>Status</label>
                        <select name="status">
                            <option value="" ${empty param.status ? 'selected' : ''}>All Movies</option>
                            <option value="showing" ${param.status == 'showing' ? 'selected' : ''}>Now Showing</option>
                            <option value="upcoming" ${param.status == 'upcoming' ? 'selected' : ''}>Upcoming</option>
                            <option value="ended" ${param.status == 'ended' ? 'selected' : ''}>Ended</option>
                            <option value="hidden" ${param.status == 'hidden' ? 'selected' : ''}>Hidden (Soft Deleted)</option>
                        </select>
                    </div>
                    
                    <div class="filter-group">
                        <label>Genre</label>
                        <select name="genre">
                            <option value="all" ${param.genre == 'all' || empty param.genre ? 'selected' : ''}>All Genres</option>
                            <c:forEach var="g" items="${genres}">
                                <option value="${g}" ${param.genre == g ? 'selected' : ''}>${g}</option>
                            </c:forEach>
                        </select>
                    </div>
                    
                    <div class="filter-group">
                        <label>Language</label>
                        <select name="language">
                            <option value="all" ${param.language == 'all' || empty param.language ? 'selected' : ''}>All Languages</option>
                            <c:forEach var="lang" items="${languages}">
                                <option value="${lang}" ${param.language == lang ? 'selected' : ''}>${lang}</option>
                            </c:forEach>
                        </select>
                    </div>
                    
                    <div class="filter-actions">
                        <button type="submit" class="btn-filter">Apply Filters</button>
                        <c:if test="${not empty param.search || not empty param.status || not empty param.genre || not empty param.language}">
                            <a href="${pageContext.request.contextPath}/manageMovies" class="btn-clear">Clear All</a>
                        </c:if>
                    </div>
                </form>
            </div>
            
            <div id="addMovieForm" style="display:none;" class="form-container">
                <h2>Add New Movie</h2>
                <form action="${pageContext.request.contextPath}/manageMovies" method="post" enctype="multipart/form-data" onsubmit="return validateMovieDates(this)">
                    <input type="hidden" name="action" value="add">
                    <input type="hidden" id="tmdbPosterUrl" name="tmdbPosterUrl" value="">

                    <!-- TMDB AUTO-FILL SECTION -->
                    <div style="background:#e8f0fe;border:2px solid #0d6efd;border-radius:8px;padding:16px;margin-bottom:20px;">
                        <span class="tmdb-badge">TMDB Auto-Fill</span>
                        <p style="font-size:13px;color:#333;margin:0 0 10px;">Search a movie title to auto-fill all fields from The Movie Database.</p>
                        <div class="tmdb-search-bar">
                            <input type="text" id="tmdbQuery" placeholder="e.g. Inception, Avatar, Interstellar..." onkeydown="if(event.key==='Enter'){event.preventDefault();tmdbSearch();}">
                            <button type="button" onclick="tmdbSearch()">Search TMDB</button>
                        </div>
                        <div id="tmdbResults" class="tmdb-results"></div>
                        <div id="tmdbNote" class="tmdb-autofill-note">Fields auto-filled from TMDB! Review and adjust if needed, then upload a poster (or use the TMDB one linked above).</div>
                    </div>

                    <div class="form-group">
                        <label>Title:</label>
                        <input type="text" id="addTitle" name="title" required>
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
                        <input type="text" id="addDirector" name="director" required>
                    </div>
                    <div class="form-group">
                        <label>Duration (minutes):</label>
                        <input type="number" id="duration" name="duration" required>
                    </div>
                    <div class="form-group">
                        <label>Language:</label>
                        <input type="text" id="addLanguage" name="language" required>
                    </div>
                    <div class="form-group">
                        <label>Movie Format:</label>
                        <select name="format" required>
                            <option value="2D">2D</option>
                            <option value="3D">3D</option>
                            <option value="IMAX">IMAX</option>
                            <option value="4DX">4DX</option>
                            <option value="IMAX 3D">IMAX 3D</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label>Age Rating:</label>
                        <select name="ageRating" required>
                            <option value="G">G — General Audiences</option>
                            <option value="PG">PG — Parental Guidance</option>
                            <option value="PG-13">PG-13 — Parents Strongly Cautioned</option>
                            <option value="R">R — Restricted (18+)</option>
                            <option value="NC-17">NC-17 — Adults Only</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label>Release Date:</label>
                        <input type="date" id="addReleaseDate" name="releaseDate" required>
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
                        <label>YouTube Trailer URL (Optional):</label>
                        <input type="url" id="addTrailerUrl" name="trailerUrl" placeholder="https://www.youtube.com/embed/...">
                        <div id="youtubeSearchFallback" style="display:none; margin-top:5px;"></div>
                    </div>
                    <div class="form-group">
                        <label>Cast (Optional):</label>
                        <input type="text" id="addCastList" name="castList" placeholder="Comma-separated list of actors">
                    </div>
                    <div class="form-group">
                        <label>Description:</label>
                        <textarea id="addDescription" name="description" required></textarea>
                    </div>
                    <div class="form-group">
                        <label>Poster Image: <span id="posterOptionalLabel" style="display:none;color:#0d6efd;font-size:12px;">(Optional — TMDB poster will be used)</span></label>
                        <input type="file" id="addPosterInput" name="posterImage" accept="image/*">
                        <small>Upload JPG, PNG, or GIF — or use TMDB auto-fill above to get the poster automatically</small>
                        <div id="tmdbPosterPreview" style="margin-top:8px;"></div>
                    </div>
                    <div class="form-group" style="background:#f9fbfd; padding:15px; border-radius:8px; border:1px solid #e0e0e0; margin-bottom:15px;">
                        <label style="color:#dc143c; display:block; margin-bottom:5px;">Advanced Pricing Overrides (Optional):</label>
                        <p style="font-size:12px; color:#666; margin-bottom:10px;">Leave blank to use the global default ticket prices.</p>
                        <div style="display:grid; grid-template-columns: 1fr 1fr 1fr 1fr; gap:10px;">
                            <div><label style="font-size:11px; margin-bottom:4px; display:block;">Standard (Rs.)</label><input type="number" step="0.5" min="1" id="addPriceStandard" name="priceStandard" placeholder="Default"></div>
                            <div><label style="font-size:11px; margin-bottom:4px; display:block;">Premium (Rs.)</label><input type="number" step="0.5" min="1" id="addPricePremium" name="pricePremium" placeholder="Default"></div>
                            <div><label style="font-size:11px; margin-bottom:4px; display:block;">Recliner (Rs.)</label><input type="number" step="0.5" min="1" id="addPriceRecliner" name="priceRecliner" placeholder="Default"></div>
                            <div><label style="font-size:11px; margin-bottom:4px; display:block;">VIP (Rs.)</label><input type="number" step="0.5" min="1" id="addPriceVip" name="priceVip" placeholder="Default"></div>
                        </div>
                    </div>
                    <div class="form-group">
                        <label>Show Schedule:</label>
                        <div class="schedule-container">
                            <p style="font-size: 14px; color: #6c757d; margin-bottom: 15px;">Select dates between Start Date and End Date, then choose halls and add show times</p>
                            <div class="date-tabs" id="dateTabs"></div>
                            <div id="hallSelection" style="display: none; margin-top: 20px;">
                                <label style="font-weight: 500; margin-bottom: 10px; display: block;">Select Halls:</label>
                                <div style="display: flex; gap: 10px; flex-wrap: wrap; margin-bottom: 20px;">
                                    <c:forEach var="hall" items="${availableHalls}">
                                        <div class="date-tab" data-hall="${hall}" onclick="toggleHall(this, '${hall}')">${hall}</div>
                                    </c:forEach>
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
                <form action="${pageContext.request.contextPath}/manageMovies" method="post" enctype="multipart/form-data" onsubmit="return validateMovieDates(this)">
                    <input type="hidden" name="action" value="update">
                    <input type="hidden" name="movieId" id="editMovieId">
                    <input type="hidden" id="tmdbPosterUrlEdit" name="tmdbPosterUrl" value="">

                    <!-- TMDB AUTO-FILL SECTION FOR EDIT -->
                    <div style="background:#f0f7ff;border:2px solid #3498db;border-radius:8px;padding:16px;margin-bottom:20px;">
                        <span class="tmdb-badge" style="background:#3498db;">TMDB Auto-Fill</span>
                        <p style="font-size:13px;color:#333;margin:0 0 10px;">Missing poster? Search here to auto-fill details and restore the image from TMDB.</p>
                        <div class="tmdb-search-bar">
                            <input type="text" id="tmdbQueryEdit" placeholder="Search title to restore details..." onkeydown="if(event.key==='Enter'){event.preventDefault();tmdbSearchEdit();}">
                            <button type="button" onclick="tmdbSearchEdit()" style="background:#3498db;">Search TMDB</button>
                        </div>
                        <div id="tmdbResultsEdit" class="tmdb-results"></div>
                        <div id="tmdbNoteEdit" class="tmdb-autofill-note">Fields auto-filled from TMDB! Click 'Update Movie' to save.</div>
                    </div>
                    
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
                        <div id="tmdbPosterPreviewEdit" style="margin-top:10px;"></div>
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
                        <label>Movie Format:</label>
                        <select name="format" id="editFormat" required>
                            <option value="2D">2D</option>
                            <option value="3D">3D</option>
                            <option value="IMAX">IMAX</option>
                            <option value="4DX">4DX</option>
                            <option value="IMAX 3D">IMAX 3D</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label>Age Rating:</label>
                        <select name="ageRating" id="editAgeRating" required>
                            <option value="G">G — General Audiences</option>
                            <option value="PG">PG — Parental Guidance</option>
                            <option value="PG-13">PG-13 — Parents Strongly Cautioned</option>
                            <option value="R">R — Restricted (18+)</option>
                            <option value="NC-17">NC-17 — Adults Only</option>
                        </select>
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
                        <label>YouTube Trailer URL (Optional):</label>
                        <input type="url" id="editTrailerUrl" name="trailerUrl" placeholder="https://www.youtube.com/embed/...">
                    </div>
                    <div class="form-group">
                        <label>Cast (Optional):</label>
                        <input type="text" id="editCastList" name="castList" placeholder="Comma-separated list of actors">
                    </div>
                    <div class="form-group">
                        <label>Description:</label>
                        <textarea name="description" id="editDescription" required></textarea>
                    </div>
                    
                    <div class="form-group" style="background:#f9fbfd; padding:15px; border-radius:8px; border:1px solid #e0e0e0; margin-bottom:15px;">
                        <label style="color:#dc143c; display:block; margin-bottom:5px;">Advanced Pricing Overrides (Optional):</label>
                        <p style="font-size:12px; color:#666; margin-bottom:10px;">Leave blank to use the global default ticket prices.</p>
                        <div style="display:grid; grid-template-columns: 1fr 1fr 1fr 1fr; gap:10px;">
                            <div><label style="font-size:11px; margin-bottom:4px; display:block;">Standard (Rs.)</label><input type="number" step="0.5" min="1" id="editPriceStandard" name="priceStandard" placeholder="Default"></div>
                            <div><label style="font-size:11px; margin-bottom:4px; display:block;">Premium (Rs.)</label><input type="number" step="0.5" min="1" id="editPricePremium" name="pricePremium" placeholder="Default"></div>
                            <div><label style="font-size:11px; margin-bottom:4px; display:block;">Recliner (Rs.)</label><input type="number" step="0.5" min="1" id="editPriceRecliner" name="priceRecliner" placeholder="Default"></div>
                            <div><label style="font-size:11px; margin-bottom:4px; display:block;">VIP (Rs.)</label><input type="number" step="0.5" min="1" id="editPriceVip" name="priceVip" placeholder="Default"></div>
                        </div>
                    </div>
                    
                    <div class="form-group">
                        <label>Edit Show Schedule:</label>
                        <div class="schedule-container">
                            <p style="font-size: 14px; color: #6c757d; margin-bottom: 15px;">Select dates to manage show times</p>
                            <div class="date-tabs" id="editDateTabs"></div>
                            <div id="editHallSelection" style="display: none; margin-top: 20px;">
                                <label style="font-weight: 500; margin-bottom: 10px; display: block;">Select Halls:</label>
                                <div style="display: flex; gap: 10px; flex-wrap: wrap; margin-bottom: 20px;">
                                    <c:forEach var="hall" items="${availableHalls}">
                                        <div class="date-tab" data-hall="${hall}" onclick="toggleEditHall(this, '${hall}')">${hall}</div>
                                    </c:forEach>
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
                
                // This function runs when the admin clicks "Add Movie" or "Update Movie".
                // It checks if the End Date is before the Start Date.
                function validateMovieDates(form) {
                    const start = new Date(form.startDate.value);
                    const end = new Date(form.endDate.value);
                    if (start > end) {
                        alert("ERROR: End Date cannot be before Start Date.");
                        return false; // This stops the form from being submitted!
                    }
                    return true; // Everything is okay
                }

                // ============================================================
                // TMDB AUTO-FILL FUNCTIONS
                // ============================================================
                const CONTEXT_PATH = '${pageContext.request.contextPath}';

                // This function searches for movies on The Movie Database (TMDB)
                function tmdbSearch() {
                    const query = document.getElementById('tmdbQuery').value.trim();
                    if (!query) { alert('Please enter a movie title to search.'); return; }

                    const resultsDiv = document.getElementById('tmdbResults');
                    resultsDiv.style.display = 'block';
                    resultsDiv.innerHTML = '<div style="padding:12px;color:#666;font-size:13px;">Searching TMDB...</div>';

                    // We call our internal servlet which talks to the TMDB API
                    fetch(CONTEXT_PATH + '/tmdbSearch?action=search&q=' + encodeURIComponent(query))
                        .then(res => res.json())
                        .then(data => {
                            if (!data || data.length === 0) {
                                resultsDiv.innerHTML = '<div style="padding:12px;color:#dc3545;font-size:13px;">No results found. Try a different title.</div>';
                                return;
                            }
                            resultsDiv.innerHTML = '';
                            data.slice(0, 8).forEach(movie => {
                                const item = document.createElement('div');
                                item.className = 'tmdb-result-item';
                                const year = movie.releaseDate ? movie.releaseDate.substring(0, 4) : '?';
                                const imgSrc = movie.posterUrl && movie.posterUrl !== '' 
                                    ? movie.posterUrl 
                                    : 'data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" width="36" height="52"><rect width="36" height="52" fill="%23e9ecef"/><text x="18" y="30" text-anchor="middle" font-size="10" fill="%23999">No Poster</text></svg>';
                                
                                // Show the search results with poster and title
                                item.innerHTML = '<img src="' + imgSrc + '" alt="poster">'
                                    + '<div><div class="tmdb-result-title">' + (movie.title || '') + '</div>'
                                    + '<div class="tmdb-result-meta">' + year + ' &bull; ' + (movie.language || '').toUpperCase() + '</div></div>';
                                
                                // When a user clicks a result, fill the form!
                                item.onclick = () => tmdbSelectMovie(movie.tmdbId, movie.title);
                                resultsDiv.appendChild(item);
                            });
                        })
                        .catch(err => {
                            resultsDiv.innerHTML = '<div style="padding:12px;color:#dc3545;font-size:13px;">Error contacting TMDB.</div>';
                        });
                }

                function tmdbSelectMovie(tmdbId, title) {
                    const resultsDiv = document.getElementById('tmdbResults');
                    resultsDiv.innerHTML = '<div style="padding:12px;color:#0d6efd;font-size:13px;">Loading full details for "' + title + '"...</div>';

                    fetch(CONTEXT_PATH + '/tmdbSearch?action=details&tmdbId=' + tmdbId)
                        .then(res => res.json())
                        .then(d => {
                            // Clear fields first so old data doesn't linger
                            ['addTitle', 'genreSelect', 'addDirector', 'duration', 'addLanguage', 'addDescription', 'addTrailerUrl', 'addCastList', 'addReleaseDate', 'tmdbPosterUrl'].forEach(id => {
                                const el = document.getElementById(id);
                                if (el) el.value = '';
                            });
                            document.getElementById('tmdbPosterPreview').innerHTML = '';
                            
                            // Auto-fill all form fields
                            setVal('addTitle',       d.title);
                            setVal('addDirector',    d.director);
                            setVal('duration',       d.duration);
                            setVal('addLanguage',    languageCodeToName(d.language));
                            setVal('addDescription', d.overview || d.description);
                            setVal('addTrailerUrl',  d.trailerUrl);
                            const trailerInput = document.getElementById('addTrailerUrl');
                            const youtubeSearchDiv = document.getElementById('youtubeSearchFallback');
                            
                            if (!d.trailerUrl || d.trailerUrl === '') {
                                if (trailerInput) {
                                    trailerInput.placeholder = "No official trailer found on TMDB. Click below to search YouTube.";
                                }
                                if (youtubeSearchDiv) {
                                    youtubeSearchDiv.style.display = 'block';
                                    youtubeSearchDiv.innerHTML = '<button type="button" onclick="searchYouTubeFallback(\'' + d.title.replace(/'/g, "\\'") + '\')" style="margin-top:5px;background:#ff0000;color:white;border:none;padding:6px 12px;border-radius:4px;font-size:12px;cursor:pointer;display:flex;align-items:center;gap:5px;"><span class="material-symbols-outlined" style="font-size:16px;">search</span> Find Trailer on YouTube</button>';
                                }
                            } else {
                                if (youtubeSearchDiv) youtubeSearchDiv.style.display = 'none';
                                if (trailerInput) trailerInput.placeholder = "https://www.youtube.com/embed/...";
                            }
                            setVal('addCastList',    d.cast);
                            if (d.releaseDate) setVal('addReleaseDate', d.releaseDate);

                            // Genre - try to match existing options
                            const genreSelect = document.getElementById('genreSelect');
                            if (genreSelect && d.genre) {
                                let matched = false;
                                for (let opt of genreSelect.options) {
                                    if (opt.value.toLowerCase() === d.genre.toLowerCase()) {
                                        genreSelect.value = opt.value;
                                        matched = true; break;
                                    }
                                }
                                if (!matched) {
                                    genreSelect.value = 'custom';
                                    toggleCustomGenre();
                                    setVal('customGenre', d.genre);
                                }
                            }

                            // Handle TMDB poster
                            if (d.posterUrl && d.posterUrl !== '') {
                                document.getElementById('tmdbPosterUrl').value = d.posterUrl;
                                document.getElementById('tmdbPosterPreview').innerHTML =
                                    '<img src="' + d.posterUrl + '" alt="TMDB Poster" style="width:80px;border-radius:6px;border:2px solid #0d6efd;">'
                                    + '<p style="font-size:11px;color:#0d6efd;margin-top:4px;">TMDB poster selected. You can still upload a custom one to override it.</p>';
                                document.getElementById('posterOptionalLabel').style.display = 'inline';
                                // Make poster upload optional
                                document.getElementById('addPosterInput').removeAttribute('required');
                            }

                            resultsDiv.style.display = 'none';
                            document.getElementById('tmdbNote').style.display = 'block';
                        })
                        .catch(err => {
                            resultsDiv.innerHTML = '<div style="padding:12px;color:#dc3545;">Failed to load movie details.</div>';
                            console.error('TMDB details error:', err);
                        });
                }

                function setVal(id, val) {
                    const el = document.getElementById(id);
                    if (el && val !== undefined && val !== null && val !== '') {
                        el.value = val;
                    }
                }

                function languageCodeToName(code) {
                    const map = { en:'English', hi:'Hindi', ta:'Tamil', te:'Telugu', ml:'Malayalam',
                                  fr:'French', es:'Spanish', de:'German', ja:'Japanese', ko:'Korean',
                                  zh:'Chinese', it:'Italian', pt:'Portuguese', ru:'Russian' };
                    return map[code] || (code ? code.toUpperCase() : '');
                }

                function searchYouTubeFallback(title) {
                    const fallbackDiv = document.getElementById('youtubeSearchFallback');
                    fallbackDiv.innerHTML = '<p style="font-size:12px;color:#666;">Searching YouTube for "' + title + '" trailers...</p>';
                    
                    fetch(CONTEXT_PATH + '/tmdbSearch?action=youtube&title=' + encodeURIComponent(title))
                        .then(res => res.json())
                        .then(results => {
                            if (!results || results.length === 0) {
                                fallbackDiv.innerHTML = '<p style="font-size:12px;color:#dc3545;">No trailers found on YouTube either. Please add manually.</p>';
                                return;
                            }
                            
                            let html = '<p style="font-size:12px;font-weight:700;margin:10px 0 5px;color:#333;">Select a Trailer from YouTube:</p>';
                            html += '<div style="display:flex;flex-direction:column;gap:5px;background:#f8f9fa;padding:10px;border-radius:6px;border:1px solid #dee2e6;max-height:200px;overflow-y:auto;">';
                            results.forEach(video => {
                                html += '<div onclick="selectYouTubeTrailer(\'' + video.url + '\')" style="padding:8px;background:white;border:1px solid #ddd;border-radius:4px;cursor:pointer;font-size:11px;transition:all 0.15s;" onmouseover="this.style.borderColor=\'#ff0000\';this.style.background=\'#fff5f5\'" onmouseout="this.style.borderColor=\'#ddd\';this.style.background=\'white\'">';
                                html += '<div style="font-weight:700;color:#1a1a1a;margin-bottom:2px;">' + video.title + '</div>';
                                html += '<div style="color:#ff0000;font-size:10px;">Click to select this trailer</div>';
                                html += '</div>';
                            });
                            html += '</div>';
                            fallbackDiv.innerHTML = html;
                        })
                        .catch(err => {
                            console.error('YouTube search error:', err);
                            fallbackDiv.innerHTML = '<p style="font-size:12px;color:#dc3545;">Error searching YouTube.</p>';
                        });
                }

                function selectYouTubeTrailer(url) {
                    const trailerInput = document.getElementById('addTrailerUrl');
                    if (trailerInput) {
                        trailerInput.value = url;
                        document.getElementById('youtubeSearchFallback').style.display = 'none';
                    }
                }

                // ============================================================
                // TMDB EDIT FORM FUNCTIONS
                // ============================================================
                function tmdbSearchEdit() {
                    const query = document.getElementById('tmdbQueryEdit').value.trim();
                    if (!query) { alert('Please enter a movie title to search.'); return; }

                    const resultsDiv = document.getElementById('tmdbResultsEdit');
                    resultsDiv.style.display = 'block';
                    resultsDiv.innerHTML = '<div style="padding:12px;color:#666;font-size:13px;">Searching TMDB...</div>';

                    fetch(CONTEXT_PATH + '/tmdbSearch?action=search&q=' + encodeURIComponent(query))
                        .then(res => res.json())
                        .then(data => {
                            if (!data || data.length === 0) {
                                resultsDiv.innerHTML = '<div style="padding:12px;color:#dc3545;font-size:13px;">No results found.</div>';
                                return;
                            }
                            resultsDiv.innerHTML = '';
                            data.slice(0, 8).forEach(movie => {
                                const item = document.createElement('div');
                                item.className = 'tmdb-result-item';
                                const year = movie.releaseDate ? movie.releaseDate.substring(0, 4) : '?';
                                const imgSrc = movie.posterUrl || 'data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" width="36" height="52"><rect width="36" height="52" fill="%23e9ecef"/><text x="18" y="30" text-anchor="middle" font-size="10" fill="%23999">No Poster</text></svg>';
                                item.innerHTML = '<img src="' + imgSrc + '"><div><div class="tmdb-result-title">' + movie.title + '</div><div class="tmdb-result-meta">' + year + '</div></div>';
                                item.onclick = () => tmdbSelectMovieEdit(movie.tmdbId, movie.title);
                                resultsDiv.appendChild(item);
                            });
                        });
                }

                function tmdbSelectMovieEdit(tmdbId, title) {
                    const resultsDiv = document.getElementById('tmdbResultsEdit');
                    resultsDiv.innerHTML = '<div style="padding:12px;color:#3498db;">Loading details...</div>';

                    fetch(CONTEXT_PATH + '/tmdbSearch?action=details&tmdbId=' + tmdbId)
                        .then(res => res.json())
                        .then(d => {
                            setVal('editTitle', d.title);
                            setVal('editDirector', d.director);
                            setVal('editDuration', d.duration);
                            setVal('editLanguage', languageCodeToName(d.language));
                            setVal('editDescription', d.overview || d.description);
                            setVal('editTrailerUrl', d.trailerUrl);
                            setVal('editCastList', d.cast);
                            if (d.releaseDate) setVal('editReleaseDate', d.releaseDate);
                            
                            // Genre matching
                            const editGenre = document.getElementById('editGenre');
                            if (editGenre && d.genre) editGenre.value = d.genre;

                            if (d.posterUrl) {
                                document.getElementById('tmdbPosterUrlEdit').value = d.posterUrl;
                                document.getElementById('tmdbPosterPreviewEdit').innerHTML =
                                    '<img src="' + d.posterUrl + '" style="width:100px;border-radius:6px;border:2px solid #3498db;margin-top:10px;">'
                                    + '<p style="font-size:11px;color:#3498db;margin-top:4px;">TMDB poster selected.</p>';
                            }

                            resultsDiv.style.display = 'none';
                            document.getElementById('tmdbNoteEdit').style.display = 'block';
                        });
                }
                // ============================================================
                // END TMDB FUNCTIONS
                // ============================================================


                // Store all show times from database
                const allShowTimesData = [
                    <c:if test="${not empty allShowTimes}">
                    <c:forEach var="st" items="${allShowTimes}" varStatus="status">
                        {movieId: ${st.movieId}, date: '${st.showDate}', time: '${st.showTime}', hall: '${st.hall}'}<c:if test="${!status.last}">,</c:if>
                    </c:forEach>
                    </c:if>
                ];
                console.log('[DEBUG] allShowTimesData:', JSON.stringify(allShowTimesData));
                
                // Store movie-specific show times if editing
                const movieShowTimesData = [
                    <c:if test="${not empty movieShowTimes}">
                    <c:forEach var="st" items="${movieShowTimes}" varStatus="status">
                        {movieId: ${st.movieId}, date: '${st.showDate}', time: '${st.showTime}', hall: '${st.hall}'}<c:if test="${!status.last}">,</c:if>
                    </c:forEach>
                    </c:if>
                ];
                console.log('movieShowTimesData:', movieShowTimesData);
                
                // Store durations of all movies to calculate end times
                const movieDurations = {
                    <c:if test="${not empty movies}">
                    <c:forEach var="m" items="${movies}" varStatus="status">
                        ${m.movieId}: ${m.duration}<c:if test="${!status.last}">,</c:if>
                    </c:forEach>
                    </c:if>
                };

                // Store titles of all movies for detailed error messages
                const movieTitles = {};
                <c:if test="${not empty movies}">
                <c:forEach var="m" items="${movies}">
                movieTitles[${m.movieId}] = '<c:out value="${m.title}" escapeXml="false"/>'.replace(/'/g, "\\'");
                </c:forEach>
                </c:if>
                
                // This clever function checks if a new showtime overlaps with any existing ones in the same hall.
                function checkTimeConflict(dateStr, hallId, newTime, newDuration, currentMovieId, scheduleObj) {
                    if (!newTime || !newDuration) return { valid: true };

                    const buffer = 30; // We add a 30-minute buffer for cleaning/breaks
                    const totalMinutes = parseInt(newDuration) + buffer;
                    const newStartMinutes = timeToMinutes(newTime);
                    const newEndMinutes = newStartMinutes + totalMinutes;

                    // 1. Check against ALL other movies already in the database
                    if (typeof allShowTimesData !== 'undefined') {
                        let formattedDate = dateStr;
                        // Format the date key if needed
                        if (dateStr.startsWith('date_')) {
                            const raw = dateStr.replace('date_', '');
                            formattedDate = raw.slice(0,4) + '-' + raw.slice(4,6) + '-' + raw.slice(6,8);
                        }

                        for (let st of allShowTimesData) {
                            // Check if date and hall match, but ignore the movie we are currently editing
                            if (st.date === formattedDate && st.hall === hallId && st.movieId != currentMovieId) {
                                const existingStartMinutes = timeToMinutes(st.time);
                                const otherDuration = parseInt(movieDurations[st.movieId]) || 120;
                                const existingEndMinutes = existingStartMinutes + otherDuration + buffer;

                                if (newStartMinutes < existingEndMinutes && newEndMinutes > existingStartMinutes) {
                                    const movieTitle = movieTitles[st.movieId] || 'another movie';
                                    const conflictHall = st.hall || hallId;
                                    const formattedTime = formatTime(st.time.substring(0, 5));
                                    const conflictDate = st.date;
                                    return { valid: false, message: "Conflict! \"" + movieTitle + "\" is already scheduled in " + conflictHall + " on " + conflictDate + " at " + formattedTime + " (including movie duration + 30 min buffer)." };
                                }
                            }
                        }
                    }

                    // 2. Check against times currently queued in the UI for this form
                    if (scheduleObj && scheduleObj[dateStr] && scheduleObj[dateStr].halls[hallId]) {
                        const existingTimes = scheduleObj[dateStr].halls[hallId];
                        for (let time of existingTimes) {
                            const existingStartMinutes = timeToMinutes(time);
                            const existingEndMinutes = existingStartMinutes + totalMinutes;

                            if (newStartMinutes < existingEndMinutes && newEndMinutes > existingStartMinutes) {
                                const formattedHall = hallId.replace('audi', 'Audi ');
                                const formattedTime = formatTime(time);
                                return { valid: false, message: "Conflict with another time you added (" + formattedTime + ") in " + formattedHall + "." };
                            }
                        }
                    }

                    return { valid: true };
                }
                
                // Store all show schedule data (dates, halls, times)
                let schedule = {};
                // Store which halls are selected for current date
                let selectedHalls = [];
                // Store currently selected date
                let currentDate = null;
                
                // Show the add movie form
                function showAddForm() { 
                    const addForm = document.getElementById('addMovieForm');
                    const editForm = document.getElementById('editMovieForm');
                    
                    if (addForm.style.display === 'block') {
                        hideAddForm();
                    } else {
                        hideEditForm(); // Ensure edit form is closed
                        addForm.style.display = 'block';
                        window.scrollTo({ top: 0, behavior: 'smooth' });
                    }
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
                    showEditForm(${editMovie.movieId}, `${editMovie.title}`, `${editMovie.genre}`, `${editMovie.director}`, ${editMovie.duration}, `${editMovie.language}`, `${editMovie.description}`, `${editMovie.posterImage}`, `${editMovie.startDate}`, `${editMovie.endDate}`, `${editMovie.releaseDate}`, `${editMovie.format}`, `${editMovie.ageRating}`, `${editMovie.trailerUrl}`, `${editMovie.castList}`, ${empty editMovie.priceStandard ? 'null' : editMovie.priceStandard}, ${empty editMovie.pricePremium ? 'null' : editMovie.pricePremium}, ${empty editMovie.priceRecliner ? 'null' : editMovie.priceRecliner}, ${empty editMovie.priceVip ? 'null' : editMovie.priceVip});
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
                        document.getElementById('dateTabs').innerHTML = '';
                        document.getElementById('timeInputSections').innerHTML = '';
                        document.getElementById('hallSelection').style.display = 'none';
                        schedule = {};
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
                    
                    // RESTORE PREVIOUSLY ADDED HALLS FOR THIS DATE
                    if (schedule[currentDate] && schedule[currentDate].halls) {
                        Object.keys(schedule[currentDate].halls).forEach(h => {
                            if (schedule[currentDate].halls[h].length > 0) {
                                const hallTab = document.querySelector('#hallSelection .date-tab[data-hall="' + h + '"]');
                                if (hallTab) {
                                    hallTab.classList.add('active');
                                    selectedHalls.push(h);
                                    addHallSection(h);
                                }
                            }
                        });
                    }
                    
                    // Update highlights for date and hall tabs
                    refreshHighlights();
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
                    
                    // --- NEW VALIDATION: Check if date has already passed ---
                    const parts = sectionId.split('_');
                    const dateStr = parts[1].slice(0,4) + '-' + parts[1].slice(4,6) + '-' + parts[1].slice(6,8);
                    const showDateObj = new Date(dateStr);
                    showDateObj.setHours(23, 59, 59, 999); // End of the show day
                    const now = new Date();
                    const isPastDate = showDateObj < now;

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
                    
                    if (isPastDate) {
                        timeInput.disabled = true;
                        addBtn.disabled = true;
                        addBtn.style.background = '#ccc';
                        addBtn.title = "Cannot add shows to past dates";
                        
                        const pastMessage = document.createElement('div');
                        pastMessage.style.color = '#856404';
                        pastMessage.style.backgroundColor = '#fff3cd';
                        pastMessage.style.border = '1px solid #ffeeba';
                        pastMessage.style.padding = '8px 12px';
                        pastMessage.style.borderRadius = '4px';
                        pastMessage.style.fontSize = '12px';
                        pastMessage.style.marginTop = '5px';
                        pastMessage.style.marginBottom = '10px';
                        pastMessage.innerHTML = '<strong>Note:</strong> This date has already passed. Show times cannot be added or modified.';
                        section.appendChild(pastMessage);
                    }

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
                    
                    // Render existing times if any
                    renderTimes(sectionId, hallId);
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
                    const duration = parseInt(document.getElementById('duration').value) || 0;
                    const timeInput = document.getElementById('timeInput_' + sectionId);
                    const newTime = timeInput.value;
                    const warning = document.getElementById('warning_' + sectionId);
                    
                    if (!newTime || !duration) {
                        warning.classList.remove('show');
                        return true;
                    }
                    
                    const parts = sectionId.split('_');
                    const dateKey = parts[0] + '_' + parts[1];
                    const hallId = parts[2];
                    
                    const checkResult = checkTimeConflict(dateKey, hallId, newTime, duration, 0, schedule);
                    if (!checkResult.valid) {
                        warning.textContent = checkResult.message;
                        warning.classList.add('show');
                        return false;
                    }
                    
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

                    // --- NEW VALIDATION: Prevent adding past times for today ---
                    const partsArr = sectionId.split('_');
                    let validatedDateStr = "";
                    if (partsArr.length > 2) {
                        // case: date_20240516
                        validatedDateStr = partsArr[1].slice(0,4) + '-' + partsArr[1].slice(4,6) + '-' + partsArr[1].slice(6,8);
                    } else {
                        // fallback
                        validatedDateStr = partsArr[0].slice(4,8) + '-' + partsArr[0].slice(8,10) + '-' + partsArr[0].slice(10,12);
                    }
                    
                    const now = new Date();
                    const selectedDateTime = new Date(validatedDateStr + 'T' + time);
                    if (selectedDateTime < now) {
                        alert('Error: Cannot add a show time that has already passed.');
                        return;
                    }
                    
                    // Check for conflicts
                    const parts = sectionId.split('_');
                    const dateKey = parts[0] + '_' + parts[1];
                    
                    const duration = parseInt(document.getElementById('duration').value) || 0;
                    const checkResult = checkTimeConflict(dateKey, hallId, time, duration, 0, schedule);
                    
                    if (!checkResult.valid) {
                        alert(checkResult.message);
                        return;
                    }
                    
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
                    // Update highlights
                    refreshHighlights();
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
                    // Update highlights
                    refreshHighlights();
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
                    const now = new Date();
                    const dateParts = sectionId.split('_');
                    const dateStr = dateParts[1].slice(0,4) + '-' + dateParts[1].slice(4,6) + '-' + dateParts[1].slice(6,8);

                    times.forEach(time => {
                        // Check if this specific show time has already passed
                        const showDateTime = new Date(dateStr + 'T' + time);
                        const isPast = showDateTime < now;

                        // Convert 24-hour time to 12-hour format
                        const [hours, minutes] = time.split(':');
                        const h = parseInt(hours);
                        const ampm = h >= 12 ? 'PM' : 'AM';
                        const displayHour = h % 12 || 12;
                        const formattedTime = displayHour + ':' + minutes + ' ' + ampm;
                        
                        // Create time chip with remove button (only if not passed)
                        html += '<span class="time-chip" style="' + (isPast ? 'background:#6c757d; cursor:not-allowed;' : '') + '" title="' + (isPast ? 'Past show - cannot remove' : '') + '">' + 
                                formattedTime + 
                                (!isPast ? '<span class="remove" onclick="removeTime(\'' + sectionId + '\', \'' + hallId + '\', \'' + time + '\')">×</span>' : '') + 
                                '</span>';
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
                
                function refreshHighlights() {
                    // 1. Date Tabs
                    document.querySelectorAll('#dateTabs .date-tab').forEach(tab => {
                        const dateKey = tab.getAttribute('data-date');
                        let hasData = false;
                        if (schedule[dateKey] && schedule[dateKey].halls) {
                            for (let h in schedule[dateKey].halls) {
                                if (schedule[dateKey].halls[h].length > 0) { hasData = true; break; }
                            }
                        }
                        if (hasData) tab.classList.add('has-data');
                        else tab.classList.remove('has-data');
                    });
                    
                    // 2. Hall Tabs
                    if (currentDate) {
                        document.querySelectorAll('#hallSelection .date-tab').forEach(tab => {
                            const hallId = tab.getAttribute('data-hall');
                            let hasData = false;
                            if (schedule[currentDate] && schedule[currentDate].halls[hallId] && schedule[currentDate].halls[hallId].length > 0) {
                                hasData = true;
                            }
                            if (hasData) tab.classList.add('has-data');
                            else tab.classList.remove('has-data');
                        });
                    }
                }
                
                // Show edit movie form with movie data
                let editSchedule = {};
                let selectedEditHalls = [];
                let currentEditDate = null;

                function showEditForm(movieId, title, genre, director, duration, language, description, posterImage, startDate, endDate, releaseDate, format, ageRating, trailerUrl, castList, pStd, pPrem, pRec, pVip) {
                    console.log('Opening edit form for movie ID:', movieId);
                    
                    hideAddForm(); // Ensure add form is closed
                    document.getElementById('editMovieForm').style.display = 'none'; // Reset view if another edit was open
                    
                    // Clear TMDB search in edit form
                    document.getElementById('tmdbQueryEdit').value = '';
                    document.getElementById('tmdbResultsEdit').innerHTML = '';
                    document.getElementById('tmdbResultsEdit').style.display = 'none';
                    document.getElementById('tmdbNoteEdit').style.display = 'none';
                    document.getElementById('tmdbPosterUrlEdit').value = '';
                    document.getElementById('tmdbPosterPreviewEdit').innerHTML = '';
                    
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
                    if (trailerUrl && trailerUrl !== 'null') document.getElementById('editTrailerUrl').value = trailerUrl;
                    if (castList && castList !== 'null') document.getElementById('editCastList').value = castList;
                    
                    document.getElementById('editPriceStandard').value = (pStd && pStd !== null) ? pStd : '';
                    document.getElementById('editPricePremium').value = (pPrem && pPrem !== null) ? pPrem : '';
                    document.getElementById('editPriceRecliner').value = (pRec && pRec !== null) ? pRec : '';
                    document.getElementById('editPriceVip').value = (pVip && pVip !== null) ? pVip : '';
                    
                    // Populate format and age rating dropdowns
                    var fmtSel = document.getElementById('editFormat');
                    if (fmtSel && format) { fmtSel.value = format; }
                    var ageSel = document.getElementById('editAgeRating');
                    if (ageSel && ageRating) { ageSel.value = ageRating; }
                    
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
                    window.scrollTo({ top: 0, behavior: 'smooth' });
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
                                const hallTab = document.querySelector('#editHallSelection .date-tab[data-hall="' + h + '"]');
                                if (hallTab) {
                                    toggleEditHall(hallTab, h);
                                }
                            }
                        });
                    }
                    
                    // Update highlights for date and hall tabs
                    refreshEditHighlights();
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
                    const now = new Date();
                    const dateParts = sectionId.split('_');
                    // sectionId looks like "date_20240509_edit_Audi 03"
                    // dateParts[1] is "20240509"
                    const dateStr = dateParts[1].slice(0,4) + '-' + dateParts[1].slice(4,6) + '-' + dateParts[1].slice(6,8);

                    times.forEach(t => {
                        const timeStr = t.length > 5 ? t.substring(0, 5) : t;
                        
                        // Check if this specific show time has already passed
                        // Combine date and time (YYYY-MM-DDTHH:MM)
                        const showDateTime = new Date(dateStr + 'T' + timeStr);
                        const isPast = showDateTime < now;

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
                        
                        // Create time chip with remove button (only if not passed)
                        html += '<span class="time-chip" style="' + (isPast ? 'background:#6c757d; cursor:not-allowed;' : '') + '" title="' + (isPast ? 'Past show - cannot remove' : '') + '">' + 
                                formattedTime + 
                                (!isPast ? '<span class="remove" onclick="removeEditTime(\'' + sectionId + '\', \'' + hallId + '\', \'' + timeStr + '\')">×</span>' : '') + 
                                '</span>';
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
                    
                    // --- NEW VALIDATION: Check if date has already passed ---
                    const partsArr = sectionId.split('_');
                    // sectionId for edit is date_20240509_edit_Audi 03
                    const dateStr = partsArr[1].slice(0,4) + '-' + partsArr[1].slice(4,6) + '-' + partsArr[1].slice(6,8);
                    const showDateObj = new Date(dateStr);
                    showDateObj.setHours(23, 59, 59, 999);
                    const now = new Date();
                    const isPastDate = showDateObj < now;

                    const timeInput = document.createElement('input');
                    timeInput.type = 'time';
                    timeInput.id = 'timeInput_' + sectionId;
                    
                    const addBtn = document.createElement('button');
                    addBtn.type = 'button';
                    addBtn.className = 'add-time-btn';
                    addBtn.textContent = 'Add Time';
                    addBtn.onclick = function() { addEditTime(sectionId, hallId); };
                    
                    if (isPastDate) {
                        timeInput.disabled = true;
                        addBtn.disabled = true;
                        addBtn.style.background = '#ccc';
                        addBtn.title = "Cannot add shows to past dates";
                        
                        const pastMessage = document.createElement('div');
                        pastMessage.style.color = '#856404';
                        pastMessage.style.backgroundColor = '#fff3cd';
                        pastMessage.style.border = '1px solid #ffeeba';
                        pastMessage.style.padding = '8px 12px';
                        pastMessage.style.borderRadius = '4px';
                        pastMessage.style.fontSize = '12px';
                        pastMessage.style.marginTop = '5px';
                        pastMessage.style.marginBottom = '10px';
                        pastMessage.innerHTML = '<strong>Note:</strong> This date has already passed. Show times cannot be added or modified.';
                        section.appendChild(pastMessage);
                    }

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
                    
                    const duration = parseInt(document.getElementById('editDuration').value) || 0;
                    const currentMovieId = document.getElementById('editMovieId').value;
                    
                    const checkResult = checkTimeConflict(currentEditDate, hallId, time, duration, currentMovieId, editSchedule);
                    if (!checkResult.valid) {
                        alert(checkResult.message);
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
                    refreshEditHighlights();
                }

                // Remove edit time
                function removeEditTime(sectionId, hallId, timeHhMm) {
                    if (editSchedule[currentEditDate] && editSchedule[currentEditDate].halls[hallId]) {
                        editSchedule[currentEditDate].halls[hallId] = editSchedule[currentEditDate].halls[hallId].filter(t => t !== timeHhMm);
                    }
                    renderEditTimes(sectionId, hallId);
                    updateEditScheduleData();
                    refreshEditHighlights();
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
                
                function refreshEditHighlights() {
                    // 1. Date Tabs
                    document.querySelectorAll('#editDateTabs .date-tab').forEach(tab => {
                        const dateKey = tab.getAttribute('data-date');
                        let hasData = false;
                        if (editSchedule[dateKey] && editSchedule[dateKey].halls) {
                            for (let h in editSchedule[dateKey].halls) {
                                if (editSchedule[dateKey].halls[h].length > 0) { hasData = true; break; }
                            }
                        }
                        if (hasData) tab.classList.add('has-data');
                        else tab.classList.remove('has-data');
                    });
                    
                    // 2. Hall Tabs
                    if (currentEditDate) {
                        document.querySelectorAll('#editHallSelection .date-tab').forEach(tab => {
                            const hallId = tab.getAttribute('data-hall');
                            let hasData = false;
                            if (editSchedule[currentEditDate] && editSchedule[currentEditDate].halls[hallId] && editSchedule[currentEditDate].halls[hallId].length > 0) {
                                hasData = true;
                            }
                            if (hasData) tab.classList.add('has-data');
                            else tab.classList.remove('has-data');
                        });
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
                            document.getElementById('editDateTabs').innerHTML = '';
                            document.getElementById('editTimeInputSections').innerHTML = '';
                            document.getElementById('editHallSelection').style.display = 'none';
                            editSchedule = {};
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
                <table class="data-table" data-paginate="true" data-rows-per-page="8">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Name</th>
                            <th>Director</th>
                            <th>Status</th>
                            <th>Genre</th>
                            <th>Format</th>
                            <th>Rating</th>
                            <th>Language</th>
                            <th>Duration</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${not empty movies}">
                                <c:forEach var="movie" items="${movies}">
                                    <tr style="${!movie.active ? 'opacity: 0.7; background-color: #f8f9fa;' : ''}">
                                        <td>${movie.movieId}</td>
                                        <td>
                                            <div style="font-weight: 700; color: ${!movie.active ? '#6c757d' : '#2c3e50'};">${movie.title}</div>
                                        </td>
                                        <td>${movie.director}</td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${movie.active}">
                                                    <span style="background:#d1e7dd;color:#0f5132;padding:2px 8px;border-radius:12px;font-size:10px;font-weight:700;text-transform:uppercase;">Active</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span style="background:#f8d7da;color:#842029;padding:2px 8px;border-radius:12px;font-size:10px;font-weight:700;text-transform:uppercase;">Hidden</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>${movie.genre}</td>
                                        <td>
                                            <span style="background:#e8f4f8;color:#2980b9;padding:2px 8px;border-radius:12px;font-size:11px;font-weight:700;">${not empty movie.format ? movie.format : '2D'}</span>
                                        </td>
                                        <td>
                                            <span style="background:#fdf2f8;color:#8e44ad;padding:2px 8px;border-radius:12px;font-size:11px;font-weight:700;">${not empty movie.ageRating ? movie.ageRating : 'PG'}</span>
                                        </td>
                                        <td>${movie.language}</td>
                                        <td>${movie.duration} mins</td>
                                        <td>
                                            <div style="display: flex; gap: 8px; justify-content: flex-end;">
                                                <a href="${pageContext.request.contextPath}/manageMovies?action=edit&id=${movie.movieId}" style="padding: 6px 10px; background: white; color: #ffc107; border: 1px solid rgba(255, 193, 7, 0.3); border-radius: 4px; text-decoration: none; display: inline-flex; align-items: center; justify-content: center; transition: all 0.2s; min-width: 36px;" onmouseover="this.style.backgroundColor='#ffc107'; this.style.color='#212529';" onmouseout="this.style.backgroundColor='white'; this.style.color='#ffc107';" title="Edit Movie">
                                                    <span class="material-symbols-outlined" style="font-size: 18px;">edit</span>
                                                </a>
                                                <c:choose>
                                                    <c:when test="${movie.active}">
                                                        <a href="${pageContext.request.contextPath}/manageMovies?action=delete&id=${movie.movieId}" onclick="return confirm('Hide movie? History will be preserved.')" style="padding: 6px 10px; background: white; color: #dc3545; border: 1px solid rgba(220, 53, 69, 0.2); border-radius: 4px; text-decoration: none; display: inline-flex; align-items: center; justify-content: center; transition: all 0.2s; min-width: 36px;" onmouseover="this.style.backgroundColor='#dc3545'; this.style.color='white';" onmouseout="this.style.backgroundColor='white'; this.style.color='#dc3545';" title="Hide Movie (Soft Delete)">
                                                            <span class="material-symbols-outlined" style="font-size: 18px;">visibility_off</span>
                                                        </a>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <a href="${pageContext.request.contextPath}/manageMovies?action=restore&id=${movie.movieId}" style="padding: 6px 10px; background: white; color: #2ecc71; border: 1px solid rgba(46, 204, 113, 0.2); border-radius: 4px; text-decoration: none; display: inline-flex; align-items: center; justify-content: center; transition: all 0.2s; min-width: 36px;" onmouseover="this.style.backgroundColor='#2ecc71'; this.style.color='white';" onmouseout="this.style.backgroundColor='white'; this.style.color='#2ecc71';" title="Restore Movie">
                                                            <span class="material-symbols-outlined" style="font-size: 18px;">restore</span>
                                                        </a>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <tr>
                                    <td colspan="10">No movies found.</td>
                                </tr>
                            </c:otherwise>
                        </c:choose>
                    </tbody>
                </table>
    </div>
    <script src="${pageContext.request.contextPath}/js/pagination.js"></script>
</body>
</html>
