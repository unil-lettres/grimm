window.addEventListener("WebComponentsReady", () => {
    
    const buttonScroll = document.getElementById('scroll');
    const buttonClick = document.getElementById('click');
    
    // Adds button counterpart parameter to disable one button when clicking on the other
    buttonScroll.buttonCounterpart = buttonClick;
    buttonClick.buttonCounterpart = buttonScroll;

// Adds event listener to buttons to fire respective functions
  buttonScroll.addEventListener('change', scrollSync, false);
  buttonClick.addEventListener('change', clickSync, false);
  
  /* If a panel is added when the scroll sync is active, click on the button
  to activate the pb-highlight elements of the new panel */
  pbEvents.subscribe("pb-refresh", 'transcription', (ev) => {
     if (buttonScroll.active) {
            buttonScroll.click();
            buttonScroll.click()
         }
/* Then disable it for the panels that have “dysable sync” active */
    var disableButtons = document.querySelectorAll('.disable');
    disableButtons.forEach(button => {
        if (button.active) {
             disableSync(button)
         } 
        })
});
});

// Desactivate click/scroll button when selecting the other option
function disableCounterpart(button, counterpart) {
    if (button.active && counterpart.active) {
        counterpart.click();
        };
    };

function clickSync(evt) {
    disableCounterpart(this, evt.currentTarget.buttonCounterpart);
    var segs = document.querySelectorAll('.syncSpan, pb-highlight');
    segs.forEach(seg => {
        seg.classList.toggle('hide')
        })
};

function scrollSync(evt) {
    disableCounterpart(this, evt.currentTarget.buttonCounterpart);
    var highlights = document.querySelectorAll('pb-highlight');
    highlights.forEach(pb => {
         if (this.active) {
             pb.removeAttribute('disabled');
         } else {
             pb.setAttribute('disabled', 'true');
             }
        })
   
};

function highlightSeg(seg) {
    clearHighlights();
    var key = seg.dataset.ref;
    var spans = document.querySelectorAll(`[data-ref="${key}"]`);
    spans.forEach(el => {
        el.style.backgroundColor = 'var(--pb-highlight-color)';
        })
};

function clearHighlights() {
    var spans = document.querySelectorAll('[data-ref]');
    spans.forEach(span => {
        span.style.backgroundColor = 'inherit'})
    };

// Disable sync for a specific panel
function disableSync(button) {
    var panel = button.parentElement;
    var highlights = panel.querySelectorAll('pb-highlight');
    highlights.forEach(el => {
        if (button.active) {
            el.setAttribute('disabled', 'true');
            el.setAttribute('scroll', 'false');
         } else {
            el.removeAttribute('disabled');
            el.setAttribute('scroll', 'true');
            }
        })
   };
   
// Function to add the content of the metadata button available in the toolbar of each panel
function getMetadata(popover) {
    const endpoint = document.querySelector("pb-page").getEndpoint();
    var panel = popover.parentElement;
    var doc = encodeURIComponent(popover.dataset.id);
    var number = panel.getAttribute('active');
    var url = `${endpoint}/api/metadata/${doc}/${number}`;
    console.log(`fetching metadata from ${url}`);
    fetch(url)
    .then(function(response) {
        return response.text();
    }).
    then(function(html) {
        popover.alternate = html
    });
};