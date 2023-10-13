Backbone = require "backbone"
Bootstrap = require "bootstrap"

module.exports = Backbone.View.extend
	container: document.getElementById 'toast-container'
	template: require 'templates/Toast'

	initialize: -> 

	alert: (title, message, type = 'info', options = {}) ->
		templateElement = document.createElement('template')

		style = ''
		switch type
			when 'info' then style = 'text-bg-secondary'
			when 'error' then style = 'text-bg-danger'
			when 'warning' then style = 'text-bg-warning'
			when 'success' then style = 'text-bg-success'

		if options.animation is not undefined then options.animation = true
		if options.autohide is not undefined then options.autohide = true

		tpl = 
			hasTitle: title != null
			title: title
			message: message
			style: style
		templateElement.innerHTML = @template tpl
		toastElement = templateElement.content.firstChild

		@container.appendChild(toastElement)
		toast = new Bootstrap.Toast(toastElement, options);
		toast.show();
