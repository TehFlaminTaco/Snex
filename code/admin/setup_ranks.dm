var/list/staff = list()
var/list/ranks = list()

/proc/setup_ranks()
	staff = json_decode(file2text("config/admins.txt"))

	var/rank_text = file2text("config/ranks.txt")
	var/list/J = json_decode(rank_text)
	for(var/name in J)
		var/list/R_json = J[name]
		var/datum/rank/R = new()
		R.name = name
		if(R_json["color"])
			R.color = rgb(R_json["color"][1], R_json["color"][2], R_json["color"][3])

		if(R_json["perms"])
			var/list/Pms = R_json["perms"]
			for(var/L in Pms)
				R.perms += perms[L]

		ranks[lowertext(name)] = R

	world.log << J