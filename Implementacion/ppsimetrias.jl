#el bueno

composition(f, n) = ∘(ntuple(_ -> f, n)...) # donde f es una funcion de una variable y composition regresa una funcion

function composition2(f,n)
    if n==1
        return f
    else
        return ∘(ntuple(_ -> f, n)...)
    end
end



function pruebaperiodicos(mapeo, simetriaA, simetriaB, n::Int64, semilla::Float64)

        mapeo_n(v) = composition2(mapeo,n)(v)
        puntoprueba1(y) = mapeo_n(simetriaA(0,y))
        ecuaNprueba(y) = simetriaB(puntoprueba1(y)[1],puntoprueba1(y)[2])
        periodoNprueba = find_zero(ecuaNprueba,semilla, Order1())

    return periodoNprueba
end



function pruebaperiodicos(mapeo, simetriaA, simetriaB, n::Int64, semilla::BigFloat)
    #y = Sym("y")
    mapeo_n(v) = composition(mapeo,n)(v)
    #puntoprueba1(y) = mapeo_n([y/2,y])
    puntoprueba1(y) = mapeo_n(simetriaA(0,y))
    ecuaNprueba(y) = simetriaB(puntoprueba1(y)[1],puntoprueba1(y)[2])
    periodoNprueba = find_zero(ecuaNprueba,semilla,Order16())
    return periodoNprueba
end



function periodicosN(mapeo,simetriaA,simetriaB,n::Int64,semilla::Float64)
    yp = pruebaperiodicos(mapeo, simetriaA, simetriaB, n::Int64, semilla::Float64)
    xp = simetriaA(yp,yp)
    return xp
end


function periodicosN(mapeo,simetriaA,simetriaB,n::Int64,semilla::BigFloat)
    yp = pruebaperiodicos(mapeo, simetriaA, simetriaB, n::Int64, semilla::BigFloat)
    xp = simetriaA(yp,yp)
    return xp
end

function Buscaperiodo(pp::Array{Float64,1},mapeo,modulo1,modulo2,tolerancia)
    contador = 0
    resta = 1.0
    puntop1 = pp
    #tolerancia = 1e-10
    MaxIter = 1e3
    for i in 1:MaxIter
        pp_n = mapeo(pp)
        pp_n = [mod(pp_n[1],modulo1),mod(pp_n[2],modulo2)]
        resta = mod(abs(norm(pp_n - puntop1)),modulo1)
        if resta <= tolerancia
            contador = i
            #print("periodo = ")
            break
        end
        pp = pp_n
    end
    return contador
end


function Buscaperiodo(pp::Array{Float64,1},mapeo,modulo,tolerancia)
    contador = 0
    resta = 1.0
    puntop1 = [mod(pp[1],modulo),pp[2]]
    MaxIter = 1e3
    for i in 1:MaxIter
        pp_n = mapeo(pp)
        pp_n = [mod(pp_n[1],modulo),pp_n[2]]
        if abs(modulo-pp_n[1])<tolerancia
            pp_n[1] = 0.0
        end

        difx = abs(pp_n[1]-puntop1[1])
        dify = abs(pp_n[2]-puntop1[2])
        if difx<=tolerancia
            if dify <= tolerancia
                contador = i
                #print("periodo = ")
                break
            end
        end
        pp = pp_n
    end
    return contador
end


function Buscaperiodo(pp::Array{BigFloat,1},mapeo,modulo1,modulo2, tolerancia)
    contador = 0
    resta =BigFloat(1.0)
    puntop1 = pp
    #tolerancia = 1e-10
    MaxIter = 1e3
    for i in 1:MaxIter
        pp_n = mapeo(pp)
        pp_n = [mod(pp_n[1],modulo1),mod(pp_n[2],modulo2)]
        resta = mod(abs(norm(pp_n - puntop1)),modulo1)
        if resta <= tolerancia
            contador = i
            print("periodo = ")
            break
        end
        pp = pp_n
    end
    return contador
end

function Buscaperiodo(pp::Array{BigFloat,1},mapeo,modulo,tolerancia)
    contador = 0
    resta = BigFloat(1.0)
    puntop1 = [mod(pp[1],modulo),pp[2]]
    MaxIter = 1e3
    for i in 1:MaxIter
        pp_n = mapeo(pp)
        pp_n = [mod(pp_n[1],modulo),pp_n[2]]
        if abs(modulo-pp_n[1])<1e-16
            pp_n[1] = BigFloat(0.0)
        end

        difx = abs(pp_n[1]-puntop1[1])
        dify = abs(pp_n[2]-puntop1[2])
        if difx<=tolerancia
            if dify <= tolerancia
                contador = i
                print("periodo = ")
                break
            end
        end
        pp = pp_n
    end
    return contador
end


function iterar(mapeo, x_ini, n, modulo1,modulo2)
    X = [mod(x_ini[1],modulo1)]
    Y = [mod(x_ini[2],modulo2)]
    for i in 1:n
        x_ini = mapeo(x_ini)
        if abs(x_ini[1])<1e-10
            x_ini[1] = 0
        end
        x_ini = [mod(x_ini[1],modulo1),mod(x_ini[2],modulo2)]
        append!(X,x_ini[1])
        append!(Y,x_ini[2])
    end
    return X,Y
end

function iterar(mapeo, x_ini, n, modulo)
    X = [mod(x_ini[1],modulo)]
    Y = [x_ini[2]]
    for i in 1:n
        x_ini = mapeo(x_ini)
        if abs(x_ini[1])<1e-10
            x_ini[1] = 0.0
        end
        x_ini = [mod(x_ini[1],modulo),x_ini[2]]
        append!(X,x_ini[1])
        append!(Y,x_ini[2])
    end
    return X,Y
end
