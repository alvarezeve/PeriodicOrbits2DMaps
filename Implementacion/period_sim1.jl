#------------------------- Method for periodic points in discrete maps using symmetries


# Function for composition of map n times
# Where f is a function of one variable and n is an integer
composition(f, n) = ∘(ntuple(_ -> f, n)...)


# ..............Newton Method manual.....
function newtonmethodE(f, fp, x; tol=sqrt(eps()))

    ctr, max_steps = 0, 100

    while (abs(f(x)) > tol) && ctr < max_steps
        x = x - f(x) / fp(x)
        ctr = ctr + 1
    end

    ctr >= max_steps ? error("Method did not converge") : return (x, ctr)

end

#..............................Secant method manualment

function secant(f::Function, x0::Number, x1::Number;
                tol::AbstractFloat=1e-68, maxiter::Integer=250)
    for _ in 1:maxiter
        y1 = f(x1)
        y0 = f(x0)
        x = x1 - y1 * (x1-x0)/(y1-y0)
        if abs(x-x1) < tol
            return x
        end
        x0 = x1
        x1 = x
    end
    error("Max iteration exceeded")
end


# Fucntion for substituting parameters and the condition of invariant set
""" substitutionMap(::function, ::function, ::Real, ::Real, ::function )

    Is a function for substituting the parameters and the symmetry condition and makes a new function whit only one variable.

"""
function substitutionMap(fx,fy,a,b,sim)
    #funciones viejas
    MapeoXA(y) = fx(sim(y),y,a,b)
    MapeoYA(y) = fy(sim(y),y,a,b)
    # funciones nuevas que tienen integrado el igual un punto fijo
    #MapeoXA(y) = fx(sim(y),y,a,b) - sim(y)
    #MapeoYA(y) = fy(sim(y),y,a,b) - y
    return [MapeoXA,MapeoYA]
end


"""periodicoSimY(::function, ::function, ::Array)

Is a function for compute the zeros of the functions in the interval [a,b]. Return an Array of the zeros [[zeros1], [zeros2]].
"""


function periodicoSimY(fx, fy, intervalo::Array{Float64,1})
    print("Estoy en la funcion a")


#    cerosy1 = find_zeros(fx,intervalo[1],intervalo[2],xatol=1e-5, xrtol =1e-5)
    cerosy1 = find_zeros(fx,intervalo[1],intervalo[2],xatol=1e-6, xrtol =1e-6)

    cerosy2 = find_zeros(fy,intervalo[1],intervalo[2],xatol=1e-6, xrtol =1e-6)
print("eeeeeerror despues de esto       ")

    #cerosy1 = find_zero(fx,(intervalo[1],intervalo[2]))
    #cerosy2 = find_zero(fy,(intervalo[1],intervalo[2]))

    #cerosy1 = find_zero(fx,(intervalo[1],intervalo[2]), Bisection())
    #cerosy2 = find_zero(fy,(intervalo[1],intervalo[2]), Bisection())

    #cerosy1 = find_zero(fx,(intervalo[1],intervalo[2]), Order16)
    #cerosy2 = find_zero(fy,(intervalo[1],intervalo[2]), Order16)


    return [cerosy1,cerosy2]

end



#function periodicoSimY(fx, fy, initialg :: Float64)
#    print("Estoy en la funcion b")
#    cerosy1 = fzero(fx,initialg)
#    cerosy2 = fzero(fy,initialg)
#    return [cerosy1,cerosy2]
#end









function periodicoSimY2(fx,fy,semilla::BigFloat)
    print("Estoy en la funcion b")
    #cerosy1 = find_zero(fx,semilla, Order16())
    #cerosy2 = find_zero(fy,semilla, Order16())

    cerosy1 = find_zero(fx,semilla, xatol = 1e-15)
    cerosy2 = find_zero(fy,semilla, xatol = 1e-15)
    return [cerosy1,cerosy2]
end
## SE MODIFICO ESTA FUNCION
function periodicoSimY3(fx,fy,Dfx,Dfy,semilla::BigFloat)
    print("Estoy en la funcion c")
    #cerosy1 = find_zero((fx,Dfx), semilla, Roots.Newton(), order=10)
    #cerosy1 = newtonmethodE(fx,Dfx,semilla)[1]
    cerosy1 = secant(fx,big(0.0),semilla)
    #cerosy2 = find_zero((fy,Dfy), semilla, Roots.Newton())
    #return [cerosy1,cerosy2]
    return[cerosy1]
end



"""
periodicoSimX(::function,::Array, Array)

Is a function for compute the zeros in X of the 2 first functions corresponds to the zeros of the arrays.
"""
function periodicoSimX(simetria,cerosy1::Array{Float64,1},cerosy2::Array{Float64,1})
    cerosx1 = [simetria(cerosy1[i]) for i in 1:length(cerosy1)]
    cerosx2 = [simetria(cerosy2[i]) for i in 1:length(cerosy2)]

    #cerosx1 = simetria(cerosy1)
    #cerosx2 = simetria(cerosy2)
    #  MODIFICADO
    #return [cerosx1, cerosx2]
    return [cerosx1,cerosx2]
