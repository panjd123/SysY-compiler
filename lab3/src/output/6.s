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
	movl	$1, %edi
	# 1 test_codes/6.sy:3:15
	subq	$4, %rsp
	movl	%edi, -4(%rbp)
	movl	$2, %edi
	# 2 test_codes/6.sy:5:19
	subq	$4, %rsp
	movl	%edi, -8(%rbp)
	movl	$3, %edi
	# 3 test_codes/6.sy:7:23
	subq	$4, %rsp
	movl	%edi, -12(%rbp)
	subq	$4, %rsp
	# align stack
	movl	-12(%rbp), %esi
	# 3 test_codes/6.sy:8:22
	leaq	.LC1(%rip), %rdi
	movl	$0, %eax
	call	printf@PLT
	addq	$8, %rsp
	movl	$-2, %r9d
	# 2 test_codes/6.sy:10:16
	movl	%r9d, -8(%rbp)
	# 2 test_codes/6.sy:10:16
	subq	$8, %rsp
	# align stack
	movl	-8(%rbp), %esi
	# 2 test_codes/6.sy:11:18
	leaq	.LC1(%rip), %rdi
	movl	$0, %eax
	call	printf@PLT
	addq	$12, %rsp
	subq	$12, %rsp
	# align stack
	movl	-4(%rbp), %esi
	# 1 test_codes/6.sy:13:14
	leaq	.LC1(%rip), %rdi
	movl	$0, %eax
	call	printf@PLT
	addq	$16, %rsp
	popq	%r9
	popq	%r8
	popq	%rbp
	ret
	.globl	x
	.data
	.align	4
	.type	x, @object
	.size	x, 4
x:
	.long	0
	.text
	.globl	main
	.type	main, @function
main:
	pushq	%rbp
	pushq	%r8
	pushq	%r9
	movq	%rsp, %rbp
	call	func
	movl	x(%rip), %esi
	# 1 test_codes/6.sy:18:14
	leaq	.LC1(%rip), %rdi
	movl	$0, %eax
	call	printf@PLT
	addq	$0, %rsp
	popq	%r9
	popq	%r8
	popq	%rbp
	ret
