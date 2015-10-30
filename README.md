[![Build Status](https://travis-ci.org/cmungall/biocontext.svg?branch=master)](https://travis-ci.org/cmungall/biocontext)

## BioContext: JSON-LD Contexts for Bioinformatics Data

The goal is to provide a modular set of [JSON-LD](http://json-ld.org/)
contexts for mapping abbreviated names of biological objects onto URIs
for use in semantic web tool chains. Here, "abbreviated name" usually
means a [CURIE](https://en.wikipedia.org/wiki/CURIE) but optionally
human-friendly symbolic names (e.g. `gene`) can also be used as
abbrevations for complete URIs (although this is more dangerous).

A CURIE is a bipartite identifier of the form `Prefix:LocalID`, in
which the prefix is a convenient abbreviation of a URI prefix. CURIEs
in JSON-LD documents are expanded to URIs, if that prefix is defined
in a `@context` object.

Note that you don't need to be using JSON-LD to find this
useful. Bipartite unique IDs are common in bioinformatics, and
mandated in formats such as OBO (the most common way of consuming
ontologies in bioinformatics toolchains).

There are many situations where it's necessary to translate a
bioinformatics ID to URI for use in the semantic web stack. This
includes the [SciGraph](https://github.com/SciGraph/SciGraph) Neo4j
application as well as triplestores, OWL tooling (ROBOT), standard
prefixes for SPARQL queries, etc.

Here are some examples of expansions from abbreviated names to URIs
using these contexts:

 * Ontology class CURIEs
    * GO:0006915 ==> http://purl.obolibrary.org/obo/GO_0006915
    * CHEBI:26619 ==> http://purl.obolibrary.org/obo/CHEBI_26619
    * UBERON:0001685 ==> http://purl.obolibrary.org/obo/UBERON_0001685
    * NCBITaxon:9606 ==> http://purl.obolibrary.org/obo/NCBITaxon_9606
 * Databases CURIEs
    * ENSEMBL:ENSG00000123374 ==> http://identifiers.org/ensembl/ENSG00000123374
    * FlyBase:FBgn0011293 ==> http://identifiers.org/flybase/FBgn0011293
 * Literature CURIEs
    * PMID:16516152 ==> http://www.ncbi.nlm.nih.gov/pubmed/16516152
    * PMCID:PMC3178059 ==> http://www.ncbi.nlm.nih.gov/pmc/articles/PMC3178059
    * DOI:10.1371/journal.pone.0015506 ==> http://dx.doi.org/10.1371/journal.pone.0015506
 * Metadata CURIEs
    * dc:title ==> http://purl.org/dc/terms/title
    * xsd:Int ==> http://www.w3.org/2001/XMLSchema#Int
    * owl:Class ==> http://www.w3.org/2002/07/owl#Class
    * foaf:is_about ==> http://xmlns.com/foaf/0.1/is_about
 * Abbreviated non-CURIE names
    * is_about ==> http://xmlns.com/foaf/0.1/is_about
    * part_of ==> http://purl.obolibrary.org/obo/BFO_0000050
    * assay ==> http://purl.obolibrary.org/obo/OBI_0000070
    * Association ==> http://semanticscience.org/resource/SIO_000897

The contexts are modular and remixable; for example, if you want to
use the [OBO Library](http://obofoundry.org) purls for ontology class
CURIEs you can reference [obo_context.json](registry/obo_context.jsonld), but you are free to ignore
the commitment to map ENSMEBL etc to `identifiers.org` URIs.

## Organization

The project is organized as a set of JSON-LD context files in the
[registry/](registry) directory. The current set is preliminary and
unstable.

Different contexts can be concatenated together. Warning: there is a
possibility that combinations can confict. See the scripts in
[bin](bin/) for concatenating and subtracting.

The current list is:

 * [obo](registry/obo_context.jsonld) : derived from the OBO registry
 * [idot](registry/idot_context.jsonld) : derived from identifiers-org/MIRIAM registry
 * [idot_nr](registry/idot_nr_context.jsonld) : idot minus OBO
 * [semweb](registry/semweb_context.jsonld) : Standard semantic web prefixes
 * [uber](registry/uber_context.jsonld) : Merger of other contexts

## Use in JSON-LD documents

You can simply copy the portions of the contexts files here to use in
your own JSON-LD documents.

When this project is more stable, you can reference any of the
contexts over the web.

For testing purposes you can do this for now:

```
 {
   "@context", "https://raw.githubusercontent.com/cmungall/biocontext/master/registry/obo_context.jsonld"
   ...
```

*but this is not stable*

## Examples

TODO

## Remixing your own contexts

TODO - provide links to JSON-LD scripts

## Philosophy

When mapping an OBO-style ID there is no ambiguity as to what to map
to. The ID "CHEBI:26619" corresponds to the OWL class with IRI
"http://purl.obolibrary.org/obo/CHEBI_26619". 

However, when presented with something like "OMIM:224050" or
"ENSEMBL:ENSG00000123374", what should the interpretation of these be
when we refer to them from within the semantic web? Are these
information artefacts *about* a biological entity, or are they
biological entities themselves? If they are biological entities, is a
gene an individual or a class?

This registry provides a pluralistic approach. The default is to map a
database ID to an identifiers.org URI, which makes no ontological
commitments to the nature of the entity. This does not preclude the
possibility of including separate mappings to ontologically committed
OWL objects. For example, one group may use to use CURIEs of the form
"OMIM:224050" as an abbreviation for an OWL Class URI. There is no
mandate in the semantic web that all groups must use the same
CURIEs. However, to avoid confusion groups should in general
coordinate for example through obo-discuss regarding different
ontological interpretations of database objects.

Note this is already built in to some extent with some databases such
as the NCBITaxonomy. The OBO Library uses the NCBITaxon prefix for a
class-based mirror of the ncbi taxonomy database. For example
"NCBITaxon:9606" is a shorthand for
http://purl.obolibrary.org/obo/NCBITaxon_9606

## What this does not do

The scope of biocontext is limited to mapping of prefixes and short
names to URIs. It is not a general purpose registry. It stores no
metadata about the prefixes used. It reuses information from other
registries such as identifiers.org and the OBO library when possible.

## Contributing

 * [new issue](issues/new)
 * Fork, branch, make a pull request
 * Edit any file directly via github web interface and make a pull request
