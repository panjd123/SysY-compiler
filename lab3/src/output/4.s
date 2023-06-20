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
	subq	$144, %rsp
	movl	$1, %edi
	# 1 test_codes/4.sy:3:15
	subq	$4, %rsp
	movl	%edi, -148(%rbp)
	movl	$1, %edi
	# 1 test_codes/4.sy:3:22
	subq	$4, %rsp
	movl	%edi, -152(%rbp)
.L1:
	# enter while
	# enter stmt
.L2:
	# if <
	movl	-148(%rbp), %r8d
	# 2 test_codes/4.sy:4:20
	movl	$5, %r9d
	# 2 test_codes/4.sy:4:20
	cmpl	%r9d, %r8d
	jl	.L3
	jmp	.L4
.L3:
	# if <
	movl	-152(%rbp), %r8d
	# 2 test_codes/4.sy:4:27
	movl	$5, %r9d
	# 2 test_codes/4.sy:4:27
	cmpl	%r9d, %r8d
	jl	.L5
	jmp	.L4
.L4:
	# exit while
	addq	$0, %rsp
	jmp	.L6
.L5:
	# enter stmt
	subq	$4, %rsp
	movl	$0, -156(%rbp)
	movl	-152(%rbp), %r8d
	# 3 test_codes/4.sy:5:18
	imull	$1, %r8d
	addl	-156(%rbp), %r8d
	movl	%r8d, -156(%rbp)
	movl	-148(%rbp), %r8d
	# 3 test_codes/4.sy:5:18
	imull	$6, %r8d
	addl	-156(%rbp), %r8d
	movl	%r8d, -156(%rbp)
	movl	-148(%rbp), %r8d
	# 3 test_codes/4.sy:5:25
	movl	-152(%rbp), %r9d
	# 3 test_codes/4.sy:5:25
	addl	%r9d, %r8d
	subq	$4, %rsp
	movl	%r8d, -160(%rbp)
	movl	-160(%rbp), %r9d
	# 3 test_codes/4.sy:5:25
	movl	-156(%rbp), %ebx
	cltq
	movl	%r9d, -144(%rbp, %rbx, 4)
	# 3 test_codes/4.sy:5:25
	movl	-152(%rbp), %r8d
	# 3 test_codes/4.sy:6:19
	movl	$1, %r9d
	# 3 test_codes/4.sy:6:19
	addl	%r9d, %r8d
	subq	$4, %rsp
	movl	%r8d, -164(%rbp)
	movl	-164(%rbp), %r9d
	# 3 test_codes/4.sy:6:19
	movl	%r9d, -152(%rbp)
	# 3 test_codes/4.sy:6:19
	addq	$12, %rsp
	addq	$0, %rsp
	jmp	.L1
.L6:
	# while end
.L7:
	# enter while
	# enter stmt
.L8:
	# if <
	movl	-148(%rbp), %r8d
	# 2 test_codes/4.sy:8:20
	movl	$5, %r9d
	# 2 test_codes/4.sy:8:20
	cmpl	%r9d, %r8d
	jl	.L9
	jmp	.L10
.L9:
	# if <
	movl	-152(%rbp), %r8d
	# 2 test_codes/4.sy:8:27
	movl	$6, %r9d
	# 2 test_codes/4.sy:8:27
	cmpl	%r9d, %r8d
	jl	.L11
	jmp	.L10
.L10:
	# exit while
	addq	$0, %rsp
	jmp	.L12
.L11:
	# enter stmt
	subq	$4, %rsp
	movl	$0, -156(%rbp)
	movl	-152(%rbp), %r8d
	# 3 test_codes/4.sy:9:18
	imull	$1, %r8d
	addl	-156(%rbp), %r8d
	movl	%r8d, -156(%rbp)
	movl	-148(%rbp), %r8d
	# 3 test_codes/4.sy:9:18
	imull	$6, %r8d
	addl	-156(%rbp), %r8d
	movl	%r8d, -156(%rbp)
	movl	-148(%rbp), %r8d
	# 3 test_codes/4.sy:9:25
	movl	-152(%rbp), %r9d
	# 3 test_codes/4.sy:9:25
	subl	%r9d, %r8d
	subq	$4, %rsp
	movl	%r8d, -160(%rbp)
	movl	-160(%rbp), %r9d
	# 3 test_codes/4.sy:9:25
	movl	-156(%rbp), %ebx
	cltq
	movl	%r9d, -144(%rbp, %rbx, 4)
	# 3 test_codes/4.sy:9:25
	movl	-148(%rbp), %r8d
	# 3 test_codes/4.sy:10:19
	movl	$1, %r9d
	# 3 test_codes/4.sy:10:19
	addl	%r9d, %r8d
	subq	$4, %rsp
	movl	%r8d, -164(%rbp)
	movl	-164(%rbp), %r9d
	# 3 test_codes/4.sy:10:19
	movl	%r9d, -148(%rbp)
	# 3 test_codes/4.sy:10:19
	addq	$12, %rsp
	addq	$0, %rsp
	jmp	.L7
.L12:
	# while end
	subq	$4, %rsp
	movl	$0, -156(%rbp)
	movl	$1, %r8d
	# 1 test_codes/4.sy:12:21
	imull	$1, %r8d
	addl	-156(%rbp), %r8d
	movl	%r8d, -156(%rbp)
	movl	$1, %r8d
	# 1 test_codes/4.sy:12:21
	imull	$6, %r8d
	addl	-156(%rbp), %r8d
	movl	%r8d, -156(%rbp)
	subq	$4, %rsp
	movl	$0, -160(%rbp)
	movl	$4, %r8d
	# 1 test_codes/4.sy:12:31
	imull	$1, %r8d
	addl	-160(%rbp), %r8d
	movl	%r8d, -160(%rbp)
	movl	$1, %r8d
	# 1 test_codes/4.sy:12:31
	imull	$6, %r8d
	addl	-160(%rbp), %r8d
	movl	%r8d, -160(%rbp)
	movl	-156(%rbp), %ebx
	cltq
	movl	-144(%rbp, %rbx, 4), %r8d
	# 1 test_codes/4.sy:12:31
	movl	-160(%rbp), %ebx
	cltq
	movl	-144(%rbp, %rbx, 4), %r9d
	# 1 test_codes/4.sy:12:31
	addl	%r9d, %r8d
	subq	$4, %rsp
	movl	%r8d, -164(%rbp)
	subq	$4, %rsp
	movl	$0, -168(%rbp)
	movl	$5, %r8d
	# 1 test_codes/4.sy:12:40
	imull	$1, %r8d
	addl	-168(%rbp), %r8d
	movl	%r8d, -168(%rbp)
	movl	$4, %r8d
	# 1 test_codes/4.sy:12:40
	imull	$6, %r8d
	addl	-168(%rbp), %r8d
	movl	%r8d, -168(%rbp)
	movl	-164(%rbp), %r8d
	# 1 test_codes/4.sy:12:40
	movl	-168(%rbp), %ebx
	cltq
	movl	-144(%rbp, %rbx, 4), %r9d
	# 1 test_codes/4.sy:12:40
	addl	%r9d, %r8d
	subq	$4, %rsp
	movl	%r8d, -172(%rbp)
	subq	$4, %rsp
	# align stack
	movl	-172(%rbp), %esi
	# 1 test_codes/4.sy:12:40
	leaq	.LC1(%rip), %rdi
	movl	$0, %eax
	call	printf@PLT
	addq	$176, %rsp
	popq	%r9
	popq	%r8
	popq	%rbp
	ret
