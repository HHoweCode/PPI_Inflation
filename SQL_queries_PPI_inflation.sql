-- Checking the highest percentage of the forecasted change--
SELECT * 
FROM inflation.ppi_dataset
WHERE forecast_percent_change > 10.0
ORDER BY forecast_percent_change desc;

--Trend analysis by category--
--See how average forecasted changes evolve over time for a given product category--
SELECT 
    producer_price_index_item,
    year_being_forecast,
    AVG(forecast_percent_change) AS avg_forecast_change
FROM inflation.ppi_dataset
WHERE attribute = 'Mid point of prediction interval'
GROUP BY producer_price_index_item, year_being_forecast
ORDER BY producer_price_index_item, year_being_forecast;

--Compare forecast bounds--
--Compare the mid-point vs upper/lower bound to analyze forecast volatility--
SELECT 
    year_being_forecast,
    producer_price_index_item,
    MAX(CASE WHEN attribute = 'Upper bound of prediction interval' THEN forecast_percent_change END) AS upper_bound,
    MAX(CASE WHEN attribute = 'Mid point of prediction interval' THEN forecast_percent_change END) AS mid_point,
    MAX(CASE WHEN attribute = 'Lower bound of prediction interval' THEN forecast_percent_change END) AS lower_bound
FROM inflation.ppi_dataset
GROUP BY year_being_forecast, producer_price_index_item
ORDER BY year_being_forecast, producer_price_index_item;

--Outlier detection--
--Identify forecasts that are extreme or suspicious--
SELECT *
FROM inflation.ppi_dataset
WHERE ABS(forecast_percent_change) > 20
ORDER BY forecast_percent_change DESC;

--YoY forecast change for items--
--Track how forecasts changed from year to year for an item--
SELECT 
    producer_price_index_item,
    year_being_forecast,
    AVG(forecast_percent_change) AS avg_change
FROM inflation.ppi_dataset
WHERE attribute = 'Mid point of prediction interval'
GROUP BY producer_price_index_item, year_being_forecast
HAVING COUNT(*) > 1
ORDER BY producer_price_index_item, year_being_forecast;

--Distribution by forecast month--
--Forecast activity month to month--
SELECT 
    month_of_forecast,
    COUNT(*) AS num_forecasts
FROM inflation.ppi_dataset
GROUP BY month_of_forecast
ORDER BY num_forecasts DESC;


