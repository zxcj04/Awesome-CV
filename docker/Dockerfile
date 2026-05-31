# Reproducible Awesome-CV build environment.
#
# Base image: official TeX Live (full scheme). It already ships everything the
# template needs -- lualatex, fontspec/luaotfload, unicode-math, fontawesome6,
# and the Source Sans 3 + Roboto fonts. The ONLY thing missing for a
# Traditional-Chinese resume is a CJK font, which we add below.
#
# Pin the tag for byte-for-byte reproducibility once you are happy with a
# release, e.g. `texlive/texlive:TL2026`. `latest` was TeX Live 2026 when this
# file was written (2026-05-31).
FROM texlive/texlive:latest

# Noto Sans/Serif CJK (the TC variant, "Noto Sans CJK TC", is bundled here).
# awesome-cv.cls registers this as a luaotfload fallback so Han characters
# render instead of showing up as tofu boxes. Keep this font name in sync with
# \acvCJKFont in awesome-cv.cls and the CI workflow (.github/workflows/main.yml).
RUN apt-get update \
 && apt-get install -y --no-install-recommends fonts-noto-cjk \
 && fc-cache -f \
 && rm -rf /var/lib/apt/lists/*

WORKDIR /work

# Default action: build all example PDFs (resume, cv, coverletter) with
# lualatex via the Makefile. Override on the command line to build one target
# or run lualatex directly.
CMD ["make"]
