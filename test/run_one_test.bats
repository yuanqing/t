#!/usr/bin/env bats

load test_helper

@test "one test; .java file not found" {
  cd no_source
  local expected="t: Need a .java file"
  run t 2    ; [ "$status" -eq 1 ]; [ "${lines[0]}" = "$expected" ]
  local expected="t: Foo.java: No such file"
  run t 2 Foo; [ "$status" -eq 1 ]; [ "${lines[0]}" = "$expected" ]
  run t Foo 2; [ "$status" -eq 1 ]; [ "${lines[0]}" = "$expected" ]
}

@test "one test; compilation error" {
  cd uncompilable
  local expected="Foo.java:1: error: reached end of file while parsing"
  run t 2    ; [ "$status" -eq 1 ]; [ "${lines[0]}" = "$expected" ]
  run t 2 Foo; [ "$status" -eq 1 ]; [ "${lines[0]}" = "$expected" ]
  run t Foo 2; [ "$status" -eq 1 ]; [ "${lines[0]}" = "$expected" ]
}

@test "one test; invalid test id" {
  cd all_passes
  local expected="t: 42: No such test"
  run t 42    ; [ "$status" -eq 1 ]; [ "${lines[0]}" = "$expected" ]
  run t 42 Foo; [ "$status" -eq 1 ]; [ "${lines[0]}" = "$expected" ]
  run t Foo 42; [ "$status" -eq 1 ]; [ "${lines[0]}" = "$expected" ]
}

@test "one test; with runtime error" {
  cd runtime_error
  local expected="Exception in thread \"main\" java.lang.RuntimeException"
  run t 2    ; [ "$status" -eq 1 ]; [ "${lines[0]}" = "$expected" ]
  run t 2 Foo; [ "$status" -eq 1 ]; [ "${lines[0]}" = "$expected" ]
  run t Foo 2; [ "$status" -eq 1 ]; [ "${lines[0]}" = "$expected" ]
}

@test "one test; without runtime error" {
  cd all_passes
  run t 2    ; [ "$status" -eq 0 ]; [ "$output" = "2" ]
  run t 2 Foo; [ "$status" -eq 0 ]; [ "$output" = "2" ]
  run t Foo 2; [ "$status" -eq 0 ]; [ "$output" = "2" ]
}
