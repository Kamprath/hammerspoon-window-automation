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
 * Set fullscreen mode button text
 * @param  {jQuery} $el     [description]
 * @param  {bool} enabled 	[description]
 */
function renderFullscreenModeBtn($el, enabled) {
	$el.text(
		(enabled) ? 'Disable Fullscreen Mode' : 'Enable Fullscreen Mode'
	);
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

// register click-event handlers for buttons that represent Hammerspoon URLs
bindEvents('click', document.querySelectorAll('[data-hs-url]'), handleHsUrlBtnClick);

// close web view on Esc key
document.addEventListener('keyup', function(e) {
	if (e.keyCode == 27) {
		window.location = 'hammerspoon://closeWebView';
	}
});

var $fullscreenModeBtn = $('#toggleFullScreenMode');

// toggle fullscreen mode on
$fullscreenModeBtn.on('click', function(e) {
	data.isFullscreenModeEnabled = !data.isFullscreenModeEnabled;

	renderFullscreenModeBtn($(this), data.isFullscreenModeEnabled);

	window.location = (data.isFullscreenModeEnabled) ? 'hammerspoon://enableFullscreenMode' : 'hammerspoon://disableFullscreenMode';
});

renderFullscreenModeBtn($fullscreenModeBtn, data.isFullscreenModeEnabled);