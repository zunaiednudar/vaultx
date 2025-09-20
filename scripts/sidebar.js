


document.addEventListener('DOMContentLoaded', () => {

    const isLoggedIn = sessionStorage.getItem('VaultXLoggedIn') === 'true';

    const topMenu = document.getElementById('topMenu');
    const bottomMenu = document.getElementById('bottomMenu');

    topMenu.innerHTML = '';
    bottomMenu.innerHTML = '';

    function createMenuItem(text, url, iconClass) {

        const li = document.createElement('li');
        const a = document.createElement('a');



        a.href = url;
        a.innerHTML = `<i class="${iconClass}"></i> ${text}`;
        li.appendChild(a);
        return li;
    }

    if (isLoggedIn) {
        topMenu.appendChild(createMenuItem('Home', 'Home.aspx', 'fas fa-home'));
        topMenu.appendChild(createMenuItem('Dashboard', 'Dashboard.aspx', 'fas fa-tachometer-alt'));
        topMenu.appendChild(createMenuItem('Fund Transfer', 'FundTransfer.aspx', 'fas fa-exchange-alt'));
        topMenu.appendChild(createMenuItem('Profile', 'Profile.aspx', 'fas fa-user'));
        topMenu.appendChild(createMenuItem('Terms & Conditions', 'Terms.aspx', 'fas fa-file-contract'));
        topMenu.appendChild(createMenuItem('FAQ', 'FAQ.aspx', 'fas fa-question-circle'));
        const logoutLi = document.createElement('li');
        const logoutA = document.createElement('a');
        logoutA.href = '#'; 
        logoutA.innerHTML = `<i class="fas fa-sign-out-alt"></i> Logout`;
        logoutA.addEventListener('click', showLogoutModal);
        logoutLi.appendChild(logoutA);
        bottomMenu.appendChild(logoutLi);
     
    } else {

        topMenu.appendChild(createMenuItem('Home', 'Home.aspx', 'fas fa-home'));
        topMenu.appendChild(createMenuItem('Terms & Conditions', 'Terms.aspx', 'fas fa-file-contract'));
        topMenu.appendChild(createMenuItem('FAQ', 'FAQ.aspx', 'fas fa-question-circle'));
        bottomMenu.appendChild(createMenuItem('Login', 'Login.aspx', 'fas fa-sign-in-alt'));
        bottomMenu.appendChild(createMenuItem('Register', 'Register.aspx', 'fas fa-user-plus'));
    }
    const currentPage = window.location.pathname.split('/').pop(); 
    document.querySelectorAll('.site-sidebar a').forEach(a => {
        if (a.getAttribute('href') === currentPage) {
            a.classList.add('active');
        }
    });
});

logoutItem.querySelector('a').addEventListener('click', showLogoutModal);
bottomMenu.appendChild(logoutItem);
function showLogoutModal(e) {
    e.preventDefault();
    document.getElementById('logoutModal').style.display = 'flex';
}

function confirmLogout() {
    sessionStorage.removeItem('VaultXLoggedIn');
    window.location = 'Logout.aspx?confirm=true'; 
}

function cancelLogout() {
    document.getElementById('logoutModal').style.display = 'none';
}




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


