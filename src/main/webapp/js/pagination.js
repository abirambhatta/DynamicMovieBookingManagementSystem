// pagination.js
document.addEventListener('DOMContentLoaded', function() {
    // Inject CSS for pagination
    const style = document.createElement('style');
    style.innerHTML = `
        .pagination-container {
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 16px 24px;
            border-top: 1px solid #e9ecef;
            background-color: #fcfcfc;
            font-family: inherit;
        }
        .pagination-info {
            font-size: 13px;
            color: #6c757d;
            font-weight: 500;
        }
        .pagination-controls {
            display: flex;
            gap: 8px;
            align-items: center;
        }
        .pagination-btn {
            display: flex;
            align-items: center;
            justify-content: center;
            min-width: 36px;
            height: 36px;
            padding: 0 10px;
            border: 1px solid #ced4da;
            background: #ffffff;
            color: #495057;
            font-size: 14px;
            font-weight: 600;
            border-radius: 6px;
            cursor: pointer;
            transition: all 0.2s;
            user-select: none;
        }
        .pagination-btn:hover:not(:disabled) {
            background-color: #f8f9fa;
            border-color: #adb5bd;
            color: #212529;
        }
        .pagination-btn.active {
            background-color: #dc143c;
            border-color: #dc143c;
            color: #ffffff;
        }
        .pagination-btn:disabled {
            opacity: 0.5;
            cursor: not-allowed;
            background-color: #f8f9fa;
        }
        .pagination-btn.view-all {
            padding: 0 16px;
            font-size: 12px;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            color: #dc143c;
            border-color: #dc143c;
        }
        .pagination-btn.view-all:hover {
            background-color: #dc143c;
            color: #ffffff;
        }
        .pagination-btn.view-all.active {
            background-color: #dc143c;
            color: #ffffff;
        }
    `;
    document.head.appendChild(style);

    // Find all tables that have the 'data-paginate' attribute
    const paginatedTables = document.querySelectorAll('table[data-paginate="true"]');
    
    paginatedTables.forEach((table, index) => {
        const rowsPerPage = parseInt(table.getAttribute('data-rows-per-page')) || 8;
        const tbody = table.querySelector('tbody');
        if (!tbody) return;
        
        const rows = Array.from(tbody.querySelectorAll('tr'));
        // If no rows or fewer rows than the limit, do nothing
        if (rows.length <= rowsPerPage) return;
        
        let currentPage = 1;
        let isViewAll = false;
        
        // Create pagination container
        const paginationContainer = document.createElement('div');
        paginationContainer.className = 'pagination-container';
        paginationContainer.id = `pagination-${index}`;
        
        // Insert it right after the table's immediate wrapper
        table.parentElement.appendChild(paginationContainer);
        
        function renderTable() {
            // Hide all
            rows.forEach(row => row.style.display = 'none');
            
            if (isViewAll) {
                rows.forEach(row => row.style.display = '');
            } else {
                const start = (currentPage - 1) * rowsPerPage;
                const end = start + rowsPerPage;
                for (let i = start; i < end && i < rows.length; i++) {
                    rows[i].style.display = '';
                }
            }
            renderControls();
        }
        
        function renderControls() {
            const totalPages = Math.ceil(rows.length / rowsPerPage);
            paginationContainer.innerHTML = '';
            
            // Left info text
            const infoText = document.createElement('span');
            infoText.className = 'pagination-info';
            if (isViewAll) {
                infoText.textContent = `Showing all ${rows.length} entries`;
            } else {
                const start = (currentPage - 1) * rowsPerPage + 1;
                const end = Math.min(start + rowsPerPage - 1, rows.length);
                infoText.textContent = `Showing ${start} to ${end} of ${rows.length} entries`;
            }
            paginationContainer.appendChild(infoText);
            
            // Buttons container
            const btnGroup = document.createElement('div');
            btnGroup.className = 'pagination-controls';
            
            // View All toggle
            const viewAllBtn = document.createElement('button');
            viewAllBtn.className = 'pagination-btn view-all' + (isViewAll ? ' active' : '');
            viewAllBtn.textContent = isViewAll ? 'View Paginated' : 'View All';
            viewAllBtn.onclick = () => {
                isViewAll = !isViewAll;
                currentPage = 1;
                renderTable();
            };
            btnGroup.appendChild(viewAllBtn);
            
            if (!isViewAll) {
                // Prev
                const prevBtn = document.createElement('button');
                prevBtn.className = 'pagination-btn';
                // Using HTML entity for arrows
                prevBtn.innerHTML = '&#8249;'; 
                prevBtn.disabled = currentPage === 1;
                prevBtn.onclick = () => {
                    if (currentPage > 1) { currentPage--; renderTable(); }
                };
                btnGroup.appendChild(prevBtn);
                
                // Pages
                const maxButtons = 5;
                let startPage = Math.max(1, currentPage - Math.floor(maxButtons / 2));
                let endPage = Math.min(totalPages, startPage + maxButtons - 1);
                
                if (endPage - startPage + 1 < maxButtons) {
                    startPage = Math.max(1, endPage - maxButtons + 1);
                }
                
                for (let i = startPage; i <= endPage; i++) {
                    const pageBtn = document.createElement('button');
                    pageBtn.className = 'pagination-btn' + (i === currentPage ? ' active' : '');
                    pageBtn.textContent = i;
                    pageBtn.onclick = () => {
                        currentPage = i;
                        renderTable();
                    };
                    btnGroup.appendChild(pageBtn);
                }
                
                // Next
                const nextBtn = document.createElement('button');
                nextBtn.className = 'pagination-btn';
                nextBtn.innerHTML = '&#8250;';
                nextBtn.disabled = currentPage === totalPages;
                nextBtn.onclick = () => {
                    if (currentPage < totalPages) { currentPage++; renderTable(); }
                };
                btnGroup.appendChild(nextBtn);
            }
            
            paginationContainer.appendChild(btnGroup);
        }
        
        // Initial render
        renderTable();
    });
});
