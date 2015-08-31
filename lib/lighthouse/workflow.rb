require 'digest'
require 'alfredo'

module Lighthouse

	class Workflow

		class << self

			def list(torrents)
				::Alfredo::Workflow.new.tap do |workflow|
					torrents.each { |t| workflow << prepare_torrent(t) }
				end
      end

      def message(message)
        ::Alfredo::Workflow.new.tap do |workflow|
          workflow << prepare_message(message).tap do |item|
            yield item if block_given?
          end
        end
      end

      private

			def prepare_torrent(t)
        ::Alfredo::Item.new({
          :title 		  => t['name'],
          :subtitle   => format_subtitle(t),
          :uid 	      => t['hash'],
          :arg 	      => JSON.generate(t),
        })
			end

      def format_subtitle(torrent)
        [
          torrent['category'],
          format_seeds(torrent['seedCount']),
          format_peers(torrent['peerCount']),
          format_size(torrent['size']),
          format_upload_date(torrent['uploadedAt'])
        ]
        .join(' · ')
      end

      def format_peers(peerCount)
        'Peers: ' + peerCount.to_s
      end

      def format_seeds(seedCount)
        'Seeds: ' + seedCount.to_s
      end

      def format_size(bytes)
        'Size: ' + calculate_mb(bytes).round(2).to_s + ' MB'
      end

      def format_upload_date(date)
        'Uploaded at: ' + format_date(date)
      end

      def format_date(date)
        DateTime.parse(date).strftime('%Y-%m-%d %H:%M:%S')
      end

      def calculate_mb(bytes)
        bytes / 1024.0 ** 2
      end

      def prepare_message(message)
        ::Alfredo::Item.new({
          :title 		=> message,
          :uid      => hash(message),
          :valid    => false
        })
      end

      def hash(message)
        ::Digest::MD5.hexdigest(message)
      end

		end
  end
end