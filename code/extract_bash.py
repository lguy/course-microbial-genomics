#!/usr/bin/env python3
"""
Extract all bash code blocks from episode .Rmd files listed in config.yaml
and write them to a single commented shell script.

Usage: python code/extract_bash.py [--output OUTPUT]
"""

import re
import argparse
from pathlib import Path

# ---------------------------------------------------------------------------
# Minimal YAML parser for the episodes list (avoids a PyYAML dependency).
# Reads only the block under the "episodes:" key, skipping commented lines.
# ---------------------------------------------------------------------------

def parse_episodes(config_path: Path) -> list[str]:
    """Return the list of episode filenames from config.yaml."""
    episodes = []
    in_episodes = False
    with config_path.open() as fh:
        for line in fh:
            stripped = line.rstrip()
            # Detect section header
            if re.match(r'^episodes\s*:', stripped):
                in_episodes = True
                continue
            # Stop when a new top-level YAML key begins (word followed by colon)
            if in_episodes and re.match(r'^\w.*:', stripped):
                break
            # Collect non-commented list items
            if in_episodes:
                m = re.match(r'^\s*-\s+(\S+)', stripped)
                if m:
                    episodes.append(m.group(1))
    return episodes


def extract_bash_blocks(rmd_path: Path) -> list[str]:
    """Return a list of bash code block contents from an .Rmd file."""
    text = rmd_path.read_text()
    # Match fenced bash blocks: ```bash ... ```
    pattern = re.compile(r'```bash\s*\n(.*?)```', re.DOTALL)
    return [m.group(1).rstrip() for m in pattern.finditer(text)]


def episode_title(rmd_path: Path) -> str:
    """Extract the title field from the YAML front matter, or fall back to filename."""
    text = rmd_path.read_text()
    m = re.search(r"^title\s*:\s*['\"]?(.+?)['\"]?\s*$", text, re.MULTILINE)
    return m.group(1) if m else rmd_path.name


# ---------------------------------------------------------------------------
# Main
# ---------------------------------------------------------------------------

def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "--output",
        default="code/all_commands.sh",
        help="Output shell script path (default: code/all_commands.sh)",
    )
    args = parser.parse_args()

    repo_root = Path(__file__).resolve().parent.parent
    config_path = repo_root / "config.yaml"
    episodes_dir = repo_root / "episodes"
    output_path = repo_root / args.output

    episodes = parse_episodes(config_path)
    if not episodes:
        print("No episodes found in config.yaml.")
        return

    lines = [
        "#!/usr/bin/env bash",
        "# Auto-generated: all bash commands from course episodes.",
        "# Source: config.yaml → episodes/ → bash code blocks.",
        "# Do not edit manually; regenerate with: python code/extract_bash.py",
        "",
    ]

    for filename in episodes:
        rmd_path = episodes_dir / filename
        if not rmd_path.exists():
            print(f"WARNING: {rmd_path} not found, skipping.")
            continue

        title = episode_title(rmd_path)
        blocks = extract_bash_blocks(rmd_path)

        if not blocks:
            continue

        # Section header for this episode
        lines.append("#" + "=" * 70)
        lines.append(f"# Episode: {title}  ({filename})")
        lines.append("#" + "=" * 70)
        lines.append("")

        for i, block in enumerate(blocks, start=1):
            lines.append(f"# --- block {i} ---")
            lines.append(block)
            lines.append("")

    output_path.parent.mkdir(parents=True, exist_ok=True)
    output_path.write_text("\n".join(lines) + "\n")
    print(f"Written {output_path} ({len(lines)} lines, {len(episodes)} episodes processed)")


if __name__ == "__main__":
    main()
