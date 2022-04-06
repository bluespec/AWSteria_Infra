Figs = \
    Fig_010_AWSteria_Infra_Architecture.png \
    Fig_020_AWSteria_Infra_Simulation.png \
    Fig_030_AWSteria_Infra_VCU118.png \
    Fig_040_AWSteria_Infra_AWSF1.png \
    Fig_050_AWSteria_Infra_TestApp.png \
    Fig_060_AWSteria_Infra_TestApp_DRM.png \


all: $(Figs)

$(Figs): %.png: %.svg
	inkscape --export-png=$@  --export-area-drawing  -d 300 -y 0.0 $<

AWSteria_architecture.html: AWSteria_architecture.adoc  $(Figs)
	asciidoctor  AWSteria_architecture.adoc

# ================================================================

.PHONY: clean
clean:
	rm -r -f *~

.PHONY: full_clean
full_clean:
	rm -r -f *~  AWSteria_architecture.html  Fig*.png
