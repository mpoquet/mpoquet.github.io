int main(void) {
  for (int i = 0; i < 10; ++i) {
    switch(fork()) {
      case -1:
        // fork error -> print some error and exit
      case 0:
        printf("%d", i); // print process number
        // exit the child process
    }
  }
  // exit the initial process
}
