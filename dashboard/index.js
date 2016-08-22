/**
 * Handle click of button that represent HS URLs
 * @param  {object} e 	The event object
 */
function handleHsUrlBtnClick(e) {
	e.preventDefault();

	var url = e.target.getAttribute('data-hs-url');

	if (!url) {
		return;
	}

	window.location = 'hammerspoon://' + url;
}

/**
 * Bind an event handler to elements
 * @param  {array} elements		An array of elements
 * @param  {function} handler  	The event handler function to bind to elements
 */
function bindEvents(event, elements, handler) {
	for (var i = 0; i < elements.length; i++) {
		elements[i].addEventListener(event, handler);
	}
}

// close web view on Esc key
document.addEventListener('keyup', function(e) {
	if (e.keyCode == 27) {
		window.location = 'hammerspoon://closeWebView';
	}
});

// register click-event handlers for buttons that represent Hammerspoon URLs
var buttons = document.querySelectorAll('[data-hs-url]');
bindEvents('click', buttons, handleHsUrlBtnClick);