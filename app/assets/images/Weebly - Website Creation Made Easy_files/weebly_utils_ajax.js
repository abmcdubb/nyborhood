
window.Weebly = window.Weebly || {};

var settingAnimations = 0;
var settingQuickExport = 0;
var settingTooltips = 0;
var uploadInProgress = 0;
var exiting = 0;
var currentTheme = '';
var ajax = '/weebly/getElements.php';
var ajaxStatusCheckTimeout = 4000;
var ajaxStatusTimeoutGrowthFactor = 1;
Weebly.ajaxLog = [];

window.onbeforeunload = function() {
	exiting = 1;
}

var myGlobalHandlers = {
	onCreate: function(ajax, t) {
		t.request.times = {
			start: new Date().getTime()
		};
		if (window.swfu && swfu.currentUpload && $('upload' + swfu.currentUpload)) {
			t.request.concurrentUpload = true;
		}
		if (!ajax.options.bgRequest) {
			startWait();
		}
		if (ajax.parameters && ajax.parameters.pos) {
			Weebly.ajaxLog.push(ajax.parameters.pos);
			if (Weebly.ajaxLog.size() > 10) {
				Weebly.ajaxLog.shift();
			}
		}
		
		ajax.options.requestHeaders = ajax.options.requestHeaders || {};
		
		// Set Weebly-Site-ID header
		if (typeof (currentSite) != "undefined") {
			ajax.options.requestHeaders['Weebly-Site-ID'] = currentSite;
		}
		if (!ajax.options.requestHeaders['x-ajax-request-id']) {
			var ajax_request_id = new Date().getTime() + '' + Math.floor(Math.random() * 999);
			ajax.options.requestHeaders['x-ajax-request-id'] = ajax_request_id;
		}
		if (ajax.options.isRetry && ajax.options.previouslyAborted) {
			ajax.options.requestHeaders['x-ajax-abort-retry'] = ajaxStatusCheckTimeout;
		}
		
		if (!ajax.options.isRetry && !Prototype.Browser.IE6) {
			setTimeout(function() {
				checkAjaxRequestStatus(ajax)
			}, ajaxStatusCheckTimeout);
		}
	},
	
	onLoading: function(ajax, t) {
		if (t.request.times && t.request.times.start) {
			t.request.times.initialized = new Date().getTime() - t.request.times.start;
		}
	},
	
	onLoaded: function(ajax, t) {
		if (t.request.times && t.request.times.start) {
			t.request.times.sent = new Date().getTime() - t.request.times.start;
			if (ajax.options.isRetry && t.request.times.sent > (ajaxStatusCheckTimeout / 2)) {
				ajaxStatusCheckTimeout = ajaxStatusCheckTimeout + ajaxStatusCheckTimeout * ajaxStatusTimeoutGrowthFactor;
				ajaxStatusTimeoutGrowthFactor = ajaxStatusTimeoutGrowthFactor * .9;
			}
		}
	},
	
	onInteractive: function(ajax, t) {
		if (t.request.times && t.request.times.start && !t.request.times.response) {
			t.request.times.response = new Date().getTime() - t.request.times.start;
		}
	},
	
	onComplete: function(ajax, t) {
		
		if (t.status == 0 && !ajax.aborted) {
			retriableErrFunc(ajax, t);
			return false;
		}
		
		if (t.request.times && t.request.times.start) {
			t.request.times.end = new Date().getTime();
			t.request.times.complete = t.request.times.end - t.request.times.start;
		}
		if (Ajax.activeRequestCount == 0) {
			endWait();
		}
		if (ajax.isRetriable()) {
			ajax.retry();
		}
		else {
			handleLogout(t, ajax);
		}
	}

};

Ajax.Responders.register(myGlobalHandlers);

/**
 * Start spinning loading animation
 * @param {string} [loadingText = 'Loading'] Change loading message
 * @param {boolean} [nodelay = false] Delay showing animation
 */
function startWait(loadingText, nodelay) {
	try {
		loadingText = loadingText || _W.tl('Loading');
		jQuery('#pleaseWait').addClass('loading').toggleClass('no-delay', !!nodelay)
			.find('.loading-text').text(loadingText);
	}
	catch (e) {}
}

/**
 * Remove spinning loading animation, reset to defaults
 */
function endWait() {
	var target;
	try {
		target = jQuery('#pleaseWait').removeClass('loading')
			.find('.loading-text').text(_W.tl('Loading'));
	}
	catch (e) {}
}

