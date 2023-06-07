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


SELECT id, created_at as "createdAt", sensor_type as "sensorType", rolling_avg as "humidity"
              FROM (SELECT *,
                          AVG(humidity) OVER (ORDER BY created_at ROWS BETWEEN 4 PRECEDING AND CURRENT ROW) AS rolling_avg,
                          ROW_NUMBER() OVER (ORDER BY created_at DESC)                                      AS row_num
                    FROM sensor_data WHERE sensor_type = 'FIRST') sub
              WHERE row_num % 12 = 1
              ORDER BY created_at DESC
              LIMIT 10;


SELECT s1.id                  as "measurement_id",
       s1.created_at          as "measured_at",
       s1.humidity            as "s1_humidity",
       s2.humidity            as "s2_humidity",
       s3.humidity            as "s3_humidity",
       wd.weather_measured_at as "weather_measured_at",
       wd.humidity            as "weather_humidity",
       wd.precipitation_mm    as "weather_precipitation",
       wd.cloud               as "weather_cloud",
       wd.temperature_c       as "weather_temperature",
       wd.uv_index            as "weather_uv_index",
       wd.pressure_mbar       as "weather_pressure"
FROM (SELECT * FROM sensor_data WHERE sensor_type = 'FIRST') s1
         JOIN (SELECT created_at, humidity FROM sensor_data WHERE sensor_type = 'SECOND') s2
              ON s2.created_at BETWEEN s1.created_at - interval '1 minute' AND s1.created_at + interval '1 minute'
         JOIN (SELECT created_at, humidity FROM sensor_data WHERE sensor_type = 'THIRD') s3
              ON s3.created_at BETWEEN s1.created_at - interval '1 minute' AND s1.created_at + interval '1 minute'
         LEFT JOIN weather_data wd on wd.id = s1.weather_id
ORDER BY s1.created_at DESC
LIMIT null;

