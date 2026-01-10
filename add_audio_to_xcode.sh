#!/bin/bash

# Script to add Audio files to Xcode project
PROJECT_DIR="/Users/yanashevchuk/Documents/SamoTetris"
XCODE_PROJ="$PROJECT_DIR/SamoTetris.xcodeproj"

echo "Adding Audio files to Xcode project..."

# Use xed to open and add files
cd "$PROJECT_DIR"

# Check if files exist
if [ ! -f "ModernTetris/Core/Audio/AudioManager.swift" ]; then
    echo "Error: AudioManager.swift not found"
    exit 1
fi

echo "Files found. Opening Xcode to add them..."
echo ""
echo "You need to add these files manually in Xcode:"
echo "1. In Xcode, find the 'ModernTetris/Core' folder in Project Navigator"
echo "2. Right-click on 'Core' folder → 'Add Files to SamoTetris...'"
echo "3. Select 'ModernTetris/Core/Audio' folder"
echo "4. IMPORTANT settings:"
echo "   - UNCHECK 'Copy items if needed'"
echo "   - SELECT 'Create groups'"
echo "   - SELECT 'SamoTetris' target"
echo "5. Click 'Add'"
echo ""
echo "Opening Xcode now..."

open "$XCODE_PROJ"
