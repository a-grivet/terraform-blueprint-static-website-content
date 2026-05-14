// ============================================================================
// STELLANTIS STATIC WEBSITE BLUEPRINT - SCRIPTS
// ============================================================================

// Initialize on DOM load
document.addEventListener('DOMContentLoaded', function() {
    initNavigation();
    initSmoothScroll();
    setDeployDate();
    addAnimations();
});

// ============================================================================
// NAVIGATION
// ============================================================================

function initNavigation() {
    const navLinks = document.querySelectorAll('.nav-link');
    const sections = document.querySelectorAll('section[id]');
    
    // Update active nav link on scroll
    window.addEventListener('scroll', () => {
        let current = '';
        
        sections.forEach(section => {
            const sectionTop = section.offsetTop;
            const sectionHeight = section.clientHeight;
            
            if (window.pageYOffset >= sectionTop - 200) {
                current = section.getAttribute('id');
            }
        });
        
        navLinks.forEach(link => {
            link.classList.remove('active');
            if (link.getAttribute('href') === `#${current}`) {
                link.classList.add('active');
            }
        });
    });
}

// ============================================================================
// SMOOTH SCROLLING
// ============================================================================

function initSmoothScroll() {
    const links = document.querySelectorAll('a[href^="#"]');
    
    links.forEach(link => {
        link.addEventListener('click', function(e) {
            const href = this.getAttribute('href');
            
            // Skip if it's just '#'
            if (href === '#') {
                e.preventDefault();
                return;
            }
            
            const target = document.querySelector(href);
            if (target) {
                e.preventDefault();
                
                const headerOffset = 80;
                const elementPosition = target.getBoundingClientRect().top;
                const offsetPosition = elementPosition + window.pageYOffset - headerOffset;
                
                window.scrollTo({
                    top: offsetPosition,
                    behavior: 'smooth'
                });
            }
        });
    });
}

// ============================================================================
// DEPLOY DATE
// ============================================================================

function setDeployDate() {
    const deployDateElement = document.getElementById('deploy-date');
    if (deployDateElement) {
        const now = new Date();
        const options = { 
            year: 'numeric', 
            month: 'short', 
            day: 'numeric',
            hour: '2-digit',
            minute: '2-digit'
        };
        deployDateElement.textContent = now.toLocaleDateString('en-US', options);
    }
}

// ============================================================================
// ANIMATIONS
// ============================================================================

function addAnimations() {
    // Observe elements for fade-in animation
    const observerOptions = {
        threshold: 0.1,
        rootMargin: '0px 0px -50px 0px'
    };
    
    const observer = new IntersectionObserver(function(entries) {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.style.opacity = '1';
                entry.target.style.transform = 'translateY(0)';
            }
        });
    }, observerOptions);
    
    // Apply to all cards
    const cards = document.querySelectorAll('.status-card, .architecture-card, .feature-card, .contact-card');
    cards.forEach((card, index) => {
        card.style.opacity = '0';
        card.style.transform = 'translateY(20px)';
        card.style.transition = `all 0.6s ease ${index * 0.1}s`;
        observer.observe(card);
    });
}

// ============================================================================
// ENVIRONMENT INFO (Optional - for debugging)
// ============================================================================

function logEnvironmentInfo() {
    console.log('='.repeat(60));
    console.log('STELLANTIS STATIC WEBSITE BLUEPRINT');
    console.log('='.repeat(60));
    console.log('Version: 1.0.0');
    console.log('Environment: Development');
    console.log('Deployed:', new Date().toISOString());
    console.log('Infrastructure: CloudFront + S3 + ACM + Route53');
    console.log('='.repeat(60));
}

// Uncomment to enable environment logging
// logEnvironmentInfo();

// ============================================================================
// UTILITY FUNCTIONS
// ============================================================================

// Check if element is in viewport
function isInViewport(element) {
    const rect = element.getBoundingClientRect();
    return (
        rect.top >= 0 &&
        rect.left >= 0 &&
        rect.bottom <= (window.innerHeight || document.documentElement.clientHeight) &&
        rect.right <= (window.innerWidth || document.documentElement.clientWidth)
    );
}

// Debounce function for performance
function debounce(func, wait = 20, immediate = true) {
    let timeout;
    return function() {
        const context = this;
        const args = arguments;
        const later = function() {
            timeout = null;
            if (!immediate) func.apply(context, args);
        };
        const callNow = immediate && !timeout;
        clearTimeout(timeout);
        timeout = setTimeout(later, wait);
        if (callNow) func.apply(context, args);
    };
}
