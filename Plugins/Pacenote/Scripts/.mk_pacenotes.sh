#!/usr/bin/env bash

# Debug every command that this script runs
# set -x

## Example of INI entries we'll generate per each ogg file.
## Column will grow to up to 4 and then get back to 0.
# [PACENOTE::1_LEFT_MINUS_TIGHTENS_AND_1_RIGHT_MINUS_OPENS]
# id=3999
# Sounds=1
# Snd0=e_1_left_minus_tightens_and_1_right_minus_opens.ogg
# column=0
# 
# [PACENOTE::1_RIGHT_MINUS_LONG_INTO_1_LEFT_MINUS_HALF_LONG]
# id=3998
# Sounds=1
# Snd0=e_1_right_minus_long_into_1_left_minus_half_long.ogg
# column=1

## We assume that we run the script from the directory containing the ogg files.

## Example of groups of ogg files we'll process into INI entries.
# e_1_left_minus_tightens_and_1_right_minus_opens.ogg
# e_1_right_minus_long_into_1_left_minus_half_long.ogg
# e_1_right_minus_short.ogg
# e_2_left_into_square_right_plus.ogg
# e_2_right_2_left.ogg
# e_2_right_2_left_5_right.ogg
# e_2_right_4_left.ogg
# e_3_left_4_right.ogg
# e_3_right_4_left.ogg
# e_3_right_6_left.ogg
# or
# m_hairpin_left_immediate_square_right_plus.ogg
# m_hairpin_right_immediate_square_left_plus.ogg
# m_hairpin_right_immediate_square_left_plus_2_right.ogg
# m_hairpin_right_immediate_square_left_plus_3_right.ogg

## We only process files that match the pattern of having some prefix (like "e_" or "m_").

## Code follows.

# Get the prefix of the files we'll process from the variable $1, it's obligatory.
prefix=$1
if [ -z "$prefix" ]; then
    echo "ERROR: You must provide the prefix of the files to process as the first argument."
    exit 1
fi

# Get the smallest vacant ID number from the INI files, which is greater than 3060 (sadly, Janne's notes go that high).
# We'll use this number as the ID of the first INI entry we'll generate.
# We'll decrement this number by 1 for each INI entry we generate.
# The path to INI is ../../../
# The sorting has to be descending, so that we get the largest number first.
# Implementation follows.
all_ids=$(grep -r -h -o -E "id=[0-9]+" ../../../ | grep -o -E "[0-9]+" | sort -nr)
smallest_vacant_id=3060
current_largest_vacant_id=3999

for id in $all_ids; do
    echo "Processing ID: $id : Current largest vacant ID: $current_largest_vacant_id : Smallest vacant ID: $smallest_vacant_id"
        # If id is smaller than current_largest_vacant_id, then make the new current_largest_vacant_id equal to id - 1.
        # If id equals smallest_vacant_id, then we're done.
            if [ "$id" -eq $smallest_vacant_id ]; then
                break
            fi
    
            if [ "$id" -lt $current_largest_vacant_id ]; then
                current_largest_vacant_id=$((id - 1))
            fi

    done

echo "* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *"
echo "* * * * Resulting largest vacant ID: $current_largest_vacant_id * * * *"
echo "* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *"

# Now, we'll process the files that match the pattern of having some prefix (like "e_" or "m_").
# We'll generate INI entries for each of them.
# We'll output the INI to a file called after the prefix.
# Then, we'll place this file into ../../config/pacenotes/packages/$cwd, where $cwd is the current working directory.
# We shall make the $cwd directory if it doesn't exist.
# Implementation follows.

# Get all the ogg files that match the pattern of having some prefix (like "e_" or "m_"). Use it in a shellcheck-friendly way.
all_oggs=$(find . -maxdepth 1 -type f -name "$prefix*.ogg" -printf "%f ")

max_column=3
current_column=0
current_id=$current_largest_vacant_id
for ogg in $all_oggs; do
    # Remove the ".OGG" suffix. Using variable replacement syntax ${var/pattern/replacement}.
    all_caps=${ogg/.OGG/}
    # Remove the ".ogg" suffix too.
    all_caps=${ogg/.ogg/}
    # Remove the prefix. Again, using variable replacement syntax ${var/pattern/replacement}.
    all_caps=${all_caps/$prefix/}
    # Transform ogg file name into ALL-CAPS and replace all "-" with "_".
    all_caps=$(echo "$ogg" | tr '[:lower:]' '[:upper:]' | tr '-' '_')
    # Now we have the name of the INI entry, like "1_LEFT_MINUS_TIGHTENS_AND_1_RIGHT_MINUS_OPENS".
    {
        echo "[PACENOTE::$all_caps]"
        echo "id=$current_id"
        echo "Sounds=1"
        echo "Snd0=$ogg"
        echo "column=$current_column"
        echo ""
    } >> "$prefix".ini
    # Decrease ID by 1 and increase column by 1 mod $max_column.
    current_id=$((current_id - 1))
    current_column=$((current_column + 1))
    if [ $current_column -gt $max_column ]; then
        current_column=0
    fi
