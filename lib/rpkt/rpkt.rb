module SimplePackets
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

def define_packet(id, &block)
  @packet_defs ||= []
  @packet_defs[id] = block
end

def process_packet(id, data)
  data = SimplePackets::DataContainer.new(data)
  data.instance_eval &@packet_defs[id]
  data.packet
end
