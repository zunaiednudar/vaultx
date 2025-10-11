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

    const currentPage = window.location.pathname.split('/').pop();

    
    if (currentPage === "Admin.aspx") {
        topMenu.appendChild(createMenuItem('Home', 'Home.aspx', 'fas fa-home'));
        topMenu.appendChild(createMenuItem('Admin Panel', 'Admin.aspx', 'fas fa-user-shield'));

        const logoutLi = document.createElement('li');
        const logoutA = document.createElement('a');
        logoutA.href = '#';
        logoutA.innerHTML = `<i class="fas fa-sign-out-alt"></i> Logout`;

  
        logoutA.addEventListener('click', (e) => {
            e.preventDefault();

            
            const msg = document.createElement('div');
            msg.innerText = "Logging out...";
            msg.style.position = 'fixed';
            msg.style.top = '50%';
            msg.style.left = '50%';
            msg.style.transform = 'translate(-50%, -50%)';
            msg.style.background = '#333';
            msg.style.color = '#fff';
            msg.style.fontSize = '20px';
            msg.style.padding = '20px 40px';
            msg.style.borderRadius = '10px';
            msg.style.zIndex = '9999';
            msg.style.textAlign = 'center';
            msg.style.boxShadow = '0 0 15px rgba(0,0,0,0.3)';
            document.body.appendChild(msg);

           
            setTimeout(() => {
                sessionStorage.removeItem('VaultXLoggedIn');
                window.location = 'Home.aspx';
            }, 1500);
        });


        logoutLi.appendChild(logoutA);
        bottomMenu.appendChild(logoutLi);

    } else if (isLoggedIn) {
     
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
        logoutA.addEventListener('click', showLogoutModal); // modal for other pages
        logoutLi.appendChild(logoutA);
        bottomMenu.appendChild(logoutLi);

    } else {
     
        topMenu.appendChild(createMenuItem('Home', 'Home.aspx', 'fas fa-home'));
        topMenu.appendChild(createMenuItem('Terms & Conditions', 'Terms.aspx', 'fas fa-file-contract'));
        topMenu.appendChild(createMenuItem('FAQ', 'FAQ.aspx', 'fas fa-question-circle'));
        bottomMenu.appendChild(createMenuItem('Login', 'Login.aspx', 'fas fa-sign-in-alt'));
        bottomMenu.appendChild(createMenuItem('Register', 'Register.aspx', 'fas fa-user-plus'));
    }

   
    document.querySelectorAll('.site-sidebar a').forEach(a => {
        if (a.getAttribute('href') === currentPage) {
            a.classList.add('active');
        }
    });
});


function showLogoutModal(e) {
    e.preventDefault();
    document.getElementById('logoutModal').style.display = 'flex';
}

function confirmLogout() {
    sessionStorage.removeItem('VaultXLoggedIn');
    window.location = 'Home.aspx'; 
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
