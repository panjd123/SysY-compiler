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
	.section	.rodata
	.align	4
	.type	M, @object
	.size	M, 4
M:
	.long	4
	.text
	.globl	sum
	.type	main, @function
sum:
	pushq	%rbp
	pushq	%r8
	pushq	%r9
	movq	%rsp, %rbp
	movl	$0, %edi
	# 1 test_codes/5.sy:6:15
	subq	$4, %rsp
	movl	%edi, -4(%rbp)
.L1:
	# enter while
	# enter stmt
.L2:
	# if <
	movl	-4(%rbp), %r8d
	# 2 test_codes/5.sy:7:17
	movl	40(%rbp), %r9d
	# 2 test_codes/5.sy:7:17
	cmpl	%r9d, %r8d
	jl	.L4
	jmp	.L3
.L3:
	# exit while
	addq	$0, %rsp
	jmp	.L10
.L4:
	# enter stmt
	movl	$0, %edi
	# 3 test_codes/5.sy:8:19
	subq	$4, %rsp
	movl	%edi, -8(%rbp)
	movl	$0, %edi
	# 3 test_codes/5.sy:9:21
	subq	$4, %rsp
	movl	%edi, -12(%rbp)
.L5:
	# enter while
	# enter stmt
.L6:
	# if <
	movl	-8(%rbp), %r8d
	# 4 test_codes/5.sy:10:21
	movl	$4, %r9d
	# 4 test_codes/5.sy:10:21
	cmpl	%r9d, %r8d
	jl	.L8
	jmp	.L7
.L7:
	# exit while
	addq	$0, %rsp
	jmp	.L9
.L8:
	# enter stmt
	subq	$4, %rsp
	movl	$0, -16(%rbp)
	movl	-8(%rbp), %r8d
	# 5 test_codes/5.sy:11:33
	imull	$1, %r8d
	addl	-16(%rbp), %r8d
	movl	%r8d, -16(%rbp)
	movl	-4(%rbp), %r8d
	# 5 test_codes/5.sy:11:33
	imull	$4, %r8d
	addl	-16(%rbp), %r8d
	movl	%r8d, -16(%rbp)
	movl	-12(%rbp), %r8d
	# 5 test_codes/5.sy:11:33
	movl	-16(%rbp), %ebx
	cltq
	movq	32(%rbp), %r10
	movl	(%r10, %rbx, 4), %r9d
	# 5 test_codes/5.sy:11:33
	addl	%r9d, %r8d
	subq	$4, %rsp
	movl	%r8d, -20(%rbp)
	movl	-20(%rbp), %r9d
	# 5 test_codes/5.sy:11:33
	movl	%r9d, -12(%rbp)
	# 5 test_codes/5.sy:11:33
	movl	-8(%rbp), %r8d
	# 5 test_codes/5.sy:12:23
	movl	$1, %r9d
	# 5 test_codes/5.sy:12:23
	addl	%r9d, %r8d
	subq	$4, %rsp
	movl	%r8d, -24(%rbp)
	movl	-24(%rbp), %r9d
	# 5 test_codes/5.sy:12:23
	movl	%r9d, -8(%rbp)
	# 5 test_codes/5.sy:12:23
	addq	$12, %rsp
	addq	$0, %rsp
	jmp	.L5
.L9:
	# while end
	subq	$4, %rsp
	# align stack
	movl	-12(%rbp), %esi
	# 3 test_codes/5.sy:14:20
	leaq	.LC1(%rip), %rdi
	movl	$0, %eax
	call	printf@PLT
	movl	-4(%rbp), %r8d
	# 3 test_codes/5.sy:15:19
	movl	$1, %r9d
	# 3 test_codes/5.sy:15:19
	addl	%r9d, %r8d
	subq	$4, %rsp
	movl	%r8d, -20(%rbp)
	movl	-20(%rbp), %r9d
	# 3 test_codes/5.sy:15:19
	movl	%r9d, -4(%rbp)
	# 3 test_codes/5.sy:15:19
	addq	$16, %rsp
	addq	$0, %rsp
	jmp	.L1
.L10:
	# while end
	addq	$4, %rsp
	popq	%r9
	popq	%r8
	popq	%rbp
	ret
	.globl	fill
	.type	main, @function
