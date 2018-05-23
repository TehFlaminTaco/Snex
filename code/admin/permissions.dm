var/list/perms = list()

/proc/setup_perms()
	for(var/T in typesof(/permission))
		if("[T]"!="/permissions")
			var/permission/P = new T()
			perms[P.name] = P

/permission
	var/name = "PERMISSIONS"
	var/list/verbs = list()
