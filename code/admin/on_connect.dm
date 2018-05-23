client
	var/datum/rank/rank

client/proc/setup_admin()
	if(rank)
		rank.remove(src)

	if(staff[lowertext(ckey)])
		rank = ranks[staff[lowertext(ckey)]]
		rank.embue(src)
	else
		rank = ranks["user"]