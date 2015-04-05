#!/usr/bin/env bats

load test_helper

@test "all tests; .java file not found" {
  cd no_source
  local expected="$t: Need a .java file"
  run $t    ; [ "$status" -eq 1 ]; [ "${lines[0]}" = "$expected" ]
  local expected="$t: Foo.java: No such file"
  run $t Foo; [ "$status" -eq 1 ]; [ "${lines[0]}" = "$expected" ]
}

@test "all tests; compilation error" {
  cd uncompilable
  local expected="Foo.java:1: error: reached end of file while parsing"
  run $t    ; [ "$status" -eq 1 ]; [ "${lines[0]}" = "$expected" ]
  run $t Foo; [ "$status" -eq 1 ]; [ "${lines[0]}" = "$expected" ]
}

@test "all tests; no input files" {
  cd no_input_files
  local expected="$t: No input files"
  run $t    ; [ "$status" -eq 1 ]; [ "${lines[0]}" = "$expected" ]
  run $t Foo; [ "$status" -eq 1 ]; [ "${lines[0]}" = "$expected" ]
}

@test "all tests; missing input file" {
  cd missing_input_file
  local expected="$t: 2: Missing input file"
  run $t    ; [ "$status" -eq 1 ]; [ "${lines[1]}" = "$expected" ]
  run $t Foo; [ "$status" -eq 1 ]; [ "${lines[1]}" = "$expected" ]
}

@test "all tests; missing output file" {
  cd missing_output_file
  local expected="$t: 2: Missing output file"
  run $t    ; [ "$status" -eq 1 ]; [ "${lines[1]}" = "$expected" ]
  run $t Foo; [ "$status" -eq 1 ]; [ "${lines[1]}" = "$expected" ]
}

@test "all tests; one test with incorrect output" {
  cd incorrect_output
  local expected="   2 / 3"
  run $t    ; [ "$status" -eq 1 ]; [ "${lines[3]}" = "$expected" ]
  run $t Foo; [ "$status" -eq 1 ]; [ "${lines[3]}" = "$expected" ]
}

@test "all tests; one test with runtime error" {
  cd runtime_error
  local expected="   2 / 3"
  run $t    ; [ "$status" -eq 1 ]; [ "${lines[4]}" = "$expected" ]
  run $t Foo; [ "$status" -eq 1 ]; [ "${lines[4]}" = "$expected" ]
}

@test "all tests; all pass" {
  cd all_passes
  local expected="   3 / 3"
  run $t    ; [ "$status" -eq 0 ]; [ "${lines[3]}" = "$expected" ]
  run $t Foo; [ "$status" -eq 0 ]; [ "${lines[3]}" = "$expected" ]
}
