# turn multi-line string (such as ascii art) into Prolog write/1.
def prologize(filename: str) -> None:
    with open(filename, "r") as fp:
        result = "write_img_line('"
        lines = [line.replace("\n", "'),\n") for line in fp.readlines()]
        result += "write_img_line('".join(lines)
        print(result)


def main() -> None:
    prologize("ascii.txt")


if __name__ == "__main__":
    main()
