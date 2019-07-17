require 'bundler/setup'
require 'active_record'
require 'rspec'

if ENV['CODECLIMATE_REPO_TOKEN']
  require 'codeclimate-test-reporter'
  CodeClimate::TestReporter.start
end

require 'simple_enum'
require 'simple_enum/multiple'
require 'support/i18n_translation_support'
require 'support/active_record_support'
require 'support/model_support'

I18n.enforce_available_locales = false
RSpec.configure do |config|
  config.include I18nTranslationSupport, i18n: true
  config.include ActiveRecordSupport, active_record: true
  config.include ModelSupport
end
