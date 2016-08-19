function showMessage(msg) {
	window.location = 'hammerspoon://showMessage?message=' + msg;
}

// bind event handler to buttons
var buttons = document.querySelectorAll('[data-hs-url]');
for (var i = 0; i < buttons.length; i++) {
	buttons[i].addEventListener('click', handleHsUrlBtnClick);
}

function handleHsUrlBtnClick(e) {
	e.preventDefault();

	var url = e.target.getAttribute('data-hs-url'),
		message = e.target.getAttribute('data-hs-message');

	if (!url) {
		return;
	}

	if (message) {
		showMessage(message);
	}

	window.location = 'hammerspoon://' + url;
	
	return false;
}