#!/bin/bash
#Calls the weather API
FOREAPI=$(curl -s "https://api.openweathermap.org/data/2.5/forecast?lat=33.57786&lon=-101.85517&appid=5761cf2fc9a109756e14b564ab19ade2&units=imperial")
WAPI=$(curl -s "https://api.openweathermap.org/data/2.5/weather?lat=33.57786&lon=-101.85517&appid=5761cf2fc9a109756e14b564ab19ade2&units=imperial")
#Function to get each day of a week
get_day_of_week() {
    case $1 in
        0) echo "Sun" ;;
        1) echo "Mon" ;;
        2) echo "Tue" ;;
        3) echo "Wed" ;;
        4) echo "Thu" ;;
        5) echo "Fri" ;;
        6) echo "Sat" ;;
    esac
}
#Get the new weather data
future_data() {
    # Extract forecast data using jq
    day1_date=$(date --date="1 day" +%Y-%m-%d)
    day2_date=$(date --date="2 days" +%Y-%m-%d)
    day3_date=$(date --date="3 days" +%Y-%m-%d)

    # Extract forecast data for each day (using jq)
    day1_temp=$(echo "$FOREAPI" | jq -r ".list[] | select(.dt_txt | startswith(\"$day1_date\")) | .main.temp" | head -n 1)
    day2_temp=$(echo "$FOREAPI" | jq -r ".list[] | select(.dt_txt | startswith(\"$day2_date\")) | .main.temp" | head -n 1)
    day3_temp=$(echo "$FOREAPI" | jq -r ".list[] | select(.dt_txt | startswith(\"$day3_date\")) | .main.temp" | head -n 1)
    day1_desc=$(echo "$FOREAPI" | jq -r ".list[] | select(.dt_txt | startswith(\"$day1_date\")) | .weather[0].description" | head -n 1)
    day2_desc=$(echo "$FOREAPI" | jq -r ".list[] | select(.dt_txt | startswith(\"$day2_date\")) | .weather[0].description" | head -n 1)
    day3_desc=$(echo "$FOREAPI" | jq -r ".list[] | select(.dt_txt | startswith(\"$day3_date\")) | .weather[0].description" | head -n 1)
    # Get the names of the days
    day1_name=$(get_day_of_week $(date --date="$day1_date" +%w))
    day2_name=$(get_day_of_week $(date --date="$day2_date" +%w))
    day3_name=$(get_day_of_week $(date --date="$day3_date" +%w))

    # Print the weather forecast for the next 3 days
    echo "Now the tempature for the next three days:"
    echo "On $day1_name, $day1_date the temp will be $day1_temp°F with it being $day1_desc outside!"
    echo "On $day2_name, $day2_date the temp will be $day2_temp°F with it being $day2_desc outside!"
    echo "On $day3_name, $day3_date the temp will be $day3_temp°F with it being $day3_desc outside!"
}
#Function for getting all the variables
catchAll()
{
    
    description=$(echo $WAPI | jq -r '.weather[0].description')
    present_temp=$(echo $WAPI | jq -r '.main.temp')
    present_wind=$(echo $WAPI | jq -r '.wind.speed')
    present_rain=$(echo $WAPI | jq -r '.rain."1h" // .rain."3h" // "0"')
}

catchAll
echo "Todays weather has $description with a wind speed of $present_wind mph".
if [[ "$temp" -lt 60 ]]; then
    echo "Make sure to bring a jacket outside! The temp is $present_temp°F!"
elif [[ "$temp" -ge 60  && "$temp" -lt 90 ]]; then
    echo "Its going to be a good day outside! Temp is $present_temp°F!"
else
    echo "Also have I mentioned that it's HOT?! Temp is $present_temp°F!"
fi
if [[ "$present_rain" -gt 0 ]]; then
    echo "It seems like we will get rain within the next hour with a precipitation of around $rain."
else
    echo "It seems like it will be dry (at least for the next hour :P)"
fi
future_data
echo "Press 'q' to quit the program"

while true; do
    read -n 1 -s key
    if [[ "$key" == "q" ]]; then
        break
    else
        echo "Bro did not type q"
    fi
done