fill:
	pushq	%rbp
	pushq	%r8
	pushq	%r9
	movq	%rsp, %rbp
	movl	$0, %edi
	# 1 test_codes/5.sy:19:15
	subq	$4, %rsp
	movl	%edi, -4(%rbp)
.L11:
	# enter while
	# enter stmt
.L12:
	# if <
	movl	-4(%rbp), %r8d
	# 2 test_codes/5.sy:20:17
	movl	40(%rbp), %r9d
	# 2 test_codes/5.sy:20:17
	cmpl	%r9d, %r8d
	jl	.L14
	jmp	.L13
.L13:
	# exit while
	addq	$0, %rsp
	jmp	.L20
.L14:
	# enter stmt
	movl	$0, %edi
	# 3 test_codes/5.sy:21:19
	subq	$4, %rsp
	movl	%edi, -8(%rbp)
.L15:
	# enter while
	# enter stmt
.L16:
	# if <
	movl	-8(%rbp), %r8d
	# 4 test_codes/5.sy:22:21
	movl	$4, %r9d
	# 4 test_codes/5.sy:22:21
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
	movl	$0, -12(%rbp)
	movl	-8(%rbp), %r8d
	# 5 test_codes/5.sy:23:22
	imull	$1, %r8d
	addl	-12(%rbp), %r8d
	movl	%r8d, -12(%rbp)
	movl	-4(%rbp), %r8d
	# 5 test_codes/5.sy:23:22
	imull	$4, %r8d
	addl	-12(%rbp), %r8d
	movl	%r8d, -12(%rbp)
	movl	-4(%rbp), %r8d
	# 5 test_codes/5.sy:23:27
	neg %r8d
	subq $4, %rsp
	movl %r8d, -16(%rbp)
	movl	-16(%rbp), %r8d
	# 5 test_codes/5.sy:23:30
	movl	-8(%rbp), %r9d
	# 5 test_codes/5.sy:23:30
	imull	%r8d, %r9d
	subq	$4, %rsp
	movl	%r9d, -20(%rbp)
	movl	-20(%rbp), %r9d
	# 5 test_codes/5.sy:23:30
	movl	-12(%rbp), %ebx
	cltq
	movq	32(%rbp), %r10
	movl	%r9d, (%r10, %rbx, 4)
	# 5 test_codes/5.sy:23:30
	movl	-8(%rbp), %r8d
	# 5 test_codes/5.sy:24:23
	movl	$1, %r9d
	# 5 test_codes/5.sy:24:23
	addl	%r9d, %r8d
	subq	$4, %rsp
	movl	%r8d, -24(%rbp)
	movl	-24(%rbp), %r9d
	# 5 test_codes/5.sy:24:23
	movl	%r9d, -8(%rbp)
	# 5 test_codes/5.sy:24:23
	addq	$16, %rsp
	addq	$0, %rsp
	jmp	.L15
.L19:
	# while end
	movl	-4(%rbp), %r8d
	# 3 test_codes/5.sy:26:19
	movl	$1, %r9d
	# 3 test_codes/5.sy:26:19
	addl	%r9d, %r8d
	subq	$4, %rsp
	movl	%r8d, -12(%rbp)
	movl	-12(%rbp), %r9d
	# 3 test_codes/5.sy:26:19
	movl	%r9d, -4(%rbp)
	# 3 test_codes/5.sy:26:19
	addq	$8, %rsp
	addq	$0, %rsp
	jmp	.L11
