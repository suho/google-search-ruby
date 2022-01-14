# frozen_string_literal: true

module API
  module V1
    class KeywordsController < ApplicationController
      include Pagy::Backend

      def create
        if save_keywords
          SearchKeywordsJob.perform_later(keywords_form.keyword_ids)

          render status: :created
        else
          render_error(
            detail: keywords_form.errors.full_messages.first,
            code: :invalid_file,
            status: :unprocessable_entity)
        end
      end

      private

      def save_keywords
        keywords_form.save(params[:keywords_file])
      end

      def keywords_form
        @keywords_form ||= KeywordsForm.new(current_user)
      end

      def keywords_query
        @keywords_query ||= KeywordsQuery.new(current_user.keywords, permitted_params)
      end

      def permitted_params
        params.permit(:keyword)
      end
    end
  end
end
