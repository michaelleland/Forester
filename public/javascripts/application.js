// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

$('nav').tabs();

function change_content (target, tab) {
	
	var target_div = ''
	if (tab == 1) { target_div = '#setup_contents' } else if (tab == 2) { target_div = '#receipt_contents' } else if (tab == 3) { target_div = '#report_contents'};
	
	if (tab == 1 || tab == 2 || tab == 3) {
		
		$(target_div).fadeOut();
		
		setTimeout(function() {
		
			$.ajax({
				url: '/'+target,
				cache: false,
				success: function (html) {
					
					$(target_div).html(html);
					$(target_div).attr('style', 'display: none');
					
					$('#inner_nav ul').contents().each (function () { $(this).attr('class', '') });
					$('#'+target+"_nav").attr('class', 'selected_left_nav_item');
					
					$(target_div).fadeIn();
					
				}
			});
			
			
		}, 600);		
	} else if (tab == 4) {
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

function import_jobs_of_partner(owner_id, role) {
	var url = '';
	if (role == 1) {
		url = '/import_jobs_of_logger/';
	} else if (role == 2) {
		url = '/import_jobs_of_trucker/';
	}
	$.ajax ({
		url: url+owner_id,
		cache: false,
		success: function (html) {
			$('#job_selector').html(html);
		}		
	})
}

function refresh_all_entries (type) {
	$.ajax ({
		url: '/all_'+type+'_entries',
		cache: false,
		success: function (html) {
			$('.all_entries_row').each(function () { $(this).remove()})
			$('#all_entries table').append(html);
		}		
	})
}
