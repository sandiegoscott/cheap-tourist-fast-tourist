#
# Puzzlenode.com: Cheap tourist, fast tourist
#
require 'csv'
require 'pry'

def duration( departure, arrival )
  departure_hour, departure_minute = departure.split(':')
  arrival_hour, arrival_minute = arrival.split(':')
  60.0 * (arrival_hour.to_i - departure_hour.to_i) + arrival_minute.to_i - departure_minute.to_i
end

def to_time( strg )
  hour, minute = strg.split(':')
  Time.new(2015,7,2,hour.to_i,minute.to_i)
end

# least cost algorithm
def least_cost( all_flights )
  # keep a list of lowest cost routes (destination only, no intermediate stops)
  # loop through the available flights
  # add routes where they are better on cost or arrival time (so ties can be broken)

  # seed route
  routes = { 'A' => [[nil, to_time('23:59'), 0.0]] }  # { terminus => [[departed, arrived, totalcost] , [departed, arrived, totalcost], ...]

  # endless loop
  until false
    puts "START LOOP"
    # loop through the flights
    routes_added = false
    all_flights.each do |flight|
      #puts "flight=#{flight.inspect} routes.size=#{routes.size}"
      origin, destination, departure, arrival, price = *flight
      # check for routes to add the flight to
      # if there are no routes that end at the origin, move on
      next if routes[origin].nil?
      # for each of the routes from the origin--
      routes[origin].each do |route_from_origin|
        departed, arrived, cost = *route_from_origin
        # add a route with this leg?
        if routes[destination].nil?
          routes[destination] = [[departed||departure, arrival, cost+price]]
          routes_added = true
          puts "ADD route: #{destination} => #{routes[destination].inspect}"
        else
          # compare this route to the destination with others we have
          routes[destination].each do |route_to_destination|
            route_departure, route_arrival, route_cost = *route_to_destination
            # if it's lower cost or same cost and earlier
            if (cost + price < route_cost) || (cost + price == route_cost && arrival < route_arrival)
              # replace the route
              puts "Rmv route: #{destination} => #{route_to_destination.inspect}"
              routes[destination].delete(route_to_destination)
              routes[destination] << [departed||departure, arrival, cost+price]
              routes_added = true
              puts "Add route: #{destination} => #{routes[destination].inspect}"
              break
            # if it's higher cost but arrives earlier
            #elsif arrival < route_arrival || cost+price < route_cost
            #  # add the route
            #  routes[destination] << [departed, arrival, cost+price]
            #  break
            end
          end
        end
      end
    end
    break if !routes_added
  end

  puts '============'
  routes.each_pair do |destination, route|
    puts "Route: #{destination} => #{route.inspect}"
  end
end

# initialize
ncases = nil
nflights = 0
flights = [ ]

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

  # acquire the data
  if nflights == 0
    # # of flights
    nflights = strg.to_i
    #puts "nflights: #{nflights}"
  else
    origin, destination, departure, arrival, price = strg.split(' ')
    flights << [origin, destination, to_time(departure), to_time(arrival), price.to_f]
    nflights -= 1
  end

  # solve case
  if nflights == 0
    least_cost(flights)
    data = [ ]
  end

end






