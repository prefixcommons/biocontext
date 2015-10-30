Ontology objects are typically `classes` (aka terms), but may also
include `object properties` (aka *relations* or *relationship types*)
or `individuals`.

Almost all life science or health oriented ontologies are represented
in OWL (this is true even of those ontologies typically thought of as
"OBO Format", as OBO Format is a serialization of a subset of OWL). As
a consequence of this fact, each class is associated with a single
URI. This URI is minted by publisher of the ontology. Some examples
include:

 * http://purl.obolibrary.org/obo/HP_0000112 (Nephropathy)
 * http://semanticscience.org/resource/SIO_000897 (Association)
 * http://purl.obolibrary.org/obo/BFO_0000050 (part of)
 * http://purl.obolibrary.org/obo/CHEBI_41774 (tamoxifen)

Note that as far as the semantic web standards stack is concerned
there is no distinct identifier field; the URI is the identifier and
locator. (of course any OWL document can choose to abbreviate the URIs
how it pleases, for example, using prefix declarations; but these
abbreviations are local to the document, and not universal).

## OBO Library Ontologies

The Open Biomedical Ontology (OBO) library is a confederation of
ontologies intended to work together and cover the biological and
biomedical domain. It includes many of the ontologies commonly used in
bioinformatics tools and the major biological databases; ontologies
such as GO, HP, OBI, CHEBI, SO.

OBOs represent a special case. For any OBO class, *there is a
guaranteed single canonical bipartite identifier*. For example

 * http://purl.obolibrary.org/obo/HP_0000112 <==> HP:0000112
 * http://purl.obolibrary.org/obo/OBI_0000070 <==> OBI:0000070
 * http://purl.obolibrary.org/obo/CHEBI_41774 <==> CHEBI:41774

This is enshrined in both the [OBO Foundry ID
policy](http://www.obofoundry.org/id-policy.shtml), and in the Formal
Specification of OBO Format.

OBO class bipartite identifiers are equivalent to CURIEs in a semantic
web document together with prefix declarations:

    OBI http://purl.obolibrary.org/obo/OBI_
    HP http://purl.obolibrary.org/obo/HP_
    CHEBI http://purl.obolibrary.org/obo/CHEBI_
    ...

For JSON-LD documents, the complete set of relevant prefixes can be
found in the following context file within this registry:

 * [obo_context.jsonld](registry/obo_context.jsonld)

## Ontologies not in the OBO Library

For any given OWL ontologies not in the OBO library, there is no
guaranteed authoritative mapping from the URI to any kind of shortform
identifier, bipartite or otherwise. Different groups may have
different conventions, and these conventions may or may not have some
degree of stability.

Within this project, we provide some prefix declarations for non OBO
Library ontologies. These should not be regarded as authoritative
outside the context of this project.

An example is

 * [semweb_context.jsonld](registry/semweb_context.jsonld)

This provides a default context for common semantic web
vocabularies/ontologies. Anything that uses this context can use
prefixes such as:

 * dc
 * faldo
 * foaf
 * xsd

Note that without this context imported, there is no guarantee that
the above prefixes will resolve to the desired URI prefixes, or will
be valid at all.

## Non-OWL Ontologies

Ontologies that do not have their native form in OWL or as part of the
semweb stack represent a different case. Here we are not even
guaranteed a canonical URI. Instead, the ontology may have one or more
identifier schemes. Examples include ontologies such as SNOMED, which
are developed using a non-OWL DL.

