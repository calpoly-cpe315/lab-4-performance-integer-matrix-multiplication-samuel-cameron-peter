.arch armv8-a
.global intmul

// @param x0: the first integer
// @param x1: the second integer
// @return x3: the product of x0 and x1
intmul:
	stp    x19, x20, [sp, -16]!
	stp    x21, x22, [sp, -16]!
	stp    x23, x24, [sp, -16]!
	stp    x25, x26, [sp, -16]!
	stp    x27, x28, [sp, -16]!
	stp    x29, x30, [sp, -16]! //Store FP, LR.
	mov x19, x0		// First integer
	mov x20, x1		// Second integer
	mov x21, #0		// Result
	mov x22, #1		// tmp used for storing operations
	mov x23, #64	// intialize counter to 64, we will loop over each bit
loop:
	// while(counter != 0)
	cmp x23, #0		
	b.eq return

	// counter--
	mov x0, x23
	mov x1, #1
	bl intsub
	mov x23, x3

	and x22, x20, #1
	cmp x22, #1
	b.ne even
	// if b%1 == 1, res  = res + a
	mov x0, x19
	mov x1, x21
	bl intadd
	mov x21, x3
even:
	// a << 1
	lsl x19, x19, #1
	// b >> 1
	lsr x20, x20, #1
	b loop
return:
	mov x3, x21
	ldp    x29, x30, [sp], #16
	ldp    x27, x28, [sp], #16
	ldp    x25, x26, [sp], #16
	ldp    x23, x24, [sp], #16
	ldp    x21, x22, [sp], #16
	ldp    x19, x20, [sp], #16
	ret

