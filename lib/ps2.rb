require 'pathname'
require 'version'

__LIB__ ||= Pathname.new(__FILE__).join('..', '..', 'lib')
$:.unshift(__LIB__.to_s) unless $:.include?(__LIB__.to_s)

require 'ps2/errors'
require 'ps2/game'
require 'ps2/iso'
require 'core_ext/pathname'
require 'core_ext/string'

# Convert PS2 ISO filenames to the OPL standard of `game_code.name.iso`, such as `SCUS_973.28.GT4.iso`.
module PS2
  is_versioned
end
