# frozen_string_literal: true

RSpec.describe RubyCritter::Comms::Client do
  subject(:client) do
    described_class.new(configuration: configuration, socket: socket, options: options)
  end

  before do
    server_thread
    sleep 1
  end

  after do
    client.quit
    server_thread.join
  end

  let(:options) { { verbose: true, debug: true } }
  let(:configuration) { RubyCritter::IO::Configuration.new }
  let(:socket) { build(:socket) }
  let(:server_thread) do
    Thread.new do
      RubyCritter::Comms::Server.new(configuration: configuration, options: options).start
    end
  end

  describe 'commands' do
    describe '#nop' do
      it 'sends a NOP command and receives an acknowledgment' do
        puts output = capture_stdout_and_strip_escapes { client.nop }
        expect(output).to include('ACK: nop')
      end
    end

    describe '#ping' do
      it 'sends a PING command and receives an acknowledgment' do
        puts output = capture_stdout_and_strip_escapes { client.ping }
        expect(output).to include('ACK: ping')
      end
    end

    describe '#state' do
      it 'sends a STATE command and receives an acknowledgment' do
        puts output = capture_stdout_and_strip_escapes { client.state(sprite_id: 'Test') }
        expect(output).to include('ACK: state')
      end
    end

    describe '#quit' do
      it 'sends a QUIT command and receives an acknowledgment' do
        puts output = capture_stdout_and_strip_escapes { client.quit }
        expect(output).to include('ACK: quit')
      end
    end

    describe '#close' do
      before do
        client.nop
      end

      it 'is running before the test' do
        expect(client.running?).to be true
      end

      it 'closes the socket' do
        client.close
        expect(client.running?).to be false
      end
    end
  end

  context 'when an IOError error is raised' do
    before do
      allow(socket).to receive(:send).and_raise(IOError)
    end

    it 'prints the error to stderr' do
      puts output = capture_stderr_and_strip_escapes { client.ping }
      expect(output).to match(/IO Error - the command .+ could not be sent/)
    end
  end

  context 'when an Errno::ECONNREFUSED error is raised' do
    before do
      allow(socket).to receive(:send).and_raise(Errno::ECONNREFUSED)
    end

    it 'prints the error to stderr' do
      puts output = capture_stderr_and_strip_escapes { client.ping }
      expect(output).to include('Connection refused')
    end
  end

  context 'when an Errno::EHOSTUNREACH error is raised' do
    before do
      allow(socket).to receive(:send).and_raise(Errno::EHOSTUNREACH)
    end

    it 'prints the error to stderr' do
      puts output = capture_stderr_and_strip_escapes { client.ping }
      expect(output).to include('Host unreachable')
    end
  end

  context 'when an Errno::ETIMEDOUT error is raised' do
    before do
      allow(socket).to receive(:send).and_raise(Errno::ETIMEDOUT)
    end

    it 'prints the error to stderr' do
      puts output = capture_stderr_and_strip_escapes { client.ping }
      expect(output).to include('Connection timed out')
    end
  end

  context 'when an IO::WaitReadable error is raised' do
    before do
      allow(socket).to receive(:recvfrom_nonblock).and_raise(Errno::EAGAIN)
    end

    it 'prints the error to stderr' do
      pending 'This is not working. Find out a way to test this properly.'
      puts output = capture_stderr_and_strip_escapes { client.ping }
      expect(output).to include('Operation would block')
    end
  end

  context 'when an SocketError error is raised' do
    before do
      allow(socket).to receive(:send).and_raise(SocketError)
    end

    it 'prints the error to stderr' do
      puts output = capture_stderr_and_strip_escapes { client.ping }
      expect(output).to include('Socket Error')
    end
  end
end
