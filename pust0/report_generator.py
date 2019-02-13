import argparse

def get_authors() -> str:
    """
        Acquire authors name and create string for tex file
    """
    authors = []
    while True:
        author = input("Please provide project author name (empty line to finish): ")
        if author == "":
            break
        authors.append(author)

    if len(authors) == 0: 
        print("Please provie at least one author!")
        exit(1)

    author_str = ""
    last_author = authors.pop()
    for author in authors:
        author_str += author
        author_str += " \\\ "

    author_str += "{0}".format(last_author) 
    return author_str

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("-fp", "--frontpage", help="generate frontpage", action="store_true")
    parser.add_argument("-ch", "--chapter", help="generate new chapter", action="store_true")
    parser.add_argument("path", help="path to folder where to create new file")
    args = parser.parse_args()

    if args.frontpage:
        
        author_str = get_authors()

        with open("./resources/main.tex") as file:
            tex_template = file.read() 

        print("Generating frontpage...")
        tex_template = tex_template.replace("__AUTHORS__", author_str)
        tex_template = tex_template.replace("__PROJECT_NAME__", "Projekt 1")
        tex_template = tex_template.replace("__COURSE_NAME__", "Projektowanie układów sterowania")
        tex_template = tex_template.replace("__TEACHER__", "dr inż. Patryk Chaber")
        with open(args.path + "/main.tex", mode="w") as file:
            file.write(tex_template)
        exit(0)

    if args.chapter:
        print("generating chapter...")
        exit(0)

    parser.print_help()