// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

$('nav').tabs();

var states = ["AL", "AK", "AZ", "AR", "CA", "CO", "CT", "DE", "DC", "FL", "GA", "HI", "ID", "IL", "IN", "IA", "KS", "KY", "LA", "ME", "MD", "MA", "MI", "MN", "MS", "MO", "MT", "NE", "NV", "NH", "NJ", "NM", "NY", "NC", "ND", "OH", "OK", "OR", "PA", "RI", "SC", "SD", "TN", "TX", "UT", "VT", "VA", "WA", "WV", "WI", "WY"];

function change_content (target, tab, time) {
	setTimeout(function() {
		change_content(target, tab)
	}, time);
}


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

function fadeRemove(element) {
	setTimeout(function() {
		$(element).remove();
	}, 620);
}

function refresh_all_entries (type) {
	$.ajax ({
		url: '/all_'+type+'_entries',
		cache: false,
		success: function (html) {
			$('.all_entries_row').each(function () { $(this).remove()})
			$('.species_edit_rows').each(function () { $(this).remove()})
			$('#all_entries table tbody').append(html);
		}		
	});
}

/**
*
*  Base64 encode / decode
*  http://www.webtoolkit.info/
*
**/
 
var Base64 = {
 
	// private property
	_keyStr : "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=",
 
	// public method for encoding
	encode : function (input) {
		var output = "";
		var chr1, chr2, chr3, enc1, enc2, enc3, enc4;
		var i = 0;
 
		input = Base64._utf8_encode(input);
 
		while (i < input.length) {
 
			chr1 = input.charCodeAt(i++);
			chr2 = input.charCodeAt(i++);
			chr3 = input.charCodeAt(i++);
 
			enc1 = chr1 >> 2;
			enc2 = ((chr1 & 3) << 4) | (chr2 >> 4);
			enc3 = ((chr2 & 15) << 2) | (chr3 >> 6);
			enc4 = chr3 & 63;
 
			if (isNaN(chr2)) {
				enc3 = enc4 = 64;
			} else if (isNaN(chr3)) {
				enc4 = 64;
			}
 
			output = output +
			this._keyStr.charAt(enc1) + this._keyStr.charAt(enc2) +
			this._keyStr.charAt(enc3) + this._keyStr.charAt(enc4);
 
		}
 
		return output;
	},
 
	// public method for decoding
	decode : function (input) {
		var output = "";
		var chr1, chr2, chr3;
		var enc1, enc2, enc3, enc4;
		var i = 0;
 
		input = input.replace(/[^A-Za-z0-9\+\/\=]/g, "");
 
		while (i < input.length) {
 
			enc1 = this._keyStr.indexOf(input.charAt(i++));
			enc2 = this._keyStr.indexOf(input.charAt(i++));
			enc3 = this._keyStr.indexOf(input.charAt(i++));
			enc4 = this._keyStr.indexOf(input.charAt(i++));
 
			chr1 = (enc1 << 2) | (enc2 >> 4);
			chr2 = ((enc2 & 15) << 4) | (enc3 >> 2);
			chr3 = ((enc3 & 3) << 6) | enc4;
 
			output = output + String.fromCharCode(chr1);
 
			if (enc3 != 64) {
				output = output + String.fromCharCode(chr2);
			}
			if (enc4 != 64) {
				output = output + String.fromCharCode(chr3);
			}
 
		}
 
		output = Base64._utf8_decode(output);
 
		return output;
 
	},
 
	// private method for UTF-8 encoding
	_utf8_encode : function (string) {
		string = string.replace(/\r\n/g,"\n");
		var utftext = "";
 
		for (var n = 0; n < string.length; n++) {
 
			var c = string.charCodeAt(n);
 
			if (c < 128) {
				utftext += String.fromCharCode(c);
			}
			else if((c > 127) && (c < 2048)) {
				utftext += String.fromCharCode((c >> 6) | 192);
				utftext += String.fromCharCode((c & 63) | 128);
			}
			else {
				utftext += String.fromCharCode((c >> 12) | 224);
				utftext += String.fromCharCode(((c >> 6) & 63) | 128);
				utftext += String.fromCharCode((c & 63) | 128);
			}
 
		}
 
		return utftext;
	},
 
	// private method for UTF-8 decoding
	_utf8_decode : function (utftext) {
		var string = "";
		var i = 0;
		var c = c1 = c2 = 0;
 
		while ( i < utftext.length ) {
 
			c = utftext.charCodeAt(i);
 
			if (c < 128) {
				string += String.fromCharCode(c);
				i++;
			}
			else if((c > 191) && (c < 224)) {
				c2 = utftext.charCodeAt(i+1);
				string += String.fromCharCode(((c & 31) << 6) | (c2 & 63));
				i += 2;
			}
			else {
				c2 = utftext.charCodeAt(i+1);
				c3 = utftext.charCodeAt(i+2);
				string += String.fromCharCode(((c & 15) << 12) | ((c2 & 63) << 6) | (c3 & 63));
				i += 3;
			}
 
		}
 
		return string;
	}
 
}

function validate_date(date) {
	var month = date.substr(0, 2);
	var day = date.substr(3, 2);
	var year = date.substr(6, 4);
	
	if (isNaN(parseInt(month))) {
		return false;
	} else {
		month = parseInt(month);
	}
	
	if (isNaN(parseInt(day))) {
		return false;
	} else {
		day = parseInt(day);
	}
	
	if (isNaN(parseInt(year))) {
		return false;
	} else {
		year = parseInt(year);
	}
	
	if (day < 0 || day > 31) {
		return false;
	}
	
	if (month < 0 || month > 12) {
		return false;
	}
	
	if (year < 1900 || year > 2100) {
		return false;
	}
	
	return true;
}

function shorten(str) {
	if (str.length < 16) {
		return str;
	} else {
		return str.substr(0, 16)+"..."
	}
}
