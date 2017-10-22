# This file is a part of DAQCorE.jl, licensed under the MIT License (MIT).

__precompile__(true)

module DAQCorE

include("lockable.jl")
include("device.jl")
include("device_property.jl")
include("SCPI/SCPI.jl")

end # module
