import argparse
import json
import os

def get_coursename() -> str:
    """ Acquire course name """
    course_name = input("Course name: ")
    return course_name 

def get_projectname() -> str:
    """ Acquire project name """
    project_name = input("Project name: ")
    return project_name

def get_teacher() -> str:
    """ Acquire teacher name """
    teacher_name = input("Teacher name: ")
    return teacher_name

def get_chaptername() -> str:
    """ Acquire chapter name """
    chapter_name = input("Chapter name: ")
    return chapter_name

def get_authors() -> str:
    """ Acquire authors name and create string for tex file """

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
    parser.add_argument("-fpc", "--frontconf", help="generate frontpage from .conf file", action="store_true")
    parser.add_argument("-cc", "--createconf", help="create configuration file", action="store_true")
    parser.add_argument("path", help="path to folder where to create new file")
    args = parser.parse_args()

    if args.createconf:
        conf = {}
        conf['course'] = get_coursename()
        conf['authors'] = get_authors()
        conf['teacher'] = get_teacher()

        with open("./.conf", "w") as file:
            json.dump(conf, file)
        exit(0)

    if args.frontpage:
        course_name = get_coursename()
        project_name = get_projectname()
        author_str = get_authors()
        teacher_name = get_teacher()

        with open("./resources/main.tex") as file:
            tex_template = file.read() 

        print("Generating frontpage...")
        tex_template = tex_template.replace("__COURSE_NAME__", course_name)
        tex_template = tex_template.replace("__PROJECT_NAME__", project_name)
        tex_template = tex_template.replace("__AUTHORS__", author_str)
        tex_template = tex_template.replace("__TEACHER__", teacher_name)
        with open(args.path + "/main.tex", mode="w") as file:
            file.write(tex_template)
        exit(0)

    if args.frontconf:
        if not os.path.isfile("./.conf"):
            print(".conf file does not exist!")
            exit(1)

        with open("./.conf") as file:
            conf = json.load(file)

        project_name = get_projectname()

        with open("./resources/main.tex") as file:
            tex_template = file.read() 

        print("Generating frontpage...")
        tex_template = tex_template.replace("__COURSE_NAME__", conf['course'])
        tex_template = tex_template.replace("__PROJECT_NAME__", project_name)
        tex_template = tex_template.replace("__AUTHORS__", conf['authors'])
        tex_template = tex_template.replace("__TEACHER__", conf['teacher'])

        with open(args.path + "/main.tex", mode="w") as file:
            file.write(tex_template)
        exit(0)

    if args.chapter:
        chapter_name = get_chaptername()
        words = chapter_name.split()
        name = ""
        for word in words:
            name += word

        with open("./resources/chapter.tex") as file:
            tex_template = file.read() 

        tex_template = tex_template.replace("__CHAPTER_NAME__", chapter_name)
        
        if not os.path.isdir(args.path + "/sections"):
            os.mkdir(args.path + "/sections")

        with open(args.path + "/sections/" + name + ".tex", mode="w") as file:
            file.write(tex_template)

        print("generating chapter...")
        exit(0)

    parser.print_help()