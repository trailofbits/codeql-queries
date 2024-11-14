class RecursiveCall { 
    public boolean bar() {
        boolean fooResult = foo();
        return fooResult;
    }

    public boolean foo() {
        return bar();
    }

    public boolean directRecursive() {
        return directRecursive();
    }

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
 

class NotRecursive {

    public static boolean foo() {
        return bar();
    }

    public static boolean bar() {
        return true;
    }
}