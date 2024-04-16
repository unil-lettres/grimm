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

window.addEventListener("WebComponentsReady", () => {
  var button = document.getElementById('scroll');

  button.addEventListener('change', function () {
    var highlights = document.querySelectorAll('pb-highlight');
    for (var i = 0; i < highlights.length; i++) {
         if (button.active) {
             highlights[i].removeAttribute('disabled');
         } else {
              highlights[i].setAttribute('disabled', 'true');
             }
    }
  });
});