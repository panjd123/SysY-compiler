.LC0:
	.string	"%d"
.LC1:
	.string	"%d\n"
	.section	.rodata
	.align	4
	.type	N, @object
	.size	N, 4
N:
	.long	10
	.text
	.globl	a
	.data
	.align	4
	.type	a, @object
	.size	a, 40
a:
	.long	0
	.long	0
	.long	0
	.long	0
	.long	0
	.long	0
	.long	0
	.long	0
	.long	0
	.long	0
	.text
	.globl	b
	.data
	.align	4
	.type	b, @object
	.size	b, 40
b:
	.long	0
	.long	0
	.long	0
	.long	0
	.long	0
	.long	0
	.long	0
	.long	0
	.long	0
	.long	0
	.text
	.globl	c
	.data
	.align	4
	.type	c, @object
	.size	c, 40
c:
	.long	0
	.long	0
	.long	0
	.long	0
	.long	0
	.long	0
	.long	0
	.long	0
	.long	0
	.long	0
	.text
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
	# 1 test_codes/3.sy:9:14
	leaq	.LC0(%rip), %rdi
	movl	$0, %eax
	call	__isoc99_scanf@PLT
	leaq	-8(%rbp), %rsi
	# 1 test_codes/3.sy:10:14
	leaq	.LC0(%rip), %rdi
	movl	$0, %eax
	call	__isoc99_scanf@PLT
	movl	$0, %edi
	# 1 test_codes/3.sy:11:15
	subq	$4, %rsp
	movl	%edi, -20(%rbp)
.L1:
	# enter while
	# enter stmt
.L2:
	# if <
	movl	-20(%rbp), %r8d
	# 2 test_codes/3.sy:12:18
	movl	-4(%rbp), %r9d
	# 2 test_codes/3.sy:12:18
	cmpl	%r9d, %r8d
	jl	.L4
	jmp	.L3
.L3:
	# exit while
	addq	$0, %rsp
	jmp	.L5
.L4:
	# enter stmt
	subq	$4, %rsp
	movl	$0, -24(%rbp)
	movl	-20(%rbp), %r8d
	# 3 test_codes/3.sy:13:21
	imull	$1, %r8d
	addl	-24(%rbp), %r8d
	movl	%r8d, -24(%rbp)
	subq	$8, %rsp
	# align stack
	movl	-24(%rbp), %ebx
	cltq
	leaq	0(, %rbx, 4), %rdx
	leaq	a(%rip), %rbx
	leaq	(%rdx, %rbx), %rsi
	# 3 test_codes/3.sy:13:21
	leaq	.LC0(%rip), %rdi
	movl	$0, %eax
	call	__isoc99_scanf@PLT
	movl	-20(%rbp), %r8d
	# 3 test_codes/3.sy:14:19
	movl	$1, %r9d
	# 3 test_codes/3.sy:14:19
	addl	%r9d, %r8d
	subq	$4, %rsp
	movl	%r8d, -36(%rbp)
	movl	-36(%rbp), %r9d
	# 3 test_codes/3.sy:14:19
	movl	%r9d, -20(%rbp)
	# 3 test_codes/3.sy:14:19
	addq	$16, %rsp
	addq	$0, %rsp
	jmp	.L1
.L5:
	# while end
	movl	$0, %r9d
	# 1 test_codes/3.sy:16:11
	movl	%r9d, -20(%rbp)
	# 1 test_codes/3.sy:16:11
.L6:
	# enter while
	# enter stmt
.L7:
	# if <
	movl	-20(%rbp), %r8d
	# 2 test_codes/3.sy:17:18
	movl	-8(%rbp), %r9d
	# 2 test_codes/3.sy:17:18
	cmpl	%r9d, %r8d
	jl	.L9
	jmp	.L8
.L8:
	# exit while
	addq	$0, %rsp
	jmp	.L10
.L9:
	# enter stmt
	subq	$4, %rsp
	movl	$0, -24(%rbp)
	movl	-20(%rbp), %r8d
	# 3 test_codes/3.sy:18:21
	imull	$1, %r8d
	addl	-24(%rbp), %r8d
	movl	%r8d, -24(%rbp)
	subq	$8, %rsp
	# align stack
	movl	-24(%rbp), %ebx
	cltq
	leaq	0(, %rbx, 4), %rdx
	leaq	b(%rip), %rbx
	leaq	(%rdx, %rbx), %rsi
	# 3 test_codes/3.sy:18:21
	leaq	.LC0(%rip), %rdi
	movl	$0, %eax
	call	__isoc99_scanf@PLT
	movl	-20(%rbp), %r8d
	# 3 test_codes/3.sy:19:19
	movl	$1, %r9d
	# 3 test_codes/3.sy:19:19
	addl	%r9d, %r8d
	subq	$4, %rsp
	movl	%r8d, -36(%rbp)
	movl	-36(%rbp), %r9d
	# 3 test_codes/3.sy:19:19
	movl	%r9d, -20(%rbp)
	# 3 test_codes/3.sy:19:19
	addq	$16, %rsp
	addq	$0, %rsp
	jmp	.L6
