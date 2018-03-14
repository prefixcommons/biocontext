# Makefile to generate source JSON-LD contexts plus merged contexts

CONTEXTS := pr goxrefs obo idot idot_nr semweb monarch semweb_vocab ro_vocab commons

all: $(patsubst %,registry/%_context.jsonld,$(CONTEXTS)) reports/clashes.txt

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
	wget --no-check-certificate http://obofoundry.org/registry/obo_context.jsonld -O $@ && touch $@

## Gene Ontology
## Minerva
registry/minerva_context.jsonld:  trigger
	wget --no-check-certificate https://raw.githubusercontent.com/geneontology/minerva/master/minerva-core/src/main/resources/amigo_context_manual.jsonld -O $@ && touch $@

registry/goxrefs_context.jsonld: registry/go-db-xrefs.json 
	./bin/go-xrefs-to-context.py $< > $@.tmp && mv $@.tmp $@

## Monarch
registry/monarch_curie_map.yaml:
	wget --no-check-certificate https://raw.githubusercontent.com/monarch-initiative/dipper/master/dipper/curie_map.yaml -O $@

registry/monarch_context.jsonld: registry/monarch_curie_map.yaml
	./bin/curiemap2context.py $< > $@.tmp && mv $@.tmp $@

## PRO
registry/pr_context.jsonld:
	./bin/pro-obo2jsonld.pl > $@

## IDENTIFIERS.ORG

## Step1: Get miriam
# TODO: this is currently broken
#registry/miriam.ttl:  trigger
#	wget --no-check-certificate http://www.ebi.ac.uk/miriam/main/export/registry.ttl -O $@ && touch $@

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

# Highest priority LAST
COMMONS_SOURCES =  semweb idot_nr monarch obo
registry/commons_context.jsonld: $(patsubst %, registry/%_context.jsonld, $(COMMONS_SOURCES))
	python3 ./bin/concat-context.py $^ > $@.tmp && mv $@.tmp $@

SUPERSET_SOURCES =  goxrefs idot semweb monarch semweb_vocab ro_vocab obo
reports/clashes.txt: $(patsubst %, registry/%_context.jsonld, $(SUPERSET_SOURCES))
	(python3 ./bin/concat-context.py $^ > registry/superset.jsonld) >& $@

# requires biomake
reports/clashes-$(A)-$(B).txt: $(patsubst %, registry/%_context.jsonld, $(A) $(B))
	(python3 ./bin/concat-context.py $^ > registry/superset.jsonld) >& $@

# requires biomake
reports/clashes-$(A)-$(B)-$(C).txt: $(patsubst %, registry/%_context.jsonld, $(A) $(B) $(C))
	(python3 ./bin/concat-context.py $^ > registry/superset.jsonld) >& $@

## GO
registry/go-db-xrefs.json: ../go-site/metadata/db-xrefs.yaml
	./bin/yaml2json.pl $< > $@