end

function periodicoSimX(simetria,cerosy1::BigFloat,cerosy2::BigFloat)
    cerosx1 = [simetria(cerosy1[i]) for i in 1:length(cerosy1)]
    cerosx2 = [simetria(cerosy2[i]) for i in 1:length(cerosy2)]

    #cerosx1 = simetria(cerosy1)
    #cerosx2 = simetria(cerosy2)
    return [cerosx1, cerosx2]
end

function periodicoSimX(simetria,cerosy1::Float64,cerosy2::Float64)
    cerosx1 = simetria(cerosy1)
    cerosx2 = simetria(cerosy2)

    #cerosx1 = simetria(cerosy1)
    #cerosx2 = simetria(cerosy2)
    return [cerosx1, cerosx2]
end


"""
PeriodicosS(fx::function,fy::function,simetria::function,a::Real,b::Real,n::Integer,intervalo::Array)

Is a function for compute the periodic poiints of period n in the map (fx,fy) in the interval  gives for intervalo, and using the
condition of the symmetry given by simetria. Returns an array of arrays whith zeros in X and zeros in Y.
"""
function PeriodicosS(fx,fy,simetria,a::Float64,b::Float64,n::Int64,intervalo::Array{Float64,1})
    Maps = substitutionMap(fx,fy,a,b,simetria)

    ###FUNCIONES DE PRUEBA 1
    #mapeoX(y)=composition(Maps[1],n)(y) - simetria(y)
    #mapeoY(y)=composition(Maps[2],n)(y) - y
    ###FUNCIONES DE PRUEBA 2
    mapeoX(y)=composition(Maps[1],n)(y) - simetria(y)
    mapeoY(y)=composition(Maps[2],n)(y)

    cerosY = periodicoSimY(mapeoX,mapeoY,[intervalo[1],intervalo[2]])
    print("eeeeeerror despues 2  ")
    cerosX = periodicoSimX(simetria,cerosY[1],cerosY[2])
print("eeeeeerror despues 2  ")
    cerosX = vcat(cerosX[1],cerosX[2])
    cerosY = vcat(cerosY[1],cerosY[2])
    return [cerosX,cerosY]
end

function PeriodicosS(fx,fy,simetria,a::BigFloat,b::BigFloat,n::Int64,intervalo::BigFloat)
    print("estoy en la 2 funcion")
    Maps = substitutionMap(fx,fy,a,b,simetria)
    mapeoX(y)=composition(Maps[1],n)(y) - simetria(y)
    mapeoY(y)=composition(Maps[2],n)(y)
    semilla = BigFloat(intervalo)
    print("estoy a punto de ingresar a la otra funcion  " )
    print("  semilla  " ,typeof(semilla))
    cerosY = periodicoSimY2(mapeoX,mapeoY,semilla)
    cerosX = periodicoSimX(simetria,cerosY[1],cerosY[2])
    cerosX = vcat(cerosX[1],cerosX[2])
    cerosY = vcat(cerosY[1],cerosY[2])
    return [cerosX,cerosY]
end

function PeriodicosSNewton(fx,fy,simetria,a::BigFloat,b::Float64,n::Int64,semilla::BigFloat)
    print("estoy en la 3 funcion")
    Maps = substitutionMap(fx,fy,a,b,simetria)
    mapeoX(y)=composition(Maps[1],n)(y) - simetria(y)
    mapeoY(y)=composition(Maps[2],n)(y)
    #MODIFICACIONES
    mapeosimple(y) = mapeoX(y)-mapeoY(y)
    Dfm = y -> ForwardDiff.derivative(mapeosimple,y)
    #......Dfx  = y -> ForwardDiff.derivative(mapeoX, y)
    #......Dfy  = y -> ForwardDiff.derivative(mapeoY, y)

    print("   estoy a punto de ingresar a la otra funcion  " )
    cerosY = periodicoSimY3(mapeosimple,mapeosimple,Dfm,Dfm,semilla) # se modifica
    #  ........la funcion periodicos sim
    #.....cerosY = periodicoSimY3(mapeoX,mapeoY, Dfx, Dfy,semilla)
    #.....cerosX = periodicoSimX(simetria,cerosY[1],cerosY[2])
    cerosX = periodicoSimX(simetria,cerosY[1],cerosY[1])
    cerosX = cerosX[1]

    #........cerosX = vcat(cerosX[1],cerosX[2])
    #........cerosY = vcat(cerosY[1],cerosY[2])
    return [cerosX,cerosY]
end
