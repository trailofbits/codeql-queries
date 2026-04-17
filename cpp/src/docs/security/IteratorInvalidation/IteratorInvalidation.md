# Iterator invalidation
Detects modifications to C++ containers while iterating over them. Such modifications can invalidate active iterators, leading to undefined behavior including use-after-free, out-of-bounds access, and crashes.

When a container is modified (e.g., calling `push_back` on a `std::vector` during a range-based for loop), existing iterators may become invalid. Continuing to use those iterators results in undefined behavior per the C++ Standard.

The query tracks data flow between the iterated container and the modifying call to ensure they operate on the same object.


## Recommendation
Avoid modifying containers while iterating over them. Common safe alternatives include:

* Collect modifications and apply them after the loop completes
* Use the erase-remove idiom for deletions
* Iterate over a copy of the container if modification is necessary
* Use index-based loops instead of iterator-based loops when the container supports random access

## Example

```cpp
#include <vector>

// BAD: push_back during range-based for loop invalidates iterators
void bad_example(std::vector<int>& vec) {
    for (auto& elem : vec) {
        if (elem < 0) {
            vec.push_back(-elem); // invalidates iterators
        }
    }
}

// GOOD: collect modifications, apply after loop
void good_example(std::vector<int>& vec) {
    std::vector<int> to_add;
    for (auto& elem : vec) {
        if (elem < 0) {
            to_add.push_back(-elem);
        }
    }
    for (auto& val : to_add) {
        vec.push_back(val);
    }
}

```
In the bad example, calling `push_back` inside the range-based for loop may cause the vector to reallocate, invalidating all iterators including the loop's internal iterator. The good example collects values to add and applies them after the loop.


## References
* [C++ Standard \[container.requirements.general\]](https://eel.is/c++draft/container.requirements.general) — iterator invalidation rules per container type
* [CWE-416: Use After Free](https://cwe.mitre.org/data/definitions/416.html)
* [Trail of Bits — Itergator: Iterator Invalidation Detector](https://github.com/trailofbits/itergator)
