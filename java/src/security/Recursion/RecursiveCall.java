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