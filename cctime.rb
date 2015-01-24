require 'time'

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

# def read_shift(shh)
#   puts shh
# end
a="12/31/2014  Anguiano, Lea: 12/31/2014 9:00 PM - 01/01/2015 8:00 AM  11"
b="01/16/2015  Cardoso, Monica: 10:00 AM - 1:00 PM 3"
puts a
p read_shift(a)