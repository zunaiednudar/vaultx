/**
 * VaultX Fund Transfer - Client-side UI Enhancement
 * Lightweight JavaScript for better user experience
 */

class FundTransferUI {
    constructor() {
        this.init();
    }

    init() {
        if (document.readyState === 'loading') {
            document.addEventListener('DOMContentLoaded', () => this.setup());
        } else {
            this.setup();
        }
    }

    setup() {
        this.setupModals();
        this.setupInputFormatting();
        this.setupKeyboardEvents();
        this.setupFormAnimations();
    }

    // Modal handling (client-side only)
    setupModals() {
        // Close modals when clicking outside
        window.onclick = (event) => {
            const noAccountModal = document.getElementById('noAccountModal');
            const transferErrorModal = document.getElementById('transferErrorModal');

            if (event.target === noAccountModal) {
                this.closeNoAccountModal();
            }
            if (event.target === transferErrorModal) {
                this.closeTransferErrorModal();
            }
        };

        // Close modals with Escape key
        document.addEventListener('keydown', (event) => {
            if (event.key === 'Escape') {
                this.closeNoAccountModal();
                this.closeTransferErrorModal();
            }
        });
    }

    // Input formatting (client-side only)
    setupInputFormatting() {
        const amountField = this.getField('txtAmount');
        if (amountField) {
            amountField.addEventListener('input', (e) => {
                // Allow only numbers and one decimal point
                let value = e.target.value.replace(/[^0-9.]/g, '');
                const parts = value.split('.');
                if (parts.length > 2) {
                    value = parts[0] + '.' + parts.slice(1).join('');
                }
                if (parts[1] && parts[1].length > 2) {
                    value = parts[0] + '.' + parts[1].substring(0, 2);
                }
                e.target.value = value;
            });
        }

        const accountField = this.getField('txtAccountNo');
        if (accountField) {
            accountField.addEventListener('input', (e) => {
                e.target.value = e.target.value.replace(/[^0-9]/g, '');
            });
        }
    }

    // Enhanced keyboard navigation
    setupKeyboardEvents() {
        // Submit form with Ctrl+Enter
        document.addEventListener('keydown', (e) => {
            if (e.ctrlKey && e.key === 'Enter') {
                const sendButton = this.getField('btnSend');
                if (sendButton && !sendButton.disabled) {
                    sendButton.click();
                }
            }
        });
    }

    // Simple animations
    setupFormAnimations() {
        const accountSummary = document.querySelector('.selected-account-summary');
        if (accountSummary) {
            accountSummary.addEventListener('mouseenter', () => {
                accountSummary.style.transition = 'all 0.3s ease';
                accountSummary.style.backgroundColor = '#f0f8ff';
            });

            accountSummary.addEventListener('mouseleave', () => {
                accountSummary.style.backgroundColor = '#f8f9fa';
            });
        }
    }

    // Utility method
    getField(partialId) {
        const elements = document.querySelectorAll(`[id*="${partialId}"]`);
        return elements.length > 0 ? elements[0] : null;
    }

    // Modal methods (called from server-side)
    closeNoAccountModal() {
        const modal = document.getElementById('noAccountModal');
        if (modal) modal.style.display = 'none';
    }

    closeTransferErrorModal() {
        const modal = document.getElementById('transferErrorModal');
        if (modal) modal.style.display = 'none';
    }
}

// Global functions for ASP.NET compatibility (required by server-side)
let fundTransferUI;

function validateTerms(sender, args) {
    const checkbox = document.querySelector('[id*="chkTerms"]');
    args.IsValid = checkbox ? checkbox.checked : false;
}

function clearForm() {
    document.querySelector('[id*="txtAccountNo"]').value = '';
    document.querySelector('[id*="txtAmount"]').value = '';
    document.querySelector('[id*="txtReference"]').value = '';
    document.querySelector('[id*="txtPassword"]').value = '';
    document.querySelector('[id*="chkTerms"]').checked = false;
}

function showNoAccountModal(accountType) {
    document.getElementById('selectedAccountType').textContent = accountType;
    document.getElementById('noAccountModal').style.display = 'flex';
}

function closeNoAccountModal() {
    document.getElementById('noAccountModal').style.display = 'none';
}

function showTransferErrorModal(message) {
    document.getElementById('transferErrorMessage').textContent = message;
    document.getElementById('transferErrorModal').style.display = 'flex';
}

function closeTransferErrorModal() {
    document.getElementById('transferErrorModal').style.display = 'none';
}

// Initialize
document.addEventListener('DOMContentLoaded', () => {
    fundTransferUI = new FundTransferUI();
});

// Minimal CSS for enhanced interactions
const styles = `
.form-control:focus {
    transform: translateY(-2px);
    box-shadow: 0 4px 8px rgba(78, 205, 196, 0.2) !important;
}
.btn:active { transform: translateY(1px); }
.modal-overlay { backdrop-filter: blur(5px); }
`;

if (document.head) {
    const styleSheet = document.createElement('style');
    styleSheet.textContent = styles;
    document.head.appendChild(styleSheet);
}










//otp

function showOtpModal() {
    document.getElementById('otpModal').style.display = 'block';
}

function closeOtpModal() {
    document.getElementById('otpModal').style.display = 'none';
}

