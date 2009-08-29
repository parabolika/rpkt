$:.unshift File.join(File.dirname(__FILE__), '..', 'lib')

require 'rpkt'

describe SimplePackets::Packet do
  before(:each) do
    @packet = SimplePackets::Packet.new
  end

  it "should dynamically define attribute getters" do
    @packet.set_var(:some_var, 5)
    @packet.some_var.should eql(5)
  end
end

describe SimplePackets::DataContainer do
  before(:each) do
    @data = SimplePackets::DataContainer.new((1..5).to_a)
  end

  it "should add a value to the packet" do
    @data.u1 :some_var
    @data.packet.should respond_to(:some_var)
  end
end

describe SimplePackets do
  after(:each) do
    @packet_defs.clear
  end

  it "should add a new packet definition to the list" do
    packet = define_packet(5) {  }
    @packet_defs.should include({ 5 => packet })
  end

  it "should process and return a packet" do
    define_packet(5) {  }
    packet = process_packet(5, (1..5).to_a)
    packet.should be_an_instance_of(SimplePackets::Packet)
  end

  it "should define and fill a new data structure" do
    define_packet(5) { u1 :some_var }
    packet = process_packet(5, (1..5).to_a)
    packet.should respond_to(:some_var)
  end
end
