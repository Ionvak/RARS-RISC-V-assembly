		.eqv	SYS_EXIT, 93
		.eqv	GET_TIME, 30
		.eqv	READ_FLOAT, 6
		.eqv	HEAP_MEM, 9
		.eqv	SLEEP, 32
		.eqv	white_color, 0x00FFFFFF
		.eqv	DISPLAY_SIZE, 16384
	
		.data 	
gravity: 	.float	-9.8
time_step:	.float	0.0625
			
		.text	
		.globl _start
		
_start:	
		li	 a7, READ_FLOAT
		ecall
		fmv.s	 ft1, fa0		#Store the initial velocity value in ft1.
		
		li 	 a7, HEAP_MEM
		li	 a0, DISPLAY_SIZE
		ecall
		mv	 s0, a0
		
		li	 t0, white_color
		lui 	 t3, 0x10040    	#store beginning of heap memory address space.
		mv	 t5, t3
		li	 t2, 32512		#move to bottom-middle of the display.
		add	 t3, t3,t2
		sw	 t0, (t3)		#initialize the ball in the bottom-middle of the screen
		mv 	 t4, t3			#store pixel representing bottom of display in t4.
		addi	 t5, t5, 256		#store pixel representing top of display in t5.
		
update_velocity:				
		li 	 t0, 1024
		fcvt.s.w ft4, t0
		fdiv.s	 ft3, ft1, ft4
		fsub.s	 ft1, ft1, ft3		#Store the velocity decrement in ft2
		
		la	 t0, gravity
		flw	 ft3, (t0)
		la	 t0, time_step
		flw	 ft2, (t0)
		fmul.s	 ft2, ft2, ft3
		fadd.s	 ft1, ft1, ft2		#Store the calculated new velocity for the current step.
		
		li	 a7, 2			#PRINTING FOR TESTING (REMOVE THIS).
		fmv.s	 fa0, ft1
		ecall
			
move_ball:
		li	 t2, 512
		fcvt.s.w ft4, zero
		sw	 zero, (t3)		#remove ball from last step.
		
		fcvt.w.s t1, ft1
		bne	 t3, t4, continue
		beqz	 t1, finish		#go to end if ball is at 0 velocity (stationary) and is in sarting position.
		
continue:	li 	 a7, SLEEP
		li	 a0, 62
		ecall
		
		fgt.s	 t1, ft1, ft4
		flt.s	 t0, ft1, ft4
		bnez	 t1, move_up		#move up if velocity is positive.
		bnez	 t0, move_down		#move down if velocity is negative.
		j	 update_velocity	#don't move if velocity is 0.
		
move_up:
		beq	 t3, t5, bounce
		sub	 t3,t3,t2
		li	 t0, white_color
		sw	 t0, (t3)
		beq	 t3, t5, bounce
		j	 update_velocity

move_down:
		beq	 t3, t4, bounce
		add	 t3,t3,t2
		li	 t0, white_color
		sw	 t0, (t3)
		j	 update_velocity
		
bounce:		
		fneg.s	ft1, ft1
		j update_velocity

finish:
		li	 a7, SYS_EXIT
		li	 a0, 0
		ecall