.L10:
	# while end
	movl	$0, %edi
	# 1 test_codes/3.sy:21:15
	subq	$4, %rsp
	movl	%edi, -24(%rbp)
	movl	$0, %r9d
	# 1 test_codes/3.sy:22:11
	movl	%r9d, -20(%rbp)
	# 1 test_codes/3.sy:22:11
.L11:
	# enter while
	# enter stmt
.L12:
	# if <
	movl	-20(%rbp), %r8d
	# 2 test_codes/3.sy:23:18
	movl	-4(%rbp), %r9d
	# 2 test_codes/3.sy:23:18
	cmpl	%r9d, %r8d
	jl	.L14
	jmp	.L13
.L13:
	# exit while
	addq	$0, %rsp
	jmp	.L20
.L14:
	# enter stmt
	movl	$0, %r9d
	# 3 test_codes/3.sy:24:15
	movl	%r9d, -24(%rbp)
	# 3 test_codes/3.sy:24:15
.L15:
	# enter while
	# enter stmt
.L16:
	# if <
	movl	-24(%rbp), %r8d
	# 4 test_codes/3.sy:25:22
	movl	-8(%rbp), %r9d
	# 4 test_codes/3.sy:25:22
	cmpl	%r9d, %r8d
	jl	.L18
	jmp	.L17
.L17:
	# exit while
	addq	$0, %rsp
	jmp	.L19
.L18:
	# enter stmt
	subq	$4, %rsp
	movl	$0, -28(%rbp)
	movl	-20(%rbp), %r8d
	# 5 test_codes/3.sy:26:29
	imull	$1, %r8d
	addl	-28(%rbp), %r8d
	movl	%r8d, -28(%rbp)
	subq	$4, %rsp
	movl	$0, -32(%rbp)
	movl	-24(%rbp), %r8d
	# 5 test_codes/3.sy:26:35
	imull	$1, %r8d
	addl	-32(%rbp), %r8d
	movl	%r8d, -32(%rbp)
	movl	-28(%rbp), %ebx
	cltq
	leaq	0(, %rbx, 4), %rdx
	leaq	a(%rip), %rbx
	movl	(%rdx, %rbx), %r8d
	# 5 test_codes/3.sy:26:35
	movl	-32(%rbp), %ebx
	cltq
	leaq	0(, %rbx, 4), %rdx
	leaq	b(%rip), %rbx
	movl	(%rdx, %rbx), %r9d
	# 5 test_codes/3.sy:26:35
	imull	%r8d, %r9d
	subq	$4, %rsp
	movl	%r9d, -36(%rbp)
	movl	-36(%rbp), %edi
	# 5 test_codes/3.sy:26:35
	subq	$4, %rsp
	movl	%edi, -40(%rbp)
	movl	-20(%rbp), %r8d
	# 5 test_codes/3.sy:27:21
	movl	-24(%rbp), %r9d
	# 5 test_codes/3.sy:27:21
	addl	%r9d, %r8d
	subq	$4, %rsp
	movl	%r8d, -44(%rbp)
	subq	$4, %rsp
	movl	$0, -48(%rbp)
	movl	-44(%rbp), %r8d
	# 5 test_codes/3.sy:27:23
	imull	$1, %r8d
	addl	-48(%rbp), %r8d
	movl	%r8d, -48(%rbp)
	movl	-20(%rbp), %r8d
	# 5 test_codes/3.sy:27:32
	movl	-24(%rbp), %r9d
	# 5 test_codes/3.sy:27:32
	addl	%r9d, %r8d
	subq	$4, %rsp
	movl	%r8d, -52(%rbp)
	subq	$4, %rsp
	movl	$0, -56(%rbp)
	movl	-52(%rbp), %r8d
	# 5 test_codes/3.sy:27:34
	imull	$1, %r8d
	addl	-56(%rbp), %r8d
	movl	%r8d, -56(%rbp)
	movl	-56(%rbp), %ebx
	cltq
	leaq	0(, %rbx, 4), %rdx
	leaq	c(%rip), %rbx
	movl	(%rdx, %rbx), %r8d
	# 5 test_codes/3.sy:27:39
	movl	-40(%rbp), %r9d
	# 5 test_codes/3.sy:27:39
	addl	%r9d, %r8d
	subq	$4, %rsp
	movl	%r8d, -60(%rbp)
	movl	-60(%rbp), %r9d
	# 5 test_codes/3.sy:27:39
	movl	-48(%rbp), %ebx
	cltq
	leaq	0(, %rbx, 4), %rdx
	leaq	c(%rip), %rbx
	movl	%r9d, (%rdx, %rbx)
	# 5 test_codes/3.sy:27:39
	movl	-24(%rbp), %r8d
	# 5 test_codes/3.sy:28:23
	movl	$1, %r9d
	# 5 test_codes/3.sy:28:23
	addl	%r9d, %r8d
	subq	$4, %rsp
	movl	%r8d, -64(%rbp)
	movl	-64(%rbp), %r9d
	# 5 test_codes/3.sy:28:23
	movl	%r9d, -24(%rbp)
	# 5 test_codes/3.sy:28:23
	addq	$40, %rsp
	addq	$0, %rsp
	jmp	.L15
