var timerID,
	startButton = document.querySelector('#timer_start'),
	stopButton = document.querySelector('#timer_pause'),
	resetButton = document.querySelector('#timer_reset');

// remove interface clutter
document.querySelector(".panel").remove();
for(var i=0;2>i;i++) {
	document.querySelectorAll(".six.columns")[1].remove();
}

// start watchTimer when 'start' button is clicked
startButton.addEventListener('click', function() {
	timerID = window.setInterval(startWatch, 1000);
	window.location = 'hammerspoon://log?message=Timer%20started';
});
stopButton.addEventListener('click', stopWatch);
resetButton.addEventListener('click', stopWatch);

function startWatch() {
	var timeLeft = document.querySelector('#timer_default').textContent;

	if (timeLeft !== '00:00') {
		return;
	}

	window.location = 'hammerspoon://notify?message=Time%20is%20up&sound=Blow&title=Tomato%20Timer&image=tomato_timer.png';

	stopWatch();
}
function stopWatch() {
	window.location = 'hammerspoon://log?message=Timer%20stopped';
	window.clearInterval(timerID);
}
