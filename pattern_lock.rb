#original display 
$OGdisplay = ["        o                   o                   o",\
              "                                                 ",\
              "                                                 ",\
              "                                                 ",\
              "    o                   o                   o    ",\
              "                                                 ",\
              "                                                 ",\
              "                                                 ",\
              "o                   o                   o        ",\
              "                                                 ",\
              "        o                   o                   o",\
              "                                                 ",\
              "                                                 ",\
              "                                                 ",\
              "    o                   o                   o    ",\
              "                                                 ",\
              "                                                 ",\
              "                                                 ",\
              "o                   o                   o        ",\
              "                                                 ",\
              "        o                   o                   o",\
              "                                                 ",\
              "                                                 ",\
              "                                                 ",\
              "    o                   o                   o    ",\
              "                                                 ",\
              "                                                 ",\
              "                                                 ",\
              "o                   o                   o        "]
			
#original varables

$OGdot_usage =[[[false,false,false],[false,false,false],[false,false,false]],\
               [[false,false,false],[false,false,false],[false,false,false]],\
               [[false,false,false],[false,false,false],[false,false,false]]]
pass1 = []
pass2 = []
insert = false

#methods

def title_image()
	puts "        o-------------------o-------------------o"
	puts "       /|                                      /|"
	puts "      / |                                     / |"
	puts "     /  |                                    /  |"
	puts "    o   |               o                   o   |"
	puts "   /    |                                  /    |"
	puts "  /     |                                 /     |"
	puts " /      |                                /      |"
	puts "o-------------------o-------------------o       |"
	puts "|       |                               |       |"
	puts "|       o                   o           |       o"
	puts "|       |                               |       |"
	puts "|       |                               |       |"
	puts "|       |                               |       |"
	puts "|   o   |               o               |   o   |"
	puts "|       |                               |       |"
	puts "|       |                               |       |"
	puts "|       |                               |       |"
	puts "o       |           o                   o       |"
	puts "|       |                               |       |"
	puts "|       o-------------------o-----------|-------o"
	puts "|      /                                |      / "
	puts "|     /                                 |     /  "
	puts "|    /                                  |    /   "
	puts "|   o                   o               |   o    "
	puts "|  /                                    |  /     "
	puts "| /                                     | /      "
	puts "|/                                      |/       "
	puts "o-------------------o-------------------o        "
end

def display() #display cube
	$display.each{ |x| puts x }
	return nil
end

def find_dot_display_arr(dot) #find dot in display array
	origin = [8,0] #origin (0,0,0) in the display array
	find_dot = origin 
	x = dot[0].to_i
	y = dot[1].to_i
	z = dot[2].to_i
	
	#x axis
	if x == 1 #if dot[0] == 0, will be at origin
		find_dot[1] += 20
	elsif x == 2
		find_dot[1] += 40
	end
	#y axis
	if y == 1 #if == 0, will be at origin
		find_dot[0] += 10
	elsif y == 2
		find_dot[0] += 20
	end
	#z axis
	if z == 1 #if == 0, will be at origin
		find_dot[0] -= 4
		find_dot[1] += 4
	elsif z == 2
		find_dot[0] -= 8
		find_dot[1] += 8
	end
	return find_dot
end

def x_change_display(dot) #use coordinates of dot to draw in x axis, +ve direction, by length 1
	find_dot = find_dot_display_arr(dot)
	for i in 1...20
		$display[find_dot[0]][find_dot[1]+i] = "-"
	end
	return nil
end

def y_change_display(dot)
	find_dot = find_dot_display_arr(dot)
	for i in 1..9
		$display[find_dot[0]+i][find_dot[1]] = "|"
	end
	return nil
end

def z_change_display(dot)
	find_dot = find_dot_display_arr(dot)
	for i in 1..3
		$display[find_dot[0]-i][find_dot[1]+i] = "/"
	end
	return nil
end

def used?(dot, r=true) #toggle dot to be used, sometimes checks if dot is used
	x = dot[0].to_i
	y = dot[1].to_i
	z = dot[2].to_i
	
	if $dot_usage[x][y][z] == false
		$dot_usage[x][y][z] = true
		usage = false
	else
		usage = true
	end
	
	if r == false #return?
		return nil
	elsif r == true
		return usage
	end
end

def number_usage() #count number of dots used -auto break if cube is full & reject pass if <5 dots connected
	num_dots_used = 0
	for x in 0..2
		for y in 0..2
			for z in 0..2
				num_dots_used += 1 if $dot_usage[x][y][z] == true
			end
		end
	end
	return num_dots_used
end

