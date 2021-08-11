using JuMP, DataFrames, Gurobi

#initializing a model named "m" using the Gurobi optimizer
m = Model(with_optimizer(Gurobi.Optimizer))


# Decision Variables

# The decision variables are the intensities of each beamlet for all of the beams (6 in total: x[1],x[2],...,x[6])
# Non-negativity constraint included! 

@variables m begin
    x[1:6] >= 0
end


#Objective Function

#Dosages
voxel_1 = 1*x[1] + 1*x[4]
voxel_3 = 2*x[1] + 2*x[6]
voxel_4 = 1*x[4] + 1*x[2]
voxel_9 = 2.5*x[3] + 2.5*x[6]
spinal_cord =  2*x[2] + 2*x[5]

#minizing the total dose to all healthy tissues and the spinal cord
@objective(m,Min,voxel_1 + voxel_3 + voxel_4 + voxel_9 + spinal_cord)


# Constraints

#Voxel 2
@constraint(m,2*x[5] + 2 * x[1] >= 7)

#Voxel 6
@constraint(m,2.5*x[2] + 2.5 * x[6] >= 7)

#Voxel 7
@constraint(m,1.5*x[3] + 1.5 * x[4] >= 7)

#Voxel 8
@constraint(m,1.5*x[3] + 1.5 * x[5] >= 7)

#Voxel 5/Spinal Cord
@constraint(m,2*x[2] + 2 * x[5] <= 5)

#--- Write codes here to query the optimal solutions

optimize!(m)

# Showing the intensities for each of the 6 beamlets
@show value(x[1]);
@show value(x[2]);
@show value(x[3]);
@show value(x[4]);
@show value(x[5]);
@show value(x[6]);

# Showing the optimal objective function value
@show objective_value(m);


using JuMP, DataFrames, Gurobi

# Initializing an array to store all of the optimal objective function values with varying constraint for the maximum dose that the spinal cord can receive
spinal_cord_dosages = [0.0,0.0,0.0,0.0,0.0,0.0]

for i = 0:5
    
    #initializing a model named "m" using the Gurobi optimizer
    m = Model(with_optimizer(Gurobi.Optimizer))


    # Decision Variables

    # The decision variables are the intensities of each beamlet for all of the beams (6 in total: x[1],x[2],...,x[6])
    # Non-negativity constraint included! 

    @variables m begin
        x[1:6] >= 0
    end

    
    #Objective Function

    #Dosages
    voxel_1 = 1*x[1] + 1*x[4]
    voxel_3 = 2*x[1] + 2*x[6]
    voxel_4 = 1*x[4] + 1*x[2]
    voxel_9 = 2.5*x[3] + 2.5*x[6]
    spinal_cord =  2*x[2] + 2*x[5]

    #minizing the total dose to all healthy tissues and the spinal cord
    @objective(m,Min,voxel_1 + voxel_3 + voxel_4 + voxel_9 + spinal_cord)
    
    
    #constraints

    #Voxel 2
    @constraint(m,2*x[5] + 2 * x[1] >= 7)

    #Voxel 6
    @constraint(m,2.5*x[2] + 2.5 * x[6] >= 7)

    #Voxel 7
    @constraint(m,1.5*x[3] + 1.5 * x[4] >= 7)

    #Voxel 8
    @constraint(m,1.5*x[3] + 1.5 * x[5] >= 7)

    #Voxel 5/Spinal Cord
    #Constraint is changed from <= 0 to <= 1 ... to <= 5
    @constraint(m,2*x[2] + 2 * x[5] <= i)


    optimize!(m)

    # Storing the optimal objective function value for this specific model with the changed spinal cord constraint
    intermediate_objective_function_value = objective_value(m);
    spinal_cord_dosages[i+1] = intermediate_objective_function_value
    
end

#Show the different optimal solutions for maximum spinal total dosage of 0,1,2,3,4,and 5, respectively 
@show spinal_cord_dosages

#--- Model specification
using JuMP, DataFrames, Gurobi

#initializing a model named "m" using the Gurobi optimizer
m = Model(with_optimizer(Gurobi.Optimizer))

# Decision Variables

# The decision variables are the intensities of each beamlet for all of the beams (6 in total: x[1],x[2],...,x[6])
# Non-negativity constraint included! 

@variables m begin
    x[1:6] >= 0
end

# Initializing an array to store all of the spinal dosages for varying parameter p
spinal_dosages = [0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0]

for i = 0:10
    
    #changing the parameter p
    p = i/10
    
     
    #Objective Function

    #Dosages
    voxel_1 = 1*x[1] + 1*x[4]
    voxel_3 = 2*x[1] + 2*x[6]
    voxel_4 = 1*x[4] + 1*x[2]
    voxel_9 = 2.5*x[3] + 2.5*x[6]
    spinal_cord =  2*x[2] + 2*x[5]

    #minizing the total dose to all healthy tissues and the spinal cord with varying parameter p
    @objective(m,Min,(1-p)*(voxel_1 + voxel_3 + voxel_4 + voxel_9) + (p* spinal_cord))
    
    #constraints

    #Voxel 2
    @constraint(m,2*x[5] + 2 * x[1] >= 7)

    #Voxel 6
    @constraint(m,2.5*x[2] + 2.5 * x[6] >= 7)

    #Voxel 7
    @constraint(m,1.5*x[3] + 1.5 * x[4] >= 7)

    #Voxel 8
    @constraint(m,1.5*x[3] + 1.5 * x[5] >= 7)

    optimize!(m)

    #Storing the spinal dosage value for this particular parameter p
    intermediate_spinal_dosage = (2 * value(x[2])) + (2 * value(x[5]));
    spinal_dosages[i+1] = intermediate_spinal_dosage
end

@show spinal_dosages

using Plots

# Labeling the X-Axis 
x_axis = [0.0,0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1.0]

# Spinal Dosages
spinal_dosages_complete_data = spinal_dosages

plot(x_axis, label= "SpinalDosage",spinal_dosages_complete_data, title = "SpinalDosage versus p", xlabel= "p value", ylabel = "SpinalDosage", xticks=x_axis)
