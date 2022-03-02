    // intadd function in this file

    .arch armv8-a
    .global intadd

// @param x0: the first integer
// @param x1: the second integer
// @return x3: the sum of x0 and x1
intadd:
   stp    x19, x20, [sp, -16]!
   stp    x21, x22, [sp, -16]!
   stp    x23, x24, [sp, -16]!
   stp    x25, x26, [sp, -16]!
   stp    x27, x28, [sp, -16]!
   stp    x29, x30, [sp, -16]! //Store FP, LR.
   mov x19, x0
   mov x20, x1
   mov x21, #0
loop:
	cmp x20, #0			// Once the second operand is zero, simply return
	beq return

	and x21, x19, x20	// The carry bits for a+b is a&b
	eor x19, x19, x20	// The sum bits for a+b is a^b
	lsl x20, x21, #1	// The carry bits need to be carried over, so shift them right
	b loop
return:
   mov x3, x19
   ldp    x29, x30, [sp], #16
   ldp    x27, x28, [sp], #16
   ldp    x25, x26, [sp], #16
   ldp    x23, x24, [sp], #16
   ldp    x21, x22, [sp], #16
   ldp    x19, x20, [sp], #16
   ret
