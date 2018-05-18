#!/usr/bin/python
"""
Convert GO db-xrefs.yaml file

Give priority to entries explicitly designated rdf_uri_prefix
"""

import json
import sys
import logging

EXAMPLE = '[example_id]'
def main(fn):

    pm = {}
    f = open(fn, 'r')
    prefixes = json.load(f)
    for p in prefixes:
        db = p['database']
        if db == 'taxon':
            db = 'NCBITaxon'
            p['database'] = db
        for e in p.get('entity_types',[]):
            u = e.get('url_syntax','')
            if u.endswith(EXAMPLE):
                url = u.replace(EXAMPLE,'')
                if db in pm and pm[db] != url:
                    logging.warn("Replacing {} : {} -> {}".format(db, pm[db], url))
                pm[db] = url

    # overwrite if rdf_uri_prefix is known. See https://github.com/geneontology/go-site/issues/617
    for p in prefixes:
        if 'rdf_uri_prefix' in p:
            pm[p['database']] = p['rdf_uri_prefix']

    rmap = {}
    for p,uri in pm.items():
        if uri in rmap:
            existing_prefix = rmap[uri]
            if len(existing_prefix) > len(p):
                logging.info("Replacing {} -> {} with {} -> {} //1".format(existing_prefix, uri, p, uri))
                del pm[existing_prefix]
                rmap[uri] = p
            else:
                logging.info("Replacing {} -> {} with {} -> {} //2".format(p, uri, existing_prefix, uri))
                del pm[p]
        else:
            rmap[uri] = p
                
                

    obj = {'@context': pm}
    print(json.dumps(obj, indent=4))
        

def usage():
    print("go-xrefs-to-context.py db-xrefs.yaml")

if __name__ == "__main__":
    if len(sys.argv) > 2:
        print("Too many arguments")
        usage()
        sys.exit(1)
    if len(sys.argv) < 2:
        print("Too few arguments")
        usage()

    main(sys.argv[1])
