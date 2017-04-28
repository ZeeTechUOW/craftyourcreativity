package Model;

public class HttpErrorList {

    public HttpErrorList() {
    }

    // Common HTTP Error List
    public static String getMessages(int code) {
        switch (code) {
            case 400:
                return "Bad Request";

            case 401:
                return "Unauthorized";

            case 403:
                return "Forbidden";

            case 404:
                return "Not Found";

            case 405:
                return "Method Not Allowed";

            case 407:
                return "Proxy Authentication Required";

            case 408:
                return "Request Timeout";

            case 500:
                return "Internal Server Error";

            case 501:
                return "Not Implemented";

            case 502:
                return "Bad Gateway";

            case 503:
                return "Service Unavailable";

            case 504:
                return "Gateway Time-out";

            default:
                return "";
        }
    }
}
