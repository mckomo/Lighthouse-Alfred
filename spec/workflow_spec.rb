require_relative 'support/bootstrap'
require_relative 'support/stub_factory'


describe Lighthouse::Workflow do


  it 'creates item with given message' do

    workflow =  Lighthouse::Workflow.message('Test message')

    workflow.items.first.title.must_equal 'Test message'

  end

  it 'enables to alternate message item with lambda' do

    workflow = Lighthouse::Workflow.message('Test message') do |item|
      item.subtitle = 'Test subtitle'
    end

    workflow.items.first.subtitle.must_equal 'Test subtitle'

  end

  let(:torrents) { 10.times.map { StubFactory.torrent } }

  it 'creates list with torrent items' do

    workflow = Lighthouse::Workflow.list(torrents)

    workflow.items.length.must_equal 10

  end

  describe 'torrent item' do

    let(:torrent) { torrents.first }
    let(:torrent_item) { Lighthouse::Workflow.list(torrents).items.first }

    it 'has torrent name as the title' do
      torrent_item.title.must_equal torrent['name']
    end

    it 'has torrent hash as the uid' do
      torrent_item.uid.must_equal torrent['hash']
    end

    it 'has torrent in the JSON format as argument' do
      torrent_item.arg.must_equal JSON.generate(torrent)
    end

    it 'has category in the subtitle' do
      torrent_item.subtitle.must_match /#{torrent['category']}/
    end

    it 'has seeds number in the subtitle' do
      torrent_item.subtitle.must_match /Seeds\: [[:digit:]]+/
    end

    it 'has peers number in the subtitle' do
      torrent_item.subtitle.must_match /Peers\: [[:digit:]]+/
    end

    it 'has torrent size in the subtitle' do
      torrent_item.subtitle.must_match /Size\: [[:digit:]]+\.[[:digit:]]+ MB/
    end

    it 'has torrent upload time in the subtitle' do
      torrent_item.subtitle.must_match /Uploaded at\: [[:digit:]]{4}-[[:digit:]]{2}-[[:digit:]]{2} [[:digit:]]{2}\:[[:digit:]]{2}\:[[:digit:]]{2}/
    end

  end


end