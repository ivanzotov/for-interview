module Surveymonkey
  class WebhookCallback
    attr_reader :name,
                :filter_type,
                :filter_id,
                :event_type,
                :event_id,
                :event_datetime,
                :object_type,
                :object_id,
                :resources

    def self.from_action_parameters params
      WebhookCallback.new(params.permit!.to_h)
    end

    def self.from_params params
      WebhookCallback.new(params)
    end

    def to_params
      {
        name: @name,
        filter_type: @filter_type,
        filter_id: @filter_id,
        event_type: @event_type,
        event_id: @event_id,
        event_datetime: @event_datetime,
        object_type: @object_type,
        object_id: @object_id,
        resources: @resources,
      }
    end

    def initialize params
      @name = params[:name]
      @filter_type = params[:filter_type]
      @filter_id = params[:filter_id]
      @event_type = params[:event_type]
      @event_id = params[:event_id]
      @event_datetime = params[:event_datetime]
      @object_type = params[:object_type]
      @object_id = params[:object_id]
      @resources = params[:resources]
    end

    def valid?
      error.nil?
    end

    def error
      if @name.blank?
        "name must be present"
      elsif @resources.blank?
        "resources must be present"
      elsif !@resources.is_a?(Hash)
        "resources must be a hash"
      elsif @resources.dig(:respondent_id).blank?
        "resources.respondent_id must be present"
      elsif @resources.dig(:survey_id).blank?
        "resources.survey_id must be present"
      end
    end
  end
end