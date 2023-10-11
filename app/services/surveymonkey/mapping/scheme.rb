module Surveymonkey
  class Mapping
    class Scheme
      attr_reader :name, :page_id, :question_id, :type, :params

      def initialize params
        @name = params[:name].to_sym
        @page_id = params[:page_id]
        @question_id = params[:question_id]
        @type = params[:type].to_sym
        @params = params[:params] || {}
      end
    end
  end
end