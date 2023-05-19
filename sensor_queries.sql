SELECT sd.id                  as "measurement_id",
       sd.sensor_type         as "sensor",
       sd.created_at          as "measured_at",
       sd.humidity            as "humdity",
       wd.weather_measured_at as "weather_measured_at",
       wd.humidity            as "weather_himidity",
       wd.precipitation_mm    as "weather_precipitation",
       wd.cloud               as "weather_cloud",
       wd.temperature_c       as "weather_temperature",
       wd.uv_index            as "weather_uv_index",
       wd.pressure_mbar       as "weather_pressure"
FROM sensor_data sd
         LEFT JOIN weather_data wd on wd.id = sd.weather_id
ORDER BY sd.created_at ASC;



-- DELETE FROM weather_data WHERE TRUE;
-- DELETE FROM sensor_data WHERE TRUE;