/mob/proc/on_ghost()
	return 1

/client/verb/ghost()
	set name = "Ghost"
	set category = "OOC"

	if(mob.on_ghost())
		var/mob/observer/G = new()
		G.name = mob.name
		G.loc = mob.loc
		G.body = mob
		G.client = src

/mob/observer
	name = "Spooky Ghost"
	icon_state = "ghost"
	invisibility = INVIS_GHOST
	see_invisible = INVIS_GHOST
	var/mob/body


	UsrClick(var/O)
		loc = O

	verb/re_enter()
		set name = "Re-enter Body"
		set category = "Ghost"
		if(istype(body))
			if(body.client)
				alert("Someone hijacked your worm, You'll need to summon a new one.")
				body = null
				summon()
			else
				body.client = client
				del(src)
		else
			alert("You have no body to enter!")

	verb/summon()
		set name = "Summon Worm"
		set category = "Ghost"
		if(!istype(body))
			var/mob/sausage/head/wrm = new()
			wrm.client = client
			del(src)
		else
			alert("You already have a body! Go be that!")

	Move(var/atom/tar)
		if(istype(tar))
			loc = tar