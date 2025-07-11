#!/bin/bash

# ==============================================================================
# This script creates COMPRESSED archives from existing uncompressed .npz files.
# It should be run after merge_all_uncompressed.sh has completed.
# ==============================================================================

# Exit immediately if a command exits with a non-zero status.
set -e

# --- User Configuration ---
# IMPORTANT: Set this variable to the absolute path of your top-level data directory.
# This is the only line you should need to edit.
DATA_DIR="/home/skowronek/Documents/PhD/nuclear_fusion_cooling/data"

# --- Script Configuration ---
HA_NUMBERS=(300 500 700 1000)

# Get the absolute path of the directory where this script is located to robustly find other scripts.
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
COMPRESS_SCRIPT="${SCRIPT_DIR}/compress_npz.py"

# --- Sanity Checks ---
if [ "$DATA_DIR" == "/path/to/your/data_directory" ]; then
    echo "Error: Please edit this script and set the DATA_DIR variable to the correct path." >&2
    exit 1
fi

if [ ! -d "$DATA_DIR" ]; then
    echo "Error: The specified data directory does not exist: $DATA_DIR" >&2
    exit 1
fi

if [ ! -f "$COMPRESS_SCRIPT" ]; then
    echo "Error: The python helper script was not found at: $COMPRESS_SCRIPT" >&2
    exit 1
fi

# --- Main Processing Loop ---
echo "================================================="
echo "Creating COMPRESSED archives from .npz files"
echo "================================================="

for ha in "${HA_NUMBERS[@]}"; do
    echo ""
    echo "--- Compressing for ha=$ha ---"
    
    # Define the input and output filenames
    BASE_PATH="${DATA_DIR}/re1000_ha${ha}/3d/pkl"
    UNCOMPRESSED_FILE="${BASE_PATH}/vxyz_jxyz_p_f_du_dv_dw_uncompressed.npz"
    COMPRESSED_FILE="${BASE_PATH}/vxyz_jxyz_p_f_du_dv_dw_compressed.npz"

    # Construct and run the command to compress the file
    COMMAND_COMPRESS="python $COMPRESS_SCRIPT $UNCOMPRESSED_FILE $COMPRESSED_FILE"
    echo "Running command: $COMMAND_COMPRESS"
    $COMMAND_COMPRESS
done

echo ""
echo "================================================="
echo "All compression complete."
echo "================================================="
