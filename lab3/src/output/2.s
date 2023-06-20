.LC0:
	.string	"%d"
.LC1:
	.string	"%d\n"
	.section	.rodata
	.align	4
	.type	N, @object
	.size	N, 4
N:
	.long	3
	.text
	.globl	a
	.data
	.align	4
	.type	a, @object
	.size	a, 72
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
	.long	0
	.long	0
	.long	0
	.long	0
	.long	0
	.long	0
	.long	0
	.long	0
	.text
	.globl	f
	.type	main, @function
f:
	pushq	%rbp
	pushq	%r8
	pushq	%r9
	movq	%rsp, %rbp
.L1:
	# if ==
	movl	32(%rbp), %r8d
	# 1 test_codes/2.sy:17:16
	movl	$1, %r9d
	# 1 test_codes/2.sy:17:16
	cmpl	%r9d, %r8d
	je	.L2
	jmp	.L3
.L2:
	# enter stmt
	movl	$1, %eax
	# 2 test_codes/2.sy:18:18
	addq	$0, %rsp
	popq	%r9
	popq	%r8
	popq	%rbp
	ret
	addq	$0, %rsp
.L3:
	# if end
	movl	$1, %edi
	# 1 test_codes/2.sy:19:17
	subq	$4, %rsp
	movl	%edi, -4(%rbp)
	movl	32(%rbp), %r8d
	# 1 test_codes/2.sy:20:23
	movl	$1, %r9d
	# 1 test_codes/2.sy:20:23
	subl	%r9d, %r8d
	subq	$4, %rsp
	movl	%r8d, -8(%rbp)
	subq	$8, %rsp
	# align stack
	movl	-8(%rbp), %r8d
	# 1 test_codes/2.sy:20:23
	subq	$4, %rsp
	movl	%r8d, -20(%rbp)
	call	f
	subq	$4, %rsp
	movl	%eax, -24(%rbp)
	movl	32(%rbp), %r8d
	# 1 test_codes/2.sy:20:23
	movl	-24(%rbp), %r9d
	# 1 test_codes/2.sy:20:23
	imull	%r8d, %r9d
	subq	$4, %rsp
	movl	%r9d, -28(%rbp)
	movl	-28(%rbp), %r9d
	# 1 test_codes/2.sy:20:24
	movl	%r9d, -4(%rbp)
	# 1 test_codes/2.sy:20:24
	movl	-4(%rbp), %eax
	# 1 test_codes/2.sy:21:16
	addq	$28, %rsp
	popq	%r9
	popq	%r8
	popq	%rbp
	ret
	.globl	main
	.type	main, @function
main:
	pushq	%rbp
	pushq	%r8
	pushq	%r9
	movq	%rsp, %rbp
	movl	$10, %r8d
	# 1 test_codes/2.sy:26:18
	subq	$4, %rsp
	movl	%r8d, -4(%rbp)
	call	f
	subq	$4, %rsp
	movl	%eax, -8(%rbp)
	movl	-8(%rbp), %edi
	# 1 test_codes/2.sy:26:19
	subq	$4, %rsp
	movl	%edi, -12(%rbp)
.L4:
	# if !=
	movl	-12(%rbp), %r8d
	# 1 test_codes/2.sy:27:24
	movl	$3628800, %r9d
	# 1 test_codes/2.sy:27:24
	cmpl	%r9d, %r8d
	jne	.L6
	jmp	.L5
.L5:
	movl	-12(%rbp), %r8d
	# 1 test_codes/2.sy:27:27
	cmpl	$0, %r8d
	jne	.L6
	jmp	.L10
.L6:
	# enter stmt
	# enter stmt
	subq	$4, %rsp
	# align stack
	movl	$2333, %esi
	# 3 test_codes/2.sy:28:21
	leaq	.LC1(%rip), %rdi
	movl	$0, %eax
	call	printf@PLT
	movl	-12(%rbp), %eax
	# 3 test_codes/2.sy:29:16
	testl %eax, %eax
	sete %al
	movzbl %al, %eax
	subq $4, %rsp
	movl %eax, -20(%rbp)
