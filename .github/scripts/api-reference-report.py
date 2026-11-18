"""Write a plain-text API reference report and a GitHub Actions summary."""

import json
import os
from datetime import datetime, timezone
from pathlib import Path
import subprocess
from urllib.error import HTTPError, URLError
from urllib.parse import urlencode
from urllib.request import Request, urlopen


REFERENCES = (
    (
        "Swift",
        "/swiftlang/swift-book",
        "https://docs.swift.org/swift-book/documentation/the-swift-programming-language/",
        "How do I use #available and @available to adopt new Apple SDK APIs while supporting older operating systems?",
    ),
    (
        "SwiftLog",
        "/apple/swift-log",
        "https://github.com/apple/swift-log",
        "Show the current SwiftLog Logger API for log levels, metadata, and custom log handlers.",
    ),
)


def get_context(library_id, query):
    params = urlencode({"libraryId": library_id, "query": query, "type": "txt"})
    request = Request(f"https://context7.com/api/v2/context?{params}")
    key = os.environ.get("CONTEXT7_API_KEY")
    if key:
        request.add_unredirected_header("Authorization", f"Bearer {key}")

    try:
        with urlopen(request, timeout=15) as response:
            excerpt = response.read(12_001)
    except HTTPError as error:
        return f"Unavailable (HTTP {error.code})", ""
    except (URLError, TimeoutError):
        return "Unavailable (connection error or timeout)", ""

    text = excerpt[:12_000].decode("utf-8", errors="replace").strip()
    if not text:
        return "Unavailable (empty response)", ""
    if len(excerpt) > 12_000:
        text += "\n\n[Excerpt shortened to fit this report.]"
    return "Retrieved", text


def main():
    report_dir = Path(os.environ["RUNNER_TEMP"]) / "api-reference-report"
    report_dir.mkdir(parents=True, exist_ok=True)
    generated_at = datetime.now(timezone.utc).strftime("%Y-%m-%d %H:%M UTC")
    manifest = json.loads(subprocess.check_output(["swift", "package", "dump-package"], text=True))
    versions = subprocess.check_output(["xcodebuild", "-version"], text=True).strip()
    sdks = subprocess.check_output(["xcodebuild", "-showsdks"], text=True).strip()

    lines = [
        "API Reference Report",
        f"Generated: {generated_at}",
        f"Commit: {os.environ['GITHUB_SHA']}",
        "",
        "This report lists the runner SDKs and reference material. The build workflows check code compatibility.",
        "",
        "Xcode on the runner",
        versions,
        "",
        "Installed Apple SDKs",
        sdks,
        "",
        "Package deployment targets",
    ]
    lines.extend(f"- {item['platformName']}: {item['version']}" for item in manifest["platforms"])
    lines.extend(["", "Apple SDK release notes", "https://developer.apple.com/documentation/xcode-release-notes"])

    summary = [
        "## API reference report",
        "",
        f"Generated {generated_at}",
        "",
        "| Reference | Context7 lookup |",
        "| --- | --- |",
    ]
    for title, library_id, upstream, query in REFERENCES:
        status, excerpt = get_context(library_id, query)
        print(f"{title} documentation lookup: {status}.")
        lines.extend(["", title, f"Official reference: {upstream}", f"Context7 lookup: {status}"])
        if excerpt:
            lines.extend([f"Context7 query: {query}", "", excerpt])
        summary.append(f"| [{title}]({upstream}) | {status} |")

    summary.extend([
        "",
        "Download the **api-reference-report** artifact for the text report, installed SDKs, and package deployment targets.",
    ])
    (report_dir / "api-reference-report.txt").write_text("\n".join(lines) + "\n", encoding="utf-8")
    with open(os.environ["GITHUB_STEP_SUMMARY"], "a", encoding="utf-8") as summary_file:
        summary_file.write("\n".join(summary) + "\n")


if __name__ == "__main__":
    main()
