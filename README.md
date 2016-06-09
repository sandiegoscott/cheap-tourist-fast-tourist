# cheap-tourist-fast-tourist

I wrote this Ruby code in response to a request for a sample of the code I write. I only had proprietary client code at the time, so it was suggested I code one of the problems at [Puzzlenode.com](http://www.puzzlenode.com).

I chose this problem ([Cheap tourist, fast tourist](http://www.puzzlenode.com/puzzles/2-cheap-tourist-fast-tourist)) because I thought I could modify a well-know algorithm (Dijkstra's algorithm) for finding the shortest path between nodes in a graph. That turned out not to be the case; this is more difficult because of the time constraints (you can't board a flight that took off before you arrived).

The algorithm I came up with constructs routes from sequences of flights and keeps only the best routes out of each city. Care must be taken to consider all routes; this requires keeping a flight around for consideration until all the incoming routes it might be added to have been computed.

I have modeled each Flight with an object, with objects for a FlightQueue (to hold those flights still up for consideration) and BestFlights (to hold those routes--combinations of flights--that are optimal so far), as well as monkey patching some built-in Ruby classes for easy input and output.

The minimize_cost and minimize_time methods are very similar and could possibly be combined with a flag to decide which code to use where they differ. But that would complicate the code and get away from the purpose of the exercise.

To fetch these files, make sure git is installed and at the command line type:

```
$ git clone git@github.com:sandiegoscott/cheap-tourist-fast-tourist.git
```

To run the code against the sample data, make sure Ruby is installed, then type:

```
$ cd cheap-tourist-fast-tourist
$ ruby tourist.rb sample-input.txt
```

You will see that I have added the duration of the trips and the id's of the cities travelled through.

To run against the large data sets provided:

```
$ ruby tourist.rb sample-input.txt

09:00 13:30 200.0 | duration: 4:30 cities: A B Z
10:00 12:00 300.0 | duration: 2:00 cities: A Z

08:00 19:00 225.0 | duration: 11:00 cities: A B C Z
12:00 16:30 550.0 | duration: 4:30 cities: A B Z

$ ruby tourist.rb input.txt

06:00 22:07 1027.31 | duration: 16:07 cities: A C D Z
06:00 17:07 1062.31 | duration: 11:07 cities: A C D Z

00:00 20:34 1606.96 | duration: 20:34 cities: A F I G Z
06:00 20:34 2283.35 | duration: 14:34 cities: A C F I G Z

01:00 21:42 1549.21 | duration: 20:42 cities: A H Z
09:00 19:42 1664.21 | duration: 10:42 cities: A C Z
```
