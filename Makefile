.PHONY: examples create clean

# LuaLaTeX is required: it resolves the named font faces (e.g. "Source Sans 3
# Light Italic") that XeTeX cannot match via fontconfig on Linux, and it powers
# the luaotfload CJK fallback in awesome-cv.cls. See docker/ for a ready env.
CC = lualatex
CFLAGS = -interaction=nonstopmode -halt-on-error
EXAMPLES_DIR = examples
RESUME_DIR = examples/resume
OUTPUT_DIR = examples/tex_output
CV_DIR = examples/cv
RESUME_SRCS = $(shell find $(RESUME_DIR) -name '*.tex')
CV_SRCS = $(shell find $(CV_DIR) -name '*.tex')

examples: $(foreach x, coverletter cv resume, $x.pdf)

resume.pdf: $(EXAMPLES_DIR)/resume.tex $(RESUME_SRCS) create
	$(CC) $(CFLAGS) -output-directory=$(OUTPUT_DIR) $<

cv.pdf: $(EXAMPLES_DIR)/cv.tex $(CV_SRCS) create
	$(CC) $(CFLAGS) -output-directory=$(OUTPUT_DIR) $<

coverletter.pdf: $(EXAMPLES_DIR)/coverletter.tex create
	$(CC) $(CFLAGS) -output-directory=$(OUTPUT_DIR) $<

create:
	mkdir -p $(OUTPUT_DIR)

clean:
	rm -rf $(OUTPUT_DIR)/*
