// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

$('nav').tabs();

function change_content (target) {
	$('#jobs').fadeOut();
	$('#owners').fadeOut();
	$('#loggers').fadeOut();
	$('#truckers').fadeOut();
	$('#sawmills').fadeOut();

	setTimeout(function() {
		$('#jobs').remove();
		$('#owners').remove();
		$('#loggers').remove();
		$('#truckers').remove();
		$('#sawmills').remove();
	}, 600)
	
	setTimeout(	function () {
		$.ajax({
			url: '/'+target,
			cache: false,
			success: function (html) {
				$('#inner_nav').after(html);
				$('#'+target).attr('style', 'display: none');
				$('#inner_nav').remove();
				$('#'+target).fadeIn();
		}});
	}, 600);
}