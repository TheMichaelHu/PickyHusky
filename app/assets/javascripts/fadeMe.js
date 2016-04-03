$(document).ready(function() {
  $(".fadeMe").hide();
  $(".fadeMe").fadeToggle(555);
  var $window = $(window);
  var h = $window.height()*80/100;
  $(".section1").height(h);
});

$(window).resize(function() {
  var $window = $(window);
  var h = $window.height()*80/100;
  $(".section1").height(h);
});
