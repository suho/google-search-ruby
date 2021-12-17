# frozen_string_literal: true

require 'rails_helper'

RSpec.describe KeywordsForm, type: :form do
  describe '#save' do
    context 'given no keywords file' do
      it 'returns an invalid file error' do
        form = save_file(nil)
        expect(form.errors.full_messages.first).to eq I18n.t('keywords.upload.invalid_file')
      end
    end

    context 'given an empty file' do
      it 'returns an invalid size error' do
        form = save_file('empty_keywords.csv')
        expect(form.errors.full_messages.first).to eq I18n.t('keywords.upload.invalid_size')
      end
    end

    context 'given a more than 1000 keywords file' do
      it 'returns an invalid size error' do
        form = save_file('more_than_1000_keywords.csv')
        expect(form.errors.full_messages.first).to eq I18n.t('keywords.upload.invalid_size')
      end
    end

    context 'given a non csv keywords file' do
      it 'returns an invalid extension error' do
        form = save_file('non_csv_file.rb')
        expect(form.errors.full_messages.first).to eq I18n.t('keywords.upload.invalid_extension')
      end
    end

    context 'given a valid keywords file' do
      it 'returns no error' do
        form = save_file('valid_keywords.csv')
        expect(form.errors).to be_empty
      end
    end
  end
end
