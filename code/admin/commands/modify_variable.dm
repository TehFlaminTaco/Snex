/proc/get_list_var(var/list/L,var/name)
	return L[name]

/proc/get_datum_var(var/datum/D,var/name)
	return D.vars[name]

/proc/set_list_var(var/list/L,var/name,var/val)
	return L[name] = val

/proc/set_datum_var(var/datum/D,var/name,var/val)
	return D.vars[name] = val


/proc/get_var(var/D,var/name)
	if(istype(D,/list))
		return get_list_var(D,name)
	return get_datum_var(D,name)

/proc/set_var(var/D,var/name,var/val)
	if(istype(D,/list))
		return set_list_var(D,name,val)
	return set_datum_var(D,name,val)

/client/proc/modify_variable(var/tar,var/var_name,var/assume)
	var/var_type = "text"
	var/val = get_var(tar,var_name)
	if(val==null)
		var_type = "null"
	else if(isnum(val))
		var_type = "num"
	else if(istext(val))
		var_type = "text"
	else if(isloc(val))
		var_type = "ref"
	else if(isicon(val))
		var_type = "icon"
	else if(istype(val,/atom)||istype(val,/datum))
		var_type = "type"
	else if(istype(val,/list))
		var_type = "list"
	else if(istype(val,/client))
		var_type = "client"
	else
		var_type = "file"

	if(var_name == "client")
		var_type = "client"

	if(!assume||var_type == "null")
		var_type = input("Select new variable type","Variable Type","text") as null|anything in list("num","text","ref","icon","type","list","file")

	usr << "Var Type selected: <b>[var_type]</b>"
	switch(var_type)
		if("num")
			val = text2num(input("New Value"))
		if("text")
			val = input("New Value")
		if("ref")
			if(marked!=null)
				val = marked
		if("icon"||"file")
			usr << "Currently Unsupported. :("
			return
		if("list")
			val = list()
			view_variables(val)
		if("client")
			var/list/candidates = list()
			var/list/keys = list()
			for(var/mob/M in world)
				if(M.client)
					var/client/C = M.client
					keys += C.ckey
					candidates[C.ckey] = C
			keys += "CANCEL"
			var/target = input("Select target client","Chance Client","CANCEL") as null|anything in keys
			if(target == "CANCEL")
				return
			val = candidates[target]
	set_var(tar,var_name,val)