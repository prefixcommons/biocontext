# Makefile to generate source JSON-LD contexts plus merged contexts

CONTEXTS_WITHOUT_UBER := obo idot idot_nr semweb monarch semweb_vocab ro_vocab
CONTEXTS := $(CONTEXTS_WITHOUT_UBER) uber

all: $(patsubst %,registry/%_context.jsonld,$(CONTEXTS))

# TODO: Dockerize
install:
	pip install -r requirements.txt

test: all

trigger:
	touch $@

## ----------------------------------------
## CONTEXTS
## ----------------------------------------

## OBO
## We pull from the official OBO registry
##
registry/obo_context.jsonld: trigger
	wget --no-check-certificate http://obofoundry.org/registry/obo_context.jsonld -O $@

## Gene Ontology
## Minerva
registry/minerva_context.jsonld:  trigger
	wget --no-check-certificate https://raw.githubusercontent.com/geneontology/minerva/master/minerva-core/src/main/resources/amigo_context_manual.jsonld -O $@

## IDENTIFIERS.ORG

## Step1: Get miriam
# TODO: this is currently broken
#registry/miriam.ttl:  trigger
#	wget --no-check-certificate http://www.ebi.ac.uk/miriam/main/export/registry.ttl -O $@

##
## Everything from MIRIAM registry
#registry/idot_context.jsonld: registry/miriam.ttl
#	 ./bin/miriam2jsonld.pl $< > $@

## NON-REDUNDANT IDOT
##
## OBO Library takes priority, we subtract OBO from IDOT
registry/idot_nr_context.jsonld: registry/idot_context.jsonld registry/obo_context.jsonld
	python3 ./bin/subtract-context.py $^ > $@.tmp && mv $@.tmp $@

## Generic: derived from manually curated source
registry/%_context.jsonld: registry/%_context.yaml
	./bin/yaml2json.py $< > $@.tmp && mv $@.tmp $@

## COMBINED
##
## The kitchen sink

UBER = obo idot_nr semweb
registry/uber_context.jsonld: $(patsubst %,registry/%_context.jsonld,$(CONTEXTS_WITHOUT_UBER))
	python3 ./bin/concat-context.py $^ > $@.tmp && mv $@.tmp $@



## GO
registry/go-db-xrefs.json: ../go-site/metadata/db-xrefs.yaml
	./bin/yaml2json.pl $< > $@

## Monarch
registry/monarch-curie_map.yaml:
	wget --no-check-certificate https://raw.githubusercontent.com/monarch-initiative/dipper/master/dipper/curie_map.yaml
