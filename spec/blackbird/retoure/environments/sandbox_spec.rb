RSpec.describe Blackbird::Retoure::Environments::Sandbox do
  it '#endpoint_url' do
    expect(described_class.new.endpoint_url).to eq 'https://cig.dhl.de/services/sandbox/rest/returns/'
  end

  it '#authentication_data' do
    expect(described_class.new.authentication_data).to be_a Array
    expect(described_class.new.authentication_data.size).to eq 2
    expect(described_class.new.authentication_data)
      .to eq(
        [
          ::Blackbird::Retoure.configuration.username,
          ::Blackbird::Retoure.configuration.password
        ]
      )
  end

  it '#dpdhl_token' do
    expect(described_class.new.dpdhl_token).to eq 'MjIyMjIyMjIyMl9jdXN0b21lcjp1QlFiWjYyIVppQmlWVmJoYw=='
  end
end
