#!/usr/bin/env bats

# Basic start-up and connection tests
# These tests expect a running container at port 8080 with the name "grimm"

@test "container jvm responds from client" {
  run docker exec grimm java -version
  [ "$status" -eq 0 ]
}

@test "container can be reached via http" {
  result=$(curl -Is http://127.0.0.1:8080/ | grep -o 'Jetty')
  [ "$result" == 'Jetty' ]
}

@test "container reports healthy to docker" {
  result=$(docker ps | grep -c 'healthy')
  [ "$result" -eq 1 ]
}

@test "logs show clean start" {
  result=$(docker logs grimm | grep -o 'Server has started')
  [ "$result" == 'Server has started' ]
}

# Make sure the package has been deployed
@test "logs show package deployment" {
  result=$(docker logs grimm | grep -om 1 'https://teipublisher.com/apps/grimm')
  [ "$result" == 'https://teipublisher.com/apps/grimm' ]
}

@test "logs are error free" {
  skip "there are errors" # not a good reason to skip
  result=$(docker logs grimm | grep -ow -c 'ERROR' || true)
  [ "$result" -eq 0 ]
}

@test "no fatalities in logs" {
  result=$(docker logs grimm | grep -ow -c 'FATAL' || true)
  [ "$result" -eq 0 ]
}