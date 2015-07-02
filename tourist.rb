#
# Puzzlenode.com: Cheap tourist, fast tourist
#
require 'csv'
require 'pry'

def to_time( strg )
  hour, minute = strg.split(':')
  Time.new(2015,7,2,hour.to_i,minute.to_i)
end

def from_time( time )
  time.strftime("%H:%M")
end

def show_flight( flight )
  "#{flight[0]} #{flight[1]} #{from_time(flight[2])} #{from_time(flight[3])} #{sprintf('%.2f', 0.01*flight[4])}"
end

def show_route( destination, route )
  route_departure, route_arrival, route_cost, route_duration = *route
  route_departure ||= Time.now
  "#{destination}: #{from_time(route_departure)} #{from_time(route_arrival)} #{sprintf('%.2f', 0.01*route_cost)} #{route_duration}"
end

# least cost algorithm
def least_cost( all_flights, show_flag )
  # keep a list of lowest cost routes (destination only, no intermediate stops)
  # loop through the available flights
  # replace route where better on cost or same on cost and better on arrival time

  # seed route
  routes = { 'A' => [[nil, to_time('23:59'), 0, 0]] }  # { terminus => [[route_departure, route_arrival, totalcost] , [route_departure, route_arrival, totalcost], ...]

  # endless loop through the flights until no changes are made to the routes
  puts "NEW CASE" if show_flag
  until false
    puts "START LOOP" if show_flag
    # loop through the flights
    routes_added = false
    all_flights.each do |flight|
      puts "flight=#{show_flight(flight)} routes.size=#{routes.size}"
      flight_origin, flight_destination, flight_departure, flight_arrival, flight_price = *flight
      # check for routes to add the flight to
      # if there are no routes that end at the flight origin, move on
      next if routes[flight_origin].nil?
      # for each of the routes to the origin of the flight--
      routes[flight_origin].each do |route_to_flight_origin|
        route_departure, route_arrival, route_cost, route_duration = *route_to_flight_origin
        # compute a new route combining the existing route and the flight
        new_destination = flight_destination
        new_departure = route_departure || flight_departure  # seed route has nil route_departure field
        new_arrival = flight_arrival
        new_cost = route_cost + flight_price
        new_duration = flight_arrival - new_departure
        # if there are no routes yet to the new route destination--
        if routes[new_destination].nil?
          # add the new route
          routes[new_destination] = [[new_departure, new_arrival, new_cost, new_duration]]
          #binding.pry
          routes_added = true
          puts "ADD route: #{show_route(new_destination, [new_departure, new_arrival, new_cost, new_duration])}" if show_flag
        # --otherwise--
        else
          # compare this route with existing routes to the flight destination
          do_not_add_route = false
          routes[flight_destination].each do |alt_route_to_new_destination|
            alt_route_departure, alt_route_arrival, alt_route_cost, alt_route_duration = *alt_route_to_new_destination
            # if the new route both arrives no earlier and costs no less then an existing route, it's not better, toss it out
            do_not_add_route = true
            next if new_arrival >= alt_route_arrival && new_cost >= alt_route_cost
            do_not_add_route = false
          end
          unless do_not_add_route
            # add the new route
            routes[new_destination] << [new_departure, new_arrival, new_cost, new_duration]
            #binding.pry
            routes_added = true
            puts "Add route: #{new_destination} => #{routes[new_destination].inspect}" if show_flag
          end
        end
      end
    end
    break if !routes_added
    #binding.pry
  end

  if show_flag
    puts '============'
    routes.each_pair do |destination, routes|
      routes.each do |route|
        puts "Route: #{show_route(destination, route)}"
      end
    end
  end

  if routes.keys.include?('Z')
    #puts routes['Z'].inspect
    puts from_time(routes['Z'][0][0]) + ' ' + from_time(routes['Z'][0][1]) + ' ' + sprintf("%.2f", 0.01*routes['Z'][0][2])
    puts
  else
    puts "You can't get from A to Z!"
    puts
  end
end

#
# =============== main program ===============
#

# initialize
ncases = nil
nflights = 0
flights = [ ]

show_flag = !ARGV[1].nil?

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
    origin, destination, departure, arrival, currency = strg.split(' ')
    price = currency.split('.')
    cents = 100 * price[0].to_i + price[1].to_i
    flights << [origin, destination, to_time(departure), to_time(arrival), cents]
    nflights -= 1
  end

  # solve case
  if nflights == 0
    least_cost(flights, show_flag)
    data = [ ]
  end

end






