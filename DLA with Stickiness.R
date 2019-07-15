###minor biasing in the random_walk function
###using a matrix instead of a data_frame
rm(list=ls())
library(tidyr)
library(ggplot2)
library(dplyr)

# Square Matrix's dimensions
dim_matrix <- 500

#Number of particles 
num_particles <-  50000
stickiness <- 0.5

#Initializing the matrix with center cell occupied
center_cell <- if_else(dim_matrix  %% 2 ==0, dim_matrix/2, (dim_matrix+1 )/2 )
df_image <-  matrix(data = center_cell, nrow = num_particles+1, ncol =2)

prob_list <- list( c(1/8,1/8,1/8,1/8,1/8,1/8,1/8,.11), c(1/8,1/8,1/8,1/8,.11,1/8,1/8,1/8), c(1/8,1/8,1/8,1/8,1/8,1/8,.11,1/8),c(1/8,1/8,1/8,.11,1/8,1/8,1/8,1/8))

random_walker <-  function(){
  # Choose a coordinate along the boundary of the M*M square. This is where a particle will be introduced
  rand_row <- sample(1:dim_matrix,1, prob =c(0.25, rep.int(0.5/(dim_matrix-2) , dim_matrix-2)  ,0.25))
  rand_col <- if_else( 
    rand_row ==1 | rand_row ==dim_matrix,
    as.integer(sample(1:dim_matrix,1))  ,
    as.integer(sample(c(1,dim_matrix),1))
  )
  return(c(rand_row, rand_col))
}

random_walk <-  function(x,y) {
  #move the particle randomly to a neighbouring cell (max of 8 neighbours)
  neighbors <- matrix(c(x,x,x+1,x+1,x+1,x-1,x-1,x-1,y+1,y-1,y,y+1,y-1,y,y+1,y-1) ,nrow=8, ncol=2)
  quadrant <- ( (x-center_cell)/abs(x-center_cell)+1)/2+ ((y-center_cell)/abs(y-center_cell)+2) #1 to 4  => c(3,4,1,2)
  #this code adds a minor negative bias towards movements away from the center, based on the quadrant. All other directions have 
  #equal probability of being selected, which is greater than the diagonal direction away from the center
  new_coord <-  neighbors[(neighbors[,1]>0 & neighbors[,1]<=dim_matrix ) & (neighbors[,2]>0 &neighbors[,2]<=dim_matrix)  , ]
  new_coord <-  new_coord[sample(1:nrow(new_coord),1, prob = prob_list[[quadrant ]][1:nrow(new_coord)] ),]
  return(c(new_coord[1], new_coord[2]))
}

CheckStuck <-  function(x,y){
  #Check if a neighbour is an already existing particle
  condition <-  min( (df_image[,1] - x)^2 + (df_image[,2] - y)^2)
  return(condition)
}

# Rprof("check_profiling") #to profile which operation is taking the most time.
start_time <- Sys.time()
iter_while <- matrix(0, nrow = num_particles,ncol=1)
for (iter in 1:num_particles) {
  #outer loop to introduce particles at the edge
  print(paste("Number of particles: ",iter))
  particle <- random_walker()
  
  check_value <- CheckStuck(particle[1],particle[2])
  while(TRUE ){
    #inner loop to create the random walk
    #Don't need to check stuck in every iteration, checking every 10 iterations, until the particle is close to another
    if(check_value <100 | iter_while[iter,1]%%10 ==0){
    check_value <- CheckStuck(particle[1],particle[2])
    if(check_value<=2) break()
    }
    particle <- random_walk(particle[1], particle[2]) #new position of particle after random walk
    iter_while[iter,1] <- iter_while[iter,1] + 1 
  }
  df_image[iter+1,] <- c(particle[1], Y =particle[2])
}

###.plotting
df_image <- data.frame(df_image)
df_image <- df_image %>%  cbind(1:nrow(df_image))
colnames(df_image) <- c("X","Y", "row")
gp <- ggplot(df_image, aes(x =X, y=Y)) + geom_point(size=1, shape=18, aes(color= row))
{
  gp + xlim(0,dim_matrix +1 ) +ylim(0,dim_matrix + 1) +theme_void() + 
  geom_segment(aes(x = 0, y = 0, xend = dim_matrix +1, yend = 0)) + 
  geom_segment(aes(x = 0, y = dim_matrix+1, xend = dim_matrix +1, yend = dim_matrix +1)) + 
  geom_segment(aes(x = 0, y = 0, xend = 0, yend = dim_matrix +1)) + 
  geom_segment(aes(x = dim_matrix + 1, y = 0, xend = dim_matrix +1, yend = dim_matrix +1))+
  ggtitle(paste("M = ",dim_matrix , ", N = ",num_particles, ", Stickiness = ", stickiness)) +
  theme(plot.title = element_text(hjust = 0.5))
}
# Rprof(NULL)
# summaryRprof("check_profiling")
end_time <- Sys.time() 
print(end_time - start_time)
#write.csv(df_image, paste("M = ",dim_matrix , ", N = ",num_particles, ", Stickiness = ", stickiness,".csv"))
