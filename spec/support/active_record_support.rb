# Frozen-String-Literal: true
# rubocop:disable Style/ParallelAssignment
# Encoding: utf-8

module ActiveRecordSupport
  def self.connection
    a, d = 'sqlite3', ':memory:'
    @connection_pool ||=
      ActiveRecord::Base.establish_connection(
        adapter: a, database: d
      )

    ActiveRecord::Base.connection
  end

  def self.included(base)
    base.before do
      reset_active_record
    end
  end

  def reset_active_record
    ActiveRecordSupport.connection.create_table :dummies, force: true do |t|
      t.column :name, :string
      t.column :gender_cd, :integer
      t.column :favorite_cds, :integer
      t.column :bitwise_cds, :integer
      t.column :text_cds, :text
    end
  end
end

ActiveRecord::Base.send :extend, SimpleEnum::Attribute
ActiveRecord::Base.send :extend, SimpleEnum::Translation
