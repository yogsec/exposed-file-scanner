# Exposed File Finder

The **Exposed File Finder** is a Bash script designed to identify exposed files (e.g., `.html`, `.js`, `.json`) in a website's source code. It scans for potentially sensitive files that could reveal vulnerabilities or sensitive information. This script is useful for security researchers, developers, and organizations aiming to secure their web applications.

---

## Features

- Scan a single URL for exposed files.
- Process multiple URLs from a list.
- Save scan results to a specified file.
- Lightweight and easy to use.

---

## Prerequisites

- A Unix-based operating system with Bash installed (Linux, macOS, or WSL on Windows).
- The `curl` command-line tool for fetching web content.

---

## Usage

### 1. Script Options

```bash
Usage: ./exposed_files.sh [options]
Options:
  -u <url>         Scan a single URL for exposed files.
  -l <file>        Scan a list of URLs from a file.
  -s <file>        Save results to a specified file.
  -h               Display help and usage information.
```

### 2. Examples

#### Scan a Single URL

```bash
./exposed_files.sh -u https://example.com
```

#### Scan Multiple URLs from a File

Create a file (`urls.txt`) containing the URLs to scan:

```
https://example1.com
https://example2.com
```

Run the script with the file:

```bash
./exposed_files.sh -l urls.txt
```

#### Save Results to a File

```bash
./exposed_files.sh -u https://example.com -s results.txt
```

### Display Help

```bash
./exposed_files.sh -h
```

---

## How to Find Vulnerabilities in a GitHub Repository

To use this script for identifying vulnerabilities in your GitHub repository:

1. **Host Your Repository**: Ensure your repository is publicly hosted, or use a local development server to serve your files.

   - Example: If you use GitHub Pages, your repository might be available at `https://<username>.github.io/<repository>/`.

2. **Scan the Hosted Site**:

   Run the script against the hosted site:

   ```bash
   ./exposed_files.sh -u https://<username>.github.io/<repository>/
   ```

3. **Analyze Exposed Files**:

   Review the results for sensitive information like API keys, credentials, or configuration details that might be inadvertently exposed.

4. **Remediation**:

   - Remove or secure exposed files in your repository.
   - Follow secure coding and deployment practices.
   - Use `.gitignore` to exclude sensitive files from being committed.

---

## Notes

- Ensure you have the necessary permissions before scanning third-party websites.
- The script is a tool for improving security and should be used ethically.

---

## License

This script is open-source and available under the [MIT License](LICENSE).

---

## Disclaimer

Use this script responsibly. The author is not liable for any misuse or damages caused by its use.

---

## Description

**Exposed File Finder** is a lightweight and efficient Bash script designed to enhance web application security by identifying exposed files in HTML, JavaScript, and JSON code. It helps developers and security researchers uncover potential vulnerabilities and sensitive information in websites or hosted GitHub repositories. This tool supports scanning individual URLs, processing bulk URL lists, and saving results for further analysis, making it an essential addition to any security toolkit.

