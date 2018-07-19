require "bundler/setup"
Bundler.require

dir = File.expand_path("../lib", __dir__)
$:.unshift(dir) unless $LOAD_PATH.include?(dir)

require 'ai/base_ai'
require 'ai/cd'
require 'ai/km'
require 'ai/mm'

require 'players/player'
require 'players/computer'
require 'players/human'

require 'board'
require 'game'
