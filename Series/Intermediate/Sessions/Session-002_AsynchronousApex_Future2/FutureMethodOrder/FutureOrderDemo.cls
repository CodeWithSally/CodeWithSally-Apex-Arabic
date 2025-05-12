public class FutureOrderDemo {
    
    @future
    public static void callFuture1() {
        System.debug('🚀 Running Future 1');
    }

    @future
    public static void callFuture2() {
        System.debug('🔥 Running Future 2');
    }

    @future
    public static void callFuture3() {
        System.debug('🎯 Running Future 3');
    }

    public static void runAllFutures() {
        callFuture1();
        callFuture2();
        callFuture3();
    }
}