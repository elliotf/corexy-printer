all: stls

define render_stl_template

stls: stl/$(1)

stl/$(1) : parts/$(1).scad
	echo $$^ && openscad --enable=predictible-output -D debug=0 -m make -o $$@.stl $$^ && (notify-send "$$@ done" || true)

.PHONY : stl/$(1)

endef

scads := $(foreach scad, $(wildcard parts/*.scad),$(patsubst %.scad,%,$(notdir $(scad))))

$(foreach scad, $(scads), $(eval $(call render_stl_template,$(scad))))
