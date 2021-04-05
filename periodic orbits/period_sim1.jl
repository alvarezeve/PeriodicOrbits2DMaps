#------------------------- Method for periodic points in discrete maps using symmetries


# Function for composition of map n times
# Where f is a function of one variable and n is an integer
composition(f, n) = ∘(ntuple(_ -> f, n)...)



# Fucntion for substituting parameters and the condition of invariant set
""" substitutionMap(::function, ::function, ::Real, ::Real, ::function )

    Is a function for substituting the parameters and the symmetry condition and makes a new function whit only one variable.

"""
function substitutionMap(fx,fy,a,b,sim)
    MapeoXA(y) = MapeoX(sim(y),y,a,b)
    MapeoYA(y) = MapeoY(sim(y),y,a,b)
    return [MapeoXA,MapeoYA]
end


"""periodicoSimY(::function, ::function, ::Array)

Is a function for compute the zeros of the functions in the interval [a,b]. Return an Array of the zeros [[zeros1], [zeros2]].
"""
function periodicoSimY(fx, fy, intervalo)
    cerosy1 = find_zeros(fx,intervalo[1],intervalo[2])
    cerosy2 = find_zeros(fy,intervalo[1],intervalo[2])
    return [cerosy1,cerosy2]
end

"""
periodicoSimX(::function,::Array, Array)

Is a function for compute the zeros in X of the 2 first functions corresponds to the zeros of the arrays.
"""
function periodicoSimX(simetria,cerosy1,cerosy2)
    cerosx1 = [simetria(cerosy1[i]) for i in 1:length(cerosy1)]
    cerosx2 = [simetria(cerosy2[i]) for i in 1:length(cerosy2)]
    return [cerosx1, cerosx2]
end


"""
PeriodicosS(fx::function,fy::function,simetria::function,a::Real,b::Real,n::Integer,intervalo::Array)

Is a function for compute the periodic poiints of period n in the map (fx,fy) in the interval  gives for intervalo, and using the
condition of the symmetry given by simetria. Returns an array of arrays whith zeros in X and zeros in Y.
"""
function PeriodicosS(fx,fy,simetria,a,b,n,intervalo)
    Maps = substitutionMap(fx,fy,a,b,simetria)
    mapeoX(y)=composition(Maps[1],n)(y)
    mapeoY(y)=composition(Maps[2],n)(y)
    cerosY = periodicoSimY(mapeoX,mapeoY,[intervalo[1],intervalo[2]])
    cerosX = periodicoSimX(mapeoX,mapeoY,simetria,cerosY[1],cerosY[2])
    return [cerosX,cerosY]
end
