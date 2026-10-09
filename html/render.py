#!/usr/bin/env python3
"""Render the published site from html/site.toml + html/index.html.

Usage: html/render.py OUT_DIR

site.toml is the single source of page content (intro, apps, sections).
The template index.html carries the layout; {{TITLE}}, {{INTRO}},
{{SECTIONS}} and {{GENERATED}} are substituted. Any other file in this
directory (CNAME, images, extra pages, ...) is copied through verbatim.

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

# Files belonging to the rendering pipeline, not the published site.
SKIP = {"index.html", "site.toml", os.path.basename(__file__), "__pycache__"}


def esc(s, quote=False):
    return html.escape(s, quote=quote)


def cmd_block(cmd):
    return f"""<div class="cmd">
  <pre><code><span class="p">$</span> {esc(cmd)}</code></pre>
  <button class="copy" type="button" data-cmd="{esc(cmd, quote=True)}">copy</button>
</div>"""


def app_entry(app):
    cmd = f"flatpak install hcssmith {app['id']}"
    return f"""<div class="app">
<h3><span class="hash">###</span> {esc(app['name'])} <code class="app-id">{esc(app['id'])}</code></h3>
<p>{esc(app['blurb'])}</p>
{cmd_block(cmd)}
</div>"""


def render_section(section, apps):
    parts = [f'<section>\n<h2><span class="hash">##</span> {esc(section["heading"])}</h2>']
    if section.get("note"):
        parts.append(f'<p class="note">{esc(section["note"])}</p>')
    if section.get("apps"):
        if not apps:
            sys.exit("site.toml: a section sets apps = true but [[apps]] is empty")
        parts.append("\n".join(app_entry(a) for a in apps))
    for cmd in section.get("commands", []):
        parts.append(cmd_block(cmd))
    parts.append("</section>")
    return "\n".join(parts)


def main():
    parser = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    parser.add_argument("out_dir", help="site output directory (the ostree repo root)")
    args = parser.parse_args()

    with open(os.path.join(HERE, "site.toml"), "rb") as f:
        data = tomllib.load(f)

    site_url = data.get("site_url", "https://flatpak.hcssmith.com")
    title = site_url.removeprefix("https://").removeprefix("http://").rstrip("/")
    sections = "\n".join(render_section(s, data.get("apps", [])) for s in data.get("sections", []))

    with open(os.path.join(HERE, "index.html"), encoding="utf-8") as f:
        template = f.read()

    page = (template
            .replace("{{TITLE}}", esc(title))
            .replace("{{INTRO}}", esc(data.get("intro", "")))
            .replace("{{SECTIONS}}", sections)
            .replace("{{GENERATED}}", datetime.datetime.now(datetime.timezone.utc)
                     .strftime("%Y-%m-%d %H:%M UTC")))

    os.makedirs(args.out_dir, exist_ok=True)
    out_index = os.path.join(args.out_dir, "index.html")
    with open(out_index, "w", encoding="utf-8") as f:
        f.write(page)
    print(f"wrote {out_index} ({len(data.get('apps', []))} apps, "
          f"{len(data.get('sections', []))} sections)")

    for name in sorted(os.listdir(HERE)):
        if name in SKIP or name.startswith("."):
            continue
        src = os.path.join(HERE, name)
        if os.path.isfile(src):
            shutil.copy2(src, os.path.join(args.out_dir, name))
            print(f"copied {name}")


if __name__ == "__main__":
    main()
