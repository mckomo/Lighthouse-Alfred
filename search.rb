require_relative 'lib/lighthouse'

# set up the workflow
query = ARGV[0] || ''

begin
  torrents = Lighthouse::Repository.connect.find(query)
rescue ArgumentError => err
  workflow = Lighthouse::Workflow.message('Enter torrent\'s name') { |msg| msg.subtitle = err.message }
rescue RuntimeError => err
	workflow = Lighthouse::Workflow.message('Error has occurred') { |msg| msg.subtitle = err.message }
else
  workflow = Lighthouse::Workflow.list(torrents)
end

workflow.output!
