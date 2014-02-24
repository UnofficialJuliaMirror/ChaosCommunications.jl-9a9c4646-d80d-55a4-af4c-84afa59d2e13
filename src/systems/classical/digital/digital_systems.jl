function gen_sys(sprlen::Ranges{Int}, ebn0db::Ranges{Float64}; system::Symbol=:UTURUniChannelCSK, args...)
  if system == :UTURUniChannelCSK
    uturunichannelcsk_gen_sys(sprlen, ebn0db; args...)
  else
    error("sim_ber was called with invalid arguments.")
  end
end

gen_sys(sprlen::Int, ebn0db::Ranges{Float64}; system::Symbol=:UTURUniChannelCSK, args...) =
  gen_sys(sprlen:sprlen, ebn0db; system=system, args...)

gen_sys(sprlen::Ranges{Int}, ebn0db::Float64; system::Symbol=:UTURUniChannelCSK, args...) =
  gen_sys(sprlen, ebn0db:ebn0db; system=system, args...)

gen_sys(sprlen::Int, ebn0db::Float64; system::Symbol=:UTURUniChannelCSK, args...) =
  gen_sys(sprlen:sprlen, ebn0db:ebn0db; system=system, args...)

function sim_ber(s::DigitalSystem, bit::Int, n::Int64)
  nbiterrors::Int64 = 0
  ndecfails::Int64 = 0

  for i = 1:n
    bit_estimate = sim_sys(s, bit)
    if in(bit_estimate, [-1, 1])
      if bit_estimate != bit
        nbiterrors += 1
      end
    else
      ndecfails += 1
    end
  end

  nbiterrors, ndecfails, nbiterrors/(n-ndecfails)
end

function sim_ber{T<:DigitalSystem}(s::Vector{T}, bit::Int, n::Int64)
  slen = length(s)
  output = cell(slen)

  for i = 1:slen
    output[i] = sim_ber(s[i], bit, n)
  end

  return output
end

function sim_ber{T<:DigitalSystem}(s::Matrix{T}, bit::Int, n::Int64)
  nrows, ncols = size(s)
  output = cell(nrows, ncols)

  for i = 1:nrows
    for j = 1:ncols
      output[i, j] = sim_ber(s[i, j], bit, n)
    end
  end

  return output
end

function psim_ber(s::DigitalSystem, bit::Int, n::Int64)
  ndecfails, nbiterrors =
  (@parallel (+) for i = 1:n
    bit_estimate = sim_sys(s, bit)
    in(bit_estimate, [-1, 1]) ? (bit_estimate == bit ? [0, 0]: [0, 1]) : [1, 0]
  end)

  nbiterrors, ndecfails, nbiterrors/(n-ndecfails)
end

function psim_ber{T<:DigitalSystem}(s::Vector{T}, bit::Int, n::Int64)
  slen = length(s)
  output = cell(slen)

  for i = 1:slen
    output[i] = psim_ber(s[i], bit, n)
  end

  return output
end

function psim_ber{T<:DigitalSystem}(s::Matrix{T}, bit::Int, n::Int64)
  nrows, ncols = size(s)
  output = cell(nrows, ncols)

  for i = 1:nrows
    for j = 1:ncols
      output[i, j] = psim_ber(s[i, j], bit, n)
    end
  end

  return output
end

function ber_lb{T<:DigitalSystem}(s::Vector{T}; args...)
  slen = length(s)
  output = Array(Float64, slen)

  for i = 1:slen
    output[i] = ber_lb(s[i]; args...)
  end

  return output
end

function ber_lb{T<:DigitalSystem}(s::Matrix{T}; args...)
  nrows, ncols = size(s)
  output = Array(Float64, nrows, ncols)

  for i = 1:nrows
    for j = 1:ncols
      output[i, j] = ber_lb(s[i, j]; args...)
    end
  end

  return output
end
