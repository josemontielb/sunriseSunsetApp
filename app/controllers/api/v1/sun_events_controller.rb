module Api
    module V1
      class SunEventsController < ApplicationController
        def index
          location = params[:location]
          start_date = params[:start_date]
          end_date = params[:end_date]
  
          return render json: { error: 'Missing parameters' }, status: :bad_request if location.blank? || start_date.blank? || end_date.blank?
  
          begin
            records = SunEvents::Fetcher.call(location, start_date, end_date)
            render json: records
          rescue StandardError => e
            render json: { error: e.message }, status: :unprocessable_entity
          end
        end
      end
    end
  end
  