

const _chapman_so_filename = 
            string(
                    @__DIR__, "/chapman",
                    isapple ? "_macos" : islinux ? "_linux" : "_win",
                    ".so",
                )

_check_chapman() = _check_so(_chapman_so_filename)
_check_chapman()

# export atm8_chapman
atm8_chapman(xscale::Float64, chi::Float64)::Float64 =
    ccall((:atm8_chapman_, _chapman_so_filename),
            Float64,
            (Ref{Float64}, Ref{Float64}),
            xscale, chi,)

function test_chapman()
    ch1 = atm8_chapman(1000.0, 30.0)
    ch1
    # isapprox(ch1, 1.154317169142657)
end