#!/usr/bin/env bash
nbrun=100
w='wait'

for i in nop nbf lbf fbf; do
  for p in nop p pf pn pnf w wn; do
    for e in exit _exit segv; do
      variant=${i}-${p}-${e}-${w}

      for run in $(seq ${nbrun}); do
        echo "run ${variant} ${run}"
        ./${variant}

        # print a newline here if the print variant does not issue any newline
        if [[ ${p} != *"n"* ]]; then
          echo
        fi
      done
    done
  done
done
