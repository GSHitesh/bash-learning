#!/bin/bash

#Text processing

grep -i "some" out.txt


# sed 's/old/new/g'      # Replace
# sed '/pattern/d'       # Delete lines
# sed -n '/pattern/p'    # Print matching lines
# sed -i '...' file      # Edit file directly
# sed '/pattern/a text'  # Append
# sed '/pattern/i text'  # Insert
# sed '/pattern/c text'  # Change line



echo "Hit esh" | cut -d ' ' -f 1

sort -n num.txt
echo "=====reverse-unique===="
sort -nur num.txt

# find . -name "*.log" | xargs rm