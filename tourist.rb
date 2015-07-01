#
# Puzzlenode.com: Cheap tourist, fast tourist
#
require 'csv'
require 'pry'

COST = 0
DEPARTURE = 1
ARRIVAL = 2

# initialize
ncases = nil
nflights = 0
data = [ ]

# read the file
CSV.foreach(ARGV[0]) do |row|
  # skip blank lines
  next if row.empty?
  strg = row[0]
  #puts "row: #{row}"

  # first row
  unless ncases
    ncases = strg.to_i
    next
  end

  # acquire data
  if nflights == 0
    # # of flights
    nflights = strg.to_i
    #puts "nflights: #{nflights}"
  else
    origin, destination, departure, arrival, price = strg.split(' ')
    departure_hour, departure_minute = departure.split(':')
    arrival_hour, arrival_minute = arrival.split(':')
    duration = 60.0 * (arrival_hour.to_i - departure_hour.to_i) + arrival_minute.to_i - departure_minute.to_i
    data << [ origin, destination, departure, arrival, duration, price.to_f ]
    nflights -= 1
  end

  # solve case
  if nflights == 0
    solve(data, 4)  # find fastest route
    solve(data, 5)  # find low cost route
    data = [ ]
  end

  # Dijkstra's algorithm
  def solve( alldata )
    #puts alldata.inspect
    bestcosts = { 'A' => [ 0.0, nil, nil] }
    alldata.each do |flight_data|
      # update the list of lowest cost options to each city
      origin, destination, departure, arrival, duration, price = *flight_data
      current_best_cost = bestcosts.keys.include?(destination) ? bestcosts[destination][COST] : 100000000.0
      cost = bestcosts[origin][COST] + price
      bestcosts[destination] = [ cost, bestcosts[origin][DEPARTURE] || departure, arrival ] if cost < current_best_cost
    end
    puts bestcosts.inspect
  end

end
