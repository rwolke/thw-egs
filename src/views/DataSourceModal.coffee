Backbone = require "backbone"
keyNormalizer = require "keyNormalizer"

module.exports = class DataSourceModal
	modal: document.getElementById 'dataSourceModal'
	inputField: document.getElementById 'dataSourceModal-input'
	saveButton: document.getElementById 'dataSourceModal-save'
	cancelButton: document.getElementById 'dataSourceModal-cancel'
	resetButton: document.getElementById 'dataSourceModal-reset'
	errorBanner: document.getElementById 'dataSourceModal-error'
	
	constructor: (@app) ->
		@saveButton.addEventListener 'click', @save
		@cancelButton.addEventListener 'click', @cancel
		@resetButton.addEventListener 'click', @reset
	
	reset: (evt) =>
		@inputField.value = App.defaultSource
	
	save: (evt) =>
		keygid = keyNormalizer @inputField.value, true
		if keygid
			@errorBanner.style.display = 'none'
			@app.navigate keygid.join('/'), trigger:true
		else
			@errorBanner.style.display = ''
			do evt.preventDefault
			do evt.stopPropagation