.L19:
	# while end
	movl	-20(%rbp), %r8d
	# 3 test_codes/3.sy:30:19
	movl	$1, %r9d
	# 3 test_codes/3.sy:30:19
	addl	%r9d, %r8d
	subq	$4, %rsp
	movl	%r8d, -28(%rbp)
	movl	-28(%rbp), %r9d
	# 3 test_codes/3.sy:30:19
	movl	%r9d, -20(%rbp)
	# 3 test_codes/3.sy:30:19
	addq	$4, %rsp
	addq	$0, %rsp
	jmp	.L11
.L20:
	# while end
	movl	$0, %r9d
	# 1 test_codes/3.sy:32:11
	movl	%r9d, -20(%rbp)
	# 1 test_codes/3.sy:32:11
.L21:
	# enter while
	# enter stmt
	movl	-4(%rbp), %r8d
	# 2 test_codes/3.sy:33:23
	movl	-8(%rbp), %r9d
	# 2 test_codes/3.sy:33:23
	addl	%r9d, %r8d
	subq	$4, %rsp
	movl	%r8d, -28(%rbp)
	movl	-28(%rbp), %r8d
	# 2 test_codes/3.sy:33:26
	movl	$1, %r9d
	# 2 test_codes/3.sy:33:26
	subl	%r9d, %r8d
	subq	$4, %rsp
	movl	%r8d, -32(%rbp)
.L22:
	# if <
	movl	-20(%rbp), %r8d
	# 2 test_codes/3.sy:33:26
	movl	-32(%rbp), %r9d
	# 2 test_codes/3.sy:33:26
	cmpl	%r9d, %r8d
	jl	.L24
	jmp	.L23
.L23:
	# exit while
	addq	$8, %rsp
	jmp	.L25
.L24:
	# enter stmt
	subq	$4, %rsp
	movl	$0, -36(%rbp)
	movl	-20(%rbp), %r8d
	# 3 test_codes/3.sy:34:21
	imull	$1, %r8d
	addl	-36(%rbp), %r8d
	movl	%r8d, -36(%rbp)
	subq	$12, %rsp
	# align stack
	movl	-36(%rbp), %ebx
	cltq
	leaq	0(, %rbx, 4), %rdx
	leaq	c(%rip), %rbx
	movl	(%rdx, %rbx), %esi
	# 3 test_codes/3.sy:34:21
	leaq	.LC1(%rip), %rdi
	movl	$0, %eax
	call	printf@PLT
	movl	-20(%rbp), %r8d
	# 3 test_codes/3.sy:35:19
	movl	$1, %r9d
	# 3 test_codes/3.sy:35:19
	addl	%r9d, %r8d
	subq	$4, %rsp
	movl	%r8d, -52(%rbp)
	movl	-52(%rbp), %r9d
	# 3 test_codes/3.sy:35:19
	movl	%r9d, -20(%rbp)
	# 3 test_codes/3.sy:35:19
	addq	$20, %rsp
	addq	$8, %rsp
	jmp	.L21
.L25:
	# while end
	movl	$0, %eax
	# 1 test_codes/3.sy:37:14
	addq	$24, %rsp
	popq	%r9
	popq	%r8
	popq	%rbp
	ret
