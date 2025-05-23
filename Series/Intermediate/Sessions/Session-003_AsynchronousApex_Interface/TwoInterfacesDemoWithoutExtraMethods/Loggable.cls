public interface Loggable {
    void log(String message);
    void logError(Exception ex);
}