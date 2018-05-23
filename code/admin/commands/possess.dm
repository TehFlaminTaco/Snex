/client/proc/possess(var/mob/H in world)
	set name = "Possess"
	set category = "Debug"
	if(!H.client)
		H.client = usr.client