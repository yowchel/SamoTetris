#!/bin/bash

# This script creates an Xcode project for SamoTetris
# Run this from the SamoTetris directory

PROJECT_NAME="SamoTetris"
BUNDLE_ID="com.samotetris.app"
ORGANIZATION="SamoTetris"

echo "Creating Xcode project structure..."

# Create project using xcodegen or manually
# Since we have the code ready, we'll create a simple Package.swift first

cat > Package.swift << 'EOF'
// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "SamoTetris",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "SamoTetris",
            targets: ["SamoTetris"])
    ],
    targets: [
        .target(
            name: "SamoTetris",
            path: "ModernTetris")
    ]
)
EOF

echo "✅ Package.swift created"
echo ""
echo "To create the Xcode project:"
echo "1. Open Xcode"
echo "2. File → New → Project"
echo "3. Choose iOS → App"
echo "4. Settings:"
echo "   - Product Name: SamoTetris"
echo "   - Organization Identifier: com.samotetris"
echo "   - Interface: SwiftUI"
echo "   - Language: Swift"
echo "5. Save in this directory"
echo ""
echo "Or run: open -a Xcode ."
