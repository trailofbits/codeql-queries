import java.awt.Desktop;
import java.io.IOException;
import java.net.URI;
import java.net.URISyntaxException;
import javax.servlet.http.HttpServletRequest;

public class PotentiallyUnguardedProtocolHandler {

    public void bad1(HttpServletRequest request) throws IOException, URISyntaxException {
        String url = request.getParameter("url");
        Desktop.getDesktop().browse(new URI(url));
    }

    public void bad2(String userInput) throws IOException, URISyntaxException {
        URI uri = new URI(userInput);
        Desktop.getDesktop().browse(uri);
    }

    public void safe1(HttpServletRequest request) throws IOException, URISyntaxException {
        String url = request.getParameter("url");
        URI uri = new URI(url);
        if (uri.getScheme().equals("https") || uri.getScheme().equals("http")) {
            Desktop.getDesktop().browse(uri);
        }
    }

    public void safe2(String userInput) throws IOException, URISyntaxException {
        if (userInput.startsWith("https://") || userInput.startsWith("http://")) {
            Desktop.getDesktop().browse(new URI(userInput));
        }
    }

    public void bad3(HttpServletRequest request) throws IOException, URISyntaxException {
        String url = request.getParameter("url");
        URI uri = new URI(url);

        // Weak check - only checks if scheme exists, not what it is
        if (uri.getScheme() != null) {
            Desktop.getDesktop().browse(uri);
        }
    }

    public void safe3(String userInput) throws IOException, URISyntaxException {
        URI uri = new URI(userInput);
        String scheme = uri.getScheme();

        if (scheme != null && (scheme.equalsIgnoreCase("http") || scheme.equalsIgnoreCase("https"))) {
            Desktop.getDesktop().browse(uri);
        }
    }

    public void safe4() throws IOException, URISyntaxException {
        // hardcoded, no untrusted input
        Desktop.getDesktop().browse(new URI("https://example.com"));
    }
}
