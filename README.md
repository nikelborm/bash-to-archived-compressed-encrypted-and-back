# main.sh

`main.sh` is a Bash script that provides two functions for creating and extracting encrypted compressed archives. The script uses the `tar`, `zstd`, and `gpg` utilities to create and extract archives.

## Usage

```
Usage: main.sh do_tar_zstd_gpg source_dir dest_file
       main.sh do_ungpg_unzstd_untar source_file dest_dir

  do_tar_zstd_gpg: Create a tar archive, compress with zstd, and encrypt with gpg
  do_ungpg_unzstd_untar: Decrypt, decompress, and extract files from an encrypted compressed archive

  source_dir: The source directory to be archived
  source_file: The source archive file to be extracted
  dest_file: The destination archive file to be created
  dest_dir: The destination directory for the extracted files

Examples:
  Create an encrypted compressed archive of a directory:
    main.sh do_tar_zstd_gpg /path/to/source_dir /path/to/file.tar.zst.gpg

  Extract an encrypted compressed archive to a directory:
    main.sh do_ungpg_unzstd_untar /path/to/file.tar.zst.gpg /path/to/dest_dir

Note: The GPG recipient email or key ID can be set using the GPG_RECIPIENT environment variable. For example:
  GPG_RECIPIENT="recipient_email@example.com" main.sh do_tar_zstd_gpg /path/to/source_dir /path/to/dest_file

  Script does not add any extensions, so it is recommended that you add .tar.zst.gpg to the destination file
```

## Functions

### `do_tar_zstd_gpg`

The `do_tar_zstd_gpg` function creates an encrypted compressed archive of a directory. The function takes two arguments:

- `source_dir`: The source directory to be archived.
- `dest_file`: The destination file for the archive.

### `do_ungpg_unzstd_untar`

The `do_ungpg_unzstd_untar` function extracts an encrypted compressed archive to a directory or file. The function takes two arguments:

- `source_file`: The source archive file to be extracted.
- `dest_dir`: The destination directory for the extracted files.

## Environment Variables

### `GPG_RECIPIENT`

The `GPG_RECIPIENT` environment variable sets the recipient email or key ID for the `gpg` encryption. The default value is `"recipient_email@example.com"`. To set a different recipient, export the `GPG_RECIPIENT` variable before invoking the script.

## License

This script is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
