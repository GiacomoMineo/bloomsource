//Ajax
$(document).ajaxComplete(function(event, xhr, settings) {
	// Re-enable submit buttons
	$('.in-submit').prop("disabled", false);
	// Login
	if(settings.url == '/users/sign_in') {
		//Success
		if(xhr.status == '201') {
			$('#login_form .in-submit').addClass('success').attr('value', 'Success!');
			window.location.reload();
		}
		//Error
		if(xhr.status == '401') {
			$('#login_form .in-error').html(xhr.responseText);
		}
	};
	// Signup and edit
	if(settings.url == '/users') {
		// Success
		if(xhr.status == '201' || xhr.status == '204') {
			$('#signup_form .in-submit').addClass('success').attr('value', 'Success!');
			$('#user_edit_form .in-submit').addClass('success').attr('value', 'Success!');
			if(xhr.status == '204') {
				window.location.replace("/");
			} else {
				window.location.reload();
			}
		}
		// Error
		if(xhr.status == '422') {
			errorText = "";
			$.each(jQuery.parseJSON(xhr.responseText).errors, function(key, value) {
				errorText += "<span>" + key + " " + value + "</span>";
			});
			$('#signup_form .in-error').html(errorText);
			$('#user_edit_form .in-error').html(errorText);
		}
	};
	// Feedback
	if(settings.url == '/feedbacks.json') {
		// Success
		if(xhr.status == '201') {
			$('#feedback_form .in-submit').addClass('success').attr('value', 'Success!');
			setTimeout(function() {
				$('#feedback').slideUp(200);
				//reset form
				$('#feedback_form .in-submit').removeClass('success').attr('value', 'Send');
				$('#feedback_form .in-field').each(function() {
					$(this).val('');
					$(this).parent().removeClass('.in-filled');
				});
			}, 300);
		}
		// Error
		if(xhr.status == '422') {
			errorText = "<span>";
			$.each(jQuery.parseJSON(xhr.responseText), function(key, value) {
				errorText += key + " " + value + ", ";
			})
			errorText = errorText.slice(0, -2);
			errorText += "</span>";
			$('#feedback_form .in-error').html(errorText);
		}
	}
});