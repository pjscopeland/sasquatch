RSpec.configure do |config|
  config.filter_run_excluding :exclude
  config.filter_run_including :focus
  config.run_all_when_everything_filtered = true
end
