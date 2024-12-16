		.eqv	SYS_EXIT, 93
		.eqv	GET_TIME, 30
		.eqv	READ_FLOAT, 6
		.eqv	SLEEP, 32
		.eqv 	SLEEP_TIME, 12		#time representing how long pixel is lit (how fast ball moves on screeen).
		.eqv	AIR_FRICTION, 1024	#reciprocal of the air friction coefficient (inversely proportional to velocity).
		.eqv	COLOR, 0x00FFFFFF	#color is set to white
	
		.data 	
Gravity: 	.float	-9.8
TimeStep:	.float	0.0625
			
		.text	
		.globl _start
		
_start:	
		li	 a7, READ_FLOAT
		ecall
		fmv.s	 ft1, fa0		#Store the initial velocity value in ft1.
		
		li	 t0, COLOR
		lui 	 t3, 0x10040    	#store beginning of heap memory address space.
		mv	 t5, t3
		li	 t2, 32512		#move to bottom-middle of the display.
		add	 t3, t3,t2
		sw	 t0, (t3)		#initialize the ball in the bottom-middle of the screen
		mv 	 t4, t3			#store pixel representing bottom of display in t4.
		addi	 t5, t5, 256		#store pixel representing top of display in t5.
		
update_velocity:				
		li 	 t0, AIR_FRICTION
		fcvt.s.w ft4, t0
		fdiv.s	 ft3, ft1, ft4
		fsub.s	 ft1, ft1, ft3		#calculate the effect of air friction within the current steo.
		
		la	 t0, Gravity
		flw	 ft3, (t0)
		la	 t0, TimeStep		#calculate the effect of gravity within the current step.
		flw	 ft2, (t0)
		fmul.s	 ft2, ft2, ft3
		fadd.s	 ft1, ft1, ft2		#Store the calculated new velocity for the current step.
			
move_ball:
		li	 t2, 512
		fcvt.s.w ft4, zero
		
		li 	 a7, SLEEP		#pause the program for 62 milliseconds (about 1/16 sec).
		li	 a0, SLEEP_TIME
		ecall
		sw	 zero, (t3)		#remove ball from last step.
		
		fcvt.w.s t1, ft1
		bne	 t3, t4, continue
		beqz	 t1, finish		#go to end if ball is at 0 velocity (stationary) and is in sarting position.
		
continue:
		fgt.s	 t1, ft1, ft4
		flt.s	 t0, ft1, ft4
		bnez	 t1, move_up		#move up if velocity is positive.
		bnez	 t0, move_down		#move down if velocity is negative.
		j	 update_velocity	#don't move if velocity is 0.
		
move_up:
		beq	 t3, t5, bounce		#bounce if top of screen is met.
		sub	 t3,t3,t2
		li	 t0, COLOR
		sw	 t0, (t3)		#update upper pixel (relative to current pixel) to color.
		beq	 t3, t5, bounce
		j	 update_velocity

move_down:
		beq	 t3, t4, bounce		#bounce if bottom of screen is met.
		add	 t3,t3,t2
		li	 t0, COLOR
		sw	 t0, (t3)		#update lower pixel (relative to current pixel) to color.
		j	 update_velocity
		
bounce:		
		fneg.s	ft1, ft1		#reverse sign (direction) of velocity when barrier of display is met.
		j update_velocity

finish:
		li	 a7, SYS_EXIT		#close program with return value 0.
		li	 a0, 0
		ecall
