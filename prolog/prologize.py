# turn multi-line string (such as ascii art) into Prolog write/1.
def prologize(filename: str) -> None:
    with open(filename, 'r') as fp:
        result = "write('"
        lines = [line.replace('\n', "'), nl,\n") for line in fp.readlines()]
        result += "write('".join(lines)
        print(result)

def main() -> None:
    prologize('ascii.txt')

if __name__=="__main__":
    main()

