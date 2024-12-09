		.eqv 	ts, 0.0625
		.eqv	SYS_EXIT, 93
		.eqv	GET_TIME, 30
		.eqv	READ_FLOAT, 6
	
		.data 	
gravity: 	.word	-9.8
			
		.text	
		
		.globl _start
_start:
		li 	a7, GET_TIME
			ecall
		fmv.w.x	ft0, a0		#Store the time at the start of the program in ft0.
	
		li	a7, READ_FLOAT
		ecall
		fmv.s	ft1, fa0	#Store the initial velocity value in ft1.
		
			
update_velocity:
		li 	a7, GET_TIME
		ecall
		fmv.w.x ft2, a0		
		fsub.s  ft0,ft0,ft2	
		li	t0, 1000
		fmv.s.x ft3, t0
		fdiv.s 	ft0, ft0, ft3	#Store the time since the last time-step in ft0.
		
		fmv.s 	ft2, ft1
		srai	ft2, ft2, 10	
		fsub.s	ft1, ft1, ft2	#Store the velocity decrement in ft2
		
		flw	ft3, gravity
		fmul.s	ft0, ft0, ft3
		fadd.s	ft1, ft1, ft0	#Store the calculated new velocity for the current step.
			
move_ball:
		

	
finish:
		li	a7, SYS_EXIT
		li	a0, 0
		ecall