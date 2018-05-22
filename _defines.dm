
#define NORTH 1
#define NORTHEAST 5
#define EAST 4
#define SOUTHEAST 6
#define SOUTH 2
#define SOUTHWEST 10
#define WEST 8
#define NORTHWEST 9

#define ICON_SIZE world.icon_size

var/adjecent = list(NORTH,SOUTH,EAST,WEST)

proc/mirror_dir(var/d)
	if(d == 1)
		return 2
	if(d == 2)
		return 1
	if(d == 4)
		return 8
	if(d == 8)
		return 4

proc/dir_x(var/d)
	return ((d&EAST)>0)-((d&WEST)>0)

proc/dir_y(var/d)
	return ((d&NORTH)>0)-((d&SOUTH)>0)


// Returns an integer given a hexadecimal number string as input.
/proc/hex2num(hex)
	if (!istext(hex))
		return

	var/num   = 0
	var/power = 1
	var/i     = length(hex)

	while (i)
		var/char = text2ascii(hex, i)
		switch(char)
			if(48)                                  // 0 -- do nothing
			if(49 to 57) num += (char - 48) * power // 1-9
			if(97,  65)  num += power * 10          // A
			if(98,  66)  num += power * 11          // B
			if(99,  67)  num += power * 12          // C
			if(100, 68)  num += power * 13          // D
			if(101, 69)  num += power * 14          // E
			if(102, 70)  num += power * 15          // F
			else
				return
		power *= 16
		i--
	return num

/proc/GetRedPart(const/hexa)
	return hex2num(copytext(hexa,2,4))

/proc/GetGreenPart(const/hexa)
	return hex2num(copytext(hexa,4,6))

/proc/GetBluePart(const/hexa)
	return hex2num(copytext(hexa,6,8))

/proc/lerp(var/col1,var/col2,var/amt)
	var r1 = GetRedPart(col1)
	var g1 = GetGreenPart(col1)
	var b1 = GetBluePart(col1)
	var r2 = GetRedPart(col2)
	var g2 = GetGreenPart(col2)
	var b2 = GetBluePart(col2)

	return rgb(
		r1 + (r2 - r1)*amt,
		g1 + (g2 - g1)*amt,
		b1 + (b2 - b1)*amt
	)

/proc/inv_adj(var/d)
	switch(d)
		if(NORTH)
			return SOUTH
		if(SOUTH)
			return NORTH
		if(EAST)
			return WEST
		if(WEST)
			return EAST
	return NORTH