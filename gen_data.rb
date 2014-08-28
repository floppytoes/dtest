require 'bloom_libs/bloom_lib_table.rb'

testdata_directory = "testdata"


if ARGV.length == 0 || ARGV[0] =~ /^[-\/]h(elp)?$/
	puts "usage: #{$0} <input_file>"
	exit
end

debug_trace = false


in_fn = ARGV[0]

unless File.exist?(in_fn)
	puts "cannot load #{in_fn}"
	exit
end

unless File.directory?(testdata_directory)
	puts "cannot find dir #{testdata_directory}"
	exit
end



in_f = File.open(in_fn, "r")
iline = 0
sqlout_fn = false
qout_fn = false
tableList = []
curTable = false
sqlin_fn = []
qin_fn = []
while (line = in_f.gets)
	iline = iline + 1 
	#print "#{iline}: #{line}"
	if line =~ /^\s*#/ or line =~ /^\s*$/
		# skip comments and blank line
	elsif line =~ /^\s*\[sqlout=(.*)\]\s*$/
		sqlout_fn = $1
	elsif line =~ /^\s*\[qout=(.*)\]\s*$/
		qout_fn = $1
	elsif line =~ /^\s*\[sqlin=(.*)\]\s*$/
		sqlin_fn << $1
	elsif line =~ /^\s*\[qin=(.*)\]\s*$/
		qin_fn << $1
	elsif line =~ /^\s*\[gentableinternal=\"?(\w*)\"?\s+(\d+)\]/
		if debug_trace then puts "gentableinternal: #{$1} #{$2}" end
		if curTable 
			puts "error: found new gentableinternal without ending #{cur_table}"
			exit
		end

		tableName = $1
		numRows = $2.to_i
		
		if tableName == "internal_abcde"
			table_names = ["a", "b", "c", "d", "e"]
			table_names.each do |i|
				t = Table.new(i)

				t.addfield("ordcol","count")
				t.addfield(i + "f1","rand",1,10)
				t.addfield(i + "f2","rand",1,100)
				t.addfield(i + "f3","rand",1,1000)
				t.addfield(i + "f4","rand",1,10000)
				t.addfield(i + "f5", "Wrand")
				t.addfield(i + "f6", "Wrand")
				t.addfield(i + "f7", "Wrand")
				t.addfield(i + "f8", "Wrand")
				t.addfield(i + "f9", "Wrand")
				t.addfield(i + "f10","rand",1,1000000000)
				t.generate(numRows)
				tableList << t
			end
		else
			puts "error: does not match any internal tables"
			exit
		end
	elsif line =~ /^\s*\[gentable=\"?(\w*)\"?\s+$/
		if curTable 
			puts "error: found new gentable #{$1} without ending #{cur_table}"
			exit
		end
		curTable = Table.new($1)
		if debug_trace then puts "creating table: #{$1}" end

	elsif line =~ /^\s*(\d+)\]\s*$/
		# end of table note: generate and move on
		if curTable 
			if debug_trace then puts "ending table and generating #{$1}" end
			curTable.generate($1.to_i)
			tableList << curTable
			curTable = false

		else
			puts "error: no cur_table established"		
			exit
		end
	elsif line =~ /^\s*\[ordcol\]\s*$/
		curTable.addfield("ordcol","count")
	elsif line =~ /^\s*\[field=\"?(\w+)\"?\s+type=\"?(\w+)\"?(.*)\]$/
		# new table field.....

		field = $1
		type = $2
		valstr = $3
		#puts "field: #{field} type: #{type} vals: \"#{valstr}\""

	
		#########################
		if type == "varchar"
			if valstr =~ /^\s*values=(.*)$/
				valstr = $1
			else
				puts "help"
				exit
			end

			# skip prefixed whitespace, then get to word or quote
			newvals = []
			while true
				if valstr =~ /^\s*$/
					break
				elsif valstr =~ /^\s*\"([\w\s]*)\"(.*)$/   # hit a quoted word/space combo
					newvals << $1
					valstr = $2
				elsif valstr =~ /^\s*(\w*)(.*)$/   # ws separator
					newvals << $1
					valstr = $2
				else
					puts "help"
					exit
				end
			end

			#puts "addfield(#{field},#{type},#{newvals[0]})"
			curTable.addfield(field,type,*newvals)


		#########################
		elsif type == "integer" and valstr =~ /^\s*values=\s*(.*)$/   
			valstr = $1
			ints_as_strings = valstr.split(" ")
			newvals = []
			ints_as_strings.each do |x|
				newvals << x.to_i
			end
			# need to splat with *  --> turns the array into a bunch of args
			curTable.addfield(field,type,*newvals)

		#########################		
		elsif type == "rand" and valstr =~ /^\s*(\d+)\s+(\d+)\s*$/
			x, y = $1.to_i, $2.to_i
			curTable.addfield(field,type,x,y)
		end

		#########################
		if type == "Wrand" 
			curTable.addfield(field,type)
		end

	##################### end section of identifying types
	elsif (line =~ /^\s*\[/)
		puts "help again A"
		exit
	else
		puts "help again B"
		puts "line: #{line}"
		exit

	end
end


# read in static data

sqldata_static = []
sqlin_fn.each do |x|
	if debug_trace then puts "loading #{x} as static sql" end
	if File.exist?(x)
		infile = File.open(x, "r")
		while (line = infile.gets)
			sqldata_static << line
		end
	else
		puts "error: could not load file #{x}"
		exit
	end
end

qdata_static = []
qin_fn.each do |x|
	if debug_trace then puts "loading #{x} as static q" end
	if File.exist?(x)
		infile = File.open(x, "r")
		while (line = infile.gets)
			qdata_static << line
		end
	else
		puts "error: could not load file #{x}"
		exit
	end
end

# open files for writing

if sqlout_fn 
	sqlout = File.open(testdata_directory + "/" + sqlout_fn, "w") 

	# static data
	sqldata_static.each do |x|
		sqlout.puts x
	end
	
	# random data
	sqldata_gen = []
	tableList.each do |x|
		sqldata_gen << x.sql
	end

	# write generated data
	sqldata_gen.each do |x|
		sqlout.puts x
	end
end

if qout_fn   
	qout = File.open(testdata_directory + "/" + qout_fn, "w")

	# static data
	qdata_static.each do |x|
		qout.puts x
	end

	# random data
	qdata_gen = []
	tableList.each do |x|
		qdata_gen << x.q
	end

	# write generated data
	qdata_gen.each do |x|
		qout.puts x
	end
end



exit
# random data




puts "sqlout_fn: #{sqlout_fn}"
puts "qout_fn:   #{qout_fn}"




sqlin_fn.each do |x|
	puts "load #{x}"
end

qin_fn.each do |x|
	puts "load #{x}"
end



