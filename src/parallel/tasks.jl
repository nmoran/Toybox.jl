#!/usr/bin/env julia
"""
Example showing very simple use of channels and tasks

Creates and input and output channel and a function that reads
from the input, applies and operation and writes to the output.
Starts this in the background and then sends on some data.

Some caution should be used in deciding the size of the buffer as
the put! (take!) methods will block if the buffer is full (empty)
"""

let
    c1 = Channel(32)
    c2 = Channel(32)

    function foo()
        while isopen(c1) && isopen(c2)
            data = take!(c1)
            sleep(1)
            put!(c2, data*2)
        end
    end

    N = 5
    n = 20 # cannot be greater than output buffer
    for _ in 1:N
        @async foo()
    end

    foreach(i->put!(c1, i), 1:n)

    for _ in 1:n
        print(take!(c2))
    end

    close(c1)
    close(c2)

    println()
end
