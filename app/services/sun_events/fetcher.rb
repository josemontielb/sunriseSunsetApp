module SunEvents
    class Fetcher
      include HTTParty
      base_uri 'https://api.sunrisesunset.io/json'
  
      def self.call(location, start_date, end_date)
        start_date_obj = Date.parse(start_date)
        end_date_obj = Date.parse(end_date)
  
        (start_date_obj..end_date_obj).map do |date|
          existing = SunEvent.find_by(location: location, date: date)
          return existing if existing
  
          response = fetch_from_api(location, date)
  
          raise "API error: #{response['status']}" unless response['status'] == 'OK'
  
          sunrise = DateTime.parse(response['results']['sunrise'])
          sunset = DateTime.parse(response['results']['sunset'])
          golden_hour = calculate_golden_hour(sunrise, sunset)
  
          event = SunEvent.create!(
            location: location,
            date: date,
            sunrise_time: sunrise,
            sunset_time: sunset,
            golden_hour: golden_hour
          )
          event
        end
      end
  
      def self.fetch_from_api(location, date)
        response = get('', query: { 
          lat: geocode(location)[:lat], 
          lng: geocode(location)[:lng], 
          date: date 
        })
  
        JSON.parse(response.body)
      end
  
      def self.geocode(location)
        # Simulación simple, en un caso real usarías Geocoding API
        case location.downcase
        when 'lisbon'
          { lat: 38.7169, lng: -9.1399 }
        when 'berlin'
          { lat: 52.5200, lng: 13.4050 }
        else
          raise "Invalid location"
        end
      end
  
      def self.calculate_golden_hour(sunrise, sunset)
        # Golden hour simple: 1 hora después del amanecer
        sunrise + (1.0/24)
      end
    end
  end
  