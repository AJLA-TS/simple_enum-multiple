# Frozen-String-Literal: true
# Encoding: utf-8

module I18nTranslationSupport
  def self.included(base)
    base.let!(:i18n_previous_backend) { I18n.backend }
    base.let(:i18n_backend) { I18n::Backend::Simple.new }
    base.after { I18n.backend = i18n_previous_backend }
    base.before { I18n.backend = i18n_backend }
  end

  def store_translations(lang, translations)
    i18n_backend.store_translations(
      lang, translations
    )
  end
end
