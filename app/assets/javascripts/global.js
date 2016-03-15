/* Global */

// Scrolling function
function scrollToAnchor(id_selector){
  $('html,body').animate({ scrollTop: id_selector.offset().top - 52 }, 300);
};

// Tooltip enabler
function enable_tooltips() {
	$('[data-toggle="tooltip"]').tooltip();
};

// Group filter binder
function bind_group_filter() {
	//filter by group
	$('.group-nav-item').click(function() {
		filter_by_group($(this));
	});
};

// Group filter renderer
function filter_by_group(group_element) {
	group_id = group_element.attr('id');
	// Current filter?
	if(!group_element.hasClass('group-nav-current')) {
		$('.group-nav-current').removeClass('group-nav-current');
		group_element.addClass('group-nav-current');
		$('.entry').show();
		if(!group_element.hasClass('group-all')) {
			$('.entry:not(.' + group_id + ')').hide();
		}
	}
};

ready = function() {

	// Initialization
	//inputs
	$('.in-field').each(function() {
		$(this).val() != '' ? $(this).parent().addClass('in-filled') : $(this).parent().removeClass('in-filled');
	});
	$('.in-field').bind("propertychange change click keyup input paste", function(event) {
	  $(this).val() != '' ? $(this).parent().addClass('in-filled') : $(this).parent().removeClass('in-filled')
	});
	//disable ajax buttons before firing
	$('#login_form, #signup_form, #feedback_form').find('.in-submit').click(function() {
		$(this).prop("disabled", true);
		$(this).parents('form').submit();
	});
	//reset login and signup
	$('#signup, #login').hide();
	$('#signup-btn').removeClass('clicked');

	//user dropdown
	$('.user-toggle').click(function(e) {
		e.stopPropagation();
		$('.user-dropdown').toggle();
	});
	$('html, body').click(function() {
		if($(window).width()>768){
			$('.user-dropdown').hide();
		};
	});

	//signup and login button popups
	$('.signup-btn:not(.landing)').click(function(e) {
		e.preventDefault();
		$('.overlay').hide();
		$('#signup-popup').fadeIn(200);
		if($(window).width() < 768) {
			$('.navbar-toggle').click();
		};
	});
	$('.login-btn:not(.landing)').click(function(e) {
		e.preventDefault();
		$('.overlay').hide();
		$('#login-popup').fadeIn(200);
		if($(window).width() < 768) {
			$('.navbar-toggle').click();
		};
	});
	$('.close-popup').click(function() {
		$('.overlay').hide();
	});
	$('.popup').click(function(e) {
		e.stopPropagation();
	})
	$('.overlay').click(function() {
		$('.overlay').hide();
	});

	// Login prompt
	$('.entry-vote.not-logged, .new-entry-btn.not-logged').click(function(e) {
		e.stopImmediatePropagation();
		e.preventDefault();
		$('.overlay').hide();
		$('#prompt-popup').fadeIn(200);
	});

	//signup panel
	$('#signup-btn.landing').click(function(e) {
		e.preventDefault();
		$(this).toggleClass('clicked');
		$(this).blur();
		$('#signup').slideToggle(300);
		$('#login').slideUp(300);
		$('#login-btn.landing').removeClass('clicked');
	    if($(this).hasClass('clicked')) {
	      $('html, body').animate({
	        scrollTop: $(this).offset().top - 88
	      }, 300);
	    };
	});
	//login panel
	$('#login-btn.landing').click(function(e) {
		e.preventDefault();
		$btn_element = $(this);
		$btn_element.toggleClass('clicked');
		$('#login').slideToggle(300);
		$('#signup-btn.landing').removeClass('clicked');
		$('#signup').slideUp(300, function() {
			if($btn_element.hasClass('clicked')) {
			    $('html, body').animate({
			    	scrollTop: $btn_element.offset().top - 76
			    }, 300);
		    };
		});
	});

	//suggestions
	// Filter out cookied suggestions
	function filterTips() {
		$('.tip').each(function() { $(this).hide(); });
		$('.tip').each(function() {
			one = true;
			if(typeof(Cookies.get($(this).attr('id'))) == 'undefined') {
				$(this).show();
				one = false;
			};
			return one;
		});
	};
	
	// Bind new tips
	$('.tip-done').click(function() {
		$popup = $(this).parent();
		Cookies.set($popup.attr('id'), true);
		$popup.fadeOut(300, function() { filterTips(); });
	});

	filterTips();

	function setCookie () {
	  var argc = arguments.length, bImplGlob = typeof arguments[argc - 1] === "string";
	  if (bImplGlob) { argc++; }
	  if (argc < 3) { throw new TypeError("executeOnce - not enough arguments"); }
	  var fExec = arguments[0], sKey = arguments[argc - 2];
	  if (typeof fExec !== "function") { throw new TypeError("executeOnce - first argument must be a function"); }
	  if (!sKey || /^(?:expires|max\-age|path|domain|secure)$/i.test(sKey)) { throw new TypeError("executeOnce - invalid identifier"); }
	  if (decodeURIComponent(document.cookie.replace(new RegExp("(?:(?:^|.*;)\\s*" + encodeURIComponent(sKey).replace(/[\-\.\+\*]/g, "\\$&") + "\\s*\\=\\s*([^;]*).*$)|^.*$"), "$1")) === "1") { return false; }
	  fExec.apply(argc > 3 ? arguments[1] : null, argc > 4 ? Array.prototype.slice.call(arguments, 2, argc - 2) : []);
	  document.cookie = encodeURIComponent(sKey) + "=1; expires=Fri, 31 Dec 9999 23:59:59 GMT" + (bImplGlob || !arguments[argc - 1] ? "; path=/" : "");
	  return true;
	}

	//footer
	$('#feedback, #social').hide();
	$('.footer-links a').click(function(event) {
		id = $(this).attr('href')
		if(id == '#social' ||
		   id == '#feedback') {
		   	event.stopPropagation();
		    event.preventDefault();
		   	$('.footer-panel > div:not(' + id + ')').hide();
		   	$(id).slideToggle(200);
		} else {
			event.stopPropagation();
		}
	});
	$('.footer-panel').click(function(e) { e.stopPropagation(); });
	$('.footer-panel .close-popup').click(function() {
		$('.footer-panel > div').hide();
		$('#feedback_form .in-error').html("");
	});
	$('body,html').click(function() {
		$('.footer-panel > div').hide();
		$('#feedback_form .in-error').html("");
	});

	$('.main-content, .aside-content').stickysidebar({
      // Settings
      additionalMarginTop: 75
    });

	/*
	pad = ($('.lib-cat').width() - $('.lib-cat h2').height()) / 2;
    $('.lib-cat').css('padding-top', pad).css('padding-bottom', pad);
    $(window).resize(function() {
    	pad = ($('.lib-cat').width() - $('.lib-cat h2').height()) / 2;
    	$('.lib-cat').css('padding-top', pad).css('padding-bottom', pad);
    });
    */

	bind_group_filter();
	enable_tooltips();

	share_resource();
};

// Doc ready
$(document).ready(ready);
$(document).on('page:load', ready);
