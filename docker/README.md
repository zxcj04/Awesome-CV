# Reproducible build environment (`docker/`)

This folder gives any developer **or coding agent** a one-command, repeatable way
to compile the CV/résumé/cover-letter PDFs — with **Traditional-Chinese text
rendering correctly** — without installing TeX or fonts on the host.

## What it solves

The résumé mixes English and Chinese. The upstream `awesome-cv.cls` is tuned for
macOS and has two issues on a clean Linux/CI box:

1. **`XeTeX` cannot find named font faces** like `Source Sans 3 Light Italic`
   via fontconfig → build fails.
2. **No CJK font** → Chinese shows up as tofu boxes (`□□□`).

This environment fixes both:

- Builds with **LuaLaTeX** (`luaotfload` resolves the named faces correctly).
- Installs **Noto Sans CJK TC** and wires it in as a luaotfload *fallback* inside
  `awesome-cv.cls`, so Han characters fall back to the CJK font while Latin text
  keeps using Source Sans 3 / Roboto.

## Requirements

- Docker with Compose v2 (`docker compose ...`).
- ~5 GB disk for the TeX Live base image (pulled once).

## Usage

Run these from the **repository root**:

```bash
# Build all example PDFs -> examples/tex_output/{resume,cv,coverletter}.pdf
docker compose -f docker/docker-compose.yaml run --rm cv

# Build just the résumé
docker compose -f docker/docker-compose.yaml run --rm cv make resume.pdf

# Run lualatex directly (compile from repo root so \input paths resolve)
docker compose -f docker/docker-compose.yaml run --rm cv \
  lualatex -interaction=nonstopmode -output-directory=examples/tex_output examples/resume.tex

# Interactive shell (inspect fonts: fc-list | grep -i "noto.*cjk")
docker compose -f docker/docker-compose.yaml run --rm cv bash
```

The repo is bind-mounted at `/work`, so generated PDFs appear directly in your
working tree under `examples/tex_output/`.

> The first invocation builds the image (TeX Live + `fonts-noto-cjk`). Later runs
> reuse it. Rebuild after changing the `Dockerfile` with
> `docker compose -f docker/docker-compose.yaml build`.

## Using a different CJK font

The CJK family is `Noto Sans CJK TC` by default. To use another **installed**
font (e.g. `Noto Sans CJK SC`, `Source Han Sans`), set it before
`\documentclass` in your `.tex`:

```latex
\def\acvCJKFont{Noto Sans CJK SC}
\documentclass[11pt, a4paper]{awesome-cv}
```

If the font is not in the image, add it to `Dockerfile` (another `apt-get install`
line, then `fc-cache -f`) and rebuild.

## Keep in sync

Three places reference the toolchain/font; change them together:

- `docker/Dockerfile` — installs `fonts-noto-cjk`.
- `.github/workflows/main.yml` — installs the same font in CI.
- `awesome-cv.cls` — `\acvCJKFont` and the `lualatex`-only fallback.
- `Makefile` — `CC = lualatex`.
