// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

$('nav').tabs();

function change_content (target, tab) {
	
	if (tab == 1) {
		
		$('#setup_contents').fadeOut();
		
		setTimeout(function() {
		
			$.ajax({
				url: '/'+target,
				cache: false,
				success: function (html) {
					
					$('#setup_contents').html(html);
					$('#setup_contents').attr('style', 'display: none');
					
					$('#inner_nav ul').contents().each (function () { $(this).attr('class', '') });
					$('#'+target+"_nav").attr('class', 'selected_left_nav_item');
					
					$('#setup_contents').fadeIn();
					
				}
			});
			
			
		}, 600);
		
	} else if (tab == 2) {
		setTimeout(function() {
			
			$('#report_contents').fadeOut();
			
			$.ajax({
				url: '/'+target,
				cache: false,
				success: function (html) {
					$('#report_contents').html(html);
					$('#report_contents').attr('style', 'display: none');
					
					$('#inner_nav ul').contents().each (function () { $(this).attr('class', '') });
					$('#'+target+"_nav").attr('class', 'selected_left_nav_item');
					
					$('#report_contents').fadeIn();
				}
			});
			
				
		}, 600);
		
	} else if (tab == 3) {
		setTimeout(function() {
			
			$('#entry_contents').fadeOut();
			
			$.ajax({
				url: '/'+target,
				cache: false,
				success: function (html) {
					$('#entry_contents').html(html);
					
					$('#entries_inner_nav ul').contents().each (function () { $(this).attr('class', 'unselected_item') });
					$('#'+target+"_nav").attr('class', 'selected_entries_nav_item');
					
					$('#entry_contents').fadeIn();
				}
			});	
		}, 600);
	}
}