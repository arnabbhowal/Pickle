from openperplex import OpenperplexSync
import json
from typing import Dict
import os
import re
import requests

# Replace with your actual OpenPerplex API key
OPENPERPLEX_API_KEY = os.getenv("OPENPERPLEX_API_KEY")

# Initialize the OpenPerplex client
client_sync = OpenperplexSync(OPENPERPLEX_API_KEY)

def get_city_state(zipcode):
    """
    Fetches the city and state for a given ZIP code using the Zippopotam.us API.
    """
    url = f"http://api.zippopotam.us/us/{zipcode}"
    response = requests.get(url)
    
    if response.status_code == 200:
        data = response.json()
        city = data['places'][0]['place name'].lower().replace(" ", "-")
        state = data['places'][0]['state abbreviation'].lower()
        return f"{city}-{state}"
    else:
        raise ValueError(f"Invalid ZIP code: {zipcode}")

def get_current_movies_in_cinemas_using_openperplex(pincode: str, date: str, radius: int) -> Dict:
    """
    Calls the OpenPerplex API to fetch movies currently playing in cinemas for the given pincode, date, and radius.
    Ensures a structured JSON response. If no movies are found, it returns {"cinemas": {}}.
    """
    try:
        # Construct the Moviefone URL dynamically
        city_state = get_city_state(pincode)
        moviefone_url = f"https://www.moviefone.com/showtimes/theaters/{city_state}/{pincode}/?selectedShowDate={date}"

        # Define the query for OpenPerplex
        query = (
            f"Find movies currently playing in cinema halls on this website. Go through several theatres if multiple are present. Don't stop at few."
            f"Use the Moviefone website as one of the sources. "
            "If no showtimes are available for the given date, return an empty JSON object: {'cinemas': {}}. "
            "Otherwise, structure the response with cinema halls as the primary key, listing movies and their show timings. "
            "The JSON response should follow this exact structure: "
            '{"source": "source_url", "cinemas": {"Cinema Name": {"movies": [{"movie_name": "Movie Name", "show_timings": ["time1", "time2"]}]}}}'
        )

        # Query OpenPerplex using the constructed URL and query
        result = client_sync.query_from_url(
            url=moviefone_url,
            query=query,
            response_language="en"
        )
        

        # Extract the response content
        response_text = result.get("llm_response", "").strip()

        # Use regex to extract the JSON string from the response
        json_match = re.search(r"```json\n(.+?)\n```", response_text, re.DOTALL)
        if json_match:
            json_string = json_match.group(1).strip()
        else:
            # If no JSON block is found, assume the entire response is JSON
            json_string = response_text

        # Parse the JSON string
        try:
            movies_data = json.loads(json_string)
            # Add the source URL to the response
            movies_data["source"] = moviefone_url
            return movies_data
        except json.JSONDecodeError as e:
            return {"error": f"Failed to parse JSON response: {str(e)}", "response": response_text}

    except Exception as e:
        return {"error": f"OpenPerplex API request failed: {str(e)}"}
