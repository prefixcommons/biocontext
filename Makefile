MODS := obo idot idot_nr uber

all: $(patsubst %,registry/%_context.jsonld,$(MODS))

install:
	npm install

registry/obo_context.jsonld: ../owltools2-experimental/owltools2-core/src/main/resources/obo_context.jsonld
	cp $< $@

registry/miriam.ttl:
	wget http://www.ebi.ac.uk/miriam/main/export/registry.ttl -O $@

registry/idot_context.jsonld: registry/miriam.ttl
	 ./bin/miriam2jsonld.pl $< > $@

registry/idot_nr_context.jsonld: registry/idot_context.jsonld registry/obo_context.jsonld
	./bin/subtract-context.pl $^ > $@.tmp && mv $@.tmp $@

UBER = obo idot_nr
registry/uber_context.jsonld: $(patsubst %,registry/%_context.jsonld,$(MODS))
	./bin/concat-context.pl $^ > $@.tmp && mv $@.tmp $@
