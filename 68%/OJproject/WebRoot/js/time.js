var m = 120; //传个分钟数到这里	
var s = 0;

function showtime() {
	document.getElementById('m').innerHTML = m;
	document.getElementById('s').innerHTML = s;
	if(s > 0) {
		s = s - 1;
	}
	if(s == 0 && m != 0) {
		m = m - 1;
		s = 60
	}
	if(m == 0 && s == 0) {
		window.location = ''; //倒计时结束跳转到 懒人建站 http://www.51xuediannao.com/
	}
	if(m == 14 && s == 60) {
		alert("还剩最后15分钟");
		s--;
	}
}
clearInterval(settime);
var settime = setInterval(function() {
	showtime();
}, 1000);