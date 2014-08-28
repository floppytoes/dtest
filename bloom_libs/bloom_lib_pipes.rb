# bloom_lib_pipes.rb

DefaultSleepTime = 0.001
MaxSleepTime = 4
MaxWaitTime = 5



def get_all_as_ready(pipe, initial_wait_timeout = 10,initial_wait_inc = 0.01,ongoing_wait_timeout = 0.01,ongoing_wait_inc = 0.01)
  t_start = Time.now 
  t_last =  t_start
  return_val = []
  no_data = true

  while true
    if pipe.ready?
      while pipe.ready?
        return_val << pipe.gets.chomp
        t_last = Time.now
        no_data = false
      end
    elsif no_data 
      if (Time.now - t_last >= initial_wait_timeout)
        # waited too long, never got any input
        return false
      else
        sleep initial_wait_inc
      end
    else
      if (Time.now - t_last >= ongoing_wait_timeout)
        # done waiting for more input
        return return_val
      else
        sleep ongoing_wait_inc
      end
    end
  end
end





def sleep_until_ready(pipe)
	total_sleep_time = 0
	while not pipe.ready?
		sleep DefaultSleepTime
		total_sleep_time = total_sleep_time + DefaultSleepTime
		if (total_sleep_time >= MaxSleepTime)
			print "overslept...", total_sleep_time, "\n"
			exit
		end
	end
end