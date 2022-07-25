#!/bin/bash

# check system network status
function network() {
  local timeout=1
  local target=www.baidu.com
  local ret_code=`curl -I -s --connect-timeout ${timeout} ${target} -w %{http_code} | tail -n1`
  if [ "x$ret_code" = "x200" ]; then
    return 1
  else
    return 0
  fi
  return 0
}
