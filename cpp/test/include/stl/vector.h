#ifndef USE_HEADERS

#ifndef HEADER_VECTOR_STUB_H
#define HEADER_VECTOR_STUB_H

namespace std {

template <typename T>
class vector {
public:
    typedef T value_type;
    typedef T& reference;
    typedef const T& const_reference;
    typedef unsigned long size_type;

    struct iterator {
        T* ptr;
        iterator() : ptr(0) {}
        iterator& operator++() { return *this; }
        iterator operator++(int) { return *this; }
        T& operator*() { return *ptr; }
        T* operator->() { return ptr; }
        bool operator!=(const iterator& other) const { return ptr != other.ptr; }
        bool operator==(const iterator& other) const { return ptr == other.ptr; }
    };

    struct const_iterator {
        const T* ptr;
        const_iterator() : ptr(0) {}
        const_iterator& operator++() { return *this; }
        const_iterator operator++(int) { return *this; }
        const T& operator*() const { return *ptr; }
        bool operator!=(const const_iterator& other) const { return ptr != other.ptr; }
        bool operator==(const const_iterator& other) const { return ptr == other.ptr; }
    };

    vector();
    ~vector();

    iterator begin();
    iterator end();
    const_iterator begin() const;
    const_iterator end() const;

    size_type size() const;

    void push_back(const T& value);
    void emplace_back();
    iterator insert(iterator pos, const T& value);
    iterator emplace(iterator pos);
    iterator erase(iterator pos);
    void pop_back();
    void clear();
    void resize(size_type count);
    void reserve(size_type new_cap);
    void shrink_to_fit();
    void swap(vector& other);

    reference operator[](size_type pos);
    const_reference operator[](size_type pos) const;
};

} // namespace std

#endif

#else // --- else USE_HEADERS

#include <vector>

#endif // --- end USE_HEADERS
