require 'base64'

RSpec.describe Blackbird::Retoure::Environments::Production do
  it '#endpoint_url' do
    expect(described_class.new.endpoint_url).to eq 'https://cig.dhl.de/services/production/rest/returns/'
  end

  it '#authentication_data' do
    expect(described_class.new.authentication_data).to be_a Array
    expect(described_class.new.authentication_data.size).to eq 2
    expect(described_class.new.authentication_data)
      .to eq(
        [
          ::Blackbird::Retoure.configuration.app_id,
          ::Blackbird::Retoure.configuration.app_token
        ]
      )
  end

  it '#dpdhl_token' do
    expect(described_class.new.dpdhl_token)
      .to eq Base64.strict_encode64(
        "#{::Blackbird::Retoure.configuration.username}:\
#{::Blackbird::Retoure.configuration.password}"
      )
  end
end
