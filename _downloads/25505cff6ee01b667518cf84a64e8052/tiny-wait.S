.text
    .global _start

_start:
    movq $0, %rbx # loop counter stays in %rbx for the initial process

    # main loop of the initial process
L:
    # puts counter on the stack so child process can access it
    pushq %rbx

    # do a fork syscall
    movq  $57, %rax # syscall number: 57 (fork)
    syscall

    # fork returns 0 (sets %eax to 0) for the child process
    cmp $0, %eax
    jz C # child process jumps to C
    # (initial process continues without jumping)

    # loop until counter is 10
    popq %rbx
    incq %rbx
    cmp $10, %rbx
    jnz L

    # do a wait4 syscall
W:  movq $61, %rax # syscall number: 61 (wait4)
    movq $-1, %rdi # arg: wait any child
    movq $0, %rsi # arg: ignore wstatus
    movq $0, %rdx # arg: no options
    movq $0, %r10 # arg: ignore rusage
    syscall

    # looping until the syscall returns a negative value
    cmp $0, %rax
    jns W
    jmp E # exit initial process

    # child process "entry point"
C:
    # top of the stack already contains the parent counter
    # this code sets the top of the stack to counter + 48 ('0')
    # so that it contains an ascii value between '0' and '9'
    popq  %rax
    addq  $48, %rax
    pushq %rax
    # do a write syscall
    movq  $1, %rax # syscall number: 1 (write)
    movq  $1, %rdi # arg: write on stdout (1)
    movq  %rsp, %rsi # arg: buffer to write starts on the top of the stack
    movq  $1, %rdx # arg: buffer is 1-byte long
    syscall

    # do an exit syscall
E:  movq  $60, %rax # syscall number: 60 (exit)
    movq  $0, %rdi # arg: status code 0
    syscall
