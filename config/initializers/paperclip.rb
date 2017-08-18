# Paperclip.options[:content_type_mappings] = { csv: 'application/vnd.ms-excel' }

require 'paperclip/media_type_spoof_detector'
module Paperclip
  class MediaTypeSpoofDetector
    def spoofed?
      false
    end
  end
end
