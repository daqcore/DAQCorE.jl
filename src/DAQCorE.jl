# This file is a part of DAQCorE.jl, licensed under the MIT License (MIT).

__precompile__(true)

module DAQCorE

include.([
    "lockable.jl",
    "device.jl",
    "device_property.jl",
    "SCPI/SCPI.jl",
])

end # module