def valid_input?(i) #(xyz) must be a number between 0-2
	return false if i.length != 3
	if (i[0].to_i==0 || i[0].to_i==1 || i[0].to_i==2) && (i[1].to_i==0 || i[1].to_i==1 || i[1].to_i==2) && (i[2].to_i==0 || i[2].to_i==1 || i[2].to_i==2)
		return true
	else
		return false
	end
end

def valid_vector?(x_change, y_change, z_change) #vector must be parallel to x,y or z axis
	if (x_change==0 && y_change==0 && z_change!=0) || (x_change==0 && y_change!=0 && z_change==0) || (x_change!=0 && y_change==0 && z_change==0)
		return true
	else
		return false
	end
end

=begin
program runs here...
=end

puts "Welcome to cube-lock"
title_image
puts "For each axis (xyz) select a number between 0-2"
puts "For example, 000 would mean x=0, y=0, z=0"
puts "Each dot can only be used once"
puts "Only vectors parallel to the x, y or z axis are allowed"
puts "Input e to save password"


for i in 1..2 #draw password again to ensure pass is same

	$dot_usage = Marshal.load(Marshal.dump($OGdot_usage))
	$display = Marshal.load(Marshal.dump($OGdisplay))

	puts "Draw password again to confirm" if i == 2

	while true #break at 216
		print "Input first dot number(xyz):"
		previous = gets.chomp
		if valid_input?(previous)
			used?(previous, false)
			break
		else
			puts "Please enter a valid input"
		end
	end

	if i == 1 #insert 1st num into pass
		pass1 << previous
	elsif i == 2
		pass2 << previous
	end

	while true #break at 235 & 242
		print "Input next dot number:"
		input = gets.chomp
		num_dots_used = number_usage

		if input.upcase == "E" #when input e
			if num_dots_used >=5
				break
			else
				puts "Must connect at least 5 dots, please continue"
				next
			end
		end

		if valid_input?(input) == false #if input is invalid
			puts "Please enter a valid input"
			next
		end

		x_change = input[0].to_i - previous[0].to_i #calcalate vector
		y_change = input[1].to_i - previous[1].to_i
		z_change = input[2].to_i - previous[2].to_i
		if valid_vector?(x_change, y_change, z_change) == false
			puts "vector must be parallel to x,y or z axis"
			next
		end
		
		if used?(input) #if dot is used, reject
			puts "Dot has been used"
			next
		end
		
		if x_change != 0 #update cube for vectors in x axis
			if x_change == 1
				x_change_display(previous) 
			elsif x_change == 2 #connect all dots if vector length == 2
				x_change_display(previous)
				tmp = previous.dup
				tmp[0] = "1"
				x_change_display(tmp.to_s)
				insert = !used?(tmp.to_s) #insert middle dot if not used in pass
				used?(tmp.to_s, false)
			elsif x_change == -1
				x_change_display(input)
			elsif x_change == -2
				x_change_display(input)
				tmp = input.dup
				tmp[0] = "1"
				x_change_display(tmp.to_s)
				insert = !used?(tmp.to_s)
				used?(tmp.to_s, false)
			end
		elsif y_change !=0 #update cube for vectors in y axis
			if y_change == 1
				y_change_display(previous)
			elsif y_change == 2
				y_change_display(previous)
				tmp = previous.dup
				tmp[1] = "1"
				y_change_display(tmp.to_s)
				insert = !used?(tmp.to_s)
				used?(tmp.to_s, false)
			elsif y_change == -1
				y_change_display(input)
			elsif y_change == -2
				y_change_display(input)
				tmp = input.dup
				tmp[1] = "1"
				y_change_display(tmp.to_s)
				insert = !used?(tmp.to_s)
				used?(tmp.to_s, false)
			end
		elsif z_change !=0 #update cube for vectors in z axis
			if z_change == 1
				z_change_display(previous)
			elsif z_change == 2
				z_change_display(previous)
				tmp = previous.dup
				tmp[2] = "1"
				z_change_display(tmp.to_s)
				insert = !used?(tmp.to_s)
				used?(tmp.to_s, false)
			elsif z_change == -1
				z_change_display(input)
			elsif z_change == -2
				z_change_display(input)
				tmp = input.dup
				tmp[2] = "1"
				z_change_display(tmp.to_s)
				insert = !used?(tmp.to_s)
				used?(tmp.to_s, false)
			end
		end
		
		if insert #insert middle dot if not used in pass
			if i == 1
				pass1 << tmp.to_s
			elsif i == 2
				pass2 << tmp.to_s
			end
			insert = false
		end
		
		if i == 1 #insert input into pass
			pass1 << input
		elsif i == 2
			pass2 << input
		end
		
		previous = input
		display()

		if num_dots_used >= 27 #break if all dots are used
			puts "All dots are used"
			break
		end
	end
end

if pass1 == pass2 #compare
	puts "Both passwords match"
else 
	puts "Both password do not match"
end
