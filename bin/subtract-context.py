#!/usr/bin/python
import json
import sys

def main(context1_path, context2_path):

    try:
        with open(context1_path, 'r') as context1:
            with open(context2_path, 'r') as context2:
                c1 = json.load(context1)
                # print(json.dumps(c1, indent=4))
                c2 = json.load(context2)
                # print(json.dumps(c2, indent=4))

                for k in c2["@context"].keys():
                    if k in c1["@context"]:
                        del c1["@context"][k]

                print(json.dumps(c1, indent=4))
    except:
        print("Could not open one of the context files")
        sys.exit(1)

def usage():
    print("subtract-context.py path/to/context1.jsonld path/to/context2.jsonld")

if __name__ == "__main__":
    if len(sys.argv) > 3:
        print("Too many arguments")
        usage()
        sys.exit(1)
    if len(sys.argv) < 3:
        print("Too few arguments")
        usage()

    main(sys.argv[1], sys.argv[2])
