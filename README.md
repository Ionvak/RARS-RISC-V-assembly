# RARS RISC-V Assembly project
**This project was done as part of the Computer Architecture course offered by the warsaw university of technology in the winter semester of 2024.**

Display a trajectory of a ball with initial vertical speed provided by the
user. Assume gravity acceleration 9.8 m/s2, no energy loss during bouncing, 
time step 1/16th of a second, and the loss of 1/1024 velocity in each
1/16th of a second due to the air resistance. Use RARS bitmap display
to show the trajectory.

This project was done using the RARS computer simulator. The code is written in RISC-V assembly. The display settings are assumed to be: 
height in pixels: 4
length in pixels: 4
heap base address for first pixel.
display is 256x512 (hxw).
