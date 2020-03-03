require 'yaml'

gem_spec = Gem::Specification.find_by_name('blackbird-retoure')
dev_environment_path = File.join(gem_spec.gem_dir, 'spec', 'support', 'dev_environments')
puts File.join(dev_environment_path, "#{ENV['USER']}.yml")
dev_environment_config = YAML.load_file(
  if File.exists?(File.join(dev_environment_path, "#{ENV['USER']}.yml"))
    File.join(dev_environment_path, "#{ENV['USER']}.yml")
  else
    File.join(dev_environment_path, 'default.yml')
  end
)

Blackbird::Retoure.configure do |config|
  config.username = dev_environment_config['dhl']['username']
  config.password = dev_environment_config['dhl']['password']
  config.environment = :sandbox
end
