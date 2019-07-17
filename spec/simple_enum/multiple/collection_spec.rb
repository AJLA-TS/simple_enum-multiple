# Frozen-String-Literal: true
# Encoding: utf-8

require 'spec_helper'

describe SimpleEnum::Multiple::Proxy do
  let(:enum) do
    SimpleEnum::Enum.new(:favorites,
      'iphone' => 0,
      'macbook' => 2,
      'ipad' => 1
    )
  end

  subject { described_class.new(favorite_cds, accessor) }
  let(:accessor) { SimpleEnum::Multiple::Accessors.new(:favorites, enum) }
  let(:favorite_cds) { [] }

  it 'is considered as empty by default' do
    expect(subject).to be_empty
    expect(subject).to_not be_present
    expect(subject).to be_blank
  end

  context '#push' do
    it 'pushes 0, 1 to collection' do
      expect(subject.push(0, 1)).to eq %i[iphone ipad]
      expect(favorite_cds).to eq [0, 1]
      expect(subject).to_not(
        be_empty
      )
    end

    it 'pushes :iphone, :macbook to collection' do
      expect(subject.push(:iphone, :macbook)).to eq %i[iphone macbook]
      expect(favorite_cds).to eq [
        0, 2
      ]
    end

    it 'pushes :other to collection' do
      expect(subject.push(:other)).to eq []
      expect(favorite_cds).to eq [
        #
      ]
    end

    it 'pushes :other, 1 to collection' do
      expect(subject.push(:other, 1)).to eq [:ipad]
      expect(favorite_cds).to eq [
        1
      ]
    end

    context do
      let(:favorite_cds) { [0] }

      it 'pushes 1, 2 to collection with [0]' do
        expect(subject.push(1, 2)).to eq %i[iphone ipad macbook]
        expect(favorite_cds).to eq [
          0, 1, 2
        ]
      end

      it 'pushes :iphone, :ipad to collection with [0]' do
        expect(subject.push(:iphone, :ipad)).to eq %i[iphone ipad]
        expect(favorite_cds).to eq [
          0, 1
        ]
      end

      it 'pushes :other to collection with [0]' do
        expect(subject.push(:other)).to eq [:iphone]
        expect(favorite_cds).to eq [
          0
        ]
      end
    end
  end

  context '#delete' do
    let(:favorite_cds) { [0] }
    it 'deletes 1 to collection with [0]' do
      expect(subject.delete(1)).to eq nil
      expect(favorite_cds).to eq [
        0
      ]
    end

    it 'deletes :ipad to collection with [0]' do
      expect(subject.delete(:iphone)).to eq :iphone
      expect(favorite_cds).to eq [
        #
      ]
    end
  end
end
