/**
 * VaultX Home Page - Simple Scroll Animations
 * Lightweight scroll-triggered animations using Intersection Observer
 */

class VaultXAnimations {
    constructor() {
        this.observer = new IntersectionObserver(
            (entries) => this.handleIntersection(entries),
            { threshold: 0.1, rootMargin: '0px 0px -50px 0px' }
        );
        this.init();
    }

    init() {
        if (document.readyState === 'loading') {
            document.addEventListener('DOMContentLoaded', () => this.setupAnimations());
        } else {
            this.setupAnimations();
        }
    }

    setupAnimations() {
        // Skip animations if user prefers reduced motion
        if (window.matchMedia('(prefers-reduced-motion: reduce)').matches) return;

        // Select elements to animate
        const elements = document.querySelectorAll(
            '.hero, .section-title, .about__text, .card, .contact__list li, .contact__panel'
        );

        // Observe each element
        elements.forEach(el => {
            el.classList.add('animate-hidden');
            this.observer.observe(el);
        });

        // Setup scroll progress bar
        this.createScrollProgress();
    }

    handleIntersection(entries) {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                const element = entry.target;

                // Add staggered delay for cards
                if (element.classList.contains('card')) {
                    const cards = Array.from(element.parentNode.children);
                    const index = cards.indexOf(element);
                    setTimeout(() => this.animateElement(element), index * 100);
                } else {
                    this.animateElement(element);
                }

                this.observer.unobserve(element);
            }
        });
    }

    animateElement(element) {
        element.classList.remove('animate-hidden');
        element.classList.add('animate-visible');
    }

    createScrollProgress() {
        const progressBar = document.createElement('div');
        progressBar.className = 'scroll-progress';
        document.body.appendChild(progressBar);

        window.addEventListener('scroll', () => {
            const scrollPercent = (window.scrollY / (document.body.scrollHeight - window.innerHeight)) * 100;
            progressBar.style.width = `${Math.min(scrollPercent, 100)}%`;
        });
    }
}

// Initialize animations
new VaultXAnimations();

// Add scroll progress styles
const style = document.createElement('style');
style.textContent = `
.scroll-progress {
    position: fixed; top: 0; left: 0; height: 3px; 
    background: var(--color-bg-primary); z-index: 1000; transition: width 0.1s;
}
.animate-hidden { opacity: 0; transform: translateY(30px); }
.animate-visible { opacity: 1; transform: translateY(0); transition: all 0.6s ease; }
`;
document.head.appendChild(style);