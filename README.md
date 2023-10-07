# main.sh

`main.sh` is a Bash script that provides two functions for creating and extracting encrypted compressed archives. The script uses the `tar`, `zstd`, and `gpg` utilities to create and extract archives.

## Usage

```
Usage: main.sh do_tar_zstd_gpg source_dir dest_file
       main.sh undo_tar_zstd_gpg source_file dest_dir

  do_tar_zstd_gpg: Create a tar archive, compress with zstd, and encrypt with gpg
  undo_tar_zstd_gpg: Decrypt, decompress, and extract files from an encrypted compressed archive

  source_dir: The source directory to be archived
  source_file: The source archive file to be extracted
  dest_file: The destination archive file to be created
  dest_dir: The destination directory for the extracted files

Examples:
  Put all files and dirs inside ~/.local/share/TelegramDesktop directory into encrypted compressed archive ~/tg.tar.zst.gpg:
    ./main.sh do_tar_zstd_gpg ~/.local/share/TelegramDesktop ~/tg.tar.zst.gpg

  Put all files and dirs inside encrypted compressed archive ~/tg.tar.zst.gpg into directory ~/.local/share/TelegramDesktop:
    rm -rf ~/.local/share/TelegramDesktop; ./main.sh undo_tar_zstd_gpg ~/tg.tar.zst.gpg ~/.local/share/TelegramDesktop

Notes:
  Env
    The GPG recipient email or key ID can be set using the GPG_RECIPIENT environment variable. For example:
    GPG_RECIPIENT="recipient_email@example.com" main.sh do_tar_zstd_gpg /path/to/source_dir /path/to/dest_file

  Archiving
    Script does not check if the destination file exists, so it is recommended
    that you manually delete the old archive before creating a new one.

    Script does not add any extensions, so it is recommended
    that you manually add .tar.zst.gpg to the archive file

  Extracting
    Script does not handle conflicts when extracting files, so it is recommended
    that you manually delete the content of destination directory before extracting.
```

## Functions

### `do_tar_zstd_gpg`

The `do_tar_zstd_gpg` function creates an encrypted compressed archive of a directory. The function takes two arguments:

- `source_dir`: The source directory to be archived.
- `dest_file`: The destination file for the archive.

### `undo_tar_zstd_gpg`

The `undo_tar_zstd_gpg` function extracts an encrypted compressed archive to a directory. The function takes two arguments:

- `source_file`: The source archive file to be extracted.
- `dest_dir`: The destination directory for the extracted files.

## Environment Variables

### `GPG_RECIPIENT`

The `GPG_RECIPIENT` environment variable sets the recipient email or key ID for the `gpg` encryption. The default value is `"recipient_email@example.com"`. To set a different recipient, export the `GPG_RECIPIENT` variable before invoking the script.

## License

This script is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
