window.addEventListener("load", () => {
    
    const buttonScroll = document.getElementById('scroll');
    const buttonClick = document.getElementById('click');
    
    // Adds button counterpart parameter to disable one button when clicking on the other
    buttonScroll.buttonCounterpart = buttonClick;
    buttonClick.buttonCounterpart = buttonScroll;
    
    // Adds event listener to buttons to fire respective functions
    buttonScroll.addEventListener('change', spanSync, false);
    buttonClick.addEventListener('change', spanSync, false);
    
    // Click scroll button as default
    buttonScroll.click();
    
    pbEvents.subscribe('pb-end-update', 'panels', () => {
        const grid = document.querySelector('pb-grid');
        document.querySelectorAll('#toc [name="panel"]')
        .forEach((input) => {
            const panel = parseInt(input.value);
            if (grid.panels.indexOf(panel) !== -1) {
                input.checked = true;
            }
            input.addEventListener('change', () => {
                if (input.checked) {
                    grid.addPanel(panel);
                } else {
                    grid.removePanel(panel);
                }
            });
        });
    });

    /* Adds the appropriate eventListener to spans in added/changed panels */
    pbEvents.subscribe("pb-panel", 'transcription', (ev) => {
        clearHighlights();
        var mode = retrieveSyncMode();
        addEvents(mode);
    });
});


/* Desactivate click/scroll button when selecting the other option
Buttons should probably be radio buttons to enable this behaviour automatically */
function disableCounterpart(button, counterpart) {
    if (button.active && counterpart.active) {
        counterpart.click();
    };
};

function addEvents(mode) {
    var panels = document.querySelectorAll('pb-panel:not(.disabled)');
    if (panels) {
        panels.forEach(panel => {
            var spans = panel.querySelectorAll('*[data-ref]')
            spans.forEach(span => {
                span.addEventListener(mode, highlightSeg, false);
            })
        });
    }
};

/* Function to sync the spans when clicking on the buttons (it cleans
    previous eventListener if the sync mode changed
) */
function spanSync(evt) {
    // Disable the other button and clear any highlights from previous mode
    disableCounterpart(this, evt.currentTarget.buttonCounterpart);
    clearHighlights();
    // Add eventlistener to spans based on mode
    var mode = retrieveSyncMode()
    var spans = document.querySelectorAll('*[data-ref]')
    spans.forEach(span => {
        switch(mode) {
            case "click":
                if (this.active) {
                    span.removeEventListener('mouseover', highlightSeg, false);
                    span.addEventListener('click', highlightSeg, false);
                }
                else {
                    span.removeEventListener('click', highlightSeg, false);
                    }
                break;
            case "mouseover":
                if (this.active) {
                    span.removeEventListener('click', highlightSeg, false);
                    span.addEventListener('mouseover', highlightSeg, false);
                    }
                else {
                    span.removeEventListener('mouseover', highlightSeg, false);
                }
            }
    });
    disablePanels();
};

function highlightSeg() {
    clearHighlights();
    var refs = this.dataset.ref.match(/\w+/g);
    refs.forEach(ref => {
        var spans = document.querySelectorAll(`span:not(.disabled).${ref}`);    
        spans.forEach(el => {
            el.style.backgroundColor = 'var(--pb-highlight-color)';
            el.scrollIntoView({
            block: "center", behavior: "smooth"
            })
        });
    });
    /* We fire the highlightening of segments that do not match just with one of the keys.
    Otherwise, we might highlight more that one segment and it will be a bit confusing*/
    closestMatch(refs[0]);
};

/*When there is no exact match, show square brackets at closest position*/
function closestMatch(key) {
    const source = key.split("_").pop();
    var panels = document.querySelectorAll('pb-panel:not(.disabled)');
    panels.forEach(panel => {
        const values = []
        const spans = panel.querySelectorAll('*[data-key]');
        spans.forEach(span => {
            var refs = span.dataset.key.match(/\w+/g);
            refs.forEach(ref => {
                values.push(ref.split("_").pop())
                })
            });
        if (values.includes(source) == false) {
            const closest = values.reduce((a, b) => {
                return Math.abs(b - source) < Math.abs(a - source) ? b : a;
                });
            spans.forEach(span => {
                var refs = span.dataset.key.match(/\w+/g);
                refs.forEach(ref => {
                   if (ref.split("_").pop() == closest) {
                        span.classList.remove('hide');
                        span.style.backgroundColor = 'var(--highlight-closest-color)';
                        span.scrollIntoView({block: "center", behavior: "instant"})
                        }
                    })

            })
        }
    })
};

/* Check which panels have the synchronization disabled, and act accordingly */
function disablePanels() {
    var disableButtons = document.querySelectorAll('.disable');
    disableButtons.forEach(button => {
        if (button.active) {
            disableSync(button);
        };
    })
};

function clearHighlights() {
    var spans = document.querySelectorAll('[data-ref], .noMatch');
    spans.forEach(span => {
        span.style.backgroundColor = 'inherit'
    });
    var unalignedSegments = document.querySelectorAll('.noMatch');
    unalignedSegments.forEach(segment => {
        segment.classList.add('hide');
        })
};

// Function to check which mode is active
function retrieveSyncMode() {
    const buttonScroll = document.getElementById('scroll');
    const buttonClick = document.getElementById('click');
    if (buttonScroll.active) {
        return 'mouseover'
        }
    else if (buttonClick.active) {
        return 'click'
        }
    };

// Disable sync for a specific panel
function disableSync(button) {
    clearHighlights();
    var panel = button.parentElement;
    if (button.active) {
        panel.classList.add('disabled')
        }
    else {
        panel.classList.remove('disabled')
        };
    var spans = panel.querySelectorAll('[data-ref], .noMatch');
    var mode = retrieveSyncMode()
    spans.forEach(span => {
        if (button.active && mode) {
            span.removeEventListener(mode, highlightSeg, false);
            span.classList.add('disabled')
        } else if (mode) {
            span.addEventListener(mode, highlightSeg, false);
            span.classList.remove('disabled')
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
    fetch(url).then(function (response) {
        return response.text();
    }).
    then(function (html) {
        popover.alternate = html
    });
};