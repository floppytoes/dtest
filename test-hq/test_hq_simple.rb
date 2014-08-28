#!/usr/bin/env ruby

require 'Open3'
require 'io/wait'


# show detail options
##############
ShowTestTimes = false
ShowTestQuery = false
ShowTestTimeSummary = false
ShowTestPassed = false
ShowTestPassedResult = false
ShowTestFailureDetails = false
ShowTestComments = false
ShowTestBlanks = false
ShowDotsForTests = false
ShowDotsForTestsInterval = 10
ShowStdErr = false

# initial config
##############
start_qkdb = "/Users/jdbloom/Dropbox/src/q/m32/q"
q_test_query1 = "2 + 3"
q_test_result1 = "5"


test_script_fn = ARGV[0]
test_data_fn = ARGV[1]

test_script_path = "test-scripts/"
test_data_path   = "../gen-data/data-out/"

q_openhyperq_command = "h:hopen `::6003\n"


DefaultSleepTime = 0.001
MaxLoadWaitTime = 0.25
MaxSleepTime = 3
MaxWaitTime = 4

EndOfTestMarker = "endendend"  # not required but can use to end early

# helper functions
##############
def exit_q(pipe)
  #puts "issuing q exit command"
  pipe.puts "\\\\"
  exit
end

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


# start execution
##############
if ARGV.length != 2 || ARGV[0] =~ /^[-\/]h(elp)?$/
  puts "usage: #{$0} <test_script.q> <qdata.q>"
  puts "ex: ruby test_hq_simple.rb hq-testscript1.q hq-test1-data.q"
  puts "reminder: before starting be sure you ran psql and loaded the corresponding sql file"
  exit
end

test_script_fn = ARGV[0]
test_data_fn = ARGV[1]


if File.exist?(test_script_path + test_script_fn)
  test_script_fn = test_script_path + test_script_fn
elsif ! File.exist?(test_script_fn)
  puts "Cannot find a test script #{test_script_fn} - exiting "
  exit
end

if File.exist?(test_data_path + test_data_fn)
  test_data_fn = test_data_path + test_data_fn
elsif ! File.exist?(test_data_fn)
  puts "Cannot find a test data #{test_data_fn} - exiting "
  exit
end

q_load_file_command = "\\l " + test_data_fn + "\n"

#puts "test_script_fn: #{test_script_fn}"
#puts "test_data_fn: #{test_data_fn}"

qkdb_totaltesttime = 0
hypq_totaltesttime = 0


# start up
stdin, stdout,stderr = Open3.popen3(start_qkdb)

# wait until kdb says it's ready 
sleep_until_ready(stdout)

# ignore all the beginning stuff until q/kdb is ready
while stdout.ready?
	line = stdout.gets
end

# quick test command
stdin.puts q_test_query1
sleep_until_ready(stdout)
line = stdout.gets.chomp
unless (line == q_test_result1)
  print "unexpected result: ", line
  exit
end


# load the test_script into the local q/kdb instance
t_start = Time.now
stdin.puts q_load_file_command
sleep_until_ready(stdout)
t_lastoutput = Time.now

while true
  while stdout.ready?
    line = stdout.gets
    t_lastoutput = Time.now
  end

  sleep 0.1

  if (Time.now - t_lastoutput) > MaxLoadWaitTime
    # done loading
    break
    #exit
  end
end




t_stop = Time.now

print "#{Time.now.strftime("%H:%M:%S %Z")}: loaded data into kdb (took ", (t_stop - t_start).round(3), " seconds)\n"


# open file handle to dtm
stdin.puts q_openhyperq_command
sleep 0.1
stdin.puts q_test_query1

sleep 0.1 # wait a bit to seeif ready
# if anything is in stderr, it failed
if (stderr.ready?)
  puts "error... stderr reports:"
  while line = stderr.ready?
    line = stderr.gets.chomp
    puts line
  end
  exit
end

sleep_until_ready(stdout)
line = stdout.gets.chomp
unless (line == q_test_result1)
  print "unexpected result (3): ", line
  exit
end

