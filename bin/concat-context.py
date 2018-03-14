#!/usr/bin/python
import json
import sys

def main(first_path, rest):

    source_for = {}
    first_context = open_json(first_path)
    for k in first_context["@context"].keys():
        source_for[k] = first_path
        
    for next_path in rest:

        next_context = open_json(next_path)
        for k in next_context["@context"].keys():
            v = next_context["@context"][k]
            if k in first_context["@context"]:
                curr = first_context["@context"][k]
                if curr != v:
                    print("WARNING: clash for {}. Was={} [{}], Now={} [{}]".
                          format(k, curr, source_for[k], v, next_path),
                          file=sys.stderr)

            first_context["@context"][k] = v
            source_for[k] = next_path

    print(json.dumps(first_context, indent=4))

def open_json(path):
    try:
        with open(path, 'r') as j:
            return json.load(j)

    except:
        print("Could not open/parse {}".format(path), file=sys.stderr)
        sys.exit(1)

def usage():
    print("concat-context.py path/to/context1.jsonld [path/to/context2.jsonld [...]]", file=sys.stderr)

if __name__ == "__main__":

    if len(sys.argv) < 2:
        print("Too few arguments", file=sys.stderr)
        usage()

    main(sys.argv[1], sys.argv[2:])
