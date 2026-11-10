import java.awt.Desktop;
import java.io.IOException;
import java.net.URI;
import java.net.URISyntaxException;
import javax.servlet.http.HttpServletRequest;

public class PotentiallyUnguardedProtocolHandler {
    public void badDesktop(HttpServletRequest request)
            throws IOException, URISyntaxException {
        String url = request.getParameter("url");
        Desktop.getDesktop().browse(new URI(url)); // BAD
    }

    public void goodDesktopScheme(HttpServletRequest request)
            throws IOException, URISyntaxException {
        String url = request.getParameter("url");
        URI uri = new URI(url);
        if ("https".equalsIgnoreCase(uri.getScheme())
                || "http".equalsIgnoreCase(uri.getScheme())) {
            Desktop.getDesktop().browse(uri); // GOOD
        }
    }

    public void goodDesktopPrefix(HttpServletRequest request)
            throws IOException, URISyntaxException {
        String url = request.getParameter("url");
        if (url.startsWith("https://") || url.startsWith("http://")) {
            Desktop.getDesktop().browse(new URI(url)); // GOOD
        }
    }

    public void badDesktopFileScheme(HttpServletRequest request)
            throws IOException, URISyntaxException {
        String url = request.getParameter("url");
        URI uri = new URI(url);
        if ("file".equalsIgnoreCase(uri.getScheme())) {
            Desktop.getDesktop().browse(uri); // BAD
        }
    }

    public void badDesktopPartialPrefix(HttpServletRequest request)
            throws IOException, URISyntaxException {
        String url = request.getParameter("url");
        if (url.startsWith("http")) {
            Desktop.getDesktop().browse(new URI(url)); // BAD
        }
    }

    public void badDesktopRejectedScheme(HttpServletRequest request)
            throws IOException, URISyntaxException {
        String url = request.getParameter("url");
        URI uri = new URI(url);
        if (!"https".equalsIgnoreCase(uri.getScheme())) {
            Desktop.getDesktop().browse(uri); // BAD
        }
    }

    public void badRuntimeArray(HttpServletRequest request) throws IOException {
        String url = request.getParameter("url");
        String[] command = {"xdg-open", url};
        Runtime.getRuntime().exec(command); // BAD
    }

    public void goodRuntimeArray(HttpServletRequest request) throws IOException {
        String url = request.getParameter("url");
        if (url.startsWith("https://")) {
            String[] command = {"xdg-open", url};
            Runtime.getRuntime().exec(command); // GOOD
        }
    }

    public void badRuntimeString(HttpServletRequest request) throws IOException {
        String url = request.getParameter("url");
        Runtime.getRuntime().exec("xdg-open " + url); // BAD
    }

    public void badRuntimeRundll(HttpServletRequest request) throws IOException {
        String url = request.getParameter("url");
        String[] command = {"rundll32", "url.dll,FileProtocolHandler", url};
        Runtime.getRuntime().exec(command); // BAD
    }

    public void badRuntimeOpen(HttpServletRequest request) throws IOException {
        String url = request.getParameter("url");
        Runtime.getRuntime().exec("open " + url); // BAD
    }

    public void unrelatedRuntime(HttpServletRequest request) throws IOException {
        String argument = request.getParameter("argument");
        Runtime.getRuntime().exec("echo " + argument); // GOOD
    }

    public void unrelatedRuntimeWithHandlerArgument(HttpServletRequest request)
            throws IOException {
        String url = request.getParameter("url");
        Runtime.getRuntime().exec(new String[]{"echo", "xdg-open", url}); // GOOD
        Runtime.getRuntime().exec("echo xdg-open " + url); // GOOD
    }

    public void badProcessBuilder(HttpServletRequest request) throws IOException {
        String url = request.getParameter("url");
        ProcessBuilder builder = new ProcessBuilder("xdg-open", url); // BAD
        builder.start();
    }

    public void goodProcessBuilder(HttpServletRequest request) throws IOException {
        String url = request.getParameter("url");
        if (url.startsWith("https://")) {
            ProcessBuilder builder = new ProcessBuilder("xdg-open", url); // GOOD
            builder.start();
        }
    }

    public void unrelatedProcessBuilder(HttpServletRequest request) throws IOException {
        String url = request.getParameter("url");
        ProcessBuilder builder = new ProcessBuilder("echo", "xdg-open", url); // GOOD
        builder.start();
    }
}
