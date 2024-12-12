		.eqv 	ts, 0.0625
		.eqv	SYS_EXIT, 93
		.eqv	GET_TIME, 30
		.eqv	READ_FLOAT, 6
		.eqv	HEAP_MEM, 9
		.eqv	white_color, 0x00FFFFFF
		.eqv	DISPLAY_SIZE, 16384
	
		.data 	
gravity: 	.word	0xc11ccccd
			
		.text	
		
		.globl _start
_start:
		li 	a7, GET_TIME
			ecall
		fmv.w.x	ft0, a0		#Store the time at the start of the program in ft0.
	
		li	a7, READ_FLOAT
		ecall
		fmv.s	ft1, fa0	#Store the initial velocity value in ft1.
		
		li 	a7, 9
		li	a0, DISPLAY_SIZE
		ecall
		mv	s0, a0
		
			
update_velocity:
		li 	a7, GET_TIME
		ecall
		fmv.w.x ft2, a0		
		fsub.s  ft0,ft0,ft2	
		li	t0, 1000
		fmv.s.x ft3, t0
		fdiv.s 	ft0, ft0, ft3	#Store the time since the last time-step in ft0.
		
		fmv.x.s t0, ft1
		srai	t0, t0, 10	
		fmv.s.x ft2, t0
		fsub.s	ft1, ft1, ft2	#Store the velocity decrement in ft2
		
		
		la	t0, gravity
		flw	ft3, (t0)
		fmul.s	ft0, ft0, ft3
		fadd.s	ft1, ft1, ft0	#Store the calculated new velocity for the current step.
			
move_ball:
		li	t0, white_color
		lui 	t1, 0x10040       # Load the upper 20 bits (0x10020 << 12 = 0x10020000)
		sw	t0, (t1)

finish:
		li	a7, SYS_EXIT
		li	a0, 0
		ecall
