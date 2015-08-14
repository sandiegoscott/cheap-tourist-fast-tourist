# cheap-tourist-fast-tourist

I wrote this Ruby code in response to a request for a sample of the code I write. I only had proprietary client code at the time, so it was suggested I code one of the problems at Puzzlenode.com.

I chose this problem because I thought I could modify a well-know algorithm (Dijkstra's algorithm) for finding the shortest path between nodes in a graph. That turned out not to be the case; this is a hard problem!

To run the code against the sample data shown at [Puzzlenode.com](http://www.puzzlenode.com/puzzles/2-cheap-tourist-fast-tourist:)

```
$ ruby tourist.rb sample-input.txt
```

You will see that I have added the duration of the trips and the id's of the cities travelled through.

To run against the large data sets provided:

```
$ ruby tourist.rb input.txt
```
