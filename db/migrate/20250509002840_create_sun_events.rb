class CreateSunEvents < ActiveRecord::Migration[8.0]
  def change
    create_table :sun_events do |t|
      t.string :location
      t.date :date
      t.datetime :sunrise_time
      t.datetime :sunset_time
      t.datetime :golden_hour

      t.timestamps
    end
  end
end
