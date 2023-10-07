#!/bin/bash

# Declare global environment variable for gpg recipient
# Change to the desired recipient email or key ID or override it during invocation
export GPG_RECIPIENT="recipient_email@example.com"

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
  tar cf - "$source_dir" | zstd - | gpg --recipient "$GPG_RECIPIENT" --output "$dest_file" --encrypt -
}

# Function to decrypt, decompress, and extract files from an encrypted compressed archive
do_ungpg_unzstd_untar() {
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
  gpg --recipient "$GPG_RECIPIENT" --output - "$source_file" | zstd -d | tar xf - -C "$dest_dir"
}

# Show help message
show_help() {
  usage=$(cat << EOF
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
EOF
)
  echo "$usage"
}



# Check if a function name was passed as an argument
if [ $# -eq 0 ]; then
  echo "Usage: $0 function_name [args...]"
  exit 1
fi

# Check the first argument and call the appropriate function
case "$1" in
  do_tar_zstd_gpg)
    do_tar_zstd_gpg "$2" "$3"
    ;;
  do_ungpg_unzstd_untar)
    do_ungpg_unzstd_untar "$2" "$3"
    ;;
  *)
    show_help
    exit 1
    ;;
esac
