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
			// Edit
			if(xhr.status == '204') {
				window.location.replace("/");
			// New Signup
			} else {
				// Raise google analytics event
				ga('send', 'event', 'Registration', 'success')
				window.location.reload();
			}
		}
		// Error
		if(xhr.status == '422') {
			errorText = "";
			$.each(jQuery.parseJSON(xhr.responseText).errors, function(key, value) {
				parseError(key, value[0]);
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

function parseError(key, value) {
	switch(key) {
		case "user_name": errorText += "<span>User name ";
			switch(value) {
				case "can't be blank": errorText += " is required.</span>";
					break;
				default: errorText += value + "</span>";
			};
			break;
		case "email": errorText += "<span>Email ";
			switch(value) {
				case "can't be blank": errorText += " is required.</span>";
					break;
				default: errorText += value + "</span>";
			};
			break;
		case "password": errorText += "<span>Password ";
			switch(value) {
				case "can't be blank": errorText += " is required.</span>";
					break;
				case "is too short (minimum is 8 characters)": errorText += " must be at least 8 characters long.</span>"
					break;
				default: errorText += value + "</span>";
			};
			break;
		case "password_confirmation": errorText += "<span>Password confirmation ";
			switch(value) {
				case "doesn't match Password": errorText += "doesn't match.</span>";
					break;
				default: errorText += value + "</span>";
			};
			break;
		default: errorText += "<span>" + key + " " + value + "</span>";
	};
	//errorText += "<span>" + key + " " + value + "</span>";
};