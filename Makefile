.PHONY: compile watch

compile:
	typst compile --font-path resume/font resume/resume.typ

watch:
	typst watch --font-path resume/font resume/resume.typ