.L7:
	# enter stmt
	movl	-12(%rbp), %r8d
	# 4 test_codes/2.sy:30:24
	movl	$10, %r9d
	# 4 test_codes/2.sy:30:24
	subl	%r9d, %r8d
	subq	$4, %rsp
	movl	%r8d, -24(%rbp)
	movl	-24(%rbp), %r9d
	# 4 test_codes/2.sy:30:24
	movl	%r9d, -12(%rbp)
	# 4 test_codes/2.sy:30:24
	addq	$4, %rsp
	jmp	.L9
.L8:
	# enter stmt
	movl	-12(%rbp), %r8d
	# 4 test_codes/2.sy:32:24
	movl	$10, %r9d
	# 4 test_codes/2.sy:32:24
	addl	%r9d, %r8d
	subq	$4, %rsp
	movl	%r8d, -24(%rbp)
	movl	-24(%rbp), %r9d
	# 4 test_codes/2.sy:32:24
	movl	%r9d, -12(%rbp)
	# 4 test_codes/2.sy:32:24
	addq	$4, %rsp
.L9:
	addq	$8, %rsp
	addq	$0, %rsp
	jmp	.L11
.L10:
	# enter stmt
	# enter stmt
	subq	$4, %rsp
	# align stack
	movl	-12(%rbp), %esi
	# 3 test_codes/2.sy:35:18
	leaq	.LC1(%rip), %rdi
	movl	$0, %eax
	call	printf@PLT
	addq	$4, %rsp
	addq	$0, %rsp
.L11:
	subq	$4, %rsp
	# align stack
	movl	-12(%rbp), %esi
	# 1 test_codes/2.sy:37:14
	leaq	.LC1(%rip), %rdi
	movl	$0, %eax
	call	printf@PLT
	movl	$0, %edi
	# 1 test_codes/2.sy:39:15
	subq	$4, %rsp
	movl	%edi, -20(%rbp)
	movl	$0, %edi
	# 1 test_codes/2.sy:39:22
	subq	$4, %rsp
	movl	%edi, -24(%rbp)
.L12:
	# enter while
	# enter stmt
.L13:
	# if <=
	movl	-20(%rbp), %r8d
	# 2 test_codes/2.sy:40:19
	movl	$3, %r9d
	# 2 test_codes/2.sy:40:19
	cmpl	%r9d, %r8d
	jle	.L15
	jmp	.L14
.L14:
	# exit while
	addq	$0, %rsp
	jmp	.L22
.L15:
	# enter stmt
.L16:
	# if ==
	movl	-20(%rbp), %r8d
	# 3 test_codes/2.sy:41:20
	movl	$1, %r9d
	# 3 test_codes/2.sy:41:20
	cmpl	%r9d, %r8d
	je	.L17
	jmp	.L18
.L17:
	# enter stmt
	# enter stmt
	movl	-20(%rbp), %r8d
	# 5 test_codes/2.sy:42:23
	movl	$1, %r9d
	# 5 test_codes/2.sy:42:23
	addl	%r9d, %r8d
	subq	$4, %rsp
	movl	%r8d, -28(%rbp)
	movl	-28(%rbp), %r9d
	# 5 test_codes/2.sy:42:23
	movl	%r9d, -20(%rbp)
	# 5 test_codes/2.sy:42:23
	addq	$4, %rsp
	jmp	.L12
	addq	$4, %rsp
	addq	$0, %rsp
.L18:
	# if end
.L19:
	# if ==
	movl	-20(%rbp), %r8d
	# 3 test_codes/2.sy:45:20
	movl	$3, %r9d
	# 3 test_codes/2.sy:45:20
	cmpl	%r9d, %r8d
	je	.L20
	jmp	.L21
.L20:
	# enter stmt
	addq	$0, %rsp
	jmp	.L22
	addq	$0, %rsp
