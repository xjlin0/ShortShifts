# This program help to find  all shifts less than assigned time length.

require 'time'      #for time string parsing and formatting.

endorsement =  900  #maximum overlapping shift time in seconds
minimum     = 7200  #minimal shift time is 2hr in seconds
origin = "07/31/2014	John, Doe: 9:00 AM - 4:00 PM" #defining system start.

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


reports = 'New Text Document.txt' #This is the name of the report-schedule(future) pure text file name
lshift_date, lcg, lstartTime, lendTime = read_shift(origin)[0], read_shift(origin)[1], read_shift(origin)[2], read_shift(origin)[3]  #defining system start as the last shift.


# Start parsing lines containing shifts
puts "#{"="*43}\nStart checking, each dot represent a shift.\n#{"="*43}\n"

File.readlines(reports).each do |line|

	if line =~ /^(\d{2})\/(\d{2})\/(\d{4})/
		shifts=line.chomp
    shift_date, cg, startTime, endTime=read_shift(shifts)[0],read_shift(shifts)[1],read_shift(shifts)[2],read_shift(shifts)[3] #parsing shift time
    
		duration = endTime - startTime #calculate shift duration in seconds
		
		if duration < minimum  # detect shift shifts
		
#http://stackoverflow.com/questions/2310197/how-to-convert-270921sec-into-days-hours-minutes-sec-ruby
#copy from Mike's solution using divmod methods			
			dhms = [60,60,24].reduce([duration]) { |m,o| m.unshift(m.shift.divmod(o)).flatten }
		  
			puts "\n#{cg}'s shift on #{shift_date} starting #{startTime.strftime("%l:%M%p")} is only #{dhms[1]}hr #{dhms[2]}min!"
	
		end

    if startTime < (lendTime - endorsement) # detect overlapped shifts
		
			puts "\n#{cg}'s shift on #{shift_date} starting #{startTime.strftime("%l:%M%p")} overlapped with #{lcg}'s shift on #{lshift_date} starting #{lstartTime.strftime("%l:%M%p")} for more than #{endorsement/60} minutes!"

		end
		lshift_date, lcg, lstartTime, lendTime = shift_date, cg, startTime, endTime  #make the current shift as the last shift.
		print "."
  end
	
	if line =~ /^Address:/  #clients separator
		lshift_date, lcg, lstartTime, lendTime = read_shift(origin)[0], read_shift(origin)[1], read_shift(origin)[2], read_shift(origin)[3]#defining system start as the last shift for different clients.
	end
	
end
puts "\nEnd Checking, please press Enter to quit"
gets

#http://apidock.com/rails/ActionView/Helpers/DateHelper/distance_of_time_in_words
#http://stackoverflow.com/questions/6853015/how-do-i-use-an-actionviewhelper-in-a-ruby-script-outside-of-rails