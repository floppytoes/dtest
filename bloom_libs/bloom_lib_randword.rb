# bloom_lib_randword.rb


class RandWordGen
	def initialize(input_filename = "../bloom_libs/words_random.txt")
		@words = []

		input_file = File.open(input_filename, 'r')
		while (line = input_file.gets)
			if line =~ /^(\w+)$/		# if finds a word
				@words << $1
			end
		end
	end

	def howMany()
		return @words.length
	end

	def showentry(i)
		return @words[i]
	end

	def get_helper()
		i = Kernel.rand(@words.length)
		return @words[i]
	end

	def get(num = 1)
		if num == 1
			return get_helper
		elsif num > 1
			return_val = []
			(1..num).each do 
				return_val << get_helper
			end
			return return_val
		end
	end
end


if (false)
	randword = RandWordGen.new()
	puts randword.howMany
	puts randword.showentry(0)
	puts randword.get
	puts randword.get(4)
end