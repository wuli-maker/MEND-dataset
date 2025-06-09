from utils.utils import information_merge


def main():
    file_path = "./utils/CLHLS/clhls18_filtered.json"
    protrait_path = "./dec/profiles"

    information_merge(file_path, protrait_path)


if __name__ == '__main__':
    main()
