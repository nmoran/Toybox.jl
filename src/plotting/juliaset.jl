using Plots

"""
    find_julia_set(w, h, c; xbounds, ybounds, max_iteration)

Fuction to generate julia set for given constant.
Adapted from pseudocode from
https://en.wikipedia.org/wiki/Julia_set#Pseudocode_for_normal_Julia_sets
"""
function find_julia_set(w, h, c;
    xbounds=(-5, 5), ybounds=(-5, 5), max_iteration=1000)
    data = ones(w, h)
    for (x, zx) in enumerate(LinRange(xbounds..., w)),
    (y, zy) in enumerate(LinRange(ybounds..., h))
        z = zx + zy * im
        iteration = 1

        while real(z * z') < 4 && iteration < max_iteration
            z = z * z + c
            iteration = iteration + 1
        end
        data[x, y] = iteration
    end
    return data
end

xbounds = (-5, 5.)
ybounds = (-5, 5.)
@time data = find_julia_set(1000, 1000, 0.3 - 0.15im)
max_val = maximum(data)
println("done: $max_val")
heatmap!(log.(data))
savefig("julia_set.png")
