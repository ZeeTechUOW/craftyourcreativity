/*
 * Copyright 2017 Andree Yosua.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package Model;

/**
 *
 * @author Andree Yosua
 */
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
