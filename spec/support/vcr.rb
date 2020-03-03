require 'vcr'

VCR.configure do |c|
  c.configure_rspec_metadata!
  c.debug_logger = File.open('vcr.log', 'w')
  c.cassette_library_dir = 'spec/fixtures/vcr_cassettes'
  c.hook_into :webmock

  c.filter_sensitive_data('<HTTP_BASIC_AUTH>') do
    "#{::Blackbird::Retoure.configuration.username}:#{CGI::escape(::Blackbird::Retoure.configuration.password) }"
  end
end
