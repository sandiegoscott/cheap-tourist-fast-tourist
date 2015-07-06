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
  attr_reader :origin, :destination, :arrival, :departure, :price
  attr_accessor :cost, :first_departure

  def initialize( flight_params )
    # flight info
    @origin, @destination, departs, arrives, currency = flight_params.split
    @departure = departs == 'nil' ? nil : departs.to_time
    @arrival = arrives.to_time
    price = currency.split('.')
    @price = 100 * price[0].to_i + price[1].to_i

    # info for route ending with this flight
    @cost = 0
    @first_departure = '00:00'.to_time
  end

  def <=>( another_flight )
    arrival <=> another_flight.arrival
  end

  def info
    [@origin, @destination, @arrival, @departure, @price]
  end

  def inspect
    depart = @departure ? @departure.strftime("%H:%M") : ' --- '
    arrive = @arrival ? @arrival.strftime("%H:%M") : ' --- '
    "#{origin} #{@destination} #{depart} #{arrive} " + sprintf('%.2f', 0.01*@price) + ' ' + sprintf('%7.2f', 0.01*@cost)
  end

  def solution
    arrive = @arrival.strftime("%H:%M")
    start = @first_departure.strftime("%H:%M")
    "#{start} #{arrive} " + ' ' + sprintf('%7.2f', 0.01*@cost)
  end
end

class FlightQueue
  def initialize
    @flights = Array.new
  end
  
  def dequeue
    flight = @flights.pop
    #puts "DEQUEUE #{flight.inspect}"
    flight
  end
  
  def enqueue(flight)
    @flights.unshift(flight)
    #puts "ENQUEUE #{flight.inspect}"
    self
  end
  
  def size
    @flights.size
  end

  def inspect
    strg = "FLIGHT QUEUE:"
    @flights.each {|flight| strg << " #{flight.origin}->#{flight.destination}"}
    strg
  end
end

class BestFlights
  def initialize
    @heap = { }
  end

  def add( flight )
    #puts "ADDHEAP #{flight.inspect}"
    flights = @heap[flight.destination]
    if flights
      flights.select!{ |in_flight| in_flight.info != flight.info }  # remove this flight if present
      flights << flight
    else
      flights = [flight]
    end
    @heap[flight.destination] = flights
  end

  def arrivals( destination )
    @heap[destination]
  end

  def inspect
    'HEAP: ' + @heap.keys.map{|dest| dest + ': ' + @heap[dest].map{|flt| flt.inspect}.join('/')}.join(' | ')
  end
end

def minimize_cost( q, arrivals )
  best_flights = BestFlights.new

  # start with a dummy flight in the heap of flights with best costs
  best_flights.add Flight.new('- A 00:00 00:00, 0.00')
  arrivals['A'] = 1

  #puts q.inspect
  #puts best_flights.inspect
  #puts
  #puts 'START'

  # while there are still flights in the queue--
  while q.size > 0
    q.inspect
    # get the next flight
    flight = q.dequeue
    # get the flights into this flight's origin city
    in_flights = best_flights.arrivals(flight.origin)
    # if there are no incoming flights to add this flight to, put it at the end of the queue, we'll consider it again
    if in_flights.nil?
      #puts "No inflights"
      q.enqueue(flight)
      next
    end
    # find the lowest cost route that includes this flight
    lowest_cost = 100000000
    #puts "Inflights to #{flight.origin}: #{in_flights.size}"
    in_flights.each do |in_flight|
      # if the flights are compatible and together are the lowest cost
      if in_flight.arrival <= flight.departure && in_flight.cost + flight.price < lowest_cost
        # save that information in the flight
        flight.cost = lowest_cost = in_flight.cost + flight.price
        flight.first_departure = flight.origin == 'A' ? flight.departure : in_flight.first_departure
      end
    end
    # add this flight to the heap
    best_flights.add(flight)
    # if not all the incoming flights have been considered, put this flight in the queue to be considered again
    if best_flights.arrivals(flight.origin).size < arrivals[flight.origin]
      q.enqueue(flight)
    else
      #puts 'Not queued again'
    end
  end

  # retrieve best route
  all_routes = best_flights.arrivals('Z')
  #puts all_routes.inspect
  best_route = all_routes.min_by { |flight| flight.cost }
  puts best_route.solution
  puts
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
  arrivals = { }

  # read each flight
  (1..nflights).each do
    line = file.gets.chomp
    # add to flight queue
    flight = Flight.new(line)
    unless flight.origin == 'Z' || flight.destination == 'A'
      flights << flight 
      # count arrivals into each city
      arrivals[flight.destination] = arrivals[flight.destination] ? arrivals[flight.destination] + 1 : 1
    end
  end

  # queue the flights by arrival time
  q_cost = FlightQueue.new
  flights.sort.each { |flight| q_cost.enqueue(flight) }
  q_time = q_cost.dup

  # apply algorithm to minimize cost
  minimize_cost(q_cost, arrivals)
end

file.close




