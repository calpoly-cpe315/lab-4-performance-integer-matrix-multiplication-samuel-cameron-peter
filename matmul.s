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
	mov x0, x25				// x0 = i
	mov x1, #1				// x1 = 1
	bl intadd				// x3 = i + 1
	mov x25, x3				// i = i + 1
	cmp x25, x22			// if(i = hA) exit loop
	beq return
i_loop_contents:
	j_loop_init:
		mov x26, #-1				// int j = 0
	j_loop_condition:
		mov x0, x26					// x0 = j
		mov x1, #1					// x1 = 1
		bl intadd					// x3 = j + 1
		mov x26, x3					// j = j + 1
		cmp x26, x24				// if(j = wB) exit loop
		beq i_loop_condition
	j_loop_contents:
		mov x27 #0					// int sum = 0
		k_loop_init:
			mov x28 #-1				// int k = 0
		k_loop_condition:
			mov x0, x28				// x0 = k
			mov x1, #1				// x1 = 1
			bl intadd				// x3 = k + 1
			mov x28, x3				// k = k + 1
			cmp x28, x23			// if(k = wA)
			beq update_result		// exit loop	
		k_loop_contents:
			// x4 = A[i * wA + k]
			mov x0, x22				// x0 = wA
			mov x1, x25				// x1 = i
			bl intmul				// x3 = i * wA
			mov x0, x3				// x0 = i * wA
			mov x1, x28				// x1 = k
			bl intadd				// x3 = i * wA + k
			ldr x4, [x20, x3]		// x4 = A[i * wA + k]

			// x5 = B[k * wB + j]
			mov x0, x21				// x0 = wB
			mov x1, x28				// x1 = k
			bl intmul				// x3 = k * wB
			mov x0, x3				// x0 = k * wB
			mov x1, x26				// x1 = j
			bl intadd				// x3 = k * wB + j
			ldr x5, [x21, x3]		// x4 = B[k * wB + j]

			// x3 = A[i * wA + k] + B[k * wB + j]
			mov x0, x4				// x0 = A[i * wA + k]
			mov x1, x5				// x1 = B[k * wB + j]
			bl intadd				// x3 = A[i * wA + k] + B[k * wB + j]

			// sum += A[i * wA + k] + B[k * wB + j]
			mov x0, x3				// x0 = A[i * wA + k] + B[k * wB + j]
			mov x1, x27				// x1 = sum
			bl intadd				// x3 = sum + A[i * wA + k] + B[k * wB + j]
			mov x27, x3				// sum += A[i * wA + k] + B[k * wB + j]

			b k_loop_condition

		update_result:
			// C[i * wB + j] = sum
			mov x0, x25				// x0 = i
			mov x1, x28				// x1 = wB
			bl intmul				// x3 = i * wB
			mov x0, x3				// x0 = i * wB
			mov x1, x26				// x1 = j
			bl intadd				// x3 = i * wB + j
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
