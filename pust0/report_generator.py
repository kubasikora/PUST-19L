import argparse

parser = argparse.ArgumentParser()
parser.add_argument("-fp", "--frontpage", help="generate frontpage", action="store_true")
parser.add_argument("-ch", "--chapter", help="generate new chapter", action="store_true")
args = parser.parse_args()

if args.frontpage:
    print("generating frontpage...")
    exit(0)

if args.chapter:
    print("generating chapter...")
    exit(0)

parser.print_help()