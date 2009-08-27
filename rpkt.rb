module SimplePackets
  module PacketDefinition
    def self.packet(id, &block)
      @packet_defs ||= []
      @packet_defs[id] = block
    end

    def self.do(id, data)
      data = DataContainer.new(data)
      @packet_defs[id].call data
      data.packet
    end
  end

  class Packet
    def method_missing(symbol, *args)
      if instance_variable_defined?('@' + symbol)
	instance_variable_get('@' + symbol)
      end
    end
  end

  class DataContainer
    attr_reader :packet

    def initialize(data)
      @data = data
      @packet = Packet.new
    end

    def u1(name)
      value = u1_intern
      add_value(name, value)
    end

    def u2(name)
      value = u1_intern << 8 + u1_intern
      add_value(name, value)
    end

    private
      def u1_intern
	@data.shift
      end

      def add_value(name, value)
	@packet.instance_variable_set('@' + name, value)
      end
  end
end

# Too long, make #packet a top-level method
# Also, remove data as a param, call top-level #u1
SimplePackets::PacketDefinition.packet 37 do |data|
  data.u1 :some_info
  data.u1 :other_info
end

# Possible to use brackets for more C-style structs as well:
# packet 37 { |data|
#   data.u1 ...
# }

data = [1, 4, 2, 6, 8, 2, 5, 5]
packet = SimplePackets::PacketDefinition.do 37, data

puts packet.inspect # -> #<SimplePackets::Packet:0x0000000238bdf8 @some_info=1, @other_info=4>
