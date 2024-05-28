window.addEventListener("load", () => {
    
    const buttonScroll = document.getElementById('scroll');
    const buttonClick = document.getElementById('click');
    
    // Adds button counterpart parameter to disable one button when clicking on the other
    buttonScroll.buttonCounterpart = buttonClick;
    buttonClick.buttonCounterpart = buttonScroll;
    
    // Adds event listener to buttons to fire respective functions
    buttonScroll.addEventListener('change', scrollSync, false);
    buttonClick.addEventListener('change', clickSync, false);
    
    // Click scroll button as default
    buttonScroll.click();
    
    /* If a panel is added or changed, click on the sync buttons
     to enable the appropriate elements in the new panel */
    pbEvents.subscribe("pb-panel", 'transcription', (ev) => {
        const buttons = [buttonScroll, buttonClick];
        buttons.forEach(button => {
            if (button.active) {
                button.click();
                button.click()
            };
        });
        // Then disable it for the panels that have “disable sync” active
        disablePanels();

    });
    
    /* With pb-highlight enabled, fire closest match function to higlight segment when there is no match;
    then clean it off */
    pbEvents.subscribe('pb-highlight-on', null, (ev) => {
        var key = ev.detail.id;
        closestMatch(key);
        });
    pbEvents.subscribe('pb-highlight-off', null, (ev) => {
         clearHighlights();
        });
    
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
            console.log('Disable sync gets fired')
        };
    })
};

// Desactivate click/scroll button when selecting the other option
function disableCounterpart(button, counterpart) {
    if (button.active && counterpart.active) {
        counterpart.click();
    };
};

/* Function to sync by clicking on the spans (which are not visible by default: pb-highlight elements are).
  N.B.: When adding a new panel, the spans are not visible, so we cannot just get all spans and pb-highlight elements
  and just use classList.toggle for all */
function clickSync(evt) {
    disableCounterpart(this, evt.currentTarget.buttonCounterpart);
    clearHighlights();
    // First hide/show pb-highlight elements accordingly
    var pbs = document.querySelectorAll('pb-highlight');
    pbs.forEach(pb => {
        if (this.active) {
            pb.classList.add('hide');
        } else {
            pb.classList.remove('hide')
        }
    });
    // Hide/show the spans for clicking. The already contain an inline event listener
    var spans = document.querySelectorAll('.syncSpan')
    spans.forEach(span => {
        if (this.active) {
            span.classList.remove('hide');
        } else {
            span.classList.add('hide')
        }
    });
    disablePanels();
};

// Enable scroll synchronization (based on pb-hightlight elements)
function scrollSync(evt) {
    disableCounterpart(this, evt.currentTarget.buttonCounterpart);
    clearHighlights();
    var highlights = document.querySelectorAll('pb-highlight');
    highlights.forEach(pb => {
        if (this.active) {
            pb.removeAttribute('disabled');
        } else {
            pb.setAttribute('disabled', 'true');
        }
    });
    disablePanels();
};

function highlightSeg(seg) {
    clearHighlights();
    var key = seg.dataset.ref;
    var spans = document.querySelectorAll(`[data-ref = "${key}"]`);
    spans.forEach(el => {
        el.style.backgroundColor = 'var(--pb-highlight-color)';
        el.scrollIntoView({
            block: "center", behavior: "instant"
        })
    })
    closestMatch(key);
};

/*When there is no exact match, show square brackets at closest position*/
function closestMatch(key) {
    const source = key.split("_").pop();
    var panels = document.querySelectorAll('pb-panel');
    panels.forEach(panel => {
        const values = []
        const spans = panel.querySelectorAll('*[data-key]');
        spans.forEach(span => {
            var ref = span.dataset.key
            values.push(ref.split("_").pop())
            });
        if (values.includes(source) == false) {
            const closest = values.reduce((a, b) => {
                return Math.abs(b - source) < Math.abs(a - source) ? b : a;
                });
            spans.forEach(span => {
                if (span.dataset.key.split("_").pop() == closest) {
                    span.classList.remove('hide');
                    span.style.backgroundColor = 'var(--pb-highlight-color)';
                    span.scrollIntoView({block: "center", behavior: "instant"})
                    }
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
    var highlights = panel.querySelectorAll('pb-highlight');
    const syncModeClick = document.getElementById('click');
    const syncModeScroll = document.getElementById('scroll')
    highlights.forEach(pb => {
        if (button.active) {
            pb.setAttribute('disabled', 'true');
            pb.removeAttribute('scroll');
            pb.classList.remove('hide');
        } else if (syncModeScroll.active) {
            pb.removeAttribute('disabled');
            pb.setAttribute('scroll', 'true');
            pb.classList.remove('hide');
        } else if (syncModeClick.active) {
            pb.classList.add('hide')
            }
    });
    var spans = panel.querySelectorAll('.syncSpan');
    spans.forEach(span => {
        if (button.active) {
            span.classList.add('hide');
        } else if (syncModeClick.active) {
            span.classList.remove('hide');
        }
        else if (syncModeScroll.active) {
            span.classList.add('hide');
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