# handle is open, now open test file and start tests
f = File.open(test_script_fn, "r")
line_number = 0
tests_failed = 0
failed = {}
tests_total = 0
print "#{Time.now.strftime("%H:%M:%S %Z")}: starting tests\n"
while testline = f.gets
  hypq_err = false
  if ShowDotsForTests 
    if tests_total % ShowDotsForTestsInterval == 0
      print "." 
    end
  end
  testline = testline.chomp
  line_number = line_number + 1
  test_passed = true

  if testline[0] == "#" 
    # skip comment line
    if ShowTestComments then print "line: %3d comment: " % line_number, testline, "\n" end
    next
  elsif (testline.length == 0)
    # skip blank line
    if ShowTestBlanks then print "line: %3d blank " % line_number, "\n" end
    next
  end

  if testline == EndOfTestMarker
    print "line: %3d end of test marker " % line_number, "\n"
    break
  end


  # perform test locally
  qkdb_result = []
  qkdb_start = Time.now
  stdin.puts testline
  qkdb_result = get_all_as_ready(stdout)
  qkdb_stop = Time.now

  hypq_result = []
  hypq_start = Time.now
  z =  "h \"" + testline.chomp + "\""
  stdin.puts z
  #puts "calling command " + z

  hypq_result = get_all_as_ready(stdout)
  hypq_stop = Time.now

  qkdb_totaltesttime = qkdb_totaltesttime + (qkdb_stop - qkdb_start)
  hypq_totaltesttime = hypq_totaltesttime + (hypq_stop - hypq_start)

  if ShowTestQuery then print "line %3d: " %line_number, testline, "\n" end
  tests_total = tests_total + 1
  #puts qkdb_result
  #puts hypq_result


  if (ShowTestTimes)
    print "line: %3d took " % line_number

    t = (qkdb_stop - qkdb_start) + (hypq_stop - hypq_start)
    r = (qkdb_stop - qkdb_start) / (hypq_stop - hypq_start)

    print "%.3fs" % t
    print " with r of %.3f" % r
    r_delta = 0.1
    if r > 1 + r_delta || r < 1 - r_delta
      print "  ("
      print "qkdb %.3f and " %(qkdb_stop - qkdb_start) 
      print "hypq %.3f seconds )\n" %(hypq_stop - hypq_start)
    else
      puts
    end
  end

  if hypq_result == false
    hypq_err = get_all_as_ready(stderr)
    if ShowStdErr then puts "hyper-q wrote to stderr at line #{line_number}: #{hypq_err}" end
    test_passed = false    
  elsif (qkdb_result.length != hypq_result.length)
    puts "length mismatch at " + line_number.to_s

    if ShowTestFailureDetails
      print "qkdb_result.length: ", qkdb_result.length, "\n"
      print "hypq_result.length: ", hypq_result.length, "\n"

      #any more remaining from hypq?
      hypq_result2 = get_all_as_ready(stdout)
      if (hypq_result2 == false)
        puts "hypq has nothing else to return - error"
        puts "check to see if we can just skip this entirely"
        exit
      end
      puts hypq_result2.length
    end
    #puts "  qkdb response:"
    #qkdb_result.each do |x|
    #  print "  ", x, "\n"
    #end

    #puts "  hypq response:"
    #hypq_result.each do |x|
    #  print "  ", x, "\n"
    #end
    test_passed = false
  else

    for i in 0..(qkdb_result.length - 1)
      if (qkdb_result[i] != hypq_result[i])
        test_passed = false
        #puts "mismatch at line " + line_number.to_s
        #puts qkdb_result[i]
        #puts hypq_result[i]
      end
    end
  end

  if test_passed == false
    if hypq_err
      hypq_err = hypq_err.to_s.chomp
      if testline.chomp
        hypq_err = testline.chomp + "\n" + hypq_err
      end
    else
      hypq_err = testline.chomp
    end

    print "#{Time.now.strftime("%H:%M:%S %Z")}: ERROR: failed test at line #{line_number}: #{hypq_err}\n"

    #puts " failed test: " + testline.chomp
    failed[line_number] = testline.chomp
    tests_failed = tests_failed + 1

    if ShowTestFailureDetails
      puts "qkdb_result:"
      puts qkdb_result
      puts "hypq_result:"
      puts hypq_result
    end
  elsif (ShowTestPassedResult)
    puts "qkdb_result:"
    puts qkdb_result
    puts "hypq_result:"
    puts hypq_result
  elsif ShowTestPassed
    puts "success"
  end

end

if ShowDotsForTests then puts end

print "#{Time.now.strftime("%H:%M:%S %Z")}: testing complete with ",tests_total - tests_failed, " of ", tests_total, " passed\n"
#print 
if ShowTestTimeSummary
  if qkdb_totaltesttime / hypq_totaltesttime > 1.1
    puts "hypq ran considerably faster"
  elsif hypq_totaltesttime / qkdb_totaltesttime > 1.1
    puts "qkdb ran considerably faster"
  end
  print "  total qkdb time: %.3f seconds " % qkdb_totaltesttime, "\n"
  print "  total hypq time: %.3f seconds " % hypq_totaltesttime, "\n"
end

 



exit_q(stdin)





