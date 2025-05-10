module SunEvents
    class Fetcher
      include HTTParty
      base_uri 'https://api.sunrisesunset.io/json'
  
      def self.call(location, start_date, end_date)
        start_date_obj = Date.parse(start_date)
        end_date_obj = Date.parse(end_date)
  
        (start_date_obj..end_date_obj).map do |date|
          # Check DB first
          existing = SunEvent.find_by(location: location, date: date)
          next existing if existing
  
          # Otherwise fetch and store
          response = fetch_from_api(location, date)
          raise "API error: #{response['status']}" unless response['status'] == 'OK'
  
          sunrise = DateTime.parse(response['results']['sunrise'])
          sunset = DateTime.parse(response['results']['sunset'])
          golden_hour = calculate_golden_hour(sunrise, sunset)
  
          SunEvent.create!(
            location: location,
            date: date,
            sunrise_time: sunrise,
            sunset_time: sunset,
            golden_hour: golden_hour
          )
        end.compact  # remove nils (from 'next existing')
      end
  
      def self.fetch_from_api(location, date)
        coords = geocode(location)
        response = get('', query: {
          lat: coords[:lat],
          lng: coords[:lng],
          date: date
        })
        JSON.parse(response.body)
      end
  
      def self.geocode(location)
        case location.downcase
        when 'lisbon'
          { lat: 38.7169, lng: -9.1399 }
        when 'berlin'
          { lat: 52.5200, lng: 13.4050 }
        when 'new york'
          { lat: 40.7128, lng: -74.0060 }
        when 'london'
          { lat: 51.5074, lng: -0.1278 }
        when 'tokyo'
          { lat: 35.6895, lng: 139.6917 }
        when 'sydney'
          { lat: -33.8688, lng: 151.2093 }
        when 'paris'
          { lat: 48.8566, lng: 2.3522 }
        when 'buenos aires'
          { lat: -34.6037, lng: -58.3816 }
        when 'cairo'
          { lat: 30.0444, lng: 31.2357 }
        when 'nairobi'
          { lat: -1.2921, lng: 36.8219 }
        else
          raise "Invalid location. Supported locations: Lisbon, Berlin, New York, London, Tokyo, Sydney, Paris, Buenos Aires, Cairo, Nairobi"
        end
      end
  
      def self.calculate_golden_hour(sunrise, sunset)
        sunrise + (1.0 / 24) # 1 hour after sunrise
      end
    end
  end
  