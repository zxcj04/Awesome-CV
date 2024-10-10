.PHONY: examples create clean

CC = xelatex
EXAMPLES_DIR = examples
RESUME_DIR = examples/resume
OUTPUT_DIR = examples/tex_output
CV_DIR = examples/cv
RESUME_SRCS = $(shell find $(RESUME_DIR) -name '*.tex')
CV_SRCS = $(shell find $(CV_DIR) -name '*.tex')

examples: $(foreach x, coverletter cv resume, $x.pdf)

resume.pdf: $(EXAMPLES_DIR)/resume.tex $(RESUME_SRCS) create
	$(CC) -output-directory=$(OUTPUT_DIR) $<

cv.pdf: $(EXAMPLES_DIR)/cv.tex $(CV_SRCS) create
	$(CC) -output-directory=$(OUTPUT_DIR) $<

coverletter.pdf: $(EXAMPLES_DIR)/coverletter.tex create
	$(CC) -output-directory=$(OUTPUT_DIR) $<

create:
	mkdir -p $(OUTPUT_DIR)

clean:
	rm -rf $(OUTPUT_DIR)/*
