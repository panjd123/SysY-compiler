.LC0:
	.string	"%d"
.LC1:
	.string	"%d\n"
	.globl	main
	.type	main, @function
main:
	pushq	%rbp
	pushq	%r8
	pushq	%r9
	movq	%rsp, %rbp
	subq	$4, %rsp
	subq	$4, %rsp
	subq	$8, %rsp
	# align stack
	leaq	-4(%rbp), %rsi
	# 1 test_codes/1.sy:9:13
	leaq	.LC0(%rip), %rdi
	movl	$0, %eax
	call	__isoc99_scanf@PLT
	leaq	-8(%rbp), %rsi
	# 1 test_codes/1.sy:10:13
	leaq	.LC0(%rip), %rdi
	movl	$0, %eax
	call	__isoc99_scanf@PLT
	movl	-4(%rbp), %r8d
	# 1 test_codes/1.sy:11:19
	movl	-8(%rbp), %r9d
	# 1 test_codes/1.sy:11:19
	addl	%r9d, %r8d
	subq	$4, %rsp
	movl	%r8d, -20(%rbp)
	movl	-20(%rbp), %edi
	# 1 test_codes/1.sy:11:19
	subq	$4, %rsp
	movl	%edi, -24(%rbp)
	subq	$8, %rsp
	# align stack
	movl	-24(%rbp), %esi
	# 1 test_codes/1.sy:12:14
	leaq	.LC1(%rip), %rdi
	movl	$0, %eax
	call	printf@PLT
	addq	$32, %rsp
	popq	%r9
	popq	%r8
	popq	%rbp
	ret