done

# Now, we'll place the INI file into ../../config/pacenotes/packages/$cwd, where $cwd is the current working directory.
# We shall make the $cwd directory if it doesn't exist.
# Implementation follows.
cwd=$(basename "$(pwd)")
# Let's make sure that $cwd isn't weird, doesn't have spaces, etc. Error out if it does!
if [[ $cwd =~ [^a-zA-Z0-9_] ]]; then
    echo "ERROR: The current working directory name contains characters other than letters, digits and underscores."
    echo "But we have already generated the INI file, so you can copy it manually to the correct location in ../../../Plugins/Pacenote/config/packages/..."
    echo "If you do, don't forget to manually add it to ../../config/packages/Extended.ini"
    exit 2
fi
packages_dir=../../config/pacenotes/packages
package_dir="$packages_dir/$cwd"
mkdir -p "$package_dir"
mv "$prefix.ini" "$package_dir/"

# Finally, we shall add the generated INI file to the list of INI files in ../../config/pacenotes/packages/Extended.ini
# Here is the format this INI file uses:
# 
# [CATEGORY::SLOWCHAIN_E_]
# file=Slowchain/e_.ini
#
# Clearly, E_ is the upper-case prefix of the INI file.
# e_.ini is the name of the INI file.
# And Slowchain is the name of the group of callouts (which coincides with the $cwd and the name of the directory in which the INI file is placed).
# Implementation follows.
{
    echo "[CATEGORY::${prefix^^}]"
    echo "file=$cwd/$prefix.ini"
} >> "$packages_dir"/Extended.ini

# For completion of the setup, we now need to create a localisation dummy for English language.
# The format is the following:
#
# [STRINGS]
# 1_LEFT_MINUS_TIGHTENS_AND_1_RIGHT_MINUS_OPENS=1 left minus tightens and 1 right minus opens
# 1_LEFT_MINUS_TIGHTENS_AND_2_RIGHT_MINUS_OPENS=1 left minus tightens and 2 right minus opens
#
# And the path to the packages localisation directory is:
# ../../language/english/pacenotes/packages/
#
# As usual, we need to create $cwd if it doesn't exist, then put the localisation file for the prefix into it.
#
# Finally, we'll need to add our prefix as the final line of the file ../../language/english/pacenotes/packages/strings.ini
#
# Implementation follows.
localisation_dir=../../language/english/pacenotes/packages
localisation_package_dir="$localisation_dir/$cwd"
mkdir -p "$localisation_package_dir"
{
    echo "[STRINGS]"
    for ogg in $all_oggs; do
        # Remove the ".OGG" suffix. Using variable replacement syntax ${var/pattern/replacement}.
        all_caps=${ogg/.OGG/}
        # Remove the ".ogg" suffix too.
        all_caps=${ogg/.ogg/}
        # Remove the prefix. Again, using variable replacement syntax ${var/pattern/replacement}.
        all_caps=${all_caps/$prefix/}
        # Transform ogg file name into ALL-CAPS and replace all "-" with "_".
        all_caps=$(echo "$ogg" | tr '[:lower:]' '[:upper:]' | tr '-' '_')
        # Now we have the name of the INI entry, like "1_LEFT_MINUS_TIGHTENS_AND_1_RIGHT_MINUS_OPENS".
        # We'll use the same name for the localisation string, but we'll replace all "_" with " " and make it lower-case.
        localisation_string=$(echo "$all_caps" | tr '_' ' ' | tr '[:upper:]' '[:lower:]')
        echo "$all_caps=$localisation_string"
    done
} >> "$localisation_package_dir/$prefix.ini"

# Finally, we'll add the prefix to the list of prefixes in the strings.ini file.
echo "$prefix=$prefix" >> "$localisation_dir/strings.ini"

# RBR is a Windows-based simulator. This is why we'll have to convert all the files we have generated to Windows-style line endings. Also known as DOS-mode line endings.
# So we need to go unix2dos on all the files we have generated.
# Implementation follows.

# Let's start with the packages_dir.
find "$packages_dir" -type f -exec unix2dos {} \;

# Let's continue with the localisation_dir.
find "$localisation_dir" -type f -exec unix2dos {} \;
