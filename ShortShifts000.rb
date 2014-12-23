# This program help to find  all shifts less than assigned time length.

require 'time'


min=7200  #minimal shift time is 2hr in seconds

# method for parsing text into time stamps. dried from ReFormatter003
def read_shift(single_line)
						format = ' %m/%d/%Y %I:%M %p'
        shift_date = single_line.split(',')[0].split[0]
             shift = single_line.split(',')[1]
                cg = shift.split(':')[0]
       shift_start = shift.split('-')[0].split(':')
  if shift =~ /(\d{2})\/(\d{2})\/(\d{4})/ 
    startTime = Time.strptime(shift_start[1]+":"+shift_start[2] , format)
    endTime   = Time.strptime(shift.split('-')[1], format)
  else
    startTime = Time.strptime(shift_date+shift_start[1]+":"+shift_start[2], format)
    endTime   = Time.strptime(shift_date+shift.split('-')[1], format)
  end
  [shift_date, cg, startTime, endTime]
end


reports='New Text Document.txt' #This is the name of the Clear Care report-schedule(future) pure text file name

# Start parsing lines containing shifts

File.readlines(reports).each do |line|

	if line =~ /^(\d{2})\/(\d{2})\/(\d{4})/
		shifts=line.chomp
    shift_date, cg, startTime, endTime=read_shift(shifts)[0],read_shift(shifts)[1],read_shift(shifts)[2],read_shift(shifts)[3] #parsing shift time
    
		duration=endTime-startTime
		
		if duration < min
			puts "\n#{cg}'s shift on #{shift_date} starting #{startTime.strftime("%l:%M%p")} is only #{duration}!"
		else
		  print "."
		end
  end
end
puts "press Enter to quit"
gets

#http://apidock.com/rails/ActionView/Helpers/DateHelper/distance_of_time_in_words
#http://stackoverflow.com/questions/6853015/how-do-i-use-an-actionviewhelper-in-a-ruby-script-outside-of-rails