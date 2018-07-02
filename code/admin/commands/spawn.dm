/client/proc/spawn_atom(var/object as text)
	set category = "Debug"
	set desc = "(atom path) Spawn an atom"
	set name = "Spawn"

	var/list/types = typesof(/atom)
	var/list/matches = new()

	for(var/path in types)
		if(findtext("[path]", object))
			matches += path

	if(matches.len==0)
		return

	var/chosen
	if(matches.len==1)
		chosen = matches[1]
	else
		chosen = input("Select an atom type", "Spawn Atom", matches[1]) as null|anything in matches
		if(!chosen)
			return

	/*if(ispath(chosen,/turf))
		var/turf/T = get_turf(usr.loc)
		T.ChangeTurf(chosen)
	else*/
	new chosen(usr.loc)

	//log_and_message_admins("spawned [chosen] at ([usr.x],[usr.y],[usr.z])")
	//feedback_add_details("admin_verb","SA") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!