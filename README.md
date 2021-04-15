# Sort State University

[![Test](https://github.com/kylehughes/sort-state-university/actions/workflows/test.yml/badge.svg)](https://github.com/kylehughes/sort-state-university/actions/workflows/test.yml)
[![Code Coverage](https://codecov.io/gh/kylehughes/sort-state-university/branch/main/graph/badge.svg)](https://codecov.io/gh/kylehughes/sort-state-university)
[![Documentation](https://kylehughes.github.io/sort-state-university/badge.svg)](https://kylehughes.github.io/sort-state-university/)

*Stateful sorting algorithms for Swift.*

## About

Imagine…

A sorting algorithm is a value type that can be called as a function. Its state represents a specific moment in the execution of the
algorithm. Each call will advance the algorithm and produce a step: either a comparison to be answered, or the final sorted 
output. The comparison will produce the next value of the algorithm when given an answer. The next value of the algorithm can be 
called to produce the next step, and so on, until the output is produced.

Sort State University brings this dream to life.

### Use Cases

- Sorting visualizations
- Et cetera

The sorting algorithms in this framework are not designed for performance and are not intended to be used for general-purpose
implementations. 

### The Name

I knew that "sort" and "state" had to be in the name. It seemed natural and funny to append "university."

## Usage

### Create an Algorithm

The input to an algorithm does not need to conform to `Comparable` because the answers to the comparisons are supplied
by the caller.

```swift
var algorithm = MergeSort(input: elements)
```

### Advance the Algorithm

A mutable algorithm can be called like a function. The return value is the next step in the algorithm: either a
comparison or the final sorted output.

```swift
switch algorithm() {
case let .comparison(comparison):
    // Answer the comparison…
case let .finished(output):
    // Handle the sorted output…
}
```

### Answer the Comparison

A comparison is a decision about the inherent order of two elements. The answer to a comparison will produce the next 
state of the algorithm. The caller is responsible for consistently applying the inherent order to the comparisons.

For example, the "inherent order" could be a user's personal preference, so the answer to the comparions would
be whichever element the user prefers.

```swift
algorithm = comparison(.left)
```

or

```swift
algorithm = comparison(.right)
```

### Handle the Sorted Output

The output is a sorted array of elements. Handling this value is an exercise left to the reader.

## Supported Platforms

- iOS 14.0+
- macOS 11.0+
- tvOS 14.0+
- watchOS 7.0+

## Requirements

- Swift 5.3+
- Xcode 12.0+

## Installation

### Swift Package Manager

```swift
dependencies: [
    .package(url: "https://github.com/kylehughes/sort-state-university.git", from: "1.0.0"),
]
```

## Documentation

[Documentation is available here](https://kylehughes.github.io/sort-state-university). 

Generated with [jazzy](https://github.com/realm/jazzy). Hosted by [GitHub Pages](https://pages.github.com).

## Contributions

Sort State University is not accepting source contributions at this time. Bug reports will be considered.

This framework is a personal hobby. Feel free to copy pieces, or to fork, but don't expect much support.

## Author

Kyle Hughes

[![my twitter][social_twitter_image]][social_twitter_url]

[social_twitter_image]: https://img.shields.io/badge/Twitter-@KyleHughes-blue.svg
[social_twitter_url]: https://www.twitter.com/KyleHughes

## License

Sort State University is available under the MIT license. 

See `LICENSE` for details.
