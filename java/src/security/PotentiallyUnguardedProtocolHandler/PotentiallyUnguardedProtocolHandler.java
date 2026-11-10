import java.awt.Desktop;
import java.io.IOException;
import java.net.URI;
import java.net.URISyntaxException;
import javax.servlet.http.HttpServletRequest;

public class PotentiallyUnguardedProtocolHandler {
    public void openUrl(HttpServletRequest request) throws IOException, URISyntaxException {
        String input = request.getParameter("url");
        Desktop.getDesktop().browse(new URI(input)); // BAD
    }

    public void openWebUrl(HttpServletRequest request) throws IOException, URISyntaxException {
        String input = request.getParameter("url");
        URI url = new URI(input);
        if ("https".equalsIgnoreCase(url.getScheme())
                || "http".equalsIgnoreCase(url.getScheme())) {
            Desktop.getDesktop().browse(url); // GOOD
        }
    }
}
