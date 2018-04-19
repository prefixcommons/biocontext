#!/usr/bin/python
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
                

    obj = {'@context': pm}
    print(json.dumps(obj, indent=4))
        

def usage():
    print("subtract-context.py path/to/context1.jsonld path/to/context2.jsonld")

if __name__ == "__main__":
    if len(sys.argv) > 2:
        print("Too many arguments")
        usage()
        sys.exit(1)
    if len(sys.argv) < 2:
        print("Too few arguments")
        usage()

    main(sys.argv[1])
