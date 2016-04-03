$(document).ready(function() {
  $(".fadeMe").hide();
  $(".fadeMe").fadeToggle(555);
  var $window = $(window);
  var h = $window.height();
  var junk = manageHeights(h);
});

$(window).resize(function() {
  var $window = $(window);
  var h = $window.height();
  var junk = manageHeights(h);
});

function manageHeights(h) {
	$(".section1").height(h*80/100);
  $(".section3").height(h*75/100);
  $(".section5").height(h*75/100);
  $(".section7").height(h);
  $(".section7").css("padding-top", h*40/100+"px");
  return 1;              // The function returns the product of p1 and p2
}