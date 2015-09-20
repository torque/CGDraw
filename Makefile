OUTPUT  := CGDraw.jsx
DEPS    := CGDrawUI.coffee CGDraw.coffee
TEMP    := .temp.coffee
INSTDIR := /Applications/Adobe Illustrator CC/Presets.localized/en_US/Scripts

.PHONY: all install clean

all: $(OUTPUT)

$(OUTPUT): $(DEPS)
	@cat $^ > $(TEMP)
	@coffee -bc $(TEMP)
	@mv $(TEMP:.coffee=.js) $(OUTPUT)
	@rm $(TEMP)

install: all
	@cp $(OUTPUT) "$(INSTDIR)"

clean:
	@rm -f $(OUTPUT)
