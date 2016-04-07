module.exports = (someKey, silent=false, parent = null) ->
	# it is a google table link
	reg = new RegExp 'spreadsheets\/d\/([^\/]+)[^#]*(?:#.*gid=([0-9]+).*)?'
	match = reg.exec someKey
	if match
		gid = match[2] if match[2]
		return [match[1], gid]
	
	# it is just the gid
	reg = new RegExp '([0-9]+)'
	match = reg.exec someKey
	if match and parent
		parent = parent.split '/'
		gid = match[1] if match[1]
		return [parent[0], gid]
	
	# it is a short specification
	reg = new RegExp '([^\/]+)(?:\/([0-9]+))?'
	match = reg.exec someKey
	if match
		gid = match[2] if match[2]
		return [match[1], gid]
	
	if silent
		return false
	
	alert "Ungültige Datenquelle: In '#{someKey}' konnte nicht der Tabellen-Key gefunden werden!"
	return ["", 0]
