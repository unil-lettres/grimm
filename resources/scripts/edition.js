window.addEventListener("load", () => {
    
    const buttonScroll = document.getElementById('scroll');
    const buttonClick = document.getElementById('click');
    
    // Adds button counterpart parameter to disable one button when clicking on the other
    buttonScroll.buttonCounterpart = buttonClick;
    buttonClick.buttonCounterpart = buttonScroll;
    
    // Adds mode parameter to add appropriate event listener to spans
    buttonScroll.mode = 'scroll';
    buttonClick.mode = 'click';
    
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
});

function disablePanels() {
    var disableButtons = document.querySelectorAll('.disable');
    disableButtons.forEach(button => {
        if (button.active) {
            disableSync(button);
        };
    })
};

// Desactivate click/scroll button when selecting the other option
function disableCounterpart(button, counterpart) {
    if (button.active && counterpart.active) {
        counterpart.click();
    };
};

/* Function to sync by clicking on the spans */
function spanSync(evt) {
    disableCounterpart(this, evt.currentTarget.buttonCounterpart);
    clearHighlights();
    // Add eventlistener
    var spans = document.querySelectorAll('*[data-ref]')
    spans.forEach(span => {
        switch(evt.currentTarget.mode) {
            case "click":
                span.removeEventListener('mouseover', highlightSeg, false);
                span.addEventListener('click', highlightSeg, false);
                break;
            case "scroll":
                span.removeEventListener('click', highlightSeg, false);
                span.addEventListener('mouseover', highlightSeg, false);
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
            block: "center", behavior: "instant"
            })
        });
        closestMatch(ref);
    });
};

/*When there is no exact match, show square brackets at closest position*/
function closestMatch(key) {
    const source = key.split("_").pop();
    var panels = document.querySelectorAll('pb-panel');
    panels.forEach(panel => {
        const values = []
        const spans = panel.querySelectorAll('*[data-key]:not(.disabled)');
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

function clearHighlights() {
    var spans = document.querySelectorAll('[data-ref],.noMatch');
    spans.forEach(span => {
        span.style.backgroundColor = 'inherit'
    });
    var unalignedSegments = document.querySelectorAll('.noMatch');
    unalignedSegments.forEach(segment => {
        segment.classList.add('hide');
        })
};

// Disable sync for a specific panel
function disableSync(button) {
    clearHighlights();
    var panel = button.parentElement;
    var spans = panel.querySelectorAll('[data-ref]');
    spans.forEach(span => {
        if (button.active) {
            span.removeEventListener('click', highlightSeg, false);
            span.removeEventListener('mouseover', highlightSeg, false);
            span.classList.add('disabled')
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