#!/usr/bin/env bats

. "lib/ip.sh"

@test "ip_network" {
  result=$(ip_network "10.10.10.11" "255.255.255.0")
  [ "$result" = "10.10.10.0" ]
}

@test "ip_broadcast" {
  result=$(ip_broadcast "10.10.10.11" "255.255.255.0")
  [ "$result" = "10.10.10.255" ]
}
