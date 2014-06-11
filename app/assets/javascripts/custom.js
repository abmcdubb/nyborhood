

/* Revolution Slider JS */

var api;
	jQuery(document).ready(function() {
		 api =  jQuery('.banner').revolution(
						{
							delay: 7000,
							
							startheight:300,
							
							hideThumbs:300,

							navigationType:"none",					//bullet, thumb, none, both		(No Thumbs In FullWidth Version !)
							navigationArrows:"verticalcentered",		//nexttobullets, verticalcentered, none
							navigationStyle:"round",				//round,square,navbar

							touchenabled:"on",						// Enable Swipe Function : on/off
							onHoverStop:"on",						// Stop Banner Timet at Hover on Slide on/off

							navOffsetHorizontal:0,
							navOffsetVertical:20,

							stopAtSlide:-1,
							stopAfterLoops:-1,

							shadow:0,								//0 = no Shadow, 1,2,3 = 3 Different Art of Shadows  (No Shadow in Fullwidth Version !)
							fullWidth:"on"							// Turns On or Off the Fullwidth Image Centering in FullWidth Modus
						});
	});
	
	
/* carousel Slider Js */

$('.img-gal .carousel').carousel({
  interval: 5000
});

$('.testimonial .carousel').carousel({
  interval: 9000
});


/* prettyPhoto Gallery */

jQuery(".prettyphoto").prettyPhoto({
   overlay_gallery: false, social_tools: false
});

/* Isotype */

// cache container
var $container = $('#portfolio');
// initialize isotope
$container.isotope({
  // options...
});

// filter items when filter link is clicked
$('#filters a').click(function(){
  var selector = $(this).attr('data-filter');
  $container.isotope({ filter: selector });
  return false;
});       

/* Inner Support page JS */

$("#slist a").click(function(e){
   e.preventDefault();
   $(this).next('p').toggle(200);
});