#!/bin/bash

# ==========================================
# SiftDNS Website Organization Script
# ==========================================

echo "Starting organization..."

# 1. SAFETY CHECK
# Ensure we are in the root of the repo by looking for index.html and CNAME
if [[ ! -f "index.html" ]] || [[ ! -f "CNAME" ]]; then
    echo "ERROR: This script must be run from the root of your repository."
    echo "Aborting."
    exit 1
fi

# 2. CREATE DIRECTORIES
echo "Creating directories..."
mkdir -p assets/images
mkdir -p assets/icons
mkdir -p scripts

# 3. MOVE FILES
# We use a function to move files only if they exist to prevent errors
move_file() {
    if [[ -f "$1" ]]; then
        mv "$1" "$2"
        echo "Moved: $1 -> $2"
    else
        echo "Skipped: $1 (not found)"
    fi
}

echo "Moving Icons and Manifests..."
move_file "android-chrome-192x192.png" "assets/icons/"
move_file "android-chrome-512x512.png" "assets/icons/"
move_file "apple-touch-icon.png" "assets/icons/"
move_file "favicon-16x16.png" "assets/icons/"
move_file "favicon-32x32.png" "assets/icons/"
move_file "favicon.ico" "assets/icons/"
move_file "site.webmanifest" "assets/icons/"

echo "Moving Images and Diagrams..."
move_file "dns-diagram.png" "assets/images/"
move_file "dns-diagram2.png" "assets/images/"
move_file "dns-diagram3.png" "assets/images/"
move_file "network-diagram.png" "assets/images/"
# Moving the timestamped/numbered images
# Using a wildcard loop for safety in case specific numbers change
for img in 176*.png; do
    [ -e "$img" ] && mv "$img" "assets/images/" && echo "Moved: $img -> assets/images/"
done

echo "Moving Scripts..."
move_file "git_commit_and_push.sh" "scripts/"

# 4. UPDATE HTML REFERENCES
echo "Updating HTML references..."

# Find all HTML files
html_files=$(ls *.html)

for file in $html_files; do
    echo "Processing $file..."
    
    # Create a backup before editing
    cp "$file" "$file.bak"
    
    # Update Icon Paths
    # Covers href="favicon..." and href="site.webmanifest" and href="apple-touch..."
    sed -i '' 's|href="favicon|href="assets/icons/favicon|g' "$file" 2>/dev/null || sed -i 's|href="favicon|href="assets/icons/favicon|g' "$file"
    sed -i '' 's|href="site.webmanifest"|href="assets/icons/site.webmanifest"|g' "$file" 2>/dev/null || sed -i 's|href="site.webmanifest"|href="assets/icons/site.webmanifest"|g' "$file"
    sed -i '' 's|href="apple-touch-icon.png"|href="assets/icons/apple-touch-icon.png"|g' "$file" 2>/dev/null || sed -i 's|href="apple-touch-icon.png"|href="assets/icons/apple-touch-icon.png"|g' "$file"
    sed -i '' 's|content="android-chrome|content="assets/icons/android-chrome|g' "$file" 2>/dev/null || sed -i 's|content="android-chrome|content="assets/icons/android-chrome|g' "$file"

    # Update Image Paths
    # This looks for src="X" where X is one of your known images
    sed -i '' 's|src="dns-diagram|src="assets/images/dns-diagram|g' "$file" 2>/dev/null || sed -i 's|src="dns-diagram|src="assets/images/dns-diagram|g' "$file"
    sed -i '' 's|src="network-diagram.png"|src="assets/images/network-diagram.png"|g' "$file" 2>/dev/null || sed -i 's|src="network-diagram.png"|src="assets/images/network-diagram.png"|g' "$file"
    
    # Attempt to catch the numbered pngs if they are referenced in HTML
    sed -i '' 's|src="176|src="assets/images/176|g' "$file" 2>/dev/null || sed -i 's|src="176|src="assets/images/176|g' "$file"
done

echo "=========================================="
echo "Organization Complete!"
echo "Backups of your HTML files were created (e.g., index.html.bak)."
echo "Please check your website locally. If everything looks good, you can delete the .bak files."
echo "=========================================="