.L20:
	# while end
	addq	$4, %rsp
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
	subq	$16, %rsp
	movl	$1, -16(%rbp)
	movl	$2, -12(%rbp)
	movl	$3, -8(%rbp)
	movl	$4, -4(%rbp)
	subq	$96, %rsp
	movl	$1, %edi
	# 1 test_codes/5.sy:34:29
	movl	%edi, -112(%rbp)
	movl	$2, %edi
	# 1 test_codes/5.sy:34:29
	movl	%edi, -108(%rbp)
	movl	$3, %edi
	# 1 test_codes/5.sy:34:29
	movl	%edi, -104(%rbp)
	movl	$4, %edi
	# 1 test_codes/5.sy:34:29
	movl	%edi, -100(%rbp)
	movl	$2, %edi
	# 1 test_codes/5.sy:34:29
	movl	%edi, -96(%rbp)
	movl	$4, %edi
	# 1 test_codes/5.sy:34:29
	movl	%edi, -92(%rbp)
	movl	$6, %edi
	# 1 test_codes/5.sy:34:29
	movl	%edi, -88(%rbp)
	movl	$8, %edi
	# 1 test_codes/5.sy:34:29
	movl	%edi, -84(%rbp)
	movl	$3, %edi
	# 1 test_codes/5.sy:34:29
	movl	%edi, -80(%rbp)
	movl	$6, %edi
	# 1 test_codes/5.sy:34:29
	movl	%edi, -76(%rbp)
	movl	$9, %edi
	# 1 test_codes/5.sy:34:29
	movl	%edi, -72(%rbp)
	movl	$12, %edi
	# 1 test_codes/5.sy:34:29
	movl	%edi, -68(%rbp)
	movl	$-1, %edi
	# 1 test_codes/5.sy:34:29
	movl	%edi, -64(%rbp)
	movl	$0, -60(%rbp)
	movl	$0, -56(%rbp)
	movl	$0, -52(%rbp)
	movl	$0, -48(%rbp)
	movl	$0, -44(%rbp)
	movl	$0, -40(%rbp)
	movl	$0, -36(%rbp)
	movl	$0, -32(%rbp)
	movl	$0, -28(%rbp)
	movl	$0, -24(%rbp)
	movl	$0, -20(%rbp)
	subq	$4, %rsp
	movl	$0, -116(%rbp)
	movl	$0, %r8d
	# 1 test_codes/5.sy:35:14
	imull	$12, %r8d
	addl	-116(%rbp), %r8d
	movl	%r8d, -116(%rbp)
	subq	$12, %rsp
	# align stack
	movl	$3, %r8d
	# 1 test_codes/5.sy:35:17
	subq	$4, %rsp
	movl	%r8d, -132(%rbp)
	movl	-116(%rbp), %ebx
	cltq
	leaq	-112(%rbp, %rbx, 4), %r8
	# 1 test_codes/5.sy:35:17
	subq	$8, %rsp
	movq	%r8, -140(%rbp)
	call	sum
	subq	$4, %rsp
	movl	%eax, -144(%rbp)
	subq	$4, %rsp
	movl	$0, -148(%rbp)
	movl	$1, %r8d
	# 1 test_codes/5.sy:36:14
	imull	$12, %r8d
	addl	-148(%rbp), %r8d
	movl	%r8d, -148(%rbp)
	subq	$12, %rsp
	# align stack
	movl	$3, %r8d
	# 1 test_codes/5.sy:36:17
	subq	$4, %rsp
	movl	%r8d, -164(%rbp)
	movl	-148(%rbp), %ebx
	cltq
	leaq	-112(%rbp, %rbx, 4), %r8
	# 1 test_codes/5.sy:36:17
	subq	$8, %rsp
	movq	%r8, -172(%rbp)
	call	sum
	subq	$4, %rsp
	movl	%eax, -176(%rbp)
	subq	$4, %rsp
	movl	$0, -180(%rbp)
	movl	$1, %r8d
	# 1 test_codes/5.sy:37:15
	imull	$12, %r8d
	addl	-180(%rbp), %r8d
	movl	%r8d, -180(%rbp)
	subq	$12, %rsp
	# align stack
	movl	$3, %r8d
	# 1 test_codes/5.sy:37:18
	subq	$4, %rsp
	movl	%r8d, -196(%rbp)
	movl	-180(%rbp), %ebx
	cltq
	leaq	-112(%rbp, %rbx, 4), %r8
	# 1 test_codes/5.sy:37:18
	subq	$8, %rsp
	movq	%r8, -204(%rbp)
	call	fill
	subq	$4, %rsp
	movl	$0, -208(%rbp)
	movl	$1, %r8d
	# 1 test_codes/5.sy:38:14
	imull	$12, %r8d
	addl	-208(%rbp), %r8d
	movl	%r8d, -208(%rbp)
	movl	$3, %r8d
	# 1 test_codes/5.sy:38:17
	subq	$4, %rsp
	movl	%r8d, -212(%rbp)
	movl	-208(%rbp), %ebx
	cltq
	leaq	-112(%rbp, %rbx, 4), %r8
	# 1 test_codes/5.sy:38:17
	subq	$8, %rsp
	movq	%r8, -220(%rbp)
	call	sum
	subq	$4, %rsp
	movl	%eax, -224(%rbp)
	addq	$224, %rsp
	popq	%r9
	popq	%r8
	popq	%rbp
	ret
