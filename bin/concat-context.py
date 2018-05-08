#!/usr/bin/env python
import json
import sys
import click
import logging

@click.command()
@click.argument("files", nargs=-1)
def convert(files):
    logging.basicConfig(level=logging.INFO)
    logging.info("Files: {}".format(files))

    first_path = files[0]
    rest = files[1:]
    
    prefix_to_uri = {}
    uri_to_prefix = {}
    first_context = open_json(first_path)
    logging.info('CANONICAL FILE: {}'.format(first_path))
    fc = first_context["@context"]
    for k in fc.keys():
        prefix_to_uri[k] = first_path
        check_uri(uri_to_prefix, k, fc[k])
        
    for next_path in rest:

        next_context = open_json(next_path)
        for k in next_context["@context"].keys():
            v = next_context["@context"][k]
            if k in first_context["@context"]:
                curr = first_context["@context"][k]
                check_uri(uri_to_prefix, k, curr)
                if curr != v:
                    logging.warning("clash for {}. Was={} [{}], Now={} [{}]".
                                    format(k, curr, prefix_to_uri[k], v, next_path))

            first_context["@context"][k] = v
            prefix_to_uri[k] = next_path

    print(json.dumps(first_context, indent=4))

def check_uri(m, prefix, uri):
    if uri in m:
        logging.warning("clash {} is expansion for {} and {}".format(uri, prefix, m[uri]))
    m[uri] = prefix
    
def open_json(path):
    try:
        with open(path, 'r') as j:
            return json.load(j)

    except:
        print("Could not open/parse {}".format(path), file=sys.stderr)
        sys.exit(1)


if __name__ == "__main__":
    convert()
