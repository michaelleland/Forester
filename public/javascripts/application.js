// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

$('nav').tabs();

function change_content (target) {
	$('#jobs').fadeOut();
	$('#owners').fadeOut();
	$('#loggers').fadeOut();
	$('#truckers').fadeOut();
	$('#sawmills').fadeOut();
	$('#owner_receipt').fadeOut();
	$('#logger_receipt').fadeOut();

	setTimeout(function() {
		
		$.ajax({
			url: '/'+target,
			cache: false,
			success: function (html) {
				$('#jobs').remove();
				$('#owners').remove();
				$('#loggers').remove();
				$('#truckers').remove();
				$('#sawmills').remove();
				$('#owner_receipt').remove();
				$('#logger_receipt').remove();
				
				$('#inner_nav').after(html);
				$('#'+target).attr('style', 'display: none');
				$('#inner_nav').remove();
				
				$('#inner_nav ul').contents().each (function () { $(this).attr('class', '') });
				$('#'+target+"_nav").attr('class', 'selected');
				
				$('#'+target).fadeIn();
			}
		});
			
	}, 600);
}