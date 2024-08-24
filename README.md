# ROUTER 1X3

![Screenshot 2024-08-24 110639](https://github.com/user-attachments/assets/3274eaaf-2d43-407e-ab5c-1e0edfd2a76d)

# RTL design and implementation of Pouter1x3
 A 1X3 Router takes in one input and directs it to one of the three possible outputs. Usually used 
 for inter network commuication, example communication between 2 different LAN's or WAN's.
 This RTL contains of four main blocks 
 * FSM (controller)
 * Register
 * Synchronizer
 * Fifo_0, Fifo_1,Fifo_2

</details><details>
<summary>  Synchronizer
</summary>
Function: A synchronizer is used to manage the transition of data between different clock 
 domains. This is crucial in designs where different parts of the system operate on different 
 clocks.
Placement: The synchronizer would be placed between the FIFO and the routing logic to ensure 
 that data is safely transferred between the input and the output paths.

</details><details>
<summary>  FIFO
</summary>
Function: FIFO buffers are used to temporarily store data. In a router, they can be used to 
 handle bursts of data or to synchronize data transfers between components operating at 
 different clock speeds.
Placement: In the 1x3 router design, you might have a FIFO at the input to buffer incoming 
 data and possibly another FIFO before each output channel to buffer outgoing data.

</details><details>
<summary>  FSM
</summary>






</details><details>
<summary>  Refister
</summary>
