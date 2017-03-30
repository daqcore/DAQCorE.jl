# This file is a part of DAQCorE.jl, licensed under the MIT License (MIT).

export Lockable


immutable Lockable{T}
   x::T
   lock::ReentrantLock

   (::Type{Lockable{T}}){T}(x::T) = new{T}(x, ReentrantLock())
end

Lockable{T}(x::T) = Lockable{T}(x)



function Base.broadcast(f, l::Lockable)
   try
       lock(l.lock)
       f(l.x)
   finally
       unlock(l.lock)
   end
end

Base.map(f, l::Lockable) = broadcast(f, l)
