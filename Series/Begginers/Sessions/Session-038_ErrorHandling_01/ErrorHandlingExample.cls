// Example to illustrate unhandled vs handled errors
public class ErrorHandlingExample {

    public static void unhandledErrorDemo() {
        // This will cause an unhandled exception
        Integer num = 5 / 0; // Division by zero
    }

    public static void handledErrorDemo() {
        try {
            Integer num = 5 / 0; // Division by zero
        } catch (Exception e) {
            //log error in custom object or to use an appexchange app
            System.debug('Handled Error: ' + e.getMessage());
            System.debug('Can not divide by zero');
        }
    }
}