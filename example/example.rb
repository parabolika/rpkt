$:.unshift File.join(File.dirname(__FILE__), '..', 'lib')

require 'rpkt'

define_packet 37 do
  u1 :some_info
  u1 :other_info
end

# Possible to use brackets for more C-style structs as well:
# packet 37 { |data|
#   u1 ...
# }

data = [1, 4, 2, 6, 8, 2, 5, 5]
packet = process_packet 37, data

puts packet.inspect # -> #<SimplePackets::Packet:0x0000000238bdf8 @some_info=1, @other_info=4>
