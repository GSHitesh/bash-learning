#!/bin/bash

# echo "Hello Hitesh" > out.txt

# # echo "Oops" > err.txt

# echo "Hello Sai hitesh" > out.txt

# echo "Something went wrong" >> /dev/stderr 

# echo "how are you Mr. Hitesh" 


# echo "how are you Mr. Rakesh" 

# echo "how are you Mr. Suresh"  >> /dev/stderr

# echo "how are you Mr. Ramesh" 

# echo "how are you Mr. Jitesh"  >> /dev/stderr



cat > out.txt << "EOF"
This I'm writing to a file
    some gibrish
content
EOF

read -r word <<< "hello"

echo $word


printf 'a\nb\n' | wc -l 