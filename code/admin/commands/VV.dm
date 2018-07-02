/var/list/view_variables_hide_vars = list("bound_x", "bound_y", "bound_height", "bound_width", "bounds", "parent_type", "step_x", "step_y", "step_size")

/datum/proc/get_vv_header()
	return "<h3>[src.type]\ref[src]</h3>"

/proc/get_vv_header_list(var/list/L)
	return "<h3>list()</h3>"

/atom/get_vv_header()
	return "<h3>\icon[src][name] [src.type]\ref[src] </h3>"

/client/proc/get_vv_header()
	return "<h3>[ckey]</h3>"

/client/var/marked

/client/proc/vv_escape(var/V)
	if(V=="null")
		return "null"
	if(istype(V,/datum))
		var/datum/D = V
		return "<a href='?src=\ref[src];action=VV;tar=\ref[D]'>[html_encode(D.type)]</a>"
	if(istype(V,/list))
		var/list/L = V
		return "<a href='?src=\ref[src];action=VV;tar=\ref[L]'>list([L.len])</a>"
	if(istype(V,/client))
		var/client/L = V
		return "<a href='?src=\ref[src];action=VV;tar=\ref[L]'>client([L.ckey])</a>"
	return html_encode(V)

/proc/get_vv_sorted_list(list/D)
	var/list/variables = list()
	for(var/x in D)
		if(x in view_variables_hide_vars)
			continue
		variables += x
	return sortList(variables)



/client/proc/debug_controller(var/datum/C in list(power_controller,mob_controller,turf_controller,physics_controller))
	set name = "Debug Controller"
	set category = "Debug"
	view_variables(C)

/client/proc/make_actions(var/A,var/name)
	var/s = ""
	s += "<a href='?src=\ref[src];action=EDIT;tar=\ref[A];name=\ref[name]'>\[E]</a> <a href='?src=\ref[src];action=CHANGE;tar=\ref[A];name=\ref[name]'>\[C]</a>"
	return s

/client/proc/view_variables(var/A in world)
	set name = "View Variables"
	set category = "Debug"

	var/html = "<a href='?src=\ref[src];action=VV;tar=\ref[A]'>Refresh</a><br>"
	if(marked == A)
		html += "<font color=red>Marked</font><br>"
	else
		html += "<a href='?src=\ref[src];action=MARK;tar=\ref[A]'>Mark as Active Object</a><br>"

	var/list/vars
	if(istype(A,/datum)||istype(A,/client))
		var/datum/D = A
		html += "[D.get_vv_header()]<br>"
		vars = D.vars
	else
		var/list/L = A
		html += "[get_vv_header_list(A)]<br>"
		vars = L

	html += "<table>"
	html += "<tr><th>actions</th><th>var</th><th>value</th></tr>"

	for(var/name in get_vv_sorted_list(vars))
		html += "<tr><td>[make_actions(A,name)]</td><td>[vv_escape(name)]</td><td>[vv_escape(vars[name])]</td></td>"

	usr << browse(html,"window=variables")

/client/Topic(href,href_list[])
	switch(href_list["action"])
		if("VV")
			var/D = locate(href_list["tar"])
			view_variables(D)
			return
		if("EDIT")
			var/D = locate(href_list["tar"])
			var/N = locate(href_list["name"])
			modify_variable(D,N,1)
			view_variables(D)
		if("CHANGE")
			var/D = locate(href_list["tar"])
			var/N = locate(href_list["name"])
			modify_variable(D,N,0)
			view_variables(D)
		if("MARK")
			var/D = locate(href_list["tar"])
			marked = D
			view_variables(D)