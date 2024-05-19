# Sort State University

[![Platforms](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fkylehughes%2Fsort-state-university%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/kylehughes/sort-state-university)
[![Swift Versions](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fkylehughes%2Fsort-state-university%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/kylehughes/sort-state-university)
[![Test](https://github.com/kylehughes/sort-state-university/actions/workflows/test.yml/badge.svg)](https://github.com/kylehughes/sort-state-university/actions/workflows/test.yml)

*Stateful sorting algorithms for Swift.*

## About

Imagine…

A sorting algorithm is a value type that can be called as a function. Its state represents a specific moment in the 
execution of the algorithm. Each call will advance the algorithm and produce a step: either a comparison to be answered,
or the final sorted output. The comparison will produce the next value of the algorithm when given an answer. The next 
value of the algorithm can be called to produce the next step, and so on, until the output is produced.

Sort State University brings this dream to life.

### Provided Algorithms

- Insertion Sort
- Merge Sort

### Use Cases

- Asynchronous sorting
- Sorting visualizations
- Et cetera

The sorting algorithms in this framework are not designed for performance and are not intended to be used for 
general-purpose implementations. 

### The Name

I knew that "sort" and "state" had to be in the name. It seemed natural and funny to append "university." There is 
nothing inherently educational about this framework.

## Usage

### Create an Algorithm

```swift
var algorithm = MergeSort(input: elements)
```

The input to an algorithm does not need to conform to `Comparable` because the answers to the comparisons are supplied
by the caller.

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

A comparison is a decision about the inherent order of two elements. The caller is responsible for consistently applying
the inherent order to the comparisons. For example, the "inherent order" could be a user's personal preference, so the 
answer to the comparions would be whichever element the user prefers.

A comparison can be answered directly to produce the next state of the sorting algorithm.

```swift
algorithm = comparison(.left)
```

or

```swift
algorithm = comparison(.right)
```

The answer to a comparison can also be provided to, and mutate, the algorithm directly. Both approaches produce the same
result but their calling patterns suit different use cases.

```swift
algorithm.answer(.left)
```

or 

```swift
algorithm.answer(.right)
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

[Documentation is available on GitHub Pages](https://kylehughes.github.io/sort-state-university).

## Contributions

Sort State University is not accepting source contributions at this time. Bug reports will be considered.

This framework is a personal hobby. Feel free to copy pieces, or to fork, but don't expect much support.

## Author

[Kyle Hughes](https://kylehugh.es)

[![my Mastodon][social_image]][social_url]

[social_image]: https://img.shields.io/mastodon/follow/109356914477272810?domain=https%3A%2F%2Fmister.computer&style=social
[social_url]: https://mister.computer/@kyle

## License

Sort State University is available under the MIT license. 

See `LICENSE` for details.
