function toggleSidebar(event) {
    if (event) event.preventDefault();

    const sidebar = document.querySelector('.site-sidebar');
    const body = document.body;

    sidebar.classList.toggle('open');
    body.classList.toggle('sidebar-open');

    if (sidebar.classList.contains('open')) {
        document.addEventListener('click', closeOnOutsideClick);
        document.addEventListener('keydown', escCloseSidebar);
    } else {
        document.removeEventListener('click', closeOnOutsideClick);
        document.removeEventListener('keydown', escCloseSidebar);
    }
}
const hamburger = document.querySelector('.hamburger');
const sidebar = document.querySelector('.site-sidebar');
const body = document.body;



function closeOnOutsideClick(e) {
    const sidebar = document.querySelector('.site-sidebar');
    const hamburger = document.querySelector('.hamburger');

    if (sidebar.classList.contains('open') &&
        !sidebar.contains(e.target) &&
        !hamburger.contains(e.target)) {
        sidebar.classList.remove('open');
        document.body.classList.remove('sidebar-open');
    }
}

function escCloseSidebar(e) {
    if (e.key === 'Escape') {
        const sidebar = document.querySelector('.site-sidebar');
        sidebar.classList.remove('open');
        document.body.classList.remove('sidebar-open');
    }
}
