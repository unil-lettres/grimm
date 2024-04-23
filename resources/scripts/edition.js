window.addEventListener("WebComponentsReady", () => {

// Scroll sync: add event listener to scroll button to fire function 
  var button = document.getElementById('scroll');
  button.addEventListener('change', scrollSync, false);
  
  /* If a panel is added when the scroll sync is active, click on the button
  to activate the pb-highlight elements of the new panel */
  pbEvents.subscribe("pb-refresh", 'transcription', (ev) => {
     if (button.active) {
         button.click();
         button.click()
         }
    });
});

function scrollSync() {
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