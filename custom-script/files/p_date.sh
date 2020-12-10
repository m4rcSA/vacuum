#!/bin/sh

print_help() {
  cat << EOF

Options:
  -h, --help    Prints this message
  [date]        in any default date format e.g. YY-M-D M/D/YY
                Create date file /mnt/reserve/p_date with date stored in it.

Report bugs to: https://github.com/m4rcSA/vacuum/issues
EOF
}

print_usage() {
  cat << EOF
Uses:
  p_date --help|-h
  p_date 2019-10-1 10/1/2019
EOF
}

PARAM="$1"

case ${PARAM} in
  *-help|-h)
  print_usage
  print_help
  ;;
  *)
  if [ -z "${PARAM}" ]; then
    echo "date is empty and required"
    print_usage
    exit 1
  else
    date -d "${PARAM}" > /dev/null  2>&1
    if [ $? != 0 ]; then
      echo "date ${PARAM} is NOT a valid date"
      print_usage
      exit 1
    else
      echo "${PARAM}" > /mnt/reserve/p_date
    fi
  fi
  ;;
esac
