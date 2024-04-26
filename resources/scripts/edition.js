window.addEventListener("WebComponentsReady", () => {
    
    const buttonScroll = document.getElementById('scroll');
    const buttonClick = document.getElementById('click');
    
    // Adds button counterpart parameter to disable one button when clicking on the other
    buttonScroll.buttonCounterpart = buttonClick;
    buttonClick.buttonCounterpart = buttonScroll;
    
    // Adds event listener to buttons to fire respective functions
    buttonScroll.addEventListener('change', scrollSync, false);
    buttonClick.addEventListener('change', clickSync, false);
    
    /* If a panel is added or changed, click on the sync buttons
     to enable the appropriate elements in the new panel */
    pbEvents.subscribe("pb-panel", 'transcription', (ev) => {
        const buttons =[buttonScroll, buttonClick];
        buttons.forEach(button => {
            if (button.active) {
                button.click();
                button.click()
            };
        });
        // Then disable it for the panels that have “disable sync” active
        var disableButtons = document.querySelectorAll('.disable');
        disableButtons.forEach(button => {
            if (button.active) {
                disableSync(button)
            }
        })
    });
    
    /* With pb-highlight enabled, fire closest match function to higlight segment when there is no match;
    then clean it off */
    pbEvents.subscribe('pb-highlight-on', null, (ev) => {
        var key = ev.detail.id;
        closestMatch(key, 'scroll');
        });
    pbEvents.subscribe('pb-highlight-off', null, (ev) => {
         clearHighlights();
        });
});

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
    })
    // Hide/show the spans for clicking. The already contain an inline event listener
    var spans = document.querySelectorAll('.syncSpan')
    spans.forEach(span => {
        if (this.active) {
            span.classList.remove('hide');
        } else {
            span.classList.add('hide')
        }
    })
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
    })
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
    closestMatch(key, 'click');
};

//When there is no exact match, hightlight in a different color the closest one
function closestMatch(key, mode) {
    const source = key.split("_").pop();
    var panels = document.querySelectorAll('pb-panel');
    panels.forEach(panel => {
        const values = []
        const spans = panel.querySelectorAll('*[data-ref]');
        spans.forEach(span => {
            var ref = span.dataset.ref
            values.push(ref.split("_").pop())
            });
        if (values.includes(source) == false) {
            const closest = values.reduce((a, b) => {
                return Math.abs(b - source) < Math.abs(a - source) ? b : a;
                });
            switch (mode) {
                case 'scroll':
                    var highlights = panel.querySelectorAll('pb-highlight');
                    highlights.forEach(pb => {
                        if (pb.getAttribute('key').split("_").pop() == closest) {
                        pb.style.backgroundColor = 'var(--highlight-closest-color)';
                        pb.classList.add('closeMatch')
                        } });
                    break;
                default: 
                    spans.forEach(span => {
                    if (span.dataset.ref.split("_").pop() == closest) {
                        span.style.backgroundColor = 'var(--highlight-closest-color)';
                        span.scrollIntoView({block: "center", behavior: "instant"})
                        }
                    })
            }
          }
        })
    };

function clearHighlights() {
    var spans = document.querySelectorAll('[data-ref], .closeMatch');
    spans.forEach(span => {
        span.style.backgroundColor = 'inherit'
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
            pb.classList.remove('hide')
        } else if (syncModeScroll.active) {
            pb.removeAttribute('disabled');
            pb.setAttribute('scroll', 'true');
        } else if (syncModeClick.active) {
            pb.classList.add('hide')
            }
    });
    var spans = panel.querySelectorAll('.syncSpan');
    spans.forEach(span => {
        if (button.active) {
            span.classList.add('hide')
        } else if (syncModeClick.active) {
            span.classList.remove('hide')
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