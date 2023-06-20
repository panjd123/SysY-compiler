.LC0:
	.string	"%d"
.LC1:
	.string	"%d\n"
	.globl	func
	.type	main, @function
func:
	pushq	%rbp
	pushq	%r8
	pushq	%r9
	movq	%rsp, %rbp
	subq	$4, %rsp
	movl	$0, -4(%rbp)
	movl	40(%rbp), %r8d
	# 1 test_codes/7.sy:3:17
	imull	$1, %r8d
	addl	-4(%rbp), %r8d
	movl	%r8d, -4(%rbp)
	subq	$12, %rsp
	# align stack
	movl	-4(%rbp), %ebx
	cltq
	movq	32(%rbp), %r10
	movl	(%r10, %rbx, 4), %esi
	# 1 test_codes/7.sy:3:17
	leaq	.LC1(%rip), %rdi
	movl	$0, %eax
	call	printf@PLT
	addq	$16, %rsp
	popq	%r9
	popq	%r8
	popq	%rbp
	ret
	.section	.rodata
	.align	4
	.type	number, @object
	.size	number, 40
number:
	.long	0
	.long	1
	.long	2
	.long	3
	.long	4
	.long	5
	.long	6
	.long	7
	.long	8
	.long	9
	.text
	.globl	main
	.type	main, @function
main:
	pushq	%rbp
	pushq	%r8
	pushq	%r9
	movq	%rsp, %rbp
	movl	$0, %r8d
	# 1 test_codes/7.sy:7:20
	subq	$4, %rsp
	movl	%r8d, -4(%rbp)
	leaq	number(%rip), %r8
	# 1 test_codes/7.sy:7:20
	subq	$8, %rsp
	movq	%r8, -12(%rbp)
	call	func
	subq	$4, %rsp
	# align stack
	movl	$5, %r8d
	# 1 test_codes/7.sy:8:20
	subq	$4, %rsp
	movl	%r8d, -20(%rbp)
	leaq	number(%rip), %r8
	# 1 test_codes/7.sy:8:20
	subq	$8, %rsp
	movq	%r8, -28(%rbp)
	call	func
	subq	$4, %rsp
	# align stack
	movl	$6, %r8d
	# 1 test_codes/7.sy:9:20
	subq	$4, %rsp
	movl	%r8d, -36(%rbp)
	leaq	number(%rip), %r8
	# 1 test_codes/7.sy:9:20
	subq	$8, %rsp
	movq	%r8, -44(%rbp)
	call	func
	addq	$44, %rsp
	popq	%r9
	popq	%r8
	popq	%rbp
	ret
