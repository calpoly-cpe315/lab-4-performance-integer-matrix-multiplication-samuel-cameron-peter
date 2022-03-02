////////////////////////////////////////////////////////////////////////////////
// You're implementing the following function in ARM Assembly
//! C = A * B
//! @param C          result matrix
//! @param A          matrix A 
//! @param B          matrix B
//! @param hA         height of matrix A
//! @param wA         width of matrix A, height of matrix B
//! @param wB         width of matrix B
//
//  Note that while A, B, and C represent two-dimensional matrices,
//  they have all been allocated linearly. This means that the elements
//  in each row are sequential in memory, and that the first element
//  of the second row immedialely follows the last element in the first
//  row, etc. 
//
//void matmul(int* C, const int* A, const int* B, unsigned int hA, 
//    unsigned int wA, unsigned int wB)
//{
//  for (unsigned int i = 0; i < hA; ++i)
//    for (unsigned int j = 0; j < wB; ++j) {
//      int sum = 0;
//      for (unsigned int k = 0; k < wA; ++k) {
//        sum += A[i * wA + k] * B[k * wB + j];
//      }
//      C[i * wB + j] = sum;
//    }
//}
////////////////////////////////////////////////////////////////////////////////

	.arch armv8-a
	.global matmul
matmul:
	// Store Callee-Saved Registers
	stp x19, x20, [sp, -16]!
	stp x21, x22, [sp, -16]!
	stp x23, x24, [sp, -16]!
	stp x25, x26, [sp, -16]!
	stp x27, x28, [sp, -16]!
	stp x29, x30, [sp, -16]! 
	mov x19, x0		// Result Matrix
	mov x20, x1		// Matrix A
	mov x21, x2		// Matrix B
	mov x22, x3		// Matrix A Height
	mov x23, x4		// Matrix A Width = Matrix A Height
	mov x24, x5		// Matrix B Width
	// The resulting matrix will have dimension x2,x5
i_loop_init:			
	mov x25, #-1			// int i = -1
i_loop_condition:
	add x25, x25, #1
	cmp x25, x22			// if(i = hA) exit loop
	beq return
i_loop_contents:
	j_loop_init:
		mov x26, #-1				// int j = 0
	j_loop_condition:
		add x26, x26, #1
		cmp x26, x24				// if(j = wB) exit loop
		beq i_loop_condition
	j_loop_contents:
		mov x27, #0					// int sum = 0
		k_loop_init:
			mov x28, #-1				// int k = 0
		k_loop_condition:
			add x28, x28, #1
			cmp x28, x23			// if(k = wA)
			beq update_result		// exit loop	
		k_loop_contents:
			// x4 = A[i * wA + k]
			mla v3, x23, x25, x28
			ldrb w4, [x20, x3]		// x4 = A[i * wA + k]

			// x5 = B[k * wB + j]
			mla x3, x24, x28, x26
			ldrb w5, [x21, x3]		// x4 = B[k * wB + j]

			// x3 = A[i * wA + k] + B[k * wB + j]
			add x3, x4, x5

			// sum += A[i * wA + k] + B[k * wB + j]
			add x3, x3, x27
			mov x27, x3				// sum += A[i * wA + k] + B[k * wB + j]

			b k_loop_condition

		update_result:
			// C[i * wB + j] = sum
			mla x3, x25, x24, x26
			lsl x3, x3, #2			//
			str x27, [x19, x3]		// C[i * wB + j] = sum

			b j_loop_condition
	
return:
	// Restore Callee-Saved Registers
	ldp x29, x30, [sp], #16
	ldp x27, x28, [sp], #16
	ldp x25, x26, [sp], #16
	ldp x23, x24, [sp], #16
	ldp x21, x22, [sp], #16
	ldp x19, x20, [sp], #16
	ret
