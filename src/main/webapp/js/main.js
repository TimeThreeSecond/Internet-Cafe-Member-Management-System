// 网吧会员管理系统JavaScript文件

// 页面加载完成后执行
$(document).ready(function() {
    // 初始化工具提示
    var tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
    var tooltipList = tooltipTriggerList.map(function (tooltipTriggerEl) {
        return new bootstrap.Tooltip(tooltipTriggerEl);
    });

    // 自动隐藏提示框
    setTimeout(function() {
        $('.alert').fadeOut('slow');
    }, 5000);
});

// 表格搜索功能
function searchTable(tableId, searchInput) {
    var input = document.getElementById(searchInput);
    var filter = input.value.toUpperCase();
    var table = document.getElementById(tableId);
    var tr = table.getElementsByTagName('tr');

    for (var i = 1; i < tr.length; i++) {
        var tdArray = tr[i].getElementsByTagName('td');
        var found = false;

        for (var j = 0; j < tdArray.length; j++) {
            var td = tdArray[j];
            if (td) {
                var txtValue = td.textContent || td.innerText;
                if (txtValue.toUpperCase().indexOf(filter) > -1) {
                    found = true;
                    break;
                }
            }
        }

        tr[i].style.display = found ? '' : 'none';
    }
}

// 确认对话框
function confirmDelete(message) {
    return confirm(message || '确定要删除这条记录吗？');
}

// 格式化日期
function formatDate(date) {
    if (!date) return '';
    var d = new Date(date);
    return d.getFullYear() + '-' +
           String(d.getMonth() + 1).padStart(2, '0') + '-' +
           String(d.getDate()).padStart(2, '0') + ' ' +
           String(d.getHours()).padStart(2, '0') + ':' +
           String(d.getMinutes()).padStart(2, '0') + ':' +
           String(d.getSeconds()).padStart(2, '0');
}

// 格式化金额
function formatMoney(amount) {
    return '¥' + parseFloat(amount).toFixed(2);
}

// 刷新页面数据
function refreshData() {
    location.reload();
}

// AJAX请求封装
function ajaxRequest(url, method, data, callback) {
    $.ajax({
        url: url,
        type: method,
        data: data,
        dataType: 'json',
        success: function(response) {
            if (callback) callback(response);
        },
        error: function(xhr, status, error) {
            console.error('AJAX Error:', error);
            alert('请求失败，请稍后重试');
        }
    });
}

// 显示加载动画
function showLoading() {
    var loadingHtml = '<div class="loading-overlay">' +
        '<div class="spinner-border text-primary" role="status">' +
        '<span class="visually-hidden">Loading...</span>' +
        '</div>' +
        '</div>';
    $('body').append(loadingHtml);
}

// 隐藏加载动画
function hideLoading() {
    $('.loading-overlay').remove();
}

// 表单验证
function validateForm(formId) {
    var form = document.getElementById(formId);
    var inputs = form.querySelectorAll('input[required], select[required], textarea[required]');
    var isValid = true;

    inputs.forEach(function(input) {
        if (!input.value.trim()) {
            input.classList.add('is-invalid');
            isValid = false;
        } else {
            input.classList.remove('is-invalid');
        }
    });

    return isValid;
}

// 清除表单验证状态
function clearFormValidation(formId) {
    var form = document.getElementById(formId);
    var inputs = form.querySelectorAll('.is-invalid, .is-valid');
    inputs.forEach(function(input) {
        input.classList.remove('is-invalid', 'is-valid');
    });
}

// 计算时间差（分钟）
function calculateTimeDiff(startTime, endTime) {
    if (!startTime || !endTime) return 0;
    var start = new Date(startTime);
    var end = new Date(endTime);
    var diff = Math.abs(end - start);
    return Math.floor(diff / (1000 * 60));
}

// 计算费用
function calculateFee(duration, hourlyRate) {
    if (!duration || !hourlyRate) return 0;
    var hours = Math.ceil(duration / 60);
    return hours * parseFloat(hourlyRate);
}

// 导出数据到Excel
function exportToExcel(tableId, fileName) {
    var table = document.getElementById(tableId);
    var rows = table.getElementsByTagName('tr');
    var csv = [];

    for (var i = 0; i < rows.length; i++) {
        var row = [], cols = rows[i].querySelectorAll('td, th');

        for (var j = 0; j < cols.length; j++) {
            var text = cols[j].innerText.replace(/"/g, '""');
            row.push('"' + text + '"');
        }

        csv.push(row.join(','));
    }

    var csvContent = csv.join('\n');
    var blob = new Blob(['\ufeff' + csvContent], { type: 'text/csv;charset=utf-8;' });
    var link = document.createElement('a');
    var url = URL.createObjectURL(blob);

    link.setAttribute('href', url);
    link.setAttribute('download', fileName || 'export.csv');
    link.style.visibility = 'hidden';
    document.body.appendChild(link);
    link.click();
    document.body.removeChild(link);
}

// 打印功能
function printContent(elementId) {
    var element = document.getElementById(elementId);
    var printWindow = window.open('', '_blank');

    printWindow.document.write('<html><head><title>打印</title>');
    printWindow.document.write('<link href="https://cdn.bootcdn.net/ajax/libs/bootstrap/5.1.3/css/bootstrap.min.css" rel="stylesheet">');
    printWindow.document.write('<style>body { padding: 20px; } .no-print { display: none; }</style>');
    printWindow.document.write('</head><body>');
    printWindow.document.write(element.innerHTML);
    printWindow.document.write('</body></html>');
    printWindow.document.close();
    printWindow.print();
}

// 检查浏览器兼容性
function checkBrowserCompatibility() {
    var userAgent = navigator.userAgent;
    var isChrome = /Chrome/.test(userAgent) && /Google Inc/.test(navigator.vendor);
    var isFirefox = /Firefox/.test(userAgent);
    var isIE = /MSIE|Trident/.test(userAgent);

    if (isIE) {
        alert('检测到您正在使用IE浏览器，为了获得更好的体验，建议使用Chrome或Firefox浏览器');
    }
}

// 页面性能监控
function trackPageLoadTime() {
    window.addEventListener('load', function() {
        var loadTime = performance.timing.loadEventEnd - performance.timing.navigationStart;
        console.log('页面加载时间：' + loadTime + 'ms');
    });
}

// 初始化应用
function initApp() {
    checkBrowserCompatibility();
    trackPageLoadTime();
    console.log('网吧会员管理系统已初始化');
}

// 执行初始化
initApp();