#ifndef USE_HEADERS

#ifndef HEADER_UNORDERED_SET_STUB_H
#define HEADER_UNORDERED_SET_STUB_H

namespace std {

template <typename T>
class unordered_set {
public:
    typedef T value_type;
    typedef const T& const_reference;
    typedef unsigned long size_type;

    struct iterator {
        const T* ptr;
        iterator() : ptr(0) {}
        iterator& operator++() { return *this; }
        iterator operator++(int) { return *this; }
        const T& operator*() const { return *ptr; }
        bool operator!=(const iterator& other) const { return ptr != other.ptr; }
        bool operator==(const iterator& other) const { return ptr == other.ptr; }
    };

    typedef iterator const_iterator;

    unordered_set();
    ~unordered_set();

    iterator begin();
    iterator end();
    const_iterator begin() const;
    const_iterator end() const;

    size_type size() const;

    iterator insert(const T& value);
    iterator emplace();
    iterator emplace_hint(const_iterator hint);
    void clear();
    iterator find(const T& value);
    iterator erase(iterator pos);
};

template <typename T>
class unordered_multiset {
public:
    typedef T value_type;
    typedef const T& const_reference;
    typedef unsigned long size_type;

    struct iterator {
        const T* ptr;
        iterator() : ptr(0) {}
        iterator& operator++() { return *this; }
        iterator operator++(int) { return *this; }
        const T& operator*() const { return *ptr; }
        bool operator!=(const iterator& other) const { return ptr != other.ptr; }
        bool operator==(const iterator& other) const { return ptr == other.ptr; }
    };

    typedef iterator const_iterator;

    unordered_multiset();
    ~unordered_multiset();

    iterator begin();
    iterator end();

    iterator insert(const T& value);
    iterator emplace();
    iterator emplace_hint(const_iterator hint);
    void clear();
    iterator find(const T& value);
};

} // namespace std

#endif

#else // --- else USE_HEADERS

#include <unordered_set>

#endif // --- end USE_HEADERS
