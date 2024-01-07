#!/usr/bin/env bats

. "lib/core.sh"

function test_core_constructor()
{
	echo "constructor"
}

function test_core_destructor()
{
	echo "destructor"
}

@test "core_constructor" {
  result=$(eval "core test_core_constructor")
  [ "$result" = "constructor" ]
}

@test "core_destructor" {
  result=$(eval "core false test_core_destructor")
  [ "$result" = "destructor" ]
}
