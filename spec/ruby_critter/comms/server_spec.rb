# frozen_string_literal: true

RSpec.describe RubyCritter::Comms::Server do
  subject(:server) do
    described_class.new(configuration: configuration, socket: socket, options: options)
  end

  after do
    server.stop
  end

  let(:options) { { verbose: true, debug: true } }
  let(:configuration) { RubyCritter::IO::Configuration.new }
  let(:socket) do
    build(:socket, options: options).tap do |socket|
      socket.bind(configuration.host, configuration.port)
    end
  end

  describe '#inlitialize' do
    it 'instantiates a Server object' do
      expect(server).to be_a described_class
    end
  end

  describe '#start' do
    it 'starts off with the server not running' do
      expect(server.running?).to be false
    end

    it 'starts the server' do
      expect(server.start).to be_a Thread
      expect(server.running?).to be true
    end
  end

  describe '#stop' do
    before do
      server.start
    end

    it 'starts off with the server running' do
      expect(server.running?).to be true
    end

    it 'stops the server' do
      server.stop
      expect(server.running?).to be false
    end
  end

  context 'when processing commands' do
    before do
      server.start
    end

    after do
      client.close
    end

    let(:client) { build(:client, options: options) }

    context 'when processing a non-quit (PING) command' do
      it 'sends an acknowledgment back to the client' do
        puts output = capture_stdout_and_strip_escapes { client.ping }
        expect(output).to match(/RubyCritter \[client .+\] > response received \(ACK: ping\)/)
      end
    end

    context 'when processing a QUIT command' do
      it 'sends an acknowledgment back to the client' do
        puts output = capture_stdout_and_strip_escapes { client.quit }
        expect(output).to match(/RubyCritter \[client .+\] > response received \(ACK: quit\)/)
      end
    end

    context 'when errors are raised' do
      context 'when an IOError error is raised' do
        before do
          allow(socket).to receive(:send).and_raise(IOError)
        end

        it 'prints the error to stderr' do
          puts output = capture_stderr_and_strip_escapes { client.ping }
          expect(output).to match(/RubyCritter \[server .+\] > Error: IOError/)
        end
      end

      context 'when an Errno::ECONNRESET error is raised' do
        before do
          allow(socket).to receive(:send).and_raise(Errno::ECONNRESET)
        end

        it 'prints the error to stderr' do
          puts output = capture_stderr_and_strip_escapes { client.ping }
          expect(output).to match(/RubyCritter \[server .+\] > Error: Connection reset by peer/)
        end
      end

      context 'when an Errno::EADDRINUSE error is raised' do
        before do
          allow(socket).to receive(:send).and_raise(Errno::EADDRINUSE)
        end

        it 'prints the error to stderr' do
          puts output = capture_stderr_and_strip_escapes { client.ping }
          expect(output).to match(/RubyCritter \[server .+\] > Error: Address already in use/)
        end
      end

      context 'when an JSON::ParserError error is raised' do
        before do
          client
        end

        it 'prints the error to stderr' do
          allow(JSON).to receive(:parse).and_raise(JSON::ParserError)
          puts output = capture_stderr_and_strip_escapes { client.ping }
          expect(output).to match(/RubyCritter \[server .+\] > Error: Unable to parse command/)
        end
      end

      context 'when an IO::WaitReadable error is raised' do
        before do
          allow(socket).to receive(:recvfrom_nonblock).and_raise(Errno::EAGAIN)
        end

        it 'prints the error to stderr' do
          pending 'This is not working. Find out a way to test this properly.'
          puts output = capture_stderr_and_strip_escapes { client.ping }
          expect(output).to match(/RubyCritter \[server .+\] > Error: Operation would block/)
        end
      end

      context 'when an SocketError error is raised' do
        before do
          allow(socket).to receive(:send).and_raise(SocketError)
        end

        it 'prints the error to stderr' do
          puts output = capture_stderr_and_strip_escapes { client.ping }
          expect(output).to match(/RubyCritter \[server .+\] > Error: Socket Error/)
        end
      end
    end
  end
end
