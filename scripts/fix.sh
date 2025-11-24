#!/bin/bash

# ==========================================
# SiftDNS Image Path Fixer
# ==========================================
# run this to catch edge cases (single quotes, ./ paths) missed by the main script

echo "Scanning for broken image links..."

# Find all HTML files
html_files=$(ls *.html)

for file in $html_files; do
    echo "Patching $file..."
    
    # 1. FIX SINGLE QUOTES (src='image.png')
    # The previous script looked for src="... this catches src='...
    sed -i '' "s|src='dns-diagram|src='assets/images/dns-diagram|g" "$file" 2>/dev/null || sed -i "s|src='dns-diagram|src='assets/images/dns-diagram|g" "$file"
    sed -i '' "s|src='network-diagram|src='assets/images/network-diagram|g" "$file" 2>/dev/null || sed -i "s|src='network-diagram|src='assets/images/network-diagram|g" "$file"
    sed -i '' "s|src='176|src='assets/images/176|g" "$file" 2>/dev/null || sed -i "s|src='176|src='assets/images/176|g" "$file"

    # 2. FIX RELATIVE PATHS (src="./image.png" or src='./image.png')
    # Some editors add a ./ before the filename
    sed -i '' 's|src="\./dns-diagram|src="assets/images/dns-diagram|g' "$file" 2>/dev/null || sed -i 's|src="\./dns-diagram|src="assets/images/dns-diagram|g' "$file"
    sed -i '' "s|src='\./dns-diagram|src='assets/images/dns-diagram|g" "$file" 2>/dev/null || sed -i "s|src='\./dns-diagram|src='assets/images/dns-diagram|g" "$file"
    
    sed -i '' 's|src="\./network-diagram|src="assets/images/network-diagram|g' "$file" 2>/dev/null || sed -i 's|src="\./network-diagram|src="assets/images/network-diagram|g' "$file"
    sed -i '' "s|src='\./network-diagram|src='assets/images/network-diagram|g" "$file" 2>/dev/null || sed -i "s|src='\./network-diagram|src='assets/images/network-diagram|g" "$file"

    # 3. SAFETY CLEANUP (Fix double-nested paths)
    # If the previous script was run twice, it might have created "assets/images/assets/images/..."
    # This command collapses them back to a single path.
    sed -i '' 's|assets/images/assets/images|assets/images|g' "$file" 2>/dev/null || sed -i 's|assets/images/assets/images|assets/images|g' "$file"
    sed -i '' 's|assets/icons/assets/icons|assets/icons|g' "$file" 2>/dev/null || sed -i 's|assets/icons/assets/icons|assets/icons|g' "$file"
done

echo "=========================================="
echo "Fixes applied."
echo "Refresh your browser to check the 'What is DNS' image."
echo "=========================================="
