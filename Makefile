NAME := realify

DATE := $(shell date "+%Y%m%d-%H%M")

REV ?= v2.1

HASH ?= release

ZIP := $(NAME)-$(REV)-$(HASH)-$(DATE).zip

EXCLUDE := Makefile *.git*  *.zip

normal: $(ZIP)

$(ZIP):
	@echo "Creating ZIP: $(ZIP)"
	@zip -r9 "$@" . -x $(EXCLUDE)
	@echo "Generating SHA1..."
	@sha1sum "$@" > "$@.sha1"
	@cat "$@.sha1"
	@echo "Done."


clean:
	@rm -vf *.zip*
	@echo "Done."
