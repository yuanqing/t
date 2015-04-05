#!/usr/bin/env bats

@test "prints usage message with the -h or -help flags" {
  local expected="Usage: t [-help] [class] [test_id]"
  run ../t -h   ; [ "$status" -eq 0 ]; [ "$output" = "$expected" ]
  run ../t -help; [ "$status" -eq 0 ]; [ "$output" = "$expected" ]
}
