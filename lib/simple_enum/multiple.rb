# Frozen-String-Literal: true
# Encoding: utf-8

require 'simple_enum/multiple/accessors'
require 'simple_enum/multiple/bitwise_accessors'
require 'simple_enum/multiple/extension'
require 'simple_enum/multiple/version'
require 'simple_enum/multiple/proxy'

SimpleEnum.register_generator :multiple, SimpleEnum::Multiple::Extension
SimpleEnum.register_accessor :bitwise, SimpleEnum::Multiple::BitwiseAccessors
SimpleEnum.register_accessor :multiple, SimpleEnum::Multiple::Accessors
