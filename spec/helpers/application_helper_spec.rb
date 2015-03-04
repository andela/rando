require 'rails_helper'

describe ApplicationHelper do
  describe '#formatted_date' do
    let(:date) { Date.new(2015, 2, 19) }

    context 'separator is defined' do
      subject { helper.formatted_date(date, separator).to_s }

      context 'dash separator' do
        let(:separator) { '-' }
        it { is_expected.to eq('2015-02-19') }
      end

      context 'slash separator' do
        let(:separator) { '/' }
        it { is_expected.to eq('2015/02/19') }
      end
    end

    context 'separator is undefined' do
      subject { helper.formatted_date(date).to_s }
      it { is_expected.to eq('2015-02-19') }
    end
  end

  describe '#capitalize_name' do
    let(:name) { 'example' }
    subject { helper.capitalize_name(name).to_s }

    it { is_expected.to eq('Example') }
  end
end