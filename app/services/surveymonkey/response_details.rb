module Surveymonkey
  class ResponseDetails
    attr_reader :pages

    def self.fetch(survey_id:, id:)
      response = Api.authorized.get Api::RESPONSE_DETAILS % { survey_id: survey_id, id: id }
      ResponseDetails.from_json(response.body)
    end

    def self.from_json(json)
      ResponseDetails.new(JSON.parse(json, symbolize_names: true))
    end

    def initialize params
      @pages = params[:pages]
    end

    def answer_by_scheme(scheme)
      page = @pages.find { |it| it[:id] == scheme.page_id }
      answer = { scheme.name => nil }
      return answer if page&.dig(:questions).blank?
      question = page[:questions].find { |it| it[:id] == scheme.question_id }
      return answer if question&.dig(:answers).blank?

      answer[scheme.name] =
        case scheme.type
        when :text
          question[:answers].first[:text]
        when :contacts
          row = question[:answers].find { |it| it[:row_id] == scheme.params[:row_id] }
          row&.dig(:text)
        when :single_choice
          row = question[:answers].first
          id = (row[:choice_id] || row[:other_id])&.to_sym
          scheme.params[:choices][id]
        end

      answer
    end

    def answers_by_mapping(mapping)
      answers = {}
      mapping.schemes.each do |scheme|
        answers.merge! answer_by_scheme(scheme)
      end
      answers
    end
  end
end