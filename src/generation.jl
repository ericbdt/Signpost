# This file contains methods to generate a data set of instances (i.e., sudoku grids)
include("io.jl")

"""
Generate an n*n grid with a given density

Argument
- n: size of the grid
- density: percentage in [0, 1] of initial values in the grid
"""

function get_neighbours(n::Int64, pivot::Int64, chaine::Vector{Int}, a_eviter::Vector{Any})

    row = div(pivot,n) + 1
    col = rem(pivot,n)
    voisins = []

    for k in 1:n 


        #Voisins sur une ligne
        v = k + (row-1)*n 
        if k == col
            totake = false
        elseif v in chaine
                totake = false
        elseif v in a_eviter[pivot]
                totake = false
        else 
            totake = true
        end
        
        if totake
            vcat!(voisins, v)
        end


        #Voisins sur une colonne
        v = col + (k-1)*n 
        if k == row
            totake = false
        elseif v in chaine
                totake = false
        elseif v in a_eviter[pivot]
                totake = false
        else 
            totake = true
        end       

        if totake
            vcat!(voisins,v)
        end

        ##### Voisins sur une diagonale
        for k in 1:min(row-1,col-1)             ##### Diagonale vers le haut à gauche
            v = col-k + (row-k-1)*n
            if v in chaine
                totake = false
            elseif v in a_eviter[pivot]
                totake = false
            else 
                totake = true
            end       
            vcat!(voisins,v)
        end

        for k in 1:min(row-1,n-col)             ##### Diagonale vers le haut à droite
            v = col+k + (row-k-1)*n
            if v in chaine
                totake = false
            elseif v in a_eviter[pivot]
                totake = false
            else 
                totake = true
            end       
            vcat!(voisins,v)
        end

        for k in 1:min(n-row,n-col)             ##### Diagonale vers le bas à droite
            v = col+k + (row+k-1)*n
            if v in chaine
                totake = false
            elseif v in a_eviter[pivot]
                totake = false
            else 
                totake = true
            end       
            vcat!(voisins,v)
        end


        for k in 1:min(n-row,col-1)             ##### Diagonale vers le bas à gauche
            v = col-k + (row+k-1)*n
            if v in chaine
                totake = false
            elseif v in a_eviter[pivot]
                totake = false
            else 
                totake = true
            end       
            vcat!(voisins,v)
        end

    end
    return voisins
end





function generateInstance(n::Int64)

    chaine = [1]
    a_eviter = []*16
    pivot = 1


    while lenght(chaine)<= 15 
            
        Voisins = get_neighbours(n, pivot, chaine, a_eviter)



        if lenght(chaine)==n*n-1
            if Voisins[1]!=n*n
                pop!(chaine)
                a_eviter[pivot] = []
                vcat!(a_eviter[chaine[end]],pivot)
                pivot = chaine[end]

            end
        else
            if lenght(Voisins) ==0

                pop!(chaine)
                a_eviter[pivot] = []
                vcat!(a_eviter[chaine[end]],pivot)
                pivot = chaine[end]

            else
                ind = rand(1:lenght(Voisins))

                pivot = Voisins[ind]
                vcat!(chaine, pivot)

        
            end
        end
    end


    return chaine
end 

function generate_Game(n::Int64)

    chaine = generateInstance(n)

    game = Matrix{Int64}(undef,n,n)

    for i in 1:(n*n-1)

        pivot = chaine[i]
        row = div(pivot,n)+1
        col = rem(pivot,n)
        suivant = chaine[i+1]
        row_s = div(suivant,n)+1
        col_s = rem(suivant,n)
    
        if col_s == col 
            if row_s < row
                game[row,col] = 0 #fleche vers le haut
            else 
                game[row,col] = 4 #fleche vers le bas 
            end
        elseif row_s == row 
            if col_s < col 
                game[row,col] = 6 #fleche vers la gauche
            else 
                game[row,col] = 2 #fleche vers la droite
            end 
        elseif row_s < row 
            if col_s < col 
                game[row,col] = 7 #fleche vers le haut à gauche
            else 
                game[row,col] = 1 #fleche vers le haut à droite 
            end
        else 
            if col_s < col 
                game[row,col] = 5 #fleche en bas à gauche
            else
                game[row,col] = 3 #fleche vers le bas a droite
            end
        end
    end
    game[n,n] = 7 

    return game


end

"""
Generate all the instances

Remark: a grid is generated only if the corresponding output file does not already exist
"""
function generateDataSet()

    # TODO
    println("In file generation.jl, in method generateDataSet(), TODO: generate an instance")
    
end



