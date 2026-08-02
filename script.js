document.addEventListener('DOMContentLoaded', () => {
    const mobileToggle = document.querySelector('.mobile-toggle');
    const navLinks = document.querySelector('.nav-links');
    const links = document.querySelectorAll('.nav-links a');

    // Toggle Mobile Menu
    mobileToggle.addEventListener('click', () => {
        mobileToggle.classList.toggle('active');
        navLinks.classList.toggle('active');
    });

    // Close menu when a link is clicked
    links.forEach(link => {
        link.addEventListener('click', () => {
            mobileToggle.classList.remove('active');
            navLinks.classList.remove('active');
        });
    });

    // Form submission simulation
    const fiscalForm = document.getElementById('fiscal-form');
    if(fiscalForm) {
        fiscalForm.addEventListener('submit', (e) => {
            e.preventDefault();
            const btn = fiscalForm.querySelector('button');
            const originalText = btn.textContent;
            
            btn.textContent = '¡Gracias por sumarte!';
            btn.style.backgroundColor = '#00b4d8'; // Switch to celeste
            btn.style.color = '#fff';
            
            setTimeout(() => {
                fiscalForm.reset();
                btn.textContent = originalText;
                btn.style.backgroundColor = ''; 
                btn.style.color = '';
            }, 3000);
        });
    }

    // Modal Logic
    const mainVideoTrigger = document.getElementById('open-video-modal-btn');
    const debateCardTrigger = document.getElementById('debate-card');
    const videoModal = document.getElementById('videoModal');
    const closeModal = document.querySelector('.close-modal');

    if (videoModal && closeModal) {
        if (mainVideoTrigger) {
            mainVideoTrigger.addEventListener('click', () => {
                videoModal.classList.add('show');
            });
        }
        if (debateCardTrigger) {
            debateCardTrigger.addEventListener('click', () => {
                videoModal.classList.add('show');
            });
        }

        closeModal.addEventListener('click', () => {
            videoModal.classList.remove('show');
        });

        // Close modal when clicking outside the content
        videoModal.addEventListener('click', (e) => {
            if (e.target === videoModal) {
                videoModal.classList.remove('show');
            }
        });
    }

    // Search Functionality
    const searchInput = document.getElementById('candidateSearch');
    const candidateCards = document.querySelectorAll('.candidato-card');
    const noResults = document.getElementById('no-results');

    if (searchInput) {
        searchInput.addEventListener('input', (e) => {
            const term = e.target.value.toLowerCase();
            let hasVisible = false;

            candidateCards.forEach(card => {
                const name = card.getAttribute('data-name');
                const cargo = card.getAttribute('data-cargo');
                
                if (name.includes(term) || cargo.includes(term)) {
                    card.style.display = 'flex';
                    hasVisible = true;
                } else {
                    card.style.display = 'none';
                }
            });

            if (!hasVisible) {
                noResults.style.display = 'block';
            } else {
                noResults.style.display = 'none';
            }
        });
    }

    // Image Modal Functionality
    const imageModal = document.getElementById('imageModal');
    const modalImage = document.getElementById('modalImage');
    const closeImageModalBtn = document.querySelector('.close-image-modal');

    if (imageModal && modalImage && closeImageModalBtn) {
        // Add click event to all candidate cards
        candidateCards.forEach(card => {
            card.addEventListener('click', () => {
                const imgElement = card.querySelector('img');
                if (imgElement) {
                    modalImage.src = imgElement.src;
                    imageModal.classList.add('show');
                    document.body.style.overflow = 'hidden'; // Prevent scrolling
                }
            });
        });

        // Close modal when clicking the X
        closeImageModalBtn.addEventListener('click', () => {
            imageModal.classList.remove('show');
            document.body.style.overflow = '';
            // Reset src after closing to avoid layout jumps on next open
            setTimeout(() => { modalImage.src = ''; }, 300);
        });

        // Close modal when clicking outside the image
        window.addEventListener('click', (e) => {
            if (e.target === imageModal) {
                imageModal.classList.remove('show');
                document.body.style.overflow = '';
                setTimeout(() => { modalImage.src = ''; }, 300);
            }
        });
    }

});