function setSetting(setting, value) {
	if (typeof (value) == "string" && value.match(/{/)) {
		value = value.replace(/^'/, '');
		value = value.replace(/'$/, '');
	}
	eval(setting + " = " + value + ";");
}

function handleLogout(t, ajax) {
	
	// Check if user is logged in; if not, redirect.
	//---- Note: This javascript redirect is for convenience purposes for the user
	//---- At this point, the user is fully logged out of the system from the
	//---- Server's perspective, so it will refuse to furnish any additional data.
	
	var header;
	try {
		header = t.getHeader("Weebly-Auth-Msg");
	}
	catch (e) {}
	
	header = header || '';
	
	if (header.match("not-logged-in")) {
		window.onbeforeunload = null;
		document.location = "/?session-expired=1";
	}
	else if (header.match("database-error")) {
		retriableErrFunc(ajax, t, header);
	}
	else if (header.match("query-error")) {
		retriableErrFunc(ajax, t, header);
	}
	else if (header.match("account-deleted")) {
		window.onbeforeunload = null;
		document.location = "logout.php";
	}
	else if (header.match("refresh-build")) {
		if (!(typeof (currentBlog) != "undefined" && currentBlog.postId && currentBlog.postId == 1 || Weebly.headerEditor
			&& Weebly.headerEditor.isEditing)) {
			window.onbeforeunload = null;
			refreshMe();
		}
	}
	else if (header.match("maintenance-soon")) {
		var maintLength = header.match(/maintenance-soon\(([^\)]+)\)/);
		window.onbeforeunload = null;
		maintenanceSoon(maintLength[1]);
	}
	
}

function maintenanceSoon(maintLength) {
	
	$('maintenanceLength').innerHTML = maintLength;
	Element.show('maintenanceDiv');
	
}

function refreshMe() {
	
	Element.show('refreshingDiv');
	Element.show('grayedOut');
	setTimeout("window.location.reload();", 4000);
	
}

function retriableErrFunc(ajax, t, header) {
	
	endWait();
	
	if (ajax.options.failSilently) {
		return;
	}
	if (exiting) {
		return;
	}
	
	if (t.status == 0) {
		showRetriableError(_W.tl('There seems to be a problem connecting to the server. Please check your Internet connection.'), ajax,
			false);
	}
	else if (header.match("database-error")) {
		showRetriableError(
			_W.tl('The system isn\'t working quite right. This is most likely a temporary glitch.<br/><br/>Please wait a bit and try again.'),
			ajax, false);
	}
	else if (header.match("query-error")) {
		showRetriableError(
			_W.tl('That didn\'t work as intended. This is most likely a temporary glitch.<br/><br/>Please wait a bit and try again.'), ajax,
			true);
	}
	
}

function errFunc(t) {
	if (t.request.isRetriable())
		return;
	
	showError(_W.tl('The system encountered an error. Please try your last request again.'), t);
}

function exceptionFunc(t, exception, xx) {
	if (t.isRetriable())
		return;
	
	if (t && (!t.getStatus || !t.getStatus() || t.getStatus() < 100 || t.getStatus() > 500)) { // will only retry if xhr or network related problem
		try {
			var options = t.options || {}, retryCount = options._retryCount || 0;
			if (retryCount <= 1) { // will retry a max of 2 times
				options._retryCount = ++retryCount;
				new Ajax.Request(t.url, options);
			}
			else {
				showError(_W.tl('The system encountered an exception. Please try your last request again.<br/><br/>')+ exception.message);
				// ^ will also report error to stats
			}
		}
		catch (e) {}
	}
	else if (window.console && console.log) {
		// couldn't throw it for some reason, so console.log it if possible
		if (typeof exception == 'object') {
			for ( var k in exception) {
				if (typeof exception[k] != 'function') {
					console.log(k + ': ' + exception[k]);
				}
			}
		}
		else {
			console.log(exception);
		}
	}
}

function checkAjaxRequestStatus(ajax) {
	if (!ajax._complete && Prototype.Browser.IE && !ajax.times.sent) {
		ajax.abort();
	}
}

Ajax.Request.addMethods({
	abort: function() {
		if (this._complete)
			return;
		
		// avoid MSIE/Mozilla calling other event handlers when aborted
		this.transport.onreadystatechange = Prototype.emptyFunction;
		this.transport.abort();
		this._complete = true;
		this.aborted = true;
		
		var response = new Ajax.Response(this);
		
		[ 'Abort', 'Complete' ].each(function(state) {
			try {
				(this.options['on' + state] || Prototype.emptyFunction)(response, response.headerJSON);
				Ajax.Responders.dispatch('on' + state, this, response, response.headerJSON);
			}
			catch (e) {
				this.dispatchException(e);
			}
		}, this);
	},
	
	retry: function(force) {
		if (force || this.isRetriable()) {
			var options = this.options || {};
			options._retryCount = (options._retryCount || 0) + 1;
			options.isRetry = true;
			options.previouslyAborted = this.aborted ? true : false;
			new Ajax.Request(this.url, options);
		}
	},
	
	isRetriable: function() {
		if (!this._complete) {
			return false;
		}
		
		var status = this.getStatus();
		var options = this.options || {};
		var maxRetries = options.maxRetries || 1;
		var retryCount = options._retryCount || 0;
		return (status == 408 || status > 10000 || this.aborted) && retryCount < maxRetries;
	}
});
