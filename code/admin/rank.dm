/datum/rank
	var/name = "Generic Rank"
	var/list/perms = list()
	var/color = "#00FF00"

	proc/embue(var/client/C)
		for(var/permission/P in perms)
			C.verbs += P.verbs

	proc/remove(var/client/C)
		for(var/permission/P in perms)
			C.verbs -= P.verbs

/client/verb/ooc(var/txt as text)
	set name = "OOC"
	set category = "OOC"

	world << "<font color=[rank.color]><b>OOC: [src]: [html_decode(txt)]</b></font>"