	.code


	;; TODO: test the 'add' instruction
	;; ...
	set r0, 7
	set r1, 5
	nop
	nop
	add r2, r0, r1
	nop
	nop
	out 0x11,r2 ; 10 + 5
	nop
	nop

	set r0, 12
	set r1, -5
	nop
	nop
	add r0, r1
	nop
	nop
	out 0x11,r0 ; 10 + (-5)
	nop
	nop
	set r0, -10
	set r1, -5
	nop
	nop
	add r0, r1
	nop
	nop
	out 0x11,r0 ; (-10) + (-5)
	nop
	nop
	set r0, 5
	set r1, -10
	nop
	nop
	add r0, r1
	out 0x11,r0 ; 5 + (-10)
	nop
	nop
	set r0, 0x7fff
	set r1, 1
	nop
	nop
	add r0, r1
	nop
	nop
	out 0x11,r0 ; max + 1 = min
	nop
	nop
	set r0, 0x8000
	set r1, -1
	nop
	nop
	add r0, r1
	nop
	nop
	out 0x11,r0 ; min + (-1) = max
	nop
	nop
	;; TODO: test the 'addc' instruction
	;; ...
	set r0, 32
	set r1, 4
	nop
	nop
	addc r0, r1
	nop
	move r0,fl0		; read flags register
	nop
	nop
	out 0x11,r0
	nop
	nop
	set r0, 0x7fff
	set r1, 0x7fff
	nop
	nop
	addc r0, r1
	nop
	nop
	move r0,fl0		; read flags register
	nop
	nop
	out 0x11,r0

	set r0, 0x8000
	set r1, 0x8000
	nop
	nop
	addc r0, r1
	nop
	nop
	move r0,fl0		; read flags register
	nop
	nop
	out 0x11,r0
	nop
	nop

	;; TODO: test the 'sub' instruction
	;; ...
	set r0, 10
	set r1, 5
	nop
	nop
	sub r0, r1
	nop
	nop
	out 0x11,r0 ; 10 - 5
	nop
	nop

	set r0, 10
	set r1, -5
	nop
	nop
	sub r0, r1
	nop
	nop
	out 0x11,r0 ; 10 - (-5)
	nop
	nop

	set r0, -10
	set r1, -5
	nop
	nop
	sub r0, r1
	nop
	nop
	out 0x11,r0 ; (-10) - (-5)
	nop
	nop
	set r0, 5
	set r1, -10
	nop
	nop	
	sub r0, r1
	nop
	nop
	out 0x11,r0 ; 5 - (-10)
	nop
	nop
	set r0, 0x7fff
	set r1, -1
	nop
	nop
	sub r0, r1
	nop
	nop
	out 0x11,r0 ; max - (-1) = 0
	nop
	nop
	set r0, 0x8000
	set r1, 1
	nop
	nop
	sub r0, r1
	nop
	nop
	out 0x11,r0 ; min - 1 = max
	nop
	nop
	;; TODO: test the 'subc' instruction
	;; ...
	set r0, 32
	set r1, 4
	nop
	nop
	subc r0, r1
	nop
	move r0,fl0		; read flags register
	nop
	nop
	out 0x11,r0
	nop
	nop
	set r0, 0x8000
	set r1, 0x7fff
	nop
	nop
	subc r0, r1
	nop
	nop
	move r0,fl0		; read flags register
	nop
	nop
	out 0x11,r0

	set r0, 0x8000
	set r1, 1
	nop
	nop
	subc r0, r1
	nop
	nop
	move r0,fl0		; read flags register
	nop
	nop
	out 0x11,r0
	nop
	nop

	;; TODO: test the 'abs' instruction
	;; ...
	set r1, 5
	nop
	nop
	abs r0, r1
	nop
	nop
	out 0x11,r0 ; abs(5) = 5
	nop
	nop
	set r1, -5
	nop
	nop
	abs r0, r1
	nop
	nop
	out 0x11,r0 ; abs(-5) = 5
	nop
	nop

	set r1, 0
	nop
	nop	
	abs r0, r1
	nop
	nop
	out 0x11,r0 ; abs(0) = 0
	nop
	nop

	set r1, 0x7fff
	nop
	nop
	abs r0, r1
	nop
	nop
	out 0x11,r0 ; abs(max) = max
	nop
	nop

	set r1, 0x8000
	nop
	nop	
	abs r0, r1
	nop
	nop
	out 0x11,r0 ; abs(min) = max
	nop
	nop

	set r1, 0x8001
	nop
	nop
	abs r0, r1
	nop
	nop
	out 0x11,r0 ; abs(min-1) = max
	nop
	nop

	;; TODO: test the 'cmp' instruction
	set	r0,4
	set	r1,2485
	nop
	nop
	cmp	r0,r1
	nop
	nop
	move	r0,fl0		; read flags register
	nop
	nop
	out	0x11,r0
	nop
	nop

	set	r0,46
	set	r1,46
	nop
	nop
	cmp	r0,r1
	nop
	nop
	move	r0,fl0		; read flags register
	nop
	nop
	out	0x11,r0
	nop
	nop

	set	r0,0x8000
	set	r1,0
	nop
	nop
	cmp	r0,r1
	nop
	nop
	move	r0,fl0		; read flags register
	nop
	nop
	out	0x11,r0
	nop
	nop
	;; ...


	;; TODO: test the 'min' and 'max' instructions
	;; ...
	set r0, 13
	set r1, 14
	nop
	nop
	max r2, r0, r1
	nop
	nop
	out 0x11,r2 ; max(13,14) = 14
	nop
	nop
	min r2, r0, r1
	nop
	nop
	out 0x11,r2 ; min(13,14) = 13
	nop
	nop

	set r0, 0x8000
	set r1, 0x7fff
	nop
	nop
	max r2, r0, r1
	nop
	nop
	out 0x11,r2 ; max(min,max) = max
	nop
	nop
	min r2, r0, r1
	nop
	nop
	out 0x11,r2 ; min(min,max) = min
	nop
	nop

	;; terminate simulation
	out	0x12,r0
	nop
