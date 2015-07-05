#
# Puzzlenode.com: Cheap tourist, fast tourist
#
require 'csv'
require 'pry'

class String
  def to_time
    hour, minute = self.split(':')
    now = Time.now
    Time.new(now.year, now.month, now.day, hour.to_i, minute.to_i)
  end
end

class Flight
  include Comparable
  attr :arrival

  def <=>(another_flight)
    arrival <=> another_flight.arrival
  end

  def initialize(flight_params)
    # flight info
    @origin, @destination, departs, arrives, currency = flight_params.split
    @departure = departs.to_time
    @arrival = arrives.to_time
    price = currency.split('.')
    @price = 100 * price[0].to_i + price[1].to_i

    # route info
    @cost = nil
    @start_time = nil
  end

  def inspect
    "#{@origin} #{@destination} #{@departure.strftime("%H:%M")} #{@arrival.strftime("%H:%M")} #{sprintf('%.2f', 0.01*@price)}"
  end
end

#
# =============== main program ===============
#

# open the file
file = File.new(ARGV[0], "r")

# number of cases
line = file.gets
ncases = line.chomp.to_i

while true
  # next case
  line = file.gets
  break if line.nil?
  next if line.chomp.empty?
  nflights = line.chomp.to_i
  flights = [ ]
  (1..nflights).each do
    line = file.gets.chomp
    flights << Flight.new(line)
  end
  flights.each { |flight| puts flight.inspect }
end

file.close




