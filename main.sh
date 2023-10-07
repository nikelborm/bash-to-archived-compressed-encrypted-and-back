#!/bin/bash

# Declare global environment variable for gpg recipient
# Change to the desired recipient email or key ID or override it during invocation
export GPG_RECIPIENT="kolya007.klass@gmail.com"

# Function to create a tar archive, compress with zstd, and encrypt with gpg
do_tar_zstd_gpg() {
  if [ $# -ne 2 ]; then
    echo "Usage: $0 source_dir dest_file"
    return 1
  fi

  local source_dir="$1"
  local dest_file="$2"

  # Check that source_dir is directory
  if [ ! -d "$source_dir" ]; then
    echo "Source directory does not exist: $source_dir"
    return 1
  fi

  # Check that source_dir is accessible (readable) to the Bash user
  if [ ! -r "$source_dir" ]; then
    echo "Source directory is not accessible: $source_dir"
    return 1
  fi

  # Create the destination directory if it doesn't exist
  mkdir -p "$(dirname "$dest_file")"

  # Create the tar archive, compress with zstd, and encrypt with gpg
  tar cf - -C "$source_dir" . | zstd - | gpg --encrypt --recipient "$GPG_RECIPIENT" --output "$dest_file" -
}

# Function to decrypt, decompress, and extract files from an encrypted compressed archive
undo_tar_zstd_gpg() {
  if [ $# -ne 2 ]; then
    echo "Usage: $0 source_file dest_dir"
    return 1
  fi

  local source_file="$1"
  local dest_dir="$2"

  # Check that source_file exists
  if [ ! -f "$source_file" ]; then
    echo "Source file does not exist: $source_file"
    return 1
  fi

  # Check that source_file is accessible (readable) to the Bash user
  if [ ! -r "$source_file" ]; then
    echo "Source file is not accessible: $source_file"
    return 1
  fi

  # Create the destination directory if it doesn't exist
  mkdir -p "$dest_dir"

  # Step 1: Decrypt with PGP (gpg), decompress with zstd, and extract with tar
  gpg --decrypt --recipient "$GPG_RECIPIENT" --output - "$source_file" | zstd -d | tar xf - -C "$dest_dir"
}

# Show help message
show_help() {
  usage=$(cat << EOF
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
EOF
)
  echo "$usage"
}

# Check the first argument and call the appropriate function
case "$1" in
  do_tar_zstd_gpg)
    do_tar_zstd_gpg "$2" "$3"
    ;;
  undo_tar_zstd_gpg)
    undo_tar_zstd_gpg "$2" "$3"
    ;;
  *)
    show_help
    exit 1
    ;;
esac
