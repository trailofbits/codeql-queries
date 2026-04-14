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
