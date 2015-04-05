#!/bin/bash

# constants
INPUT_DIR="input"
OUTPUT_DIR="output"
INPUT_EXT=".in"
OUTPUT_EXT=".out"

# unicode characters
TICK="\xe2\x9c\x94"
CROSS="\xe2\x9c\x97"

# function to normalise the given string ($1)
format_str() {
  # replace tab with two spaces
  str=${1//	/  }
  # prefix lines with spaces
  str=${str//
/
       }
  echo "$str"
}

app="$(basename $0)"

# read command line arguments
while [ "$#" -gt 0 ]; do
  if [ "$1" -eq "$1" ] 2>/dev/null; then
    test_id=$1
  else
    if [ "$1" = "-h" ] || [ "$1" = "-help" ]; then
      echo "Usage: t [-help] [class] [test_id]" >&2
      exit 0
    else
      class=$1
    fi
  fi
  shift
done

# try to find a .java file if no $class was specified via the command
# line arguments
if [ -z "$class" ]; then
  class="$(find *.java 2>/dev/null | head -1)"
  # Exit if no .java file found
  if [ -z "$class" ]; then
    echo "$app: Need a .java file" >&2
    exit 1
  fi
fi

# trim off the extension
class=${class%.java}

# exit if the .java file does not exist
if [ ! -f "$class.java" ]; then
  echo "$app: $class.java: No such file" >&2
  exit 1
fi

# compile, and exit on error
javac "$class.java" || exit "$?"

# feed the program the input file corresponding to $test_id
if [ -n "$test_id" ]; then
  # resolve $input_file, and exit if not found
  input_file="$(find $INPUT_DIR/*$test_id$INPUT_EXT 2>/dev/null | head -1)"
  if [ ! -f "$input_file" ]; then
    echo "$app: $test_id: Missing input file" >&2
    exit 1
  fi
  # run the program, and exit
  java "$class" < "$input_file"
  exit "$?"
fi

# count the number of tests
num_test="$(find $INPUT_DIR/*$INPUT_EXT 2>/dev/null | wc -l | tr -d '[[:space:]]')"

# exit if no input files found
if [ "$num_test" -eq 0 ]; then
  echo "$app: No input files" >&2
  exit 1
fi

# run all the tests
num_pass="0"
echo
for (( i = 1; i <= num_test; i++ )); do
  # resolve $input_file, and exit if not found
  input_file="$(find $INPUT_DIR/*$i$INPUT_EXT 2>/dev/null | head -1)"
  if [ ! -f "$input_file" ]; then
    echo
    echo "$app: $i: Missing input file" >&2
    exit 1
  fi
  # resolve $output_file, and exit if not found
  output_file="$(find $OUTPUT_DIR/*$i$OUTPUT_EXT 2>/dev/null | head -1)"
  if [ ! -f "$output_file" ]; then
    echo
    echo "$app: $i: Missing output file" >&2
    exit 1
  fi
  # run the test, redirecting `stderr` to `stdout`
  actual="$(java $class < $input_file 2>&1)"
  if [ "$?" -ne "0" ]; then
    # program exited with a non-zero exit code
    printf "%4d $CROSS java: " "$i"
    format_str "$actual"
  else
    # compare the actual and expected outputs
    cmp="$(echo $actual | cmp $output_file - 2>&1)"
    if [ -n "$cmp" ]; then
      # the actual and expected outputs are different
      printf "%4d $CROSS cmp: " "$i"
      format_str "$cmp"
    else
      # the actual and expected outputs are the same
      printf "%4d $TICK\n" "$i"
      ((num_pass++))
    fi
  fi
done

# print the number of passes
printf "\n%4d / $num_test\n\n" "$num_pass"

# exit with code 1 if some test failed
if [ "$num_pass" != "$num_test" ]; then
  exit 1
fi
