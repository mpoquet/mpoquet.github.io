int main(void) {
  for (int i = 0; i < 10; ++i) {
    switch(fork()) {
      case -1:
        // fork error -> print some error and exit
      case 0:
        // 1. there is uncertainty on what the sub process does here.
        //    we are 100 % sure that it does not crash nor enter an infinite loop.
        //    we are also 100 % sure that the sub process does not:
        //    - spawn any processes or communicate with other processes
        //    - print anything with stdio functions

        // 2. we are 100% sure this code is reached.
        //    all sub processes call printf.
        printf("%d\n", i);

        // 3. there is uncertainty on what the sub process does afterwards.
        //    some sub processes do nothing, some execute some code,
        //    some crash (e.g., segfault), some abort...

        // 4. finally, the sub process stops its execution.
    }
  }
  // exit the initial process
}
