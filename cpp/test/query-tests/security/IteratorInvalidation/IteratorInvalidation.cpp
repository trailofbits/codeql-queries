#include "../../../include/stl/vector.h"
#include "../../../include/stl/deque.h"
#include "../../../include/stl/unordered_set.h"

// BAD: push_back during range-based for loop on vector
void bad_vector_push_back(std::vector<int>& vec) {
    for (auto& elem : vec) { // iterated here
        if (elem < 0) {
            vec.push_back(-elem); // invalidates iterators
        }
    }
}

// BAD: erase during iterator-based while loop on vector
void bad_vector_erase(std::vector<int>& vec) {
    std::vector<int>::iterator it = vec.begin();
    while (it != vec.end()) {
        if (*it < 0) {
            vec.erase(it); // invalidates iterators, should use it = vec.erase(it)
        }
        ++it;
    }
}

// BAD: insert during iteration on deque
void bad_deque_insert(std::deque<int>& dq) {
    for (auto& elem : dq) { // iterated here
        if (elem > 100) {
            dq.insert(dq.begin(), 0); // invalidates iterators
        }
    }
}

// BAD: clear during iteration on unordered_set
void bad_set_clear(std::unordered_set<int>& s) {
    for (auto& elem : s) { // iterated here
        if (elem == 42) {
            s.clear(); // invalidates iterators
        }
    }
}

// Helper that indirectly invalidates the vector
void indirect_push(std::vector<int>& v) {
    v.push_back(999);
}

// BAD: indirect invalidation through function call
void bad_indirect_invalidation(std::vector<int>& vec) {
    for (auto& elem : vec) { // iterated here
        if (elem == 0) {
            indirect_push(vec); // indirectly invalidates iterators
        }
    }
}

// GOOD: break immediately after invalidating call
void good_break_after_invalidation(std::vector<int>& vec) {
    for (auto& elem : vec) {
        if (elem < 0) {
            vec.push_back(-elem);
            break; // loop exits, no further iterator use
        }
    }
}

// GOOD: return immediately after invalidating call
void good_return_after_invalidation(std::vector<int>& vec) {
    for (auto& elem : vec) {
        if (elem < 0) {
            vec.push_back(-elem);
            return; // function exits, no further iterator use
        }
    }
}

// GOOD: iterating over a copy of the container
void good_iterate_copy(std::vector<int>& vec) {
    std::vector<int> copy = vec;
    for (auto& elem : copy) {
        if (elem < 0) {
            vec.push_back(-elem); // modifies original, not the copy being iterated
        }
    }
}

// GOOD: index-based loop (no iterator involved)
void good_index_based(std::vector<int>& vec) {
    for (unsigned long i = 0; i < vec.size(); i++) {
        if (vec[i] < 0) {
            vec.push_back(-vec[i]); // no iterator to invalidate
        }
    }
}
