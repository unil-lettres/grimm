window.addEventListener("WebComponentsReady", () => {
    
    const buttonScroll = document.getElementById('scroll');
    const buttonClick = document.getElementById('click');
    
    // Adds button counterpart parameter to disable one button when clicking on the other
    buttonScroll.buttonCounterpart = buttonClick;
    buttonClick.buttonCounterpart = buttonScroll;

// Scroll sync: add event listener to scroll button to fire function 
  buttonScroll.addEventListener('change', scrollSync, false);
  
  
  // Click sync: add event listener to click button to fire function 
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
    for (var i = 0; i < disableButtons.length; i++) {
         if (disableButtons[i].active) {
             disableSync(disableButtons[i])
         } 
    }
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
     }

function scrollSync(evt) {
    disableCounterpart(this, evt.currentTarget.buttonCounterpart);
    var highlights = document.querySelectorAll('pb-highlight');
    for (var i = 0; i < highlights.length; i++) {
         if (this.active) {
             highlights[i].removeAttribute('disabled');
         } else {
              highlights[i].setAttribute('disabled', 'true');
             }
    }
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

// Disable sync for a specific panel
function disableSync(button) {
    console.log('stop sync');
    var panel = button.parentElement;
    var highlights = panel.querySelectorAll('pb-highlight');
    console.log(`highlights are ${highlights.length}}`)
    for (var i = 0; i < highlights.length; i++) {
         if (button.active) {
             highlights[i].setAttribute('disabled', 'true');
         } else {
              highlights[i].removeAttribute('disabled');
             }
    }
   };