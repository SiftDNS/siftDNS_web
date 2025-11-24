#!/bin/bash

# ==========================================
# SiftDNS Favicon Repair (Revert to Root)
# ==========================================

echo "Moving all favicon assets to root to prevent flickering..."

# 1. MOVE FILES FROM ASSETS/ICONS TO ROOT
# We use a wildcard to catch everything (pngs, xml, manifest, ico)
if [ -d "assets/icons" ]; then
    mv assets/icons/* . 2>/dev/null
    echo "Files moved to root."
    
    # Remove the directory if empty
    rmdir assets/icons 2>/dev/null
fi

# 2. UPDATE HTML LINKS
# We strip 'assets/icons/' from all favicon/manifest references
html_files=$(ls *.html)

for file in $html_files; do
    echo "Updating $file..."
    
    # Fix standard icons (favicon-32x32, etc.)
    sed -i '' 's|href="assets/icons/|href="|g' "$file" 2>/dev/null || sed -i 's|href="assets/icons/|href="|g' "$file"
    
    # Fix Manifest link
    sed -i '' 's|href="site.webmanifest"|href="site.webmanifest"|g' "$file" 2>/dev/null || sed -i 's|href="site.webmanifest"|href="site.webmanifest"|g' "$file"
    
    # Fix Apple Touch Icon
    sed -i '' 's|href="apple-touch-icon.png"|href="apple-touch-icon.png"|g' "$file" 2>/dev/null || sed -i 's|href="apple-touch-icon.png"|href="apple-touch-icon.png"|g' "$file"
    
    # Fix Windows/Android meta tags if present
    sed -i '' 's|content="assets/icons/|content="|g' "$file" 2>/dev/null || sed -i 's|content="assets/icons/|content="|g' "$file"
done

# 3. ENSURE MANIFEST PATHS ARE CLEAN
# The manifest usually contains filenames. We ensure they have no paths.
if [ -f "site.webmanifest" ]; then
    echo "Sanitizing site.webmanifest..."
    # Remove any leading slash or path
    sed -i '' 's|"src": "/|"src": "|g' site.webmanifest 2>/dev/null || sed -i 's|"src": "/|"src": "|g' site.webmanifest
    sed -i '' 's|"src": "assets/icons/|"src": "|g' site.webmanifest 2>/dev/null || sed -i 's|"src": "assets/icons/|"src": "|g' site.webmanifest
fi

echo "=========================================="
echo "Favicons are now in the root folder."
echo "Please CLEAR YOUR BROWSER CACHE and restart it to see changes."
echo "=========================================="
