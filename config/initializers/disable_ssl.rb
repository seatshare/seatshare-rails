# Yes, I hate me too.

require 'openssl'
silence_warnings do
  OpenSSL::SSL.const_set(:VERIFY_PEER, OpenSSL::SSL::VERIFY_NONE)
end