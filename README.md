# DLA-using-R
Recreate the process of Diffusion Limited aggreagtion to create structures like this:

![Example](https://github.com/sshourie/DLA-using-R/blob/master/Diffusion%20Limited%20aggregation.png)

## Detailed Problem statement:

### Introduction
- This problem is based on the Diffusion Limited Aggregation (DLA) model as described on this [page](https://paulbourke.net/fractals/dla/).
- Here is an excerpt from the above page, describing the model:
  - "start with a white image except for a single black pixel in the center. New points are introduced at the borders and randomly (approximation of Brownian motion) walk until they are close enough to stick to an existing   black pixel. A typical example of this is shown below in figure 1. If a point, during its random walk, approaches an edge of the image there are two strategies. The point either bounces off the edge or the image is toroidally bound (a point moving off the left edge enters on the right, a point moving off the right edge enters on the left, similarly for top and bottom). In general new points can be seeded anywhere in the image area, not just around the border without any significant visual difference."
- Here is a more precise statement of the above description:
  - Start with a M x M matrix, with all entries as 0 (representing "empty") except for the center cell of the matrix which has a 1 (representing "occupied with a particle").
  - Choose a cell randomly along the border of the matrix (i.e, along one of its 4 edges), and fill it with a 1. This represents introducing a new particle at the edge of the arena.
  - Make this particle do a 2D random walk in the empty region of the matrix. In other words, at every iteration, randomly select an empty neighboring cell, and move the particle there, leaving the old cell empty.
  - Continue the random walk until the particle encounters another particle in an adjacent cell.
  - The random walk now stops, and the particle remains stuck here forever.
  - Repeat the above procedure (introducing new particles, random walk, sticking to existing particles) for N particles.
  - To be clear, only 1 particle does a random walk at a time, and a new one is not introduced until the previous one has found a place to stick to.
- Refer to figure 1 on the above page to see an example of what the output of such a simulation looks like.
- Next, refer to the definition of "stickiness" as given just above Figure 6.
- Refer to Figures 6, 7 and 8 to see the effect of varying stickiness.

### The task
- Write code in a language of your choice to simulate DLA for a given value of stickiness. Use a matrix (or "image", as per the above websites language) of at least 500x500 cells (or "pixels"), and at least 50,000 particles to run your DLA simulations. 
- Propose an algorithm to estimate the "stickiness" parameter with which a given DLA output was generated.
- Extra points if you can support your algorithm with data gathered from your DLA simulations.
Note that the accuracy/robustness of your algorithm is not important. What is important is that your approach seems intuitively correct, and worth exploring.

### Further clarification

Here is the task of stickiness estimation:
- Assume you don't have access to the program that generated the output. All you are given is the output of a given DLA run using N particles some stickiness k. You have not been given the value of N or k. Estimate k just by analyzing the output that is given to you. The output consists of a 1001x1001 matrix of 0's and 1's, that you know has been generated using DLA.
For simplicity, assume that k can only take values between 1e-3 and 5e-2.
- It will be very interesting to see any analysis that you do on DLA outputs to show that the approaches you suggest would work, or not work. To reiterate: it is perfectly fine if the approach(es) you suggest end up being not effective, but it would be very interesting to see any analysis/evidence you can show that tells us how effective your approach is.
