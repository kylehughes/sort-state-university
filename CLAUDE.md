# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

Sort State University is a dependency-free Swift package (`SortStateUniversity`) that implements sorting algorithms as stateful value types. Algorithms are not designed for performance; they exist so callers can drive sorting interactively (e.g., asynchronous sorting, visualizations) by answering one comparison at a time. Elements do not need to conform to `Comparable` — the caller supplies the answer to each comparison.

## Commands

```sh
swift build                                  # Build the package
swift test                                   # Run all tests
swift test --filter MergeSortTests           # Run one test class
swift test --filter MergeSortTests/test_protocol_complexity   # Run one test method
```

CI (`.github/workflows/test.yml`) also runs tests on iOS, tvOS, and watchOS simulators via `xcodebuild test -scheme sort-state-university`. DocC documentation is deployed to GitHub Pages on pushes to `main` (`.github/workflows/deploy_documentation.yml`).

## Architecture

The core abstraction is the `SortingAlgorithm` protocol (`Sources/SortStateUniversity/SortingAlgorithm.swift`): a value-type state machine over an immutable `input` array. The execution loop:

1. Calling the algorithm as a function (`callAsFunction()`) advances it and returns a `SortingAlgorithmStep`: either `.comparison(Comparison)` or `.finished(output)`.
2. `Comparison` is a stateless lens over the algorithm (it holds the algorithm value as its `source`). Answering it with `.left` or `.right` returns the *next* algorithm value; alternatively `answer(_:)` mutates the algorithm in place.
3. Repeat until `.finished`.

`callAsFunction()` must be idempotent: calling it repeatedly on the same state returns the same step and does not advance further. Answering while not at a comparison must be a no-op. The abstract test suite enforces both.

Each algorithm also declares exact closed-form comparison-count functions (`averageNumberOfComparisons(for:)`, `maximum…`, `minimum…`) and a `Complexity` case. Sub-state-machines of an algorithm live in their own files in the algorithm's directory (e.g., `MergeSort+Merge.swift`, `Quicksort+Partition.swift`) and follow the same "call to advance, return nil until done" style.

### Adding a new algorithm

All of these must be updated together:

- New directory under `Sources/SortStateUniversity/` with the algorithm struct conforming to `SortingAlgorithm`.
- A static label in `SortingAlgorithmLabel.swift`.
- A new case in `BuiltInSortingAlgorithmType.swift` — plus its `erasedMetatype`, `label`, and `allCasesInAlphabeticalOrder` entries.
- A test class under `Tests/SortStateUniversityTests/Tests/<Algorithm>/` subclassing `AbstractSortingAlgorithmTests<YourSort<Int>>`, plus updates to `BuiltInSortingAlgorithmTypeTests`.

### Test infrastructure

`AbstractSortingAlgorithmTests` (XCTest) is a generic abstract base class that provides all conformance tests: idempotency, stability, answer-while-finished, peeking, and comparison-count verification. Concrete subclasses override the expected label, complexity, an input factory, and hardcoded `[inputCount: comparisonCount]` tables for average/maximum/minimum comparisons. When a comparison-count test fails, it prints the actual table formatted as Swift code so it can be pasted into the subclass after verifying the math. `defaultTestSuite` is overridden so the abstract class itself runs no tests. Input factories produce `.best` and `.worst` case inputs via `SortingAlgorithmInputCase`.

## Conventions

- Every file starts with the standard header comment (file name, project, author, date).
- Symbols are grouped under MARK sections by role and access level (e.g., `// MARK: Public Static Interface`, `// MARK: Public Instance Interface`), with protocol conformances in dedicated extensions marked `// MARK: - <Protocol> Extension`. Symbols are ordered alphabetically within sections.
- Public API is exhaustively documented with `///` doc comments; `@inlinable`/`@usableFromInline` are applied liberally.
- Algorithms are pure value types with `private(set)` state, `UUID` identity, and no Foundation dependencies beyond `UUID`.
