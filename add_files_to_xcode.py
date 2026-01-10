#!/usr/bin/env python3
import os
import subprocess
import sys

# Files to add to Xcode project
files_to_add = [
    "ModernTetris/Core/Currency/CurrencyManager.swift",
    "ModernTetris/Core/Shop/ShopItem.swift",
    "ModernTetris/Core/Shop/ShopManager.swift",
    "ModernTetris/Features/Shop/Views/ShopView.swift"
]

project_dir = "/Users/yanashevchuk/Documents/SamoTetris"
os.chdir(project_dir)

# Use xcodegen to regenerate project if available, otherwise use manual approach
print("Adding files to Xcode project...")

for file_path in files_to_add:
    full_path = os.path.join(project_dir, file_path)
    if os.path.exists(full_path):
        print(f"✓ Found: {file_path}")
    else:
        print(f"✗ Missing: {file_path}")
        sys.exit(1)

print("\nAll files exist. You need to add them manually in Xcode:")
print("\n1. Open SamoTetris.xcodeproj in Xcode")
print("2. Right-click on 'ModernTetris/Core' folder")
print("3. Select 'Add Files to SamoTetris...'")
print("4. Navigate to and select:")
print("   - ModernTetris/Core/Currency folder")
print("   - ModernTetris/Core/Shop folder")
print("5. Right-click on 'ModernTetris/Features' folder")
print("6. Select 'Add Files to SamoTetris...'")
print("7. Navigate to and select:")
print("   - ModernTetris/Features/Shop folder")
print("\nMake sure to:")
print("- UNCHECK 'Copy items if needed'")
print("- SELECT 'Create groups'")
print("- SELECT 'SamoTetris' target")
