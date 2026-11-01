all: dxfs stls svgs

define render_dxf_template

dxfs: dxf/$(1)

dxf/$(1) : parts/dxf/$(1).scad
	echo $$^ && openscad --enable=predictible-output -D debug=0 -m make -o $$@.dxf $$^ && ./dxf/fix_openscad_dxf.py $$@.dxf && (notify-send "$$@ done" || true) || (notify-send -u critical "$$@ FAILED"; false)

.PHONY : dxf/$(1)

endef

define render_stl_template

stls: stl/$(1)

stl/$(1) : parts/$(1).scad
	echo $$^ && openscad --enable=predictible-output -D debug=0 -m make -o $$@.stl $$^ && (notify-send "$$@ done" || true) || (notify-send -u critical "$$@ FAILED"; false)

.PHONY : stl/$(1)

endef

define render_svg_template

svgs: svg/$(1)

svg/$(1) : parts/svg/$(1).scad
	echo $$^ && openscad --enable=predictible-output -D debug=0 -m make -o $$@.svg $$^ && (notify-send "$$@ done" || true) || (notify-send -u critical "$$@ FAILED"; false)

.PHONY : svg/$(1)

endef

dxf_scads := $(foreach scad, $(wildcard parts/dxf/*.scad),$(patsubst %.scad,%,$(notdir $(scad))))
$(foreach scad, $(dxf_scads), $(eval $(call render_dxf_template,$(scad))))

stl_scads := $(foreach scad, $(wildcard parts/*.scad),$(patsubst %.scad,%,$(notdir $(scad))))
$(foreach scad, $(stl_scads), $(eval $(call render_stl_template,$(scad))))

svg_scads := $(foreach scad, $(wildcard parts/svg/*.scad),$(patsubst %.scad,%,$(notdir $(scad))))
$(foreach scad, $(svg_scads), $(eval $(call render_svg_template,$(scad))))
