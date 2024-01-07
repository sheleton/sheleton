#!/usr/bin/env bats

. "lib/str.sh"

@test "str_join" {
  ADAGES=(
    'ARRAY=("Si vis" pacem para bellum); TEXT="Si vis pacem para bellum"'
    'ARRAY=(A bene placito); TEXT="A bene placito"'
    'ARRAY=(Pacta sunt servanda); TEXT="Pacta sunt servanda"'
  )

  for ADAGE in "${ADAGES[@]}"; do
    eval $ADAGE

    result=$(str_join " " ${ARRAY[@]})
    [ "$result" = "$TEXT" ]
  done
}
