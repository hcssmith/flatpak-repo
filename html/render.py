#!/usr/bin/env python3
"""Render the published site: apps.toml (registry) + html/index.html.

Usage: html/render.py OUT_DIR [--registry PATH]

Every [[apps]] entry in apps.toml becomes an entry on the page; the
template html/index.html owns all the surrounding page structure (edit
commands/sections there directly). {{APPS}} and {{GENERATED}} are the
only substitutions. Any other file in html/ (CNAME, images, extra
pages, ...) is copied through verbatim.

Requires Python 3.11+ (stdlib tomllib only).
"""

import argparse
import datetime
import html
import os
import shutil
import sys
import tomllib

HERE = os.path.dirname(os.path.abspath(__file__))
DEFAULT_REGISTRY = os.path.join(HERE, os.pardir, "apps.toml")

# Files belonging to the rendering pipeline, not the published site.
SKIP = {"index.html", os.path.basename(__file__), "__pycache__"}


def esc(s, quote=False):
    return html.escape(s, quote=quote)


def app_entry(app):
    cmd = f"flatpak install hcssmith {app['id']}"
    return f"""<div class="app">
<h3><span class="hash">###</span> {esc(app['name'])} <code class="app-id">{esc(app['id'])}</code></h3>
<p>{esc(app['blurb'])}</p>
<div class="cmd">
  <pre><code><span class="p">$</span> {esc(cmd)}</code></pre>
  <button class="copy" type="button" data-cmd="{esc(cmd, quote=True)}">copy</button>
</div>
</div>"""


def main():
    parser = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    parser.add_argument("out_dir", help="site output directory (the ostree repo root)")
    parser.add_argument("--registry", default=DEFAULT_REGISTRY,
                        help="path to apps.toml (default: ../apps.toml)")
    args = parser.parse_args()

    with open(args.registry, "rb") as f:
        apps = tomllib.load(f)["apps"]
    if not apps:
        sys.exit("apps.toml: no [[apps]] entries")

    with open(os.path.join(HERE, "index.html"), encoding="utf-8") as f:
        template = f.read()

    page = (template
            .replace("{{APPS}}", "\n".join(app_entry(a) for a in apps))
            .replace("{{GENERATED}}", datetime.datetime.now(datetime.timezone.utc)
                     .strftime("%Y-%m-%d %H:%M UTC")))

    os.makedirs(args.out_dir, exist_ok=True)
    out_index = os.path.join(args.out_dir, "index.html")
    with open(out_index, "w", encoding="utf-8") as f:
        f.write(page)
    print(f"wrote {out_index} ({len(apps)} apps)")

    for name in sorted(os.listdir(HERE)):
        if name in SKIP or name.startswith("."):
            continue
        src = os.path.join(HERE, name)
        if os.path.isfile(src):
            shutil.copy2(src, os.path.join(args.out_dir, name))
            print(f"copied {name}")


if __name__ == "__main__":
    main()
