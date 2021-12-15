# frozen_string_literal: true

class KeywordsFormValidator < ActiveModel::Validator
  def validate(form)
    @form = form
    validate_file
  end

  private

  attr_reader :form

  def validate_file
    if !keywords_file
      add_error(I18n.t('keywords.upload.invalid_file'))
    elsif extension_valid?
      add_error(I18n.t('keywords.upload.invalid_size')) unless size_valid?
    else
      add_error(I18n.t('keywords.upload.invalid_extension'))
    end
  end

  def add_error(message)
    form.errors.add(:base, message)
  end

  def keywords_file
    form.file
  end

  def extension_valid?
    keywords_file.content_type == 'text/csv'
  end

  def size_valid?
    CSV.read(keywords_file.path).count.between?(1, 1000)
  end
end
