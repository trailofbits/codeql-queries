import java.io.IOException;
import java.io.InputStreamReader;
import java.util.HashMap;
import java.util.Map;

class StreamException extends RuntimeException {
    public StreamException(Throwable cause) {
        super(cause);
    }
}

class Token {
    public static final int TYPE_MAP_ID_TO_VALUE = 0x2;
    
    private int type;
    private String id;
    private Object value;
    
    public int getType() {
        return type;
    }
    
    public String getId() {
        return id;
    }
    
    public Object getValue() {
        return value;
    }
}

class TokenFormatter {
    public Token read(InputStreamReader in) throws IOException {
        // Implementation would go here
        return new Token();
    }
}

class RecursiveCallExample {
    private TokenFormatter tokenFormatter = new TokenFormatter();
    private Map<String, Object> idRegistry = new HashMap<>();
    private InputStreamReader in;

    public RecursiveCallExample(InputStreamReader in) {
        this.in = in;
    }

    // finding: readToken calls itself
    // Based on https://github.com/x-stream/xstream/blob/dfa1d35462fe84412ee72a9b0cf5b5c633086520/xstream/src/java/com/thoughtworks/xstream/io/binary/BinaryStreamReader.java#L165
    Token readToken() {
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
}

class RecursiveCallBasic {
    // finding: foo-bar recursive loop
    public boolean bar() {
        boolean fooResult = foo();
        return fooResult;
    }

    public boolean foo() {
        return bar();
    }

    // finding: calls to self
    public boolean directRecursive() {
        return directRecursive();
    }

    // finding: level0->level1->level2->level0
    public boolean level0() {
        if (someCondition()) {
            return true;
        }        
        return level1();
    }
    public boolean level1() {
        if (someCondition()) {
            return true;
        }        
        return level2();
    }
    public boolean level2() {
        if (someCondition()) {
            return true;
        }
        return level0();
    }

    private boolean someCondition() {
        return false;
    }
}

class RecursiveCallNonLinear {
    // finding: level0->...->level0
    public boolean level0() {
        if (someOtherCondition()) {
            return true;
        }
        if (someCondition()) {
            return level1();
        }        
        return level2();
    }
    public boolean level1() {
        if (someCondition()) {
            return true;
        }        
        return level2();
    }
    public boolean level2() {
        if (someCondition()) {
            return level1();
        }
        return level0();
    }

    private boolean someCondition() {
        return false;
    }

    private boolean someOtherCondition() {
        return true;
    }
}

class RecursiveCallWronglyLimited {
    // finding: recursion is not limited
    public boolean directRecursiveNoDepth(int anything, int depth) {
        if (depth == 0) {
            return true;
        }
        return directRecursiveNoDepth(anything, depth);
    }
}

class RecursiveCallLimited {
    // todook: recursion is limited
    public boolean directRecursiveDepth(int depth) {
        if (depth == 0) {
            return true;
        }
        return directRecursiveDepth(depth - 1);
    }

    // todook: level0->level1->level2->level0 with bound
    public boolean level0D(int depth) {
        if (depth == 0) {
            return true;
        }
        if (someCondition()) {
            return true;
        }        
        return level1D(depth-1);
    }
    public boolean level1D(int depth) {
        if (someCondition()) {
            return true;
        }        
        return level2D(depth);
    }
    public boolean level2D(int depth) {
        if (someCondition()) {
            return true;
        }
        return level0D(depth-1);
    }

    private boolean someCondition() {
        return false;
    }
}
 
// ok
class NotRecursive {
    public static boolean foo() {
        return bar();
    }

    public static boolean bar() {
        return true;
    }
}