.L21:
	# if end
	subq	$8, %rsp
	# align stack
	movl	-20(%rbp), %esi
	# 3 test_codes/2.sy:47:18
	leaq	.LC1(%rip), %rdi
	movl	$0, %eax
	call	printf@PLT
	movl	-20(%rbp), %r8d
	# 3 test_codes/2.sy:48:19
	movl	$1, %r9d
	# 3 test_codes/2.sy:48:19
	addl	%r9d, %r8d
	subq	$4, %rsp
	movl	%r8d, -36(%rbp)
	movl	-36(%rbp), %r9d
	# 3 test_codes/2.sy:48:19
	movl	%r9d, -20(%rbp)
	# 3 test_codes/2.sy:48:19
	addq	$12, %rsp
	addq	$0, %rsp
	jmp	.L12
.L22:
	# while end
	subq	$72, %rsp
	movl	$1, %r9d
	# 1 test_codes/2.sy:51:11
	movl	%r9d, -20(%rbp)
	# 1 test_codes/2.sy:51:11
	movl	-20(%rbp), %r8d
	# 1 test_codes/2.sy:52:15
	movl	-20(%rbp), %r9d
	# 1 test_codes/2.sy:52:15
	addl	%r9d, %r8d
	subq	$4, %rsp
	movl	%r8d, -100(%rbp)
	movl	-100(%rbp), %r9d
	# 1 test_codes/2.sy:52:15
	movl	%r9d, -24(%rbp)
	# 1 test_codes/2.sy:52:15
	subq	$4, %rsp
	movl	$0, -104(%rbp)
	movl	$0, %r8d
	# 1 test_codes/2.sy:53:14
	imull	$1, %r8d
	addl	-104(%rbp), %r8d
	movl	%r8d, -104(%rbp)
	movl	$0, %r8d
	# 1 test_codes/2.sy:53:14
	imull	$6, %r8d
	addl	-104(%rbp), %r8d
	movl	%r8d, -104(%rbp)
	movl	-24(%rbp), %r8d
	# 1 test_codes/2.sy:53:24
	movl	$2, %r9d
	# 1 test_codes/2.sy:53:24
	imull	%r8d, %r9d
	subq	$4, %rsp
	movl	%r9d, -108(%rbp)
	movl	-20(%rbp), %r8d
	# 1 test_codes/2.sy:53:25
	movl	-108(%rbp), %r9d
	# 1 test_codes/2.sy:53:25
	addl	%r9d, %r8d
	subq	$4, %rsp
	movl	%r8d, -112(%rbp)
	movl	-112(%rbp), %r9d
	# 1 test_codes/2.sy:53:25
	movl	-104(%rbp), %ebx
	cltq
	movl	%r9d, -96(%rbp, %rbx, 4)
	# 1 test_codes/2.sy:53:25
	subq	$4, %rsp
	movl	$0, -116(%rbp)
	movl	-24(%rbp), %r8d
	# 1 test_codes/2.sy:54:14
	imull	$1, %r8d
	addl	-116(%rbp), %r8d
	movl	%r8d, -116(%rbp)
	movl	-20(%rbp), %r8d
	# 1 test_codes/2.sy:54:14
	imull	$6, %r8d
	addl	-116(%rbp), %r8d
	movl	%r8d, -116(%rbp)
	movl	$3, %r9d
	# 1 test_codes/2.sy:54:17
	movl	-116(%rbp), %ebx
	cltq
	movl	%r9d, -96(%rbp, %rbx, 4)
	# 1 test_codes/2.sy:54:17
	subq	$4, %rsp
	movl	$0, -120(%rbp)
	movl	$0, %r8d
	# 1 test_codes/2.sy:55:20
	imull	$1, %r8d
	addl	-120(%rbp), %r8d
	movl	%r8d, -120(%rbp)
	movl	$0, %r8d
	# 1 test_codes/2.sy:55:20
	imull	$6, %r8d
	addl	-120(%rbp), %r8d
	movl	%r8d, -120(%rbp)
	subq	$8, %rsp
	# align stack
	movl	-120(%rbp), %ebx
	cltq
	movl	-96(%rbp, %rbx, 4), %esi
	# 1 test_codes/2.sy:55:20
	leaq	.LC1(%rip), %rdi
	movl	$0, %eax
	call	printf@PLT
	subq	$4, %rsp
	movl	$0, -132(%rbp)
	movl	-24(%rbp), %r8d
	# 1 test_codes/2.sy:56:20
	imull	$1, %r8d
	addl	-132(%rbp), %r8d
	movl	%r8d, -132(%rbp)
	movl	-20(%rbp), %r8d
	# 1 test_codes/2.sy:56:20
	imull	$6, %r8d
	addl	-132(%rbp), %r8d
	movl	%r8d, -132(%rbp)
	subq	$12, %rsp
	# align stack
	movl	-132(%rbp), %ebx
	cltq
	movl	-96(%rbp, %rbx, 4), %esi
	# 1 test_codes/2.sy:56:20
	leaq	.LC1(%rip), %rdi
	movl	$0, %eax
	call	printf@PLT
	subq	$4, %rsp
	movl	$0, -148(%rbp)
	movl	-24(%rbp), %r8d
	# 1 test_codes/2.sy:57:24
	imull	$1, %r8d
	addl	-148(%rbp), %r8d
	movl	%r8d, -148(%rbp)
	movl	-20(%rbp), %r8d
	# 1 test_codes/2.sy:57:24
	imull	$6, %r8d
	addl	-148(%rbp), %r8d
	movl	%r8d, -148(%rbp)
	subq	$4, %rsp
	movl	$0, -152(%rbp)
	movl	$0, %r8d
	# 1 test_codes/2.sy:57:33
	imull	$1, %r8d
	addl	-152(%rbp), %r8d
	movl	%r8d, -152(%rbp)
	movl	$0, %r8d
	# 1 test_codes/2.sy:57:33
	imull	$6, %r8d
	addl	-152(%rbp), %r8d
	movl	%r8d, -152(%rbp)
	movl	-148(%rbp), %ebx
	cltq
	movl	-96(%rbp, %rbx, 4), %r8d
	# 1 test_codes/2.sy:57:33
	movl	-152(%rbp), %ebx
	cltq
	movl	-96(%rbp, %rbx, 4), %r9d
	# 1 test_codes/2.sy:57:33
	addl	%r9d, %r8d
	subq	$4, %rsp
	movl	%r8d, -156(%rbp)
	movl	-156(%rbp), %edi
	# 1 test_codes/2.sy:57:33
	subq	$4, %rsp
	movl	%edi, -160(%rbp)
	movl	-160(%rbp), %esi
	# 1 test_codes/2.sy:58:16
	leaq	.LC1(%rip), %rdi
	movl	$0, %eax
	call	printf@PLT
	subq	$4, %rsp
	movl	$0, -164(%rbp)
	movl	$0, %r8d
	# 1 test_codes/2.sy:60:14
	imull	$1, %r8d
	addl	-164(%rbp), %r8d
	movl	%r8d, -164(%rbp)
	movl	$0, %r8d
	# 1 test_codes/2.sy:60:14
	imull	$6, %r8d
	addl	-164(%rbp), %r8d
	movl	%r8d, -164(%rbp)
	movl	$5, %r9d
	# 1 test_codes/2.sy:60:17
	movl	-164(%rbp), %ebx
	cltq
	leaq	0(, %rbx, 4), %rdx
	leaq	a(%rip), %rbx
	movl	%r9d, (%rdx, %rbx)
	# 1 test_codes/2.sy:60:17
	subq	$4, %rsp
	movl	$0, -168(%rbp)
	movl	$1, %r8d
	# 1 test_codes/2.sy:61:14
	imull	$1, %r8d
	addl	-168(%rbp), %r8d
	movl	%r8d, -168(%rbp)
	movl	$1, %r8d
	# 1 test_codes/2.sy:61:14
	imull	$6, %r8d
	addl	-168(%rbp), %r8d
	movl	%r8d, -168(%rbp)
	movl	$2, %r9d
	# 1 test_codes/2.sy:61:17
	movl	-168(%rbp), %ebx
	cltq
	leaq	0(, %rbx, 4), %rdx
	leaq	a(%rip), %rbx
	movl	%r9d, (%rdx, %rbx)
	# 1 test_codes/2.sy:61:17
	subq	$4, %rsp
	movl	$0, -172(%rbp)
	movl	$0, %r8d
	# 1 test_codes/2.sy:62:20
	imull	$1, %r8d
	addl	-172(%rbp), %r8d
	movl	%r8d, -172(%rbp)
	movl	$0, %r8d
	# 1 test_codes/2.sy:62:20
	imull	$6, %r8d
	addl	-172(%rbp), %r8d
	movl	%r8d, -172(%rbp)
	subq	$4, %rsp
	# align stack
	movl	-172(%rbp), %ebx
	cltq
	leaq	0(, %rbx, 4), %rdx
	leaq	a(%rip), %rbx
	movl	(%rdx, %rbx), %esi
	# 1 test_codes/2.sy:62:20
	leaq	.LC1(%rip), %rdi
	movl	$0, %eax
	call	printf@PLT
	subq	$4, %rsp
	movl	$0, -180(%rbp)
	movl	$1, %r8d
	# 1 test_codes/2.sy:63:20
	imull	$1, %r8d
	addl	-180(%rbp), %r8d
	movl	%r8d, -180(%rbp)
	movl	$1, %r8d
	# 1 test_codes/2.sy:63:20
	imull	$6, %r8d
	addl	-180(%rbp), %r8d
	movl	%r8d, -180(%rbp)
	subq	$12, %rsp
	# align stack
	movl	-180(%rbp), %ebx
	cltq
	leaq	0(, %rbx, 4), %rdx
	leaq	a(%rip), %rbx
	movl	(%rdx, %rbx), %esi
	# 1 test_codes/2.sy:63:20
	leaq	.LC1(%rip), %rdi
	movl	$0, %eax
	call	printf@PLT
	subq	$4, %rsp
	movl	$0, -196(%rbp)
	movl	$1, %r8d
	# 1 test_codes/2.sy:64:19
	imull	$1, %r8d
	addl	-196(%rbp), %r8d
	movl	%r8d, -196(%rbp)
	movl	$1, %r8d
	# 1 test_codes/2.sy:64:19
	imull	$6, %r8d
	addl	-196(%rbp), %r8d
	movl	%r8d, -196(%rbp)
	subq	$12, %rsp
	# align stack
	movl	-196(%rbp), %ebx
	cltq
	leaq	0(, %rbx, 4), %rdx
	leaq	a(%rip), %rbx
	leaq	(%rdx, %rbx), %rsi
	# 1 test_codes/2.sy:64:19
	leaq	.LC0(%rip), %rdi
	movl	$0, %eax
	call	__isoc99_scanf@PLT
	subq	$4, %rsp
	movl	$0, -212(%rbp)
	movl	$1, %r8d
	# 1 test_codes/2.sy:65:20
	imull	$1, %r8d
	addl	-212(%rbp), %r8d
	movl	%r8d, -212(%rbp)
	movl	$1, %r8d
	# 1 test_codes/2.sy:65:20
	imull	$6, %r8d
	addl	-212(%rbp), %r8d
	movl	%r8d, -212(%rbp)
	subq	$12, %rsp
	# align stack
	movl	-212(%rbp), %ebx
	cltq
	leaq	0(, %rbx, 4), %rdx
	leaq	a(%rip), %rbx
	movl	(%rdx, %rbx), %esi
	# 1 test_codes/2.sy:65:20
	leaq	.LC1(%rip), %rdi
	movl	$0, %eax
	call	printf@PLT
	movl	$0, %eax
	# 1 test_codes/2.sy:66:14
	addq	$224, %rsp
	popq	%r9
	popq	%r8
	popq	%rbp
	ret
