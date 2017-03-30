# This file is a part of DAQCorE.jl, licensed under the MIT License (MIT).

export DeviceProperty
export @device_property


"""
    DeviceProperty{T}

Represents hierarchial device properties as types, enabling Julia to dispatch
on them. `T` must be an `NTuple{N,Symbol}`.

Example:

    DeviceProperty{(:foo,)}

Howevery, device properties will typically be defined using the
`@device_property` macro.

DeviceProperty types can be combined via the `%` operator:

    DeviceProperty{(:foo,)} % DeviceProperty{(:bar,)} ==
        DeviceProperty{(:foo,:bar)}
"""
immutable DeviceProperty{T} end

Base.string{T}(::Type{DeviceProperty{T}}) = join(map(sym -> last(split(string(sym), ".")), T), "%")
Base.show{T}(io::IO, t::Type{DeviceProperty{T}}) = print(io, string(t), " (DeviceProperty{$T})")

import Base.%
%{A,B}(::Type{DeviceProperty{A}}, ::Type{DeviceProperty{B}}) = DeviceProperty{(A..., B...)}


"""
    @device_property [export] device_property

Macro for easy definition of DeviceProperty type constants.

    @device_property export Foo

is equivalent to

    const Foo = DeviceProperty{(Symbol("CURRENT_MODULE.Foo"),)}
    export Foo

Exporting the type constant is optional.

Example:

    @device_property export Foo
    @device_property Bar
    Foo%Bar
"""
macro device_property(expr)
    m = current_module()
    if isa(expr, Symbol)
        sym = expr
        export_enabled = false
    elseif isa(expr, Expr)
        modifier = expr.head::Symbol
        if (modifier == :export)
            sym = ((expr.args...)::Tuple{Symbol})[1]
            export_enabled = true
        else
            throw(AssertionError("@device_property expected :export here"))
        end
    else
        throw(AssertionError("Invalid arguments for @device_property"))
    end

    result = Expr(:block)
    prop_name = Symbol(join((string(m), string(sym)), "."))
    qsym = Expr(:quote, prop_name::Symbol)
    push!(result.args, :(Base.@__doc__ const $sym = DeviceProperty{($qsym,)}))
    export_enabled && push!(result.args, :(export $sym))
    esc(result)
end
