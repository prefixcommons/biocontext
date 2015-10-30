MODS := obo idot idot_nr semweb monarch semweb_vocab ro_vocab uber

all: $(patsubst %,registry/%_context.jsonld,$(MODS))

install:
	pip install -r requirements.txt

## OBO
## For now we just clone this from ROBOT; TODO - better way of syncing with OBO
registry/obo_context.jsonld: ../owltools2-experimental/owltools2-core/src/main/resources/obo_context.jsonld
	cp $< $@

## IDENTIFIERS.ORG
##
## Everything from MIRIAM registry
registry/idot_context.jsonld: registry/miriam.ttl
	 ./bin/miriam2jsonld.pl $< > $@

## NON-REDUNDANT IDOT
##
## OBO Library takes priority, we subtract OBO from IDOT
registry/idot_nr_context.jsonld: registry/idot_context.jsonld registry/obo_context.jsonld
	./bin/subtract-context.pl $^ > $@.tmp && mv $@.tmp $@

## Generic: derived from manually curated source
registry/%_context.jsonld: registry/%_context.yaml
	./bin/yaml2json.py $< > $@.tmp && mv $@.tmp $@

## COMBINED
##
## The kitchen sink

UBER = obo idot_nr semweb
registry/uber_context.jsonld: $(patsubst %,registry/%_context.jsonld,$(MODS))
	./bin/concat-context.pl $^ > $@.tmp && mv $@.tmp $@

## DEPENDENCIES

registry/miriam.ttl:
	wget http://www.ebi.ac.uk/miriam/main/export/registry.ttl -O $@

## GO

registry/go-db-xrefs.json: ../go-site/metadata/db-xrefs.yaml
	./bin/yaml2json.pl $< > $@
