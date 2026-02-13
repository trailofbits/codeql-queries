struct header {
    int type;
    int length;
};

// Returns number of items processed, or -1 on error
int process_items(int *items, int count) {
    int processed = 0;
    for (int i = 0; i < count; i++) {
        if (items[i] < 0)
            return -1;
        processed++;
    }
    return processed;
}

void example() {
    int items[10];
    int result;

    // Typical: return value compared with a numeric literal
    result = process_items(items, 10);
    if (result > 0) { /* success */ }

    result = process_items(items, 5);
    if (result != -1) { /* no error */ }

    result = process_items(items, 3);
    if (result == 0) { /* empty */ }

    result = process_items(items, 8);
    if (result >= 1) { /* at least one */ }

    // BAD: comparing with sizeof instead of a numeric literal.
    // This is inconsistent with all other call sites and likely a bug.
    result = process_items(items, 7);
    if (result > sizeof(struct header)) { /* wrong comparison */ }
}
