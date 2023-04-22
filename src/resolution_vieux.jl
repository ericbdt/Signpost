# This file contains methods to solve an instance (heuristically or with CPLEX)
using CPLEX
using LinearAlgebra


include("generation.jl")
include("io.jl")


TOL = 0.00001

"""
Solve an instance with CPLEX
"""
function SignPostcplexSolve(inputFile::String)



    Game, N = readInputFile(inputFile)

    # Create the model
    m = Model(CPLEX.Optimizer)

    n = size(Game,1)

    @variable(m, M[1:n*n,1:n*n], Bin)
    @variable(m, C[1:n*n], Int,lower_bound=1)



    @constraint(m, C[1]==1)
    @constraint(m, [i in 1:n*n],C[i]>=1 )
    @constraint(m, C[n*n]==n*n)
    @constraint(m, M[n*n,1]==1)


    for i in 1:n*n
        @constraint(m, sum(M[i,j] for j in 1:n*n)==1)
    end

    for j in 1:n*n
        @constraint(m, sum(M[i,j] for i in 1:n*n)==1)
    end

    for i in 1:n*n 
        for j in 1:n*n 
            @constraint(m, M[i,j]<=N[i,j])
            #@constraint(m, y[i]-y[j] + n*n * M[i,j] <= n*n-1)
        end
    end


    # for k in 2:(n*n-1)                PREMIER TEST ANTI CYCLE

    #     for S in combinations(1:n*n,k)
    #         @constraint(m, M[S[k],S[1]] + sum(M[S[l],S[l+1]] for l in 1:(k-1)) <=k-1)

    #     end
    # end
    for k in 1:n*n-1
        @constraint(m, dot(M[k,:],C)==C[k+1])
    end
    @constraint(m, dot(M[n*n,:],C)==C[1])


    for k in 1:n*n 
    
        @constraint(m, sum(C[l] for l in 1:n*n if C[l]==k)==k)

    end


        # for l in 1:n*n 
        #     # if k!=l
        #     #     @constraint(m, C[l]!=C[k])
        #     # end    
        # end 


    @objective(m, Min, M[2,2])


    # TODO
    println("Modèle lancé")

    # Start a chronometer
    start = time()

    # Solve the model
    optimize!(m)

    # Return:
    # 1 - true if an optimum is found
    # 2 - the resolution time

    Ms = JuMP.value.(M)

    for i in 1:n*n
        println(Ms[i,:])

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
