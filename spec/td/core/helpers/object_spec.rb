require 'spec_helper'

describe TD::Core::Helpers::Object do
  let(:dummy_class) do
    Class.new do
      include TD::Core::Helpers::Object
      attr_accessor :foo, :bar
    end
  end

  describe '#to_hash_without_nils' do
    it 'returns the hashified object with no nils' do
      dummy_obj = dummy_class.new
      dummy_obj.foo = 'bar'
      hash = dummy_obj.to_hash_without_nils
      expect(hash).to be_a Hash
      expect(hash[:foo]).to eq dummy_obj.foo
      expect(hash.has_key? :bar).to be false
    end
  end

  describe '#copy' do
    context 'when both objects are the same class' do
      it 'copies all instance variables from an object of the same class' do
        dummy_obj = dummy_class.new
        dummy_obj.foo = 'bar'
        dummy_obj.bar = 'foo'
        target_obj = dummy_class.new
        target_obj.copy dummy_obj
        expect(target_obj.foo).to eq dummy_obj.foo
        expect(target_obj.bar).to eq dummy_obj.bar
      end
    end

    context 'when the objects are different classes\'' do
      let(:different_class) { Class.new { attr_accessor :baz } }
      it 'returns immediately' do
        different_obj = different_class.new
        different_obj.baz = 'No one will ever copy me!'
        target_obj = dummy_class.new
        target_obj.copy different_obj
        expect(target_obj.instance_variable_defined? :@baz).to be false
      end
    end
  end

  describe 'ClassMethods' do
    describe '#camelize_attributes' do
      context 'when :hash is nil' do
        it 'returns nil' do
          expect(dummy_class.camelize_attributes(nil, false)).to eq nil
        end
      end

      context 'when :hash is not a Hash' do
        it 'returns nil' do
          expect(dummy_class.camelize_attributes("hi", false)).to eq nil
        end
      end

      context 'when :hash is an empty Hash' do
        it 'returns an empty hash' do
          expect(dummy_class.camelize_attributes({})).to eq({})
        end
      end

      context 'when :hash has some keys and no :lower is sent' do
        it 'returns the camelized and symbolized keys' do
          expected_hash = { hey: "sup", lastName: "yea" }
          expect(dummy_class.camelize_attributes(hey: "sup", last_name: "yea")).to eq expected_hash
        end
      end

      context 'when :hash has some keys and :lower is false' do
        it 'returns the upper camelized and symbolized keys' do
          expected_hash = { Hey: "sup", LastName: "yea" }
          sent_hash = { hey: "sup", last_name: "yea" }
          expect(dummy_class.camelize_attributes(sent_hash, false))
            .to eq expected_hash
        end
      end

      context 'when :hash has some keys and :lower is true' do
        it 'returns the lower camelized and symbolized keys' do
          expected_hash = { hey: "sup", lastName: "yea" }
          sent_hash = { hey: "sup", last_name: "yea" }
          expect(dummy_class.camelize_attributes(sent_hash, true)).to eq expected_hash
        end
      end

      context 'when :hash has string keys' do
        it 'returns the camelized and symbolized keys' do
          expected_hash = { hey: "sup", lastName: "yea" }
          expect(dummy_class.camelize_attributes('hey' => 'sup', 'last_name' => "yea"))
            .to eq expected_hash
        end
      end
    end

    describe '#underscore_attributes' do
      context 'when :hash is nil' do
        it 'returns nil' do
          expect(dummy_class.underscore_attributes(nil)).to eq nil
        end
      end

      context 'when :hash is not a Hash' do
        it 'returns nil' do
          expect(dummy_class.underscore_attributes("hi")).to eq nil
        end
      end

      context 'when :hash is an empty Hash' do
        it 'returns an empty hash' do
          expect(dummy_class.underscore_attributes({})).to eq({})
        end
      end

      context 'when :hash has some keys' do
        it 'returns the underscored and symbolized keys' do
          expected_hash = { hey: "sup", last_name: "yea", good_morning: "okay" }
          sent_hash = { hey: "sup", lastName: "yea", GoodMorning: "okay" }
          expect(dummy_class.underscore_attributes(sent_hash)).to eq expected_hash
        end
      end

      context 'when :hash has string keys' do
        it 'returns the underscored and symbolized keys' do
          expected_hash = { hey: "sup", last_name: "yea", good_morning: "okay" }
          sent_hash = { 'hey' => "sup", 'lastName' => "yea", 'GoodMorning' => "okay" }
          expect(dummy_class.underscore_attributes(sent_hash)).to eq expected_hash
        end
      end
    end

    describe '#parse_date' do
      context 'when :date is nil' do
        it 'returns nil' do
          expect(dummy_class.parse_date(nil)).to eq nil
        end
      end

      context 'when :date is a valid date string' do
        it 'returns the date class' do
          expected_date = Date.parse("2015-01-01")
          expect(dummy_class.parse_date("2015-01-01")).to eq expected_date
        end
      end

      context 'when :date is an invalid date string' do
        it 'returns nil' do
          expect(dummy_class.parse_date("2015-051-0ad1")).to eq nil
        end
      end

      context 'when :date is already a Date class' do
        it 'returns the same date' do
          current_date = Date.parse(Time.now.to_s)
          expect(dummy_class.parse_date(current_date)).to eq current_date
        end
      end
    end

    describe '#format_date' do
      context 'when :date is nil' do
        it 'returns nil' do
          expect(dummy_class.format_date(nil)).to eq nil
        end
      end

      context 'when :date is already valid date string' do
        it 'returns the same string' do
          my_date = "2015-01-01"
          expect(dummy_class.format_date(my_date)).to eq my_date
        end
      end

      context 'when :date is an invalid date string' do
        it 'returns nil' do
          expect(dummy_class.format_date("2015-051-0ad1")).to eq nil
        end
      end

      context 'when :date is a Date class' do
        it 'returns the string format of the date' do
          my_date = DateTime.new(2015, 03, 01)
          current_date = my_date.to_date
          expected_date = "2015-03-01"
          expect(dummy_class.format_date(current_date)).to eq expected_date
        end
      end
    end
  end
end
