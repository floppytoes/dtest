
require './bloom_libs/bloom_lib_randword'

# bloom_lib_table.rb

class String
	def sql_type		
		sql_types = {
			'test' 							=> 'wacky',
			'integer' 					=> 'bigint',
			'int'								=> 'bigint',
			'bigint'					 	=> 'bigint',
			'float'							=> 'double precision',
			'double'						=> 'double precision',
			'double precision'	=> 'double precision',
			'varchar'						=> 'varchar',
			'date'							=> 'date',
			'text'							=> 'text',
			'rand'							=> 'bigint',
			'crand'							=> 'char',
			'Crand'							=> 'char',
			'srand'							=> 'varchar',
			'Wrand'							=> 'varchar',
			'count'							=> 'bigint'
		}
		return sql_types[self]
	end

	def q_type  # not currenty used/needed		
		q_types = {
			'integer' 					=> 'integer',
			'int'								=> 'integer',
			'float'							=> 'double precision',
			'double'						=> 'double precision',
			'double precision'	=> 'double precision',
			'varchar'						=> 'varchar',
			'date'							=> 'date',
			'text'							=> 'text',
		}
		return q_types[self]
	end
end



class Field
	def initialize(name, type, values)
#		puts "called with values: #{values}"
		@name = name
		@type = type
		# add special handling if values is an array of stuff...
		@values = values
	end

	attr_reader :name
	attr_reader :type
	attr_reader :values

	def show
		print "Field name:   ", @name, "\n"
		print "Field type:   ", @type, "\n"
		print "Field values: ", @values, "\n"
	end
end




class Table
	def initialize(name)
		@tablename = name
		@fields = []
		@sql = []
		@q = []
	end

	def addfield(name, type, *values)

		if false
			puts "name: #{name} with class #{name.class}"
			puts "type: #{type} with class #{type.class}"
			puts "values: #{values} with class #{values.class}"
		end

		f = Field.new(name, type, values)
		@fields << f
	end

	def show
		print "table: ", @tablename, " contains ", @fields.length, " fields\n"
		@fields.each do |x|
			x.show
		end
	end

	def regenerate(num_rows)
		@sql = []
		@q = []
		return self.generate(num_rows)
	end

	def generated?
		if (@sql.empty?)
			return false
		else 
			return true
		end
	end

	def sql()
		return @sql
	end

	def q()
		return @q
	end

	def generate(num_rows)
		unless (@sql.empty?)
			puts "** This object already has generated data...  aborting... **"
			return false
		end

		# get reandword class ready in case we need it
		randomWordGen = RandWordGen.new()



		line = "drop table " + @tablename + ";"
		qline = ""
		
		# create table
		@sql << line
		@q << qline
		line = "create table " + @tablename + "("
		qline = @tablename + ":([]"

		@fields.each do |x|
			if (x.type == "count")
				# fields of type count are only needed by sql, not q
				line = line + x.name + " " + x.type.sql_type + ","
				#qline = qline + x.name + ":();"		
			else
				line = line + x.name + " " + x.type.sql_type + ","
				qline = qline + x.name + ":();"
			end
		end
		# replace last comma with )
		line[line.length - 1] = ")"
		line = line + ";"
		@sql << line
		# replace last semicolon with )
		qline[qline.length - 1] = ")"
		@q << qline


		# insert into
		line = "insert into " + @tablename + "("
		@fields.each do |x|
			line = line + x.name + ","
		end
		# replace last comma with )
		line[line.length - 1] = ")"
		line = line + " values "
		@sql << line

		# generate the data 
		num_rows.times do |i|
			line = "("
			qline = "`" + @tablename + " insert("
			@fields.each do |x|
				if x.type == "count"
					line = line + (i+1).to_s + ","
					# no qline entry
				elsif x.type == "rand"
					#line = line + (i+1).to_s + ","
#######
					val = Kernel.rand(x.values[1]) + x.values[0]
					line = line + val.to_s + ","
					qline = qline + val.to_s + ";"
					# no qline entry - CHECK
				elsif x.type == "crand"
					val = (Kernel.rand(26) + 97).chr
					line = line + "\'" + val + "\',"
					qline = qline + "\"" + val + "\";"
					# no qline entry - CHECK
				elsif x.type == "Crand"
					val = (Kernel.rand(26) + 65).chr
					line = line + "\'" + val + "\',"
					qline = qline + "\"" + val + "\";"
					# no qline entry - CHECK
				elsif x.type == "Wrand"
					val = randomWordGen.get
					line = line + "\'" + val + "\',"
					qline = qline + "`$\"" + val + "\";"
				else
					r = rand(x.values.length)
					if x.type == "varchar"
						line = line + "\'" + x.values[r] + "\',"
						qline = qline + "`$\"" + x.values[r] + "\";"
					elsif x.type == "text"
						line = line + "\'" + x.values[r] + "\',"
						qline = qline + "\"" + x.values[r] + "\";"
					elsif x.type == "integer" || x.type == "bigint"
						line = line + x.values[r].to_s + ","
						qline = qline + x.values[r].to_s + ";"
					elsif (x.type == "float" || x.type == "double" || x.type == "double")
						line = line + x.values[r].to_s + ","
						qline = qline + x.values[r].to_s + ";"
					else
						print "unrecognized type: ", x.type, "\n"
						exit
					end
				end
			end
			# print "x.values[r]: ", x.values[r], "is of class ", x.values[r].class, "\n"

			# fields written, now replace last comma with )
			line[line.length - 1] = ")"
			# replace last semi colon with )
			qline[qline.length - 1] = ")"

			# add a comma if not the last row, add a ; if it is
			if i == num_rows - 1
				line = line + ";"
			else
				line = line + ","
			end
			@sql << line
			@q << qline
		end

		# final adds
		@q << "\"rows in " + @tablename + ": \", string count " + @tablename

		return @sql
	end
end

