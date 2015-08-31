require_relative 'support/bootstrap'

describe Lighthouse::Repository do

  let(:connection) { Faraday.new }
  let(:repository) { Lighthouse::Repository.connect(connection) }

  describe 'when queried with less than 3 characters' do

    it 'raises ArgumentError' do
      proc { repository.find('12') }.must_raise ArgumentError
    end

  end

  describe 'when repository server is down' do


    it 'raises RuntimeError' do

      connection.expects(:get)
          .with('torrents', q: 'torrent name')
          .raises(Faraday::ConnectionFailed.new('Server down'))

      proc { repository.find('torrent name') }.must_raise RuntimeError

    end

  end

  describe 'when repository server responds with the unsuccessful response' do

    it 'raises RuntimeError' do

      connection.expects(:get)
          .with('torrents', q: 'torrent name')
          .returns(Faraday::Response.new(status: 500))

      proc { repository.find('torrent name') }.must_raise RuntimeError

    end

  end


end