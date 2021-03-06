# Frozen-String-Literal: true
# rubocop:disable Layout/MultilineMethodCallBraceLayout
# Encoding: utf-8

require 'spec_helper'

describe SimpleEnum::Multiple::Accessors do
  let :enum do
    SimpleEnum::Enum.new(:favorites,
      'iphone' => 0,
      'macbook' => 2,
      'ipad' => 1
    )
  end

  fake_multiple_model(:klass)
  let(:object) do
    klass.new
  end

  context 'MultipleAccessor' do
    subject do
      described_class.new(
        :favorites, enum
      )
    end

    context '#source' do
      it 'returns favorite_cds when source is nil' do
        r = described_class.new(:favorites, enum, nil).source
        expect(r).to eq(
          'favorite_cds'
        )
      end
    end

    context '#read' do
      shared_examples_for 'reading a multiple enum' do
        it 'returns SimpleEnum::Proxy' do
          r = subject.read(object)
          expect(r).to be_a(
            SimpleEnum::Multiple::Proxy
          )
        end

        it 'returns [] then favorite_cds is nil' do
          r = subject.read(object)
          expect(r).to eq [
            #
          ]
        end

        it 'returns [] then favorite_cds is []' do
          r = subject.read(klass.new([]))
          expect(r).to eq [
            #
          ]
        end

        it 'returns [:iphone] when favorite_cds is [0]' do
          r = subject.read(klass.new([0]))
          expect(r).to eq [
            :iphone
          ]
        end

        it 'returns [:iphone, :ipad] when favorite_cds is [0, 1]' do
          r = subject.read(klass.new([0, 1]))
          expect(r).to eq %i[
            iphone
            ipad
          ]
        end
      end

      it_behaves_like 'reading a multiple enum'
      context 'with name == source' do
        subject { described_class.new(:favorite_cds, enum, :favorite_cds) }
        it_behaves_like 'reading a multiple enum'
      end
    end

    context '#write' do
      shared_examples_for 'writing a multiple enum' do
        it 'writes [] to object with nil' do
          expect(subject.write(object, nil)).to eq []
          expect(object.favorite_cds).to eq [
            #
          ]
        end

        it 'writes [] to object with []' do
          expect(subject.write(object, [])).to eq []
          expect(object.favorite_cds).to eq [
            #
          ]
        end

        it 'writes [1] to object with [:ipad]' do
          expect(subject.write(object, [:ipad])).to eq [:ipad]
          expect(object.favorite_cds).to eq [
            1
          ]
        end

        it 'writes [0, 1] to object with ["iphone", "ipad"]' do
          expect(subject.write(object, %w[iphone ipad])).to eq %w[iphone ipad]
          expect(object.favorite_cds).to eq [
            0, 1
          ]
        end

        it 'writes [0, 1] to object with [0, 1]' do
          expect(subject.write(object, [0, 1])).to eq [0, 1]
          expect(object.favorite_cds).to eq [
            0, 1
          ]
        end

        it 'writes [0, 1] to object with [0, "ipad"]' do
          expect(subject.write(object, [0, 'ipad'])).to eq [0, 'ipad']
          expect(object.favorite_cds).to eq [
            0, 1
          ]
        end

        it 'writes [] to object with [:other]' do
          expect(subject.write(object, [:other])).to eq []
          expect(object.favorite_cds).to eq [
            #
          ]
        end

        it 'writes [0] to object with [0, :other]' do
          expect(subject.write(object, [0, :other])).to eq [0]
          expect(object.favorite_cds).to eq [
            0
          ]
        end
      end

      it_behaves_like 'writing a multiple enum'
      context 'with name == source' do
        subject { described_class.new(:favorite_cds, enum, :favorite_cds) }
        it_behaves_like 'writing a multiple enum'
      end
    end

    context '#selected?' do
      it 'returns false when favorite_cds is nil' do
        expect(subject.selected?(object)).to be_falsey
        expect(subject.selected?(object, :iphone)).to(
          be_falsey
        )
      end

      it 'returns true when favorite_cds is != nil' do
        expect(subject.selected?(klass.new([0]))).to be_truthy
        expect(subject.selected?(klass.new([0, 1]))).to(
          be_truthy
        )
      end

      it 'returns true when favorite_cds includes 0 and :iphone is passed' do
        expect(subject.selected?(klass.new([0]), :iphone)).to be_truthy
        expect(subject.selected?(klass.new([0, 1]), :iphone)).to(
          be_truthy
        )
      end

      it 'returns false when favorite_cds includes 0 and :macbook is passed' do
        expect(subject.selected?(klass.new([0]), :macbook)).to be_falsey
        expect(subject.selected?(klass.new([0, 1]), :macbook)).to(
          be_falsey
        )
      end

      it 'returns false when favorite_cds includes 0 and :other is passed' do
        expect(subject.selected?(klass.new([0]), :other)).to(
          be_falsey
        )
      end
    end

    context '#changed?' do
      it 'delegates to attribute_changed?' do
        m = 'favorite_cds'
        expect(object).to receive(:attribute_changed?).with(m) { true }
        expect(subject.changed?(object)).to(
          be_truthy
        )
      end
    end

    context '#was' do
      it 'delegates to attribute_was and resolves symbol' do
        expect(object).to receive(:attribute_was).with('favorite_cds') { [1] }
        expect(subject.was(object)).to eq [
          :ipad
        ]
      end
    end

    shared_examples_for 'dirty attributes on ActiveModel' do
      it 'does not raise error "private method attribute_was called"' do
        object.favorites = %i[ipad macbook]
        expect(object.favorites_changed?).to be_truthy
        expect(object.favorites_was).to eq [
          #
        ]
      end
    end

    shared_examples_for '#scope' do
      it 'returns an ActiveRecord::Relation' do
        expect(accessor.scope(klass, 1)).to be_a(ActiveRecord::Relation)
        expect(klass.ipads).to be_a(
          ActiveRecord::Relation
        )
      end
    end

    context 'bitwise accessor', active_record: true do
      f = %i[iphone ipad macbook]
      let(:object) { klass.create }
      let(:accessor) { klass.favorites_accessor }
      fake_active_record(:klass) { as_enum :favorites, f, accessor: :bitwise }
      it_behaves_like 'dirty attributes on ActiveModel'
      it_behaves_like '#scope'
    end
  end
end
