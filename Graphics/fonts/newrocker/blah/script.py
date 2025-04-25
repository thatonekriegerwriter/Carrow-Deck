import fontforge
F = fontforge.open(r"newrocker.ttf")
for name in F:
    
    if name.isupper():
        filename = name + "_UPPER.png"  # Export with '_UPPER' in the filename
        F[name].export(filename)
    # Check if the glyph name is lowercase
    elif name.islower():
        filename = name + "_lower.png"  # Export with '_lower' in the filename
        F[name].export(filename)
    else:
        filename = name + ".png"  # For any other characters, just export as normal
        F[name].export(filename)