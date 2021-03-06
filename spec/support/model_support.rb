# Frozen-String-Literal: true
# Encoding: utf-8

require 'active_record'

module ModelSupport
  def self.included(base)
    base.extend ClassMethods
  end

  module ClassMethods
    def fake_active_record(name, &block)
      let(name) {
        Class.new(ActiveRecord::Base) do
          self.table_name = 'dummies'
          instance_eval(
            &block
          )
        end
      }
    end

    def fake_multiple_model(name, *fields, &block)
      fields << :favorite_cds
      let name do
        Struct.new(*fields) do
          extend ActiveModel::Translation
          instance_eval(&block) if block_given?
          extend SimpleEnum::Attribute

          def self.model_name
            @model_name ||= ActiveModel::Name.new(
              self, nil, 'FakeModel'
            )
          end
        end
      end
    end

    def fake_model(name, *fields, &block)
      fields << :gender_cd
      let name do
        Struct.new(*fields) do
          extend ActiveModel::Translation
          instance_eval(&block) if block_given?
          extend SimpleEnum::Attribute

          def self.model_name
            @model_name ||= ActiveModel::Name.new(
              self, nil, 'FakeModel'
            )
          end
        end
      end
    end
  end
end
