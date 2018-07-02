/mob/proc/UsrClick(var/atom/O,var/loc,var/control,var/params)
/mob/proc/UsrDblClick(var/atom/O,var/loc,var/control,var/params)

/client/Click(var/atom/O,var/loc,var/control,var/params)
	if(mob)
		return mob.UsrClick(O,loc,control,params)
	return ..()

/client/DblClick(var/atom/O,var/loc,var/control,var/params)
	if(mob)
		return mob.UsrDblClick(O,loc,control,params)
	return ..()