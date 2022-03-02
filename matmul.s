// Peter Edmonds 2022
	.arch armv8-a
	.global matmul

matmul:
	// Store Callee Saved Registers
	stp x19, x20, [sp, -16]!
	stp x21, x22, [sp, -16]!
	stp x23, x24, [sp, -16]!
	stp x25, x26, [sp, -16]!
	stp x27, x28, [sp, -16]!
	stp x29, x30, [sp, -16]! 
	mov x19, x0					// Result Matrix
	mov x20, x1					// Matrix A
	mov x21, x2					// Matrix B
	mov x22, x3					// Matrix A Height
	mov x23, x4					// Matrix A Width = Matrix A Height
	mov x24, x5					// Matrix B Width
i_loop_init:
	mov x25, #-1				// int i = -1
i_loop_cond:
	mov x0, x25
	mov x1, #1
	bl intadd
	mov x25, x3
	cmp x25, x22				// if(i==hA)
	beq return					// break
	j_loop_init:
		mov x26, #-1			// int j = -1
	j_loop_cond:
		mov x0, x26
		mov x1, #1
		bl intadd
		mov x26, x3
		cmp x26, x24			// if(j==wB)
		beq i_loop_cond			// break
		k_loop_init:
			mov x27, #-1		// int k = -1
			mov x28, #0			// int sum = 0
		k_loop_cond:
			mov x0, x27
			mov x1, #1
			bl intadd
			mov x27, x3
			cmp x27, x23		// if(k==wA)
			beq update_result	// break
		k_loop:

		mov x0, x25
		mov x1, x23
		bl intmul
		mov x0, x3

		mov x1, x27
		bl intadd
		mov x0, x3

		lsl x0, x0, #2		// Double the offset because we are reading int
		ldr x4, [x20, x0]	// x4 = A[i*wA+k]

		mov x0, x27
		mov x1, x24
		bl intmul
		mov x0, x3

		mov x1, x26
		bl intadd
		mov x0, x3

		lsl x0, x0, #2		// Double the offset again
		ldr x5, [x21, x0]	// x5 = B[k * wB + j]

		mov x0, x5
		mov x1, x4
		bl intmul
		mov x4, x3

		mov x0, x28
		mov x1, x4
		bl intadd
		mov x28, x3

		b k_loop_cond
	update_result:
		mov x0, x25
		mov x1, x24
		bl intmul
		mov x0, x3

		mov x1, x26
		bl intadd
		mov x0, x3

		lsl x0, x0, #2		// Double the offset
		str x28, [x19, x0]	// Update result matrix
		b j_loop_cond
return:
	// Restore Callee Saved Registers
	ldp x29, x30, [sp], #16
	ldp x27, x28, [sp], #16
	ldp x25, x26, [sp], #16
	ldp x23, x24, [sp], #16
	ldp x21, x22, [sp], #16
	ldp x19, x20, [sp], #16
	ret
