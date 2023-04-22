# This file contains methods to solve an instance (heuristically or with CPLEX)
using CPLEX
using LinearAlgebra


include("generation.jl")
include("io_nc.jl")


TOL = 0.00001

"""
Solve an instance with CPLEX
"""
function SignPostcplexSolve_pas_contraint(inputFile::String)



    Game, N = readInputFile(inputFile)

    # Create the model
    m = Model(CPLEX.Optimizer)

    n = size(Game,1)

    @variable(m, C[1:n*n, 1:n*n], Bin)



    @constraint(m, C[1,1]==1)

    @constraint(m, C[n*n,n*n]==1)


    for i in 1:n*n
        @constraint(m, sum(C[i,j] for j in 1:n*n)==1)
    end

    for j in 1:n*n
        @constraint(m, sum(C[i,j] for i in 1:n*n)==1)
    end

    for k in 1:n*n-1
        for i in 1:n*n
            for j in 1:n*n  
                @constraint(m, C[i,k]*C[j,k+1]<=N[i,j] )
            end
        end
    end


    @objective(m, Min, N[2,2])


    # TODO
    println("Modèle lancé")

    # Start a chronometer
    start = time()

    # Solve the model
    optimize!(m)

    # Return:
    # 1 - true if an optimum is found
    # 2 - the resolution time

    println(JuMP.primal_status(m) == JuMP.FEASIBLE_POINT)



    Cs = JuMP.value.(C)

    SignPost_Solved = Matrix{Int64}(undef,n,n)

    for row in 1:n
        
        for count in 1:n 
            found = 0
            col = 0
            while found == 0 
                col+=1
                if Cs[(row-1)*n+count,col] == 1 
                    found = 1
                end
            end
            SignPost_Solved[row,count] = col

        end
    end




    for i in 1:n
        println(SignPost_Solved[i,:])

    end


    return JuMP.primal_status(m) == JuMP.FEASIBLE_POINT, time() - start
    
end

# """
# Heuristically solve an instance
# """
# function heuristicSolve()

#     # TODO
#     println("In file resolution.jl, in method heuristicSolve(), TODO: fix input and output, define the model")
    
# end 

# """
# Solve all the instances contained in "../data" through CPLEX and heuristics

# The results are written in "../res/cplex" and "../res/heuristic"

# Remark: If an instance has previously been solved (either by cplex or the heuristic) it will not be solved again
# """
# function solveDataSet()

#     dataFolder = "../data/"
#     resFolder = "../res/"

#     # Array which contains the name of the resolution methods
#     resolutionMethod = ["cplex"]
#     #resolutionMethod = ["cplex", "heuristique"]

#     # Array which contains the result folder of each resolution method
#     resolutionFolder = resFolder .* resolutionMethod

#     # Create each result folder if it does not exist
#     for folder in resolutionFolder
#         if !isdir(folder)
#             mkdir(folder)
#         end
#     end
            
#     global isOptimal = false
#     global solveTime = -1

#     # For each instance
#     # (for each file in folder dataFolder which ends by ".txt")
#     for file in filter(x->occursin(".txt", x), readdir(dataFolder))  
        
#         println("-- Resolution of ", file)
#         readInputFile(dataFolder * file)

#         # TODO
#         println("In file resolution.jl, in method solveDataSet(), TODO: read value returned by readInputFile()")
        
#         # For each resolution method
#         for methodId in 1:size(resolutionMethod, 1)
            
#             outputFile = resolutionFolder[methodId] * "/" * file

#             # If the instance has not already been solved by this method
#             if !isfile(outputFile)
                
#                 fout = open(outputFile, "w")  

#                 resolutionTime = -1
#                 isOptimal = false
                
#                 # If the method is cplex
#                 if resolutionMethod[methodId] == "cplex"
                    
#                     # TODO 
#                     println("In file resolution.jl, in method solveDataSet(), TODO: fix cplexSolve() arguments and returned values")
                    
#                     # Solve it and get the results
#                     isOptimal, resolutionTime = cplexSolve()
                    
#                     # If a solution is found, write it
#                     if isOptimal
#                         # TODO
#                         println("In file resolution.jl, in method solveDataSet(), TODO: write cplex solution in fout") 
#                     end

#                 # If the method is one of the heuristics
#                 else
                    
#                     isSolved = false

#                     # Start a chronometer 
#                     startingTime = time()
                    
#                     # While the grid is not solved and less than 100 seconds are elapsed
#                     while !isOptimal && resolutionTime < 100
                        
#                         # TODO 
#                         println("In file resolution.jl, in method solveDataSet(), TODO: fix heuristicSolve() arguments and returned values")
                        
#                         # Solve it and get the results
#                         isOptimal, resolutionTime = heuristicSolve()

#                         # Stop the chronometer
#                         resolutionTime = time() - startingTime
                        
#                     end

#                     # Write the solution (if any)
#                     if isOptimal

#                         # TODO
#                         println("In file resolution.jl, in method solveDataSet(), TODO: write the heuristic solution in fout")
                        
#                     end 
#                 end

#                 println(fout, "solveTime = ", resolutionTime) 
#                 println(fout, "isOptimal = ", isOptimal)
                
#                 # TODO
#                 println("In file resolution.jl, in method solveDataSet(), TODO: write the solution in fout") 
#                 close(fout)
#             end


#             # Display the results obtained with the method on the current instance
#             include(outputFile)
#             println(resolutionMethod[methodId], " optimal: ", isOptimal)
#             println(resolutionMethod[methodId], " time: " * string(round(solveTime, sigdigits=2)) * "s\n")
#         end         
#     end 
# end
