# Recursive functions
Recursive functions are methods that call themselves either directly or indirectly through other functions. While recursion can be a powerful programming technique, unbounded recursion on user inputs can lead to stack overflow errors and program crashes, potentially enabling denial of service attacks. This query detects recursive patterns up to order 4.


## Recommendation
Review recursive functions and ensure that they are either: - Not processing user-controlled data - The data has been properly sanitized before recursing - The recursion has an explicit depth limit

Consider replacing recursion with iterative alternatives where possible.


## Example

```java
// From https://github.com/x-stream/xstream/blob/dfa1d35462fe84412ee72a9b0cf5b5c633086520/xstream/src/java/com/thoughtworks/xstream/io/binary/BinaryStreamReader.java#L165
private Token readToken() {
    // ...
    try {
        final Token token = tokenFormatter.read(in);
        switch (token.getType()) {
        case Token.TYPE_MAP_ID_TO_VALUE: // 0x2
            idRegistry.put(token.getId(), token.getValue());
            return readToken(); // Next one please.
        default:
            return token;
        }
    } catch (final IOException e) {
        throw new StreamException(e);
    }
    // ...
}
```
In this example, a binary stream reader processes tokens recursively.

For each new token \`0x2\`, the parser will create a new recursive call. If this stream is user-controlled, an attacker can generate too many stackframes and crash the application with a `StackOverflow` error.


## References
* Trail Of Bits Blog: [Low-effort denial of service with recursion](https://blog.trailofbits.com/2024/05/16/TODO/)
* CWE-674: [Uncontrolled Recursion](https://cwe.mitre.org/data/definitions/674.html)
