module ChaosCommunications

using Distributions
# using NumericExtensions
using StatsBase

import StatsBase.RealVector

export
  #types
  InfoForm,
  Classical,
  Quantum,
  Analog,
  Digital,
  InteractionForm,
  TransmitterForm,
  ReceiverForm,
  UniTransmitter,
  MultiTransmitter,
  UniReceiver,
  MultiReceiver,
  OneWay,
  TwoWay,
  ChannelForm,
  UniChannel,
  MultiChannel,
  System,
  ClassicalSystem,
  QuantumSystem,
  AnalogSystem,
  DigitalSystem,
  DigitalOneWayUniChannelSystem,
  DigitalUTURUniChannelSystem,
  UTURUniChannelCSK,
  Carrier,
  RandomProcessCarrier,
  QuasiRandomCarrier,
  IterativeMapCarrier,
  LogisticCarrier,
  Decoder,
  DeterministicDecoder,
  QuasiRandomDecoder,
  RandomDecoder,
  CorDecoder,
  MCMLDecoder,

  # functions
  initialize,
  logistic,
  snr2var,
  var2snr,
  decode,
  sim_sys,
  sim_ber,
  psim_ber

abstract InfoForm
abstract Classical <: InfoForm
abstract Quantum <: InfoForm
type Analog <: Classical end
type Digital <: Classical end

abstract InteractionForm
abstract TransmitterForm
abstract ReceiverForm
type UniTransmitter <: TransmitterForm end
type MultiTransmitter <: TransmitterForm end
type UniReceiver <: ReceiverForm end
type MultiReceiver <: ReceiverForm end
abstract OneWay{T<:TransmitterForm, R<:ReceiverForm} <: InteractionForm
abstract TwoWay <: InteractionForm

abstract ChannelForm
type UniChannel <: ChannelForm end
type MultiChannel <:ChannelForm end

abstract System{Info<:InfoForm, I<:InteractionForm, C<:ChannelForm} #D stands for directionality

typealias ClassicalSystem{I<:InteractionForm, C<:ChannelForm} System{Classical, I, C}
typealias QuantumSystem{I<:InteractionForm, C<:ChannelForm} System{Quantum, I, C}
typealias AnalogSystem{I<:InteractionForm, C<:ChannelForm} System{Analog, I, C}
typealias DigitalSystem{I<:InteractionForm, C<:ChannelForm} System{Digital, I, C}

typealias DigitalOneWayUniChannelSystem{T<:TransmitterForm, R<:ReceiverForm} DigitalSystem{OneWay{T, R}, UniChannel}
# UTUR := UniTransmitter, UniReceiver
typealias DigitalUTURUniChannelSystem DigitalSystem{OneWay{UniTransmitter, UniReceiver}, UniChannel}

typealias FunctionOrNothing Union(Function, Nothing)

type MinMaxError <: Exception
    msg::String
end

include(joinpath("carriers", "carriers.jl"))
include(joinpath("carriers", "iterativemapcarriers.jl"))
include("decoders.jl")
# include(joinpath("decoders", "mcmldecoders.jl"))
include("noise.jl")
include(joinpath("systems", "classical", "digital", "csk", "onewayunichannelcsk.jl"))
